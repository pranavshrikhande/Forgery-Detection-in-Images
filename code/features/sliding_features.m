function [Y,N] = sliding_features(X, radius, params, mask)
%function Y = sliding_features(img, radius, params)
%
% Compute the local features on windows (2 radius+1)x(2 radius+1) pixels.
% The features are described in
% ''Determining image origin and integrity using sensor noise''
% written by M. Chen, J. Fridrich, M. Goljan, and J. Lukas, 
% IEEE Transactions on Information Forensics and Security, 2008.
% Note: This code is not written by the authors of the paper, and
%  the technique has been reproduced following 
%  the details described in the paper.
%   
%
%  INPUT PARAMETERS:
%   1. img        = [matrix NxM] image.
%   2. radius     = [scalar]     radius of sliding window.
%   3. params     = [vector 1x3] parameters [crit,tau,c]
%
% OUTPUT PARAMETERS:
%   1. Y         = [matrix NxMx4] local features:
%       - 1)   intensity feature.
%       - 2)    textures feature.
%       - 3)  uniformity feature.
%       - 4) composition feature.
%
%
% Author: Giovanni Chierchia, 
%         Annalisa Verdoliva.
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

 
X_hp = hpfilt(X);

% parametri di default
error( nargchk(3, 5, nargin) );
if ~exist('params', 'var')
    params = [250 6 0.03];
end
if ~exist('mask', 'var')
    mask = ones( size(X) );
end

% controllo dei parametri
if size(X,3) ~= 1
    error('Il parametro "X" deve essere una matrice NxM');
end
if any( size(X) ~= size(mask) )
    error('La matrice "X" e la maschera "mask" devono avere le stesse dimensioni');
end

% intensita'
crit = params(1);
tau  = params(2);
Fi = (X <= crit) .* (X ./ crit) + (X > crit) .* exp(-(X-crit).^2 ./ tau);

% tessitura
var5 = local_vars(X_hp, 2, mask);
Ft = 1 ./ (1+var5);

% uniformity
c = params(3);
var5 = local_vars(X, 2, mask);
Fs = double( sqrt(var5) < c * X );

% composizione
Fc = Fi .* Ft;

% conta (localmente) gli '1' della maschera
N = local_sum(mask, radius, mask);

% calcola le feature
Y(:,:,1) = local_sum(Fi, radius, mask) ./ N;
Y(:,:,2) = local_sum(Ft, radius, mask) ./ N;
Y(:,:,3) = local_sum(Fs, radius, mask) ./ N;
Y(:,:,4) = local_sum(Fc, radius, mask) ./ N;

% rimuovi gli elementi esterni alla maschera
mask_ND = repmat(mask, [1 1 size(Y,3)]);
Y(~mask_ND) = 0;
N(~mask) = 0;