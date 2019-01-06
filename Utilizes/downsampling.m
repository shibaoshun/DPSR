function z_downsample=downsampling(z,N)
% z  the high resulution image
% N the scale factor
[xN,yN,L]=size(z);
    for ll = 1:L                                 %% average pixles intensities in NxN areas of the observations
        for sy=1:yN/N
            for sx=1:xN/N
                temp0=z(( sy-1)*N+(1:N),(sx-1)*N+(1:N),ll);
%                 z(( sy-1)*N+(1:N),(sx-1)*N+(1:N),ll)=ones(N,N)*mean(temp0(:));
                z_downsample( sy,sx,ll)=sum(temp0(:));
            end
        end
    end