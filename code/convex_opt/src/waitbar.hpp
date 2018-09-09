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

#ifndef WAITBAR_HPP
#define WAITBAR_HPP

struct Waitbar 
{
    mxArray* prhs[2];   // = {scalar, handler}
    bool flag;
    Waitbar(const char* title) 
    {
        flag = checkWaitbar();
        
        if (flag) {
            // inputs
            prhs[0] = mxCreateDoubleScalar(0);
            prhs[1] = mxCreateString(title);

            // output
            mxArray* plhs[1];

            // call the function
            if( mexCallMATLAB(1, plhs, 2, prhs, "waitbar") ) 
            {
                mxDestroyArray(prhs[0]);
                mxDestroyArray(prhs[1]);
                mexErrMsgTxt("[costructor] 'waitbar' function raised an error");
            }

            // save the "waitbar" handler
            mxDestroyArray(prhs[1]);
            prhs[1] = plhs[0];
        }
    }
    
    ~Waitbar() {
        close();
    }
    
    void update(double v)
    {
        if (flag) {
            // update the value
            *mxGetPr(prhs[0]) = v;

            // call the function
            if( mexCallMATLAB(0, NULL, 2, prhs, "waitbar") )
            {
                close();
                mexErrMsgTxt("[update] 'waitbar' function raised an error");
            }
        }
    }
    
    static bool checkWaitbar() {
        mxArray* plhs_check[1];
        bool out = 0;
        
        if( mexCallMATLAB(1, plhs_check, 0, NULL, "checkwaitbar") ) {
            mexErrMsgTxt("[costructor] 'checkwaitbar' function raised an error");
        }
 
        out = (mxGetScalar(plhs_check[0])!=0);
        mxDestroyArray(plhs_check[0]);
        return out;
    }
    
    void close()
    {
        if (flag) {
            // delete the scalar
            mxDestroyArray(prhs[0]);

            // move the handler
            prhs[0] = prhs[1];

            // call the function
            mexCallMATLAB(0, NULL, 1, prhs, "close");

            // delete the handler
            mxDestroyArray(prhs[0]);
        }
    }
};

  
#endif