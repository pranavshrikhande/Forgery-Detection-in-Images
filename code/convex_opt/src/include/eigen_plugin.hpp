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

#ifndef EIGEN_PLUGIN_HPP
#define EIGEN_PLUGIN_HPP

#include <Eigen/Core>

using Eigen::Array;
using Eigen::Dynamic;
using Eigen::Map;

//
// NOTE: Eigen uses a column-major order, like matlab !!!
//

template <typename T>
void convert_input(Array<T,Dynamic,Dynamic> &y, const Image<T> &x)
{
    typedef Array<T,Dynamic,Dynamic> matrix_t;
    
    // map the input
    Map<const matrix_t> xx( x.ptr(0), x.rows(), x.cols() );
    
    // copy (the resizing is automatic)
    y = xx;
}

template <typename T>
void convert_output(Image<T> &y, const Array<T,Dynamic,Dynamic> &x)
{
    typedef Array<T,Dynamic,Dynamic> matrix_t;
    
    // map the output
    Map<matrix_t> yy( y.ptr(0), y.rows(), y.cols() );
    
    // copy (the resizing is NOT automatic)
    yy = x;
}

#endif