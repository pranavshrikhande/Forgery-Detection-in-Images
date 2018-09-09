function [mask,mask_pre,rho] = detect_forgery_mrf_corr(corr, p_corr, opt)
%function mask = detect_forgery_mrf_corr(corr, p_corr, opt)
%
% Implement the technique for forgery localization described in
% ''A Bayesian-MRF Approach for PRNU-based Image Forgery Detection''
% written by G. Chierchia, G. Poggi, C. Sansone and L. Verdoliva, 
% IEEE Transactions on Information Forensics and Security, 2014.
% Please refer to this paper for a more detailed description of the algorithm.
%
%  INPUT PARAMETERS:
%   1. corr    = [matrix NxM]   correlation
%   2. p_corr  = [matrix NxM]   prediction of correlation
%   3. opt     = [struct]       options
%
% OUTPUT PARAMETERS:
%   1. mask    = [matrix NxM] mask of forgery localization
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

if not(isfield(opt,'dilate')),
    opt.dilate = 20;
end;
if not(isfield(opt,'decimate_factor')),
    opt.decimate_factor = 1;
end;

% likelihood
rho = corr.^2 ./ opt.var_H0 - (corr-p_corr).^2 ./ opt.var_H1 + log(opt.var_H0/opt.var_H1) + 2*log( (1-opt.p0)/opt.p0 );

% minimization
mask_pre = rho < 0;
if opt.decimate_factor>1,
    [Nr,Nc] = size(rho);
    rho = rho(ceil(opt.decimate_factor/2):opt.decimate_factor:end, ceil(opt.decimate_factor/2):opt.decimate_factor:end);
    mask = minimize(rho, opt.beta, opt.norm);
    mask = imresize(mask,[Nr,Nc],'nearest');
else
    mask = minimize(rho, opt.beta, opt.norm);
end;

mask = imdilate(mask, strel('square',opt.dilate));

