function p = sliding_corr(x, y, rad)
%function p = sliding_corr(x, y, rad)
%
% Compute the local correlation between two matrices 
% on windows (2 rad+1)x(2 rad+1) pixels.
%   
%  INPUT PARAMETERS:
%   1. x   = [matrix NxM]  first matrix.
%   2. y   = [matrix NxM] second matrix.
%   3. rad = [scalar]     radius of sliding window.
%
% OUTPUT PARAMETERS:
%   1. p   = [matrix NxM] local correlation.
%
% Author: Giovanni Chierchia.
% Last revised: 14.06.2013
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


% window
N = (2*rad+1);
sigma = N/2;
win = fspecial('gaussian', N, sigma);

% local means
Sx = imfilter(x, win, 'symmetric');
Sy = imfilter(y, win, 'symmetric');

% local std.
Qx = sqrt( imfilter(x.^2, win, 'symmetric') - Sx.^2 );
Qy = sqrt( imfilter(y.^2, win, 'symmetric') - Sy.^2 );

% normalize
xn = (x - Sx) ./ Qx;
yn = (y - Sy) ./ Qy;

% local corr.
p = imfilter(xn .* yn, win, 'symmetric');