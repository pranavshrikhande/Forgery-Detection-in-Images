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

#ifndef TOOLS_HPP
#define TOOLS_HPP

#include <Eigen/Core>

using Eigen::Array;
using Eigen::Dynamic;


template <typename T>
void proj_range(Array<T,Dynamic,Dynamic> &c) 
{
    c = c.max(0);
    c = c.min(1);
}

template <typename T>
void proj_Linf(Array<T,Dynamic,Dynamic> &y, T gamma)
{   
    y = y.max(-gamma);
    y = y.min( gamma);
}

template <typename T>
void proj_L2(Array<T,Dynamic,Dynamic> &y1, Array<T,Dynamic,Dynamic> &y2, T gamma)
{   
    Array<T,Dynamic,Dynamic> a = gamma / (y1.abs2() + y2.abs2()).sqrt();
    a = a.min(1);
    y1 *= a;
    y2 *= a;
}

template <typename T>
void grad_dir(Array<T,Dynamic,Dynamic> &hor, Array<T,Dynamic,Dynamic> &ver, const Array<T,Dynamic,Dynamic> &x)
{
    typedef Array<T,Dynamic,Dynamic> matrix_t;
    
    // size
    int Nr = x.rows();
    int Nc = x.cols();
    
    // horizontal gradient
    hor.resize(Nr,Nc);
    hor.leftCols(Nc-1) = x.rightCols(Nc-1) - x.leftCols(Nc-1);
    hor.col(Nc-1) = x.col(0) - x.col(Nc-1);     // periodic extension
    
    // vertical gradient
    ver.resize(Nr,Nc);
    ver.topRows(Nr-1) = x.bottomRows(Nr-1) - x.topRows(Nr-1);
    ver.row(Nr-1) = x.row(0) - x.row(Nr-1);     // periodic extension
}

template <typename T>
void grad_adj(Array<T,Dynamic,Dynamic> &x, const Array<T,Dynamic,Dynamic> &hor, const Array<T,Dynamic,Dynamic> &ver)
{
    typedef Array<T,Dynamic,Dynamic> matrix_t;
    
    // size
    int Nr = x.rows();
    int Nc = x.cols();
    
    // horizontal adjoint gradient
    matrix_t x_h = matrix_t::Zero(Nr,Nc);
    x_h.rightCols(Nc-1) = hor.leftCols(Nc-1) - hor.rightCols(Nc-1);
    x_h.col(0) = hor.col(Nc-1) - hor.col(0);    // periodic extension
    
    // vertical adjoint gradient
    matrix_t x_v = matrix_t::Zero(Nr,Nc);
    x_v.bottomRows(Nr-1) = ver.topRows(Nr-1) - ver.bottomRows(Nr-1);
    x_v.row(0) = ver.row(Nr-1) - ver.row(0);    // periodic extension
    
    // adjoint gradient
    x = x_h + x_v;
}
 
template <typename T>
void prox_L1L2(Array<T,Dynamic,Dynamic> &p1, Array<T,Dynamic,Dynamic> &p2, const Array<T,Dynamic,Dynamic> &y1, const Array<T,Dynamic,Dynamic> &y2, T gamma)
{   
    typedef Array<T,Dynamic,Dynamic> matrix_t;
     
    // module
    matrix_t mod = (y1.abs2() + y2.abs2()).sqrt();
    
    // scaling factor
    matrix_t a = 1 - gamma/mod;
    a = a.max(0);
    
    // proximity
    p1 = a * y1;
    p2 = a * y2;
}

#endif