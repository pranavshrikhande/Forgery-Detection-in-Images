function [col,map] = getFalseColoredResult(value,gt)
% [col,map] = getFalseColoredResult(value,gt)
%  generate a false-colored image from the decision and the ground truth.
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

    if ischar(value), value = imread(value)>0; end;
    if ischar(gt)   , gt = imread(gt); end;
    
    map = [106 106 106; 235 125 125; 180 180 180; 195 177 164; 255 255 255; 155 230 203]/255;
    gt  = (gt>0)+(gt==max(gt(:)));
    col = uint8(2*gt+value);