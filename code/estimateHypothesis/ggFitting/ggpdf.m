function y = ggpdf(x, m, a, b)
%function y = ggpdf(x, m, a, b)
%
% Evaluete the PDF of Generalized Gaussian distribution:
%
%       pdf(x|m,a,b) = b * exp( -(|x-m|/a)^b ) / (2 * gamma(1/b) * a)
%
% where,
%   - m = position factor (mean).
%   - a =    scale factor.
%   - b =    shape factor. 
% "gamma" is the gamma function
%
% NOTE:
%  "mean of GG distribution" = m;
%  " var of GG distribution" = a^2 * gamma(3/b) / gamma(1/b);
%  if b =  1 the GG is a esponential distribution.
%  if b =inf the GG is a     uniform distribution.
%  if b =  2 the GG is a    gaussian distribution.
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

y = b .* exp( -(abs(x-m) ./ a) .^ b ) ./ (2 .* gamma(1./b) .* a);