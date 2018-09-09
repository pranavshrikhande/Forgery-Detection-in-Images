mex('-O','-Iinclude','minimize_mex.cpp','-output',['minimize_L1_mex.' mexext()]);
mex('-O','-Iinclude','-DalgL2','minimize_mex.cpp','-output',['minimize_L2_mex.' mexext()]);