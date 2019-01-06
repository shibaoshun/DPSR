function Iout=FFDNet(Noiseimage,imageNoiseSigma)
%%%%%%%%%%%%%%%%%%%%%%%denoise using FFDNet%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input:  
%          Noiseimage              - a noisy image 
%          imageNoiseSigma         - the estimated noise devation
%  Output: Iout               - denoised image by using FFDNet 
%%%%%%%%%%%%%%last modified by shibaoshun 2019 Jan 6th
format compact;
global sigmas; % input noise level or input noise level map
useGPU      = 1; % CPU or GPU. For single-threaded (ST) CPU computation, use "matlab -singleCompThread" to start matlab.
inputNoiseSigma = imageNoiseSigma;  % input noise level
load(fullfile('models','FFDNet_gray.mat'));
Noiseimage=single(Noiseimage);
net = vl_simplenn_tidy(net);
if useGPU
    net = vl_simplenn_move(net, 'gpu') ;
end
   %%% convert to GPU
    if useGPU
        input = gpuArray(Noiseimage);
    end
    sigmas = inputNoiseSigma; % set noise level map
    res    = vl_simplenn2(net,input,[],[],'conserveMemory',true,'mode','test'); % matconvnet default
    % res    = vl_ffdnet_concise(net, input);    % concise version of vl_simplenn for testing FFDNet
    %  res    = vl_ffdnet_matlab(net, input); % use this if you did  not install matconvnet; very slow   
    output = res(end).x;
    if useGPU
        output = gather(output);
    end
    Iout=double(output);
