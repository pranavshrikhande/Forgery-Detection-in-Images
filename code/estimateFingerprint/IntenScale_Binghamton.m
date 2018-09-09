function out = IntenScale_Binghamton(in)
% in   are pixel intensities 0<=in<=255
% out  0<=out<=1

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

T = 252;
v = 6;
out = exp(-1*(in-T).^2/v);

out(in<T) = in(in<T)/T;
%return;
% DC  = 30;
% out(in<30) = 0.1;