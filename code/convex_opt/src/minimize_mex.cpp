/*
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
*/

#include <mx_image.hpp>
#include <eigen_plugin.hpp>
#include "algos.hpp"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // check the params
    if (nrhs != 4)
        mexErrMsgTxt("This function takes 4 inputs");
    if (nlhs != 2)
        mexErrMsgTxt("This function gives 2 outputs");
    
    // pixel type
    typedef float T;
    
    // read the inputs
    MxImage<T> x( prhs[0] );
    MxImage<T> c( prhs[1] );
    T eta = mxGetScalar( prhs[2] );
    int max_it = mxGetScalar( prhs[3] );
    
    // init. the output
    int Nr = x.rows();
    int Nc = x.cols();
    MxImage<T>  y( plhs[0], Nr, Nc );
    
    // convert inputs
    Array<T,Dynamic,Dynamic> xx, cc, yy;
    convert_input(xx, x);
    convert_input(cc, c);
    
    // execute
    double it = min_CFB(yy, xx, cc, eta, max_it);

    // write the outputs
    convert_output(y, yy);
    plhs[1] = mxCreateDoubleScalar(it);
}