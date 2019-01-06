function Demo_sub_pixel_resolution_Imaging()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Coded diffraction imaging from low-resolution diffraction pattern at Gaussion noise case
%% demo code for "Deep prior-based sparse representation model for diffraction imaging: A plug-and-play method"
%%%%%%%%%%%%%%last modified by shibaoshun 2019 Jan 6th
%% add path
clear ;
close all;
CurrPath = cd;
addpath(genpath(CurrPath));
%% add the matconvenet path
% Pay attention! to run FFDNet denoiser you sholud add the correct path of the metconvnet
 addpath('...\matconvnet-1.0-beta25\matlab')
 addpath('...\matconvnet-1.0-beta25\matlab\mex')
 addpath('...\matconvnet-1.0-beta25\matlab\simplenn')
%% select an image
Imagenumber=1;
 switch Imagenumber
 case 1
 ori_image='01.png';
 case 2
 ori_image='02.png';
 case 3
 ori_image='03.png';
 case 4
 ori_image='04.png';
 case 5
 ori_image='05.png';
 case 6
 ori_image='06.png';
 case 7
 ori_image='07.png';
 case 8
 ori_image='08.png';
 case 9
 ori_image='09.png';
 case 10
 ori_image='10.png';
 case 11
 ori_image='11.png';
 case 12
 ori_image='12.png';
 case 13
 ori_image='13.png';
 case 14
 ori_image='14.png';
 case 15
 ori_image='15.png';
 case 16
 ori_image='16.png';
 case 17
 ori_image='17.png';
 case 18
 ori_image='18.png';
 case 19
 ori_image='19.png';
 case 20
 ori_image='20.png';
 end
rng('default');
disp(['Loading image ',ori_image]);
disp(' ');
Imin=double(imread(ori_image))/255;
[n1, n2]=size(Imin);
SNR= 50;                  % noise level
%% innitial guess
if size(Imin,2)==512
    load X0512.mat       % a random guess
elseif size(Imin,2)==256
    load X0256.mat
else
    X0=rand(size(Imin)); 
end  
x=X0;
%%  sampling
Masks= randsrc(n1,n2,[1i -1i 1 -1]); % quaternary mask
L=1;                                 % single observation
% Input is n1 x n2 image, output is n1 x n2 x L array
phi = @(I)  fft2(conj(Masks) .* reshape(repmat(I,[1 L]), size(I,1), size(I,2), L));  
% Input is n1 x n2 x L array, output is n1 x n2 image
phit = @(Y) sum(Masks .* ifft2(Y), 3) * size(Y,1) * size(Y,2); 
Y= abs(phi(Imin)).^2;                % True Data 
factor=4;                            % super-resolution factor
Y_l = downsampling(Y, factor);       % obtain a low-resoluiton coded diffraction pattern 
Y_l=awgn(Y_l,SNR,'measured','dB');   % add noise
%% %%%%%%%%%%%%%%%%%%%%%<<<<DPSR_FFDNet>>>%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('calling the function DPSR_FFDNet.....\n');
t=clock;
Image=DPSR_FFDNet(Y_l,phi,phit,x,factor); % the proposed algorithm DPSR_FFDNet
time=etime(clock,t);
PSNR=psnr(Image,Imin);
SSIM = ssim(Imin,Image);
%% show the result
fprintf(1,'PSNR = %f \n', PSNR);
fprintf(1,'FSIM = %f \n', SSIM);
fprintf(1,'Time = %f \n', time);
