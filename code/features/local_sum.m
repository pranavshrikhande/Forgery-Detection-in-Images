function Y = local_sum(X, rad, mask)
%Y = local_sum(X, rad, mask)
%
% Compute the local sums of sliding windows (2 rad + 1) * (1 + 2 rad).
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

% rimuovi gli elementi esterni alla maschera
X(~mask) = 0;

% riduci la dimensionalit�
Z = sum(X, 3);

% calcola le somme locali
Y = imfilter( Z, ones(2*rad+1), 'symmetric' );

% rimuovi gli elementi esterni alla maschera
Y(~mask) = 0;