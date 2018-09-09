function z = gginvcdf(y, m, a, b)
%function z = gginvcdf(y, m, a, b)
%
% Evaluete the inverse CDF of Generalized Gaussian distribution:
%
% where,
%   - m = position factor (mean).
%   - a =    scale factor.
%   - b =    shape factor. 
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

z = sign(2.*y - 1 ).*a.*(gammaincinv(abs(2.*y-1),1/b).^(1/b)) + m;