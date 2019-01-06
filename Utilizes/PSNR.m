%
% function r = PSNR(x1, x2)
%
%   This function returns the PSNR between images x1 and x2.
% 
%   See:
%     S. Mun and J. E. Fowler, "Block Compressed Sensing of Images
%     Using Directional Transforms," submitted to the IEEE
%     International Conference on Image Processing, 2009
%
%   Originally written by SungKwang Mun, Mississippi State University
%

%
% BCS-SPL: Block Compressed Sensing - Smooth Projected Landweber
% Copyright (C) 2009-2012  James E. Fowler
% http://www.ece.mstate.edu/~fowler
% 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
%PSNR=10log10(((2^n-1)^2)/MSE)
% n 
% MSE
% % function PSNR=psnr(f1,f2)
% % k=8  
% % fmax=2.^k-1;
% % a=fmax.^2;
% % e=double(f1)-double(f2);
% % [m,n]=size(e);
% % b=mean(sum(sum(e.^2)));
% % PSNR=10*log10(m*n*a/b);


function r = PSNR(x1, x2)

error = x1 - x2;

r = 10 * log10(1/ mean(error(:).^2));
