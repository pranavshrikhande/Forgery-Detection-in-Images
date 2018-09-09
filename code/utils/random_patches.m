function [Y,rows,cols] = random_patches(get_features, images, N_patches, radius, step)
%function [Y,rows,cols] = random_patches(get_features, images, N_patches, radius=0, step=1)
%
% Extract randomly "N_patches" feature vectors from the image in "images".
% The feature vectors are computed through "get_features" function. 
%
%  INPUT PARAMETERS:
%   1. get_features = [func handler]    function to compute feature vectors from the image.
%   2. images       = [cell of strings] list of images files.
%   3. N_patches    = [scalar]          number of feature vectors to extract. 
%   4. radius       = [scalar]          used to select only bocks inside the image.
%   5. step         = [scalar]          the image is previously decimated.
%
% OUTPUT PARAMETERS:
%   1. Y  = [matrix NxM] feature vectors, the vectors are along the columns
%
% Author: Giovanni Chierchia, 
%         Davide Cozzolino.
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

if nargin<5, radius = 0; end;
if nargin<6,   step = 1; end;

% numero di blocchi per singola immagine
N_images = length(images);
N_blocks = zeros(1, N_images);
N_blocks(:) = floor(N_patches / N_images);
if rem(N_patches, N_images) ~= 0
    N_blocks(end) = N_patches - sum( N_blocks(1:end-1) );
end

% inizializza l'uscita
rows = cell(1, N_images);
cols = cell(1, N_images);

   
% scorri le immagini
%h = wait_bar(0, 'Estrazione casuale dei blocchi...');
for n = N_images:-1:1
    SeeProgress(n);
    % leggi l'immagine
    if ischar( images{n} )
        img = double( imread(images{n}) );
    else
        %error('Il nome dell''immagine deve essere una stringa');
        img = images{n};
    end
    
    % sottocampiona l'immagine
    img = img(1:step:end, 1:step:end, :);
           
    % scegli casualmente la posizione di righe e colonne
    rows{n} = my_randi( 1+radius, size(img,1)-radius, [N_blocks(n) 1] );
    cols{n} = my_randi( 1+radius, size(img,2)-radius, [N_blocks(n) 1] );
    
    
    % calcola le features
    feat = get_features(img);
    
    % aggiungi le feature selezionate
    base = sum( N_blocks(1:n-1) );
    for k = N_blocks(n):-1:1
        
        % seleziona le feature
        f = feat( rows{n}(k), cols{n}(k), : );
        
        % aggiungi all'uscita
        idx = base + k;
        Y(idx, :) = f(:)';
    end
    
    %wait_bar( (N_images-n) /N_images, h );
    
end
%close(h);

function y = my_randi(a, b, sz)
%        y = my_randi(a, b, sz)
%
% La funzione restituisce un vettore di "sz(1) * sz(2) *...* sz(n)" interi 
% generati casualmente e uniformemente nell'intervallo compatto [a,b].


% controllo dei parametri
if a < 0 || b < 0 || b <= a
    error('Intervallo non corretto');
end

% parametri di default
if nargin < 2 
    error('parametri insufficienti');
end
if nargin < 3
    sz = 1;
end

y = floor( a + (b-a+1) * rand(sz) );