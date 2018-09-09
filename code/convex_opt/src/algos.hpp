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

#ifndef ALGOS_HPP
#define ALGOS_HPP

#include "tools.hpp"
#include "waitbar.hpp"


template <typename T>
int min_CFB(Array<T,Dynamic,Dynamic> &u, const Array<T,Dynamic,Dynamic> &x, const Array<T,Dynamic,Dynamic> &c, T beta, int max_it)
{
    typedef Array<T,Dynamic,Dynamic> matrix_t;
    typedef Eigen::Matrix<T,Dynamic,Dynamic> norm_t;
    
    // stepsize
    T gamma = 0.3535;    // gamma < 1 / sqrt(8)
    
    // regularization
    T beta_gamma = beta*gamma;
    
    // init. solution
    u = x;
    
    // init. dual variables
    matrix_t v_hor, v_ver;
    grad_dir(v_hor, v_ver, x);
    
    // temp. variables
    matrix_t uu = x, p = x;
    matrix_t p_hor = x, p_ver = x;
    
    // iter. numbers
    int it = 0;
    
    // iterate
    Waitbar wbar("Minimization...");
    for(it=1; it <= max_it; it++)
    {
        // primal forward step
        grad_adj(uu, v_hor, v_ver);
        uu = u - gamma * (uu + c);
        
        // primal backward step
        proj_range(uu);
        
        // dual forward step
        p = 2 * uu - u;
        grad_dir(p_hor, p_ver, p);
        v_hor += gamma * p_hor;
        v_ver += gamma * p_ver;
        
        // dual backward step
        #ifndef algL2
            proj_Linf(v_hor, beta_gamma);
            proj_Linf(v_ver, beta_gamma);
        #else
            proj_L2(v_hor, v_ver, beta_gamma);
        #endif
            
        // check criterion
        if( ((norm_t) (u - uu)).norm() < 1e-4 * ((norm_t) uu).norm() ) {    // CAMBIARE IL CRITERIO
            u = uu;
            break;
        }
        
        // update the solution
        u = uu;
        
        // update waitbar
        if( it%10 == 0 )
            wbar.update((double) it / max_it);
    }
    
    return it-1;
}

#endif