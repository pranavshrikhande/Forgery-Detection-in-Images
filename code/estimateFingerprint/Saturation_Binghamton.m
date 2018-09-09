function SaturMap = Saturation_Binghamton(X,gray,th)
% Determines saturated pixels as those having a peak value (must be over
% 250) and a neighboring pixel of equal value
% SaturMap  binary matrix, 0 - saturated pixels 
% gray      in case of 'gray' saturated pixels in SaturMap (denoted as zeros)
%           result from at least 2 saturated color channels

% This function has been downloaded from:
% http://dde.binghamton.edu/download/camera_fingerprint/
%
% -------------------------------------------------------------------------
% ------------------   Copyright  ---------------------
% -------------------------------------------------------------------------
% Copyright (c) 2012 DDE Lab, Binghamton University, NY.
% All Rights Reserved.
% -------------------------------------------------------------------------
% Permission to use, copy, modify, and distribute this software for
% educational, research and non-profit purposes, without fee, and without a
% written agreement is hereby granted, provided that this copyright notice
% appears in all copies. The program is supplied "as is," without any
% accompanying services from DDE Lab. DDE Lab does not warrant the
% operation of the program will be uninterrupted or error-free. The
% end-user understands that the program was developed for research purposes
% and is advised not to rely exclusively on the program for any reason. In
% no event shall Binghamton University or DDE Lab be liable to any party
% for direct, indirect, special, incidental, or consequential damages,
% including lost profits, arising out of the use of this software. DDE Lab
% disclaims any warranties, and has no obligations to provide maintenance,
% support, updates, enhancements or modifications.
% -------------------------------------------------------------------------
% Contact: mgoljan@binghamton.edu | January 2012
%          http://dde.binghamton.edu/download/camera_fingerprint
% -------------------------------------------------------------------------
% [1] M. Goljan, T. Filler, and J. Fridrich. Large Scale Test of Sensor 
% Fingerprint Camera Identification. In N.D. Memon and E.J. Delp and P.W. Wong and 
% J. Dittmann, editors, Proc. of SPIE, Electronic Imaging, Media Forensics and 
% Security XI, volume 7254, pages % 0I010I12, January 2009.
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

if nargin<2, gray=''; end;
if nargin<3, th=250; end;

M = size(X,1);  N = size(X,2);
if max(max(X(:)))<=th; 
    if isempty(gray), 
        SaturMap = ones(size(X)); 
    else 
        SaturMap = ones(M,N); 
    end
    return, 
end

Xh = (X - circshift(X,[0,1]));  
Xv = (X - circshift(X,[1,0]));
SaturMap = Xh & Xv & circshift(Xh,[0,-1]) & circshift(Xv,[-1,0]);

if size(X,3)==3, 
    for j = 1:3
        maxX(j) = max(max(X(:,:,j)));
        if maxX(j)>th; 
            SaturMap(:,:,j) = ~((X(:,:,j)==maxX(j)) & ~SaturMap(:,:,j));
        end
    end
elseif size(X,3)==1,
    maxX = max(max(X)); 
    SaturMap = ~((X==maxX) & ~SaturMap);    
else
    error('Invalid matrix dimensions)');
end

switch gray
    case 'gray'
        if size(X,3)==3,
            SaturMap = SaturMap(:,:,1)+SaturMap(:,:,2)+SaturMap(:,:,3);
            SaturMap(SaturMap>1) = 1;
        end
    otherwise 'do nothing';
end