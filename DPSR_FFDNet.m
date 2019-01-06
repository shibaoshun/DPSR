function Iout=DPSR_FFDNet(Yl,phi,phit,x,factor)
%% This sub-pixel resolution diffraction imaging algorithm exploits the DPSR model
%%%%%%%%%% Input:   Y     nonlinear measurements
%%%%%%%%%%         phi    linear sampling operator A 
%%%%%%%%%%         phit   linear sampling operator A^{H}
%%%%%%%%%%          x     random initial guess
%%%%%%%%%%        factor  super-resolution factor
%%%%%%%%%% Output: Iout   the recovered image
%% If you use this code, please cite the following reference or contact me. 
%%%%%% BAOSHUN SHI, QIUSHENG LIAN, HUIBIN CHANG
%%%%%%¡°Deep prior-based sparse representation model for diffraction imaging: A plug-and-play method¡±, 
%%%%%%  submitted to IEEE Transactions on Computational Imaging.
%%%%%%  Email£º shibaoshun@ysu.edu.cn
%%%%%%%%%%%%%%last modified by shibaoshun 2019 Jan 6th
%% Initial
    maxiteration=100;
    Y = Inverse_downsampling(Yl, factor);
    f = @(Yhat) sum(abs((Yhat(:)-Yl(:))).^2); 
    gradf= @(x,Yhat) 4*real(phit(phi(x).*(Yhat-Y))); % define the gradient of the data fidelity function
    xold=x;
    x_hat=x;
 %%  initial dictionary  
   p=64;
   D = DctInit(sqrt(p)); 
   W = double(D);			    
 %% parameters
   C1=4;
   C2=3.2;
 for i=1:1:maxiteration
%% deep filtering 
    Nsig=function_stdEst2D(x,2);   % evaluate the input noise standard deviation
    x_hat=FFDNet(x,Nsig);          % deep filtering by FFDNet
%% deep prior-based coefficients updating and underlying coefficients updating steps
    Wa=frame_reconstruction_two_alpha(x,x_hat,W,C1*Nsig,C2*Nsig);  %
%% image updating step
    x=proj_CPR_SR(Wa,5,f,gradf,phi,factor);
%% stop while the residual is a small value 
    Residual= norm(x_hat-xold)/norm(x_hat);
    if  Residual<1e-4
    break;
    end
    xold = x_hat;  
    i
 end
Iout=x_hat;
