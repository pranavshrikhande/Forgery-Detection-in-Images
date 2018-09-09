function hypothesis = getHypothesisSliding(H0_images, H1_images, prnu, getResidue, radius, params, predictor, step)
%function hypothesis = getHypothesisSliding(H0_images, H1_images, prnu, getResidue, radius, params)
%
% Execute the following operations:
%   1. extraction 30000 feature vectors from the  images in 'H0_images' list.
%   2. estimation the pdf of the H0 hypothesi.
%   3. extraction 30000 feature vectors from the  images in 'H1_images' list.
%   4. estimation the pdf of the H1 hypothesi with precictor.
%
%  INPUT PARAMETERS:
%   1. H0_images  = [cell of strings] list of images files of H0 hypothesi
%   2. H1_images  = [cell of strings] list of images files of H1 hypothesi
%   3. prnu       = [matrix NxMxK]    camera PRNU
%   4. getResidue = [func handler]    function to get the residue from the image
%   5. radius     = [scalar]          radius of sliding window
%   6. params     = [vector 1x3]      parameters [crit,tau,c]
%
% OUTPUT PARAMETERS:
%   1. hypothesis = [stract]          camera data to generate the prediction.
%
% Author: Giovanni Chierchia,
%           Davide Cozzolino.
% Last revised: 13.06.2013
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


% controllo dei parametri
if numel(radius) > 1
    error('Il parametro ''radius'' deve essere uno scalare');
end

if nargin<7, predictor = Regressor(); end;
if nargin<8, step=1; else prnu = prnu(1:step:end,1:step:end); end;
get_features = @(img) get_sliding(prnu, img, getResidue(double(img)), radius, params);


% calcola le statistiche dell'ipotesi H0
attr_H0 = random_patches(get_features, H0_images, 30000, radius, step);
corr_H0 = attr_H0(:, 1);

% calcola le statistiche dell'ipotesi H1
attr_H1 = random_patches(get_features, H1_images, 30000, radius, step);
corr_H1 = attr_H1(:, 1);
feat_H1 = attr_H1(:, 2:end);

% stima la pdf dell'ipotesi H0
ggd_H0 = ggfit( corr_H0 );

% addestra il predittore
[predictor,err_H1] = train(predictor, feat_H1, corr_H1 );

% rimuovi outliers (ADDED 06/02/2013)
idx = err_H1 <= abs( min(err_H1) );
err_H1 = err_H1(idx);

% stima la pdf dell'ipotesi H1
ggd_H1 = ggfit( err_H1 );

% inizializza la struttura
hypothesis = struct(...
    'radius'    , radius, ...
    'step'      , step, ...
    'params'    , params, ...
    'predictor' , predictor, ...
    'ggd_H0'    , ggd_H0, ...
    'ggd_H1'    , ggd_H1 ...
 );