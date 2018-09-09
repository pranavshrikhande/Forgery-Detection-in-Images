function Y = local_vars(X, rad, mask)
%function Y = local_vars(X, rad, mask)
%
% Compute the variances of sliding windows (2 rad + 1) * (1 + 2 rad).
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

% parametri di default
error( nargchk(2, 3, nargin) );
if ~exist('mask', 'var')
    mask = ones( size(X) );
end

% controllo dei parametri
if rad < 0
    error('Il raggio deve essere non negativo');
end
if any( size(X) ~= size(mask) )
    error('La maschera non � compatibile con la matrice d''ingresso');
end

% rimuovi gli elementi esterni alla maschera
X(~mask) = 0;

% conta (localmente) gli '1' della maschera
N = local_sum(mask, rad);

% calcola le somme locali
Sx = local_sum(X, rad, mask);

% calcola le varianze locali
Y = local_sum(X.^2, rad, mask) - Sx.^2 ./ N;

% normalizza per N-1
idx = (N > 1);
Y(idx) = Y(idx) ./ (N(idx) - 1);

% rimuovi gli elementi esterni alla maschera
Y(~mask) = 0;