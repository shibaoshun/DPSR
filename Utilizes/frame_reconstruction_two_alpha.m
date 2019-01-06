function [ im_out ] =frame_reconstruction_two_alpha(img_x,filter_x,dict,epsilon1,epsilon2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%%%% and exploit the underlying coefficients for image reconstruction
% input:
%   	img_x		-	the estimated image
%   	filter_x	-	the filtered image
%   	dict        -   the dictionary for tight frame
%       epsilon1    -	thresholding value for updating deep prior-based coefficients
%       epsilon2    -	thresholding value for updating underlying coefficients
% output:
%   	im_out		-	output image
%% If you use this code, please cite the following reference or contact me. 
%%%%%% BAOSHUN SHI, QIUSHENG LIAN, HUIBIN CHANG
%%%%%%¡°Deep prior-based sparse representation model for diffraction imaging: A plug-and-play method¡±, 
%%%%%%  submitted to IEEE Transactions on Computational Imaging.
%%%%%%  Email£º shibaoshun@ysu.edu.cn
%%%%%%%%%%%%%%last modified by shibaoshun 2019 Jan 6th
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[row,col] = size(img_x);
scalar = diag(dict'*dict);
filterSize = sqrt(size(dict,1));
im_out = zeros(row,col);
for i = 1:size(dict, 2)
    kernel1 = reshape(dict(:,i),filterSize,filterSize);
    Wx  = filter2(kernel1, img_x, 'valid');
    temp = filter2(kernel1, filter_x, 'valid');          
    beta   = wthresh(temp, 'h', epsilon1);       % Updating deep prior-based coefficients by Eqn. (14)
    temp2=Wx-beta;
    alpha  = wthresh(temp2, 's', epsilon2)+beta; % Updating underlying coefficients by Eqn. (15)
    ker    = kernel1(:);
	ker    = ker(filterSize*filterSize:-1:1);
    kernel = reshape(ker, filterSize, filterSize);
    im_out = im_out + filter2(kernel, alpha /scalar(i), 'full');
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
      
