function Y = hpfilt(X)
% Y = hpfilt(X)
%
% compute a high-pass filter in wavelet domain.
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

% opzioni della wavelet
wname = 'db4';
wmode = 'per';

% controlla le dimensioni del blocco
[Nr Nc] = size(X);
if wmaxlev(Nr,wname) < 2 || wmaxlev(Nc,wname) < 2
    error('la matrice � troppo piccola');
end
if mod(Nr,4)>0 || mod(Nc,4)>0,
    X = padarray(X,4-[mod(Nr,4) mod(Nc,4)],'replicate','post');
end

% decomposizione wavelet su 2 livelli
[LL{1} LH{1} HL{1} HH{1}] = dwt2( X, wname, 'mode', wmode );
[LL{2} LH{2} HL{2} HH{2}] = dwt2( LL{1}, wname, 'mode', wmode );

% azzera la banda LL
LL{2} = 0*LL{2};

% ricostruzione wavelet su 2 livelli
LL{1} = idwt2( LL{2}, LH{2}, HL{2}, HH{2}, wname, 'mode', wmode );
Y = idwt2( LL{1}, LH{1}, HL{1}, HH{1}, wname, 'mode', wmode );
if mod(Nr,4)>0 || mod(Nc,4)>0
    Y = Y(1:Nr,1:Nc);
end