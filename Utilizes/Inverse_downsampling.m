function z=Inverse_downsampling(z_downsample,N)
% z  the high resulution image
% N the scale factor
[xN,yN,L]=size(z_downsample);
    for ll = 1:L                                 %% average pixles intensities in NxN areas of the observations
        for sy=1:yN
            for sx=1:xN
                temp0=(1/N)*z_downsample(sy,sx,ll);
                temp=ones(N,N)*temp0;
                z(( sy-1)*N+(1:N),(sx-1)*N+(1:N),ll)=temp;
            end
        end
    end