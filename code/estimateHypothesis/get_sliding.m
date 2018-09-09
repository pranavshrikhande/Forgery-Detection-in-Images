function attr = get_sliding(prnu, img, residue, radius, params)
%function attr = get_sliding(prnu, img, residue, radius, params)
%
% Compute the local correlation and local features.
%   
%  INPUT PARAMETERS:
%   1. prnu     = [matrix NxMxK] camera PRNU
%   2. img      = [matrix NxMxK] image
%   3. residue  = [matrix NxMxK] residue of image
%   4. radius   = [scalar]       radius of sliding window
%   5. params   = [vector 1x3]   parameters [crit,tau,c]
%
% OUTPUT PARAMETERS:
%   1. attr     = [matrix NxMxK] local correlation + local features.
%
% Author: Giovanni Chierchia,
%           Davide Cozzolino.
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


% calcola la correlazione
prnu = prnu(1:size(img,1),1:size(img,2),:);
if size(prnu,3)==size(img,3),
    corr = sliding_corr( color2gray(prnu.*img), color2gray(residue), radius );
else
    corr = sliding_corr( color2gray(prnu).*color2gray(img), color2gray(residue), radius );
end;
% estrai gli attributi
img = color2gray(img);
feat = sliding_features( img, radius, params );

% costruisci l'uscita
attr = cat(3, corr, feat);