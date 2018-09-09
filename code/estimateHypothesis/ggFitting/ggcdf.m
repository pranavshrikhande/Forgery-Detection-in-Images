function y = ggcdf(x, m, a, b)
%function y = ggcdf(x, m, a, b)
%
% Evaluete the CDF of Generalized Gaussian distribution:
%
%      cdf(x|m,a,b) = 0.5 + 0.5 * sign(x-m) * gammainc( (|x-m|/a)^b, 1/b )
%
% where,
%   - m = position factor (mean).
%   - a =    scale factor.
%   - b =    shape factor. 
% "gammainc" is the incomplete gamma function
%
% Author: Giovanni Chierchia.
% Last revised: 01.06.2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Copyright (c) 2016 Image Processing Research Group of University Federico II of Naples ('GRIP-UNINA').
% All rights reserved.
% this software should be used, reproduced and modified only for informational and nonprofit purposes.
% 
% By downloading and/or using any of these files, you implicitly agree to all the
% terms of the license, as specified in the document LICENSE.txt
% (included in this package) and online at
% http://www.grip.unina.it/download/LICENSE_OPEN.txt
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if sum(size(m) ~= size(a)) ~= 0 || sum(size(a) ~= size(b)) ~= 0
    error('le dimensioni dei pamametri devono coincidere');
end

y = 0.5 + 0.5 .* sign(x-m) .* gammainc( (abs(x-m)./a).^b, 1./b );