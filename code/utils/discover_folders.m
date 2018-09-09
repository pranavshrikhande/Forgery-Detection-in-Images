function folders = discover_folders(dir_path)
%function folders = discover_folders(dir_path)
%
% Return all the folders in the folder "dir_path" 
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

    folders = dir(fullfile(dir_path,'*'));
    folders = folders([folders.isdir]);
    folders = {folders(3:end).name};