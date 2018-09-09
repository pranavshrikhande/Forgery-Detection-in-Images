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

function getResidue = makeResidueFun(nameAlg, varargin)

    if strcmpi(nameAlg,'bm3d')
        getResidue = @(x) NoiseExtractBM3D(x,varargin{:});
    elseif strcmpi(nameAlg,'cbm3d')
        getResidue = @(x) NoiseExtractCBM3D(x,varargin{:});
    elseif strcmpi(nameAlg,'mihcak')
        getResidue = @(x) NoiseExtractMihcak(x,varargin{:});
    else
        error('denoising filter not found!!');
    end;
