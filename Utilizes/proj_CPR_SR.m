function y=proj_CPR_SR(x0,iters,f,gradf,phi,factor)
%% If you use this code, please cite the following reference. 
%%%%%% BAOSHUN SHI, QIUSHENG LIAN, XIN HUANG, AND NI AN
%%%%%%¡°Constrained Phase Retrieval: when alternating projection meets regularization¡±, submitted to JOSA B.
%%%%%%%%%%%%%%last modified by shibaoshun 2018 Mar 9th
cost0=inf;cost1=cost0;
xn=x0;
if ~exist('iters','var')
    iters=1;
end
x=x0;
    for i=1:iters
    Yhat=abs(phi(x)).^2;    
%     im_l = imresize(Yhat, 1/factor, 'bicubic');
%     Yhat = imresize(im_l,factor, 'bicubic');
    Y_l = downsampling(Yhat, factor);
    Yhat = Inverse_downsampling(Y_l, factor);
    temp=gradf(x,Yhat) ;
    step_size=f(Y_l)/(sum(temp(:).^2)+1);
    x=x-step_size*temp;                   % equation (19)
    cost0=cost1;
    cost1=costNorm(xn, x);
    if cost1>=cost0
       x=(x+x0)/2;  
       cost1=costNorm(xn, x);
    end   
    x0=x;  
    end  
y=x;
function cost1=costNorm(xn, x)
  cost1=sum(abs(xn(:) - x(:)).^2);