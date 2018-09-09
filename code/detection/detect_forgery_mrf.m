function [mask,mask_pre] = detect_forgery_mrf( img, prnu, getResidue, hypothesis, opt)
%function mask = detect_forgery_mrf(img, prnu, getResidue, hypothesis, opt)
%
% Implement the technique for forgery localization described in
% ''A Bayesian-MRF Approach for PRNU-based Image Forgery Detection''
% written by G. Chierchia, G. Poggi, C. Sansone and L. Verdoliva, 
% IEEE Transactions on Information Forensics and Security, 2014.
% Please refer to this paper for a more detailed description of the algorithm.
%
%  INPUT PARAMETERS:
%   1. img        = [matrix NxMxK] image
%   2. prnu       = [matrix NxMxK] camera PRNU
%   3. getResidue = [func handler] function to get the residue from the image
%   4. hypothesis = [struct]       camera data to generate the prediction
%   5. opt        = [struct]       options
%
% OUTPUT PARAMETERS:
%   1. mask       = [matrix NxM] mask of forgery localization
%
% Author: Giovanni Chierchia, 
%         Davide Cozzolino.
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

% default options
if nargin < 5
    opt.likelihood = 'bayes';
    opt.beta = 0.3;
    opt.norm = 'L2';
    opt.p0   = 0.5;
end

h = waitbar(1/2, '(1 of 2) Local statistics');

% compute the correlation and its prediction.
[corr, p_corr] = genmtx_correlation(img, prnu, getResidue, hypothesis );

waitbar(2/2, h, '(2 of 2) Optimization');

% hyp H0
ggd = hypothesis.ggd_H0;
opt.var_H0 = ggd(2)^2 * gamma(3/ggd(3)) / gamma(1/ggd(3));

% hyp H1
ggd = hypothesis.ggd_H1;
opt.var_H1 = ggd(2)^2 * gamma(3/ggd(3)) / gamma(1/ggd(3));

% execute
if strcmpi(opt.likelihood, 'bayes')
	[mask,mask_pre] = detect_forgery_mrf_corr(corr, p_corr, opt);
else
	error('Option not recognized');
end

close(h);