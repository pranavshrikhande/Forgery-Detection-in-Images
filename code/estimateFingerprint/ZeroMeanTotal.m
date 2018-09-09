function [Y,LP]=ZeroMeanTotal(X)
% function Y=ZeroMeanTotal(X) subtracts mean from 
%   all black and all white subsets of columns and rows in the checkerboard pattern
% X     2-D or 3-D matrix
       
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

Y = zeros(size(X));

[Z,LP11] = ZeroMean(X(1:2:end,1:2:end,:),'both');
Y(1:2:end,1:2:end,:) = Z;
[Z,LP12] = ZeroMean(X(1:2:end,2:2:end,:),'both');
Y(1:2:end,2:2:end,:) = Z;
[Z,LP21] = ZeroMean(X(2:2:end,1:2:end,:),'both');
Y(2:2:end,1:2:end,:) = Z;
[Z,LP22] = ZeroMean(X(2:2:end,2:2:end,:),'both');
Y(2:2:end,2:2:end,:) = Z;

LP.d11=LP11; LP.d12=LP12; LP.d21=LP21; LP.d22=LP22; 