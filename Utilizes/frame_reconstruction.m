function [ im_out ] =frame_reconstruction(img_x,dict,epsilon)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Denoising image by the tight frame associated with the filter bank "dict"
% input:
%   	dict		-	dictionary for reconstruction
%   	img			-	noisy image
%   	lambda2		-	lambda for thresholding 
% output:
%   	im_out		-	output image
%
%Reference: Jian-feng Cai, H. Ji, Z. Shen and Guibo Ye,  
%Data-driven tight frame construction and image denoising ,
%Applied and Computational Harmonic Analysis, 37 (1), 89-105, Jul. 2014
%
%Author: Chenlong Bao, Yuhui Quan, Yuping Sun, and Hui Ji
%
%Last Revision: 11-July-2018
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Exception Management
if nargin < 2, error('No enough data are input!'); end
if ~exist('lambda2','var')   	lambda2 = 1;   	   end

%% denoising by filter bank 
[row,col] = size(img_x);
scalar = diag(dict'*dict);
filterSize = sqrt(size(dict,1));
im_out = zeros(row,col);
for i = 1:size(dict, 2);
    %% update the coeffiencient of the orignal image 
    kernel1 = reshape(dict(:,i),filterSize,filterSize);
    temp   = filter2(kernel1, img_x, 'valid');
  %% update the coeffiencient of the orignal image    
  %  if i==1
     temp   = wthresh(temp, 'h', epsilon);
 %   else
 %      temp=mydenoise(temp, lambda2/2.7);
 %   end
    ker    = kernel1(:);
	ker    = ker(filterSize*filterSize:-1:1);
    kernel = reshape(ker, filterSize, filterSize);
    im_out = im_out + filter2(kernel, temp/scalar(i), 'full');
end

%% reconstruction 
for k = 1:filterSize
    for k2 = 1:filterSize
        if (k == 1)&(k2 == 1)
            mmask = ones(row, col);
        else
            if k == 1
                temp = zeros(row, col);
                temp(:, k2:col-filterSize+k2-1) = 1;
                mmask = mmask + temp;
            elseif k2 == 1
                temp = zeros(row,col);
                temp(k:row-filterSize+k-1, :)=1;
                mmask = mmask + temp;
            else
                temp = zeros(row, col);
                temp(k:row-filterSize+k-1, k2:col-filterSize+k2-1) = 1;
                mmask = mmask + temp;                
            end
        end
    end
end
mmask  = double(mmask);
im_out = im_out./mmask;

% put the image into range [0,255]
%im_out(im_out > 255) = 255;  % lqs remove
%im_out(im_out < 0) 	 = 0;       
