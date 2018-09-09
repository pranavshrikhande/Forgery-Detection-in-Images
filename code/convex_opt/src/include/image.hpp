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

#ifndef IMAGE_HPP
#define IMAGE_HPP

#include <algorithm>
#include <vector>
#include <cmath>
#include <stdint.h>

#include <matrix.h>


#ifdef NDEBUG
#define MY_ASSERT(expr, msg)
#else
#include <string>
#include <stdexcept>
#define MY_ASSERT(expr, msg) if( !(expr) ) throw std::runtime_error(msg);
#endif


template <typename T>
class Image
{
protected:
    T* data;
    int size_[4];
    size_t step[3];
     
protected:
    
    void init(const T* data, int sz[], const size_t sp[]) {
        this->data = (T*) data;
        std::copy(sz, sz+4, size_);
        std::copy(sp, sp+3, step);
    }
    
public:

    /* constructors */
    Image() {
        int sz[4] = {0,0,0,0};
        size_t sp[3] = {0,0,0};
    	init(NULL, sz, sp);
    }
    Image(const T* data, int sz[], const size_t sp[]) {
        init(data, sz, sp);
    }
    
    /* size */
    int rows() const { return size_[0]; }
    int cols() const { return size_[1]; }
    int size(int n) const { return size_[n]; }
    const int* size() const { return size_; }
    int total() const { return size(0)*size(1)*size(2)*size(3); }
    
    /* ROI */
    const Image<T> get_roi(int row, int col, int N_rows, int N_cols) const { return get_roi( row, col, 0, N_rows, N_cols, size(2) ); }
    	  Image<T> get_roi(int row, int col, int N_rows, int N_cols) 	   { return get_roi( row, col, 0, N_rows, N_cols, size(2) ); }
    const Image<T> get_roi(int row, int col, int bnd, int N_rows, int N_cols, int N_bands) const { return get_roi( row, col, bnd, 0, N_rows, N_cols, N_bands, size(3) ); }
    	  Image<T> get_roi(int row, int col, int bnd, int N_rows, int N_cols, int N_bands) 		 { return get_roi( row, col, bnd, 0, N_rows, N_cols, N_bands, size(3) ); }
    const Image<T> get_roi(int row, int col, int bnd, int pln, int N_rows, int N_cols, int N_bands, int N_planes) const {
    	MY_ASSERT( row+N_rows <= size(0) && col+N_cols <= size(1) && bnd+N_bands <= size(2) && pln+N_planes <= size(3), "[Image<T>] la ROI supera le dimensioni massime" );
        int sz[4] = {N_rows, N_cols, N_bands, N_planes};
        return Image<T>( ptr(row,col,bnd,pln), sz, step );
    }
    Image<T> get_roi(int row, int col, int bnd, int pln, int N_rows, int N_cols, int N_bands, int N_planes) {
    	MY_ASSERT( row+N_rows <= size(0) && col+N_cols <= size(1) && bnd+N_bands <= size(2) && pln+N_planes <= size(3), "[Image<T>] la ROI supera le dimensioni massime" );
        int sz[4] = {N_rows, N_cols, N_bands, N_planes};
        return Image<T>( ptr(row,col,bnd,pln), sz, step );
    }
    
    /* pointers */
    const T* ptr(int r) const 						{ return data + r; }
    	  T* ptr(int r) 	  						{ return data + r; }
    const T* ptr(int r, int c) const 				{ return data + step[0]*c + r; }
    	  T* ptr(int r, int c) 						{ return data + step[0]*c + r; }
    const T* ptr(int r, int c, int b) const 		{ return data + step[1]*b + step[0]*c + r; }
    	  T* ptr(int r, int c, int b) 				{ return data + step[1]*b + step[0]*c + r; }
    const T* ptr(int r, int c, int b, int p) const 	{ return data + step[2]*p + step[1]*b + step[0]*c + r; }
    	  T* ptr(int r, int c, int b, int p) 		{ return data + step[2]*p + step[1]*b + step[0]*c + r; }
       
    /* accessors */
    const T& operator()(int r, int c=0, int b=0, int p=0) const { return *ptr(r,c,b,p); }
    	  T& operator()(int r, int c=0, int b=0, int p=0) 		{ return *ptr(r,c,b,p); }


    /* basic math */
    void reset() { set_to(T()); }
    void set_to(T init);
    void copy_to(Image<T> &dst) const;                                                  // per-element copy
    void copy_to(Image<T> &dst, const Image<mxLogical> &mask) const;                    // per-element copy (acts only where mask=1)
    void add(const Image<T> &src1, const Image<T> &src2);                               // this = src1 + src2 (pixel-wise addition)
    void sub(const Image<T> &src1, const Image<T> &src2);                               // this = src1 - src2 (pixel-wise subtraction)
    void sub(const Image<T> &src1, const Image<T> &src2, const Image<mxLogical> &mask);	// this = src1 - src2 (acts only where mask=1)
    void mul(const Image<T> &src1, const Image<T> &src2);                               // this = src1 .* src2 (pixel-wise multiplication)
    void div(const Image<T> &src1, const Image<T> &src2);                               // this = src1 ./ src2 (pixel-wise division [if src2(i,j)=0, then dst(i,j)=0])
    void prod(const Image<T> &src1, const Image<T> &src2);                              // this = src1 * src2 (matrix product)
    void prod_t(const Image<T> &src1, const Image<T> &src2);                            // this = src1 * src2' (matrix product with transpose)
    T sum() const;                                              // sum of elements
    T abs_sum() const;											// sum of absolute elements
    T square_sum() const;										// sum of squared elements
};



template<typename T>
void Image<T>::set_to(T init)
{
	for(int p=0; p < size(3); p++) {
		for(int b=0; b < size(2); b++) {
			for(int c=0; c < size(1); c++) {
				T* p_this = ptr(0,c,b,p);
				for(int r=0; r < size(0); r++) {
					p_this[r] = init;
				}
			}
		}
	}
}

template<typename T>
void Image<T>::copy_to(Image<T> &dst) const
{
	for(int i3=0; i3 < size(3); i3++) {
		for(int i2=0; i2 < size(2); i2++) {
			for(int i1=0; i1 < size(1); i1++) {
				T* p_dst = dst.ptr(0,i1,i2,i3);
				const T* p_src = ptr(0,i1,i2,i3);
				for(int i0=0; i0 < size(0); i0++) {
					p_dst[i0] = p_src[i0];
				}
			}
		}
	}
}

template<typename T>
void Image<T>::copy_to(Image<T> &dst, const Image<mxLogical> &mask) const
{
	for(int i3=0; i3 < size(3); i3++) {
		for(int i2=0; i2 < size(2); i2++) {
			for(int i1=0; i1 < size(1); i1++) {
				      T*         p_dst =  dst.ptr(0,i1,i2,i3);
				const T*         p_src =      ptr(0,i1,i2,i3);
                const mxLogical* p_msk = mask.ptr(0,i1,i2,i3);
				for(int i0=0; i0 < size(0); i0++) {
                    if( p_msk[i0] )
                        p_dst[i0] = p_src[i0];
				}
			}
		}
	}
}

template<typename T>
void Image<T>::add(const Image<T> &src1, const Image<T> &src2)
{
	for(int c=0; c < cols(); c++) {
		T* p_d = ptr(0,c);
		const T* p_s1 = src1.ptr(0,c);
		const T* p_s2 = src2.ptr(0,c);
		for(int r=0; r < rows(); r++) {
			p_d[r] = p_s1[r] + p_s2[r];
		}
	}
}

template<typename T>
void Image<T>::sub(const Image<T> &src1, const Image<T> &src2)
{
	for(int c=0; c < cols(); c++) {
		T* p_d = ptr(0,c);
		const T* p_s1 = src1.ptr(0,c);
		const T* p_s2 = src2.ptr(0,c);
		for(int r=0; r < rows(); r++) {
			p_d[r] = p_s1[r] - p_s2[r];
		}
	}
}

template<typename T>
void Image<T>::sub(const Image<T> &src1, const Image<T> &src2, const Image<mxLogical> &mask)
{
    for(int c=0; c < cols(); c++) {
		T* p_d = ptr(0,c);
		const T*         p_s1 = src1.ptr(0,c);
		const T*         p_s2 = src2.ptr(0,c);
        const mxLogical* p_m  = mask.ptr(0,c);
		for(int r=0; r < rows(); r++) {
            if(p_m[r]) 
                p_d[r] = p_s1[r] - p_s2[r];
		}
	}
}

template<typename T>
void Image<T>::mul(const Image<T> &src1, const Image<T> &src2)
{
	for(int c=0; c < cols(); c++) {
		T* p_d = ptr(0,c);
		const T* p_s1 = src1.ptr(0,c);
		const T* p_s2 = src2.ptr(0,c);
		for(int r=0; r < rows(); r++) {
			p_d[r] = p_s1[r] * p_s2[r];
		}
	}
}

template<typename T>
void Image<T>::div(const Image<T> &src1, const Image<T> &src2)
{
	for(int c=0; c < cols(); c++) {
		T* p_d = ptr(0,c);
		const T* p_s1 = src1.ptr(0,c);
		const T* p_s2 = src2.ptr(0,c);
		for(int r=0; r < rows(); r++) {
			//p_d[r] = (p_s2[r]==0) ? 0 : p_s1[r] / p_s2[r];
			p_d[r] = p_s1[r] / p_s2[r];
		}
	}
}

template<typename T>
void Image<T>::prod(const Image<T> &src1, const Image<T> &src2)
{
	MY_ASSERT(rows()==src1.rows() && cols()==src2.cols() && src1.cols()==src2.rows(), "Le dimensioni non sono compatibili");

	// set elements to zero
	reset();

	// compute the product
	for(int c=0; c < cols(); c++)
	{
		T* p_d  = ptr(0,c);
		const T* p_s2 = src2.ptr(0,c);
		for(int k=0; k < src1.cols(); k++)
		{
			const T* p_s1 = src1.ptr(0,k);
			for(int r=0; r < rows(); r++) {
				p_d[r] += p_s1[r] * p_s2[k];
			}
		}
	}
}

template<typename T>
void Image<T>::prod_t(const Image<T> &src1, const Image<T> &src2)
{
	MY_ASSERT(rows()==src1.rows() && cols()==src2.rows() && src1.cols()==src2.cols(), "Le dimensioni non sono compatibili");

	// set elements to zero
	reset();

	// compute the product
	for(int k=0; k < src1.cols(); k++)
	{
		const T* p_s1 = src1.ptr(0,k);
		const T* p_s2 = src2.ptr(0,k);
		for(int c=0; c < cols(); c++)
		{
			T* p_d  = ptr(0,c);
			for(int r=0; r < rows(); r++) {
				p_d[r] += p_s1[r] * p_s2[c];
			}
		}
	}
}

template<typename T>
T Image<T>::sum() const
{
	T sum = T();
	for(int i3=0; i3 < size(3); i3++) {
		for(int i2=0; i2 < size(2); i2++) {
			for(int i1=0; i1 < size(1); i1++) {
				const T* p_src = ptr(0,i1,i2,i3);
				for(int i0=0; i0 < size(0); i0++) {
					sum += p_src[i0];
				}
			}
		}
	}
	return sum;
}

template<typename T>
T Image<T>::abs_sum() const
{
	T sum = T();
	for(int i3=0; i3 < size(3); i3++) {
		for(int i2=0; i2 < size(2); i2++) {
			for(int i1=0; i1 < size(1); i1++) {
				const T* p_src = ptr(0,i1,i2,i3);
				for(int i0=0; i0 < size(0); i0++) {
					sum += std::abs(p_src[i0]);
				}
			}
		}
	}
	return sum;
}

template<typename T>
T Image<T>::square_sum() const
{
	T sum = T();
	for(int i3=0; i3 < size(3); i3++) {
		for(int i2=0; i2 < size(2); i2++) {
			for(int i1=0; i1 < size(1); i1++) {
				const T* p_src = ptr(0,i1,i2,i3);
				for(int i0=0; i0 < size(0); i0++) {
					sum += p_src[i0]*p_src[i0];
				}
			}
		}
	}
	return sum;
}


#endif
