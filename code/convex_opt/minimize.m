function [u_est,it] = minimize(likelihood, beta, norm_reg)
%function [mask,it] = minimize(likelihood, beta, norm_reg)
%
% compute the optimization described in
% ''A Bayesian-MRF Approach for PRNU-based Image Forgery Detection''
% written by G. Chierchia, G. Poggi, C. Sansone and L. Verdoliva, 
% IEEE Transactions on Information Forensics and Security, 2014.
% Please refer to this paper for details.
%
%  INPUT PARAMETERS:
%   1. likelihood = [matrix NxM]   likelihood
%   2. beta       = [scalar]       regularization parameter in MRF
%   3. norm_reg   = [string]       kind of regularization term ('L1' o 'L2')
%
% OUTPUT PARAMETERS:
%   1. mask       = [matrix NxM]   classification mask
%   2. it         = [scalar]       number of iterations
%
% Author: Giovanni Chierchia.
% Last revised: 14.06.2013
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Copyright (c) 2016 Image Processing Research Group of University Federico II of Naples ('GRIP-UNINA').
% All rights reserved.
% This work should only be used for nonprofit purposes.
% 
% By downloading and/or using any of these files, you implicitly agree to all the
% terms of the license, as specified in the document LICENSE.txt
% online at http://www.grip.unina.it/download/LICENSE_CLOSED.txt
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% default input
if nargin < 3
    norm_reg = 'L2';
end

% set parameters
max_it = 1000;

% rescaling factor (for numerical stability)
lambda_1 = abs( max(likelihood(:)) );

% execution
timeStamp = tic();
if strcmpi(norm_reg, 'L1')
    [u_est,it] = minimize_L1_mex( single(likelihood < 0), single(likelihood/lambda_1), beta/lambda_1, max_it );
else
    [u_est,it] = minimize_L2_mex( single(likelihood < 0), single(likelihood/lambda_1), beta/lambda_1, max_it );
end
time = toc(timeStamp);

% remove fractional values
u_est = (u_est > 0.75);

% print
fprintf('it: %d, time: %2.2f sec.\n', it, time);