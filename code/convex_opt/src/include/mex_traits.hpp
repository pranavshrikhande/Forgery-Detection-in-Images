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

#ifndef MEX_TRAITS_HPP
#define MEX_TRAITS_HPP

#include <mex.h>
#include <matrix.h>


template <typename T>
struct mxClassIDTrait {
	static const mxClassID type = mxUNKNOWN_CLASS;
};
template <>
struct mxClassIDTrait<mxLogical> {
	static const mxClassID type = mxLOGICAL_CLASS;
};
template <>
struct mxClassIDTrait<uint8_t> {
	static const mxClassID type = mxUINT8_CLASS;
};
template <>
struct mxClassIDTrait<int8_t> {
	static const mxClassID type = mxINT8_CLASS;
};
template <>
struct mxClassIDTrait<uint16_t> {
	static const mxClassID type = mxUINT16_CLASS;
};
template <>
struct mxClassIDTrait<int16_t> {
	static const mxClassID type = mxINT16_CLASS;
};
template <>
struct mxClassIDTrait<uint32_t> {
	static const mxClassID type = mxUINT32_CLASS;
};
template <>
struct mxClassIDTrait<int32_t> {
	static const mxClassID type = mxINT32_CLASS;
};
template <>
struct mxClassIDTrait<uint64_t> {
	static const mxClassID type = mxUINT64_CLASS;
};
template <>
struct mxClassIDTrait<int64_t> {
	static const mxClassID type = mxINT64_CLASS;
};
template <>
struct mxClassIDTrait<float> {
	static const mxClassID type = mxSINGLE_CLASS;
};
template <>
struct mxClassIDTrait<double> {
	static const mxClassID type = mxDOUBLE_CLASS;
};

#endif