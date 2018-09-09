function [corr, p_corr, feat] = genmtx_correlation(img, prnu, getResidue, hypothesis)
%function [corr, p_corr] = genmtx_correlation(img, pattern, hypothesis)
%
% Compute the correlation and its prediction.
%   
%  INPUT PARAMETERS:
%   1. img        = [matrix NxMxK] image
%   2. prnu       = [matrix NxMxK] camera PRNU
%   3. getResidue = [func handler] function to get the residue from the image
%   4. hypothesis = [struct]       camera data to generate the prediction
%
% OUTPUT PARAMETERS:
%   1. corr    = [matrix NxM] correlation
%   2. p_corr  = [matrix NxM] prediction of correlation
%
% Author: Giovanni Chierchia, Univ. Federico II of Naples - ITALY
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


% compute the residuo
img = double(img);
residue = getResidue(img);

% compute the attribute
attr = get_sliding(prnu, img, residue, hypothesis.radius, hypothesis.params);
corr = attr(:, :, 1);
feat = attr(:, :, 2:end);

% compute the prediction
[Nr,Nc,Nb] = size(feat);
x = reshape( feat, [Nr*Nc Nb] );
y = exec( hypothesis.predictor, x );
p_corr = reshape(y, [Nr Nc]);

