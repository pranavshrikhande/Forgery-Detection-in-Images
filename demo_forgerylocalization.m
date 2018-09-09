%
% Demo for the forgery localization algorithm based on PRNU 
% by G. Chierchia, G. Poggi, C. Sansone and L. Verdoliva,
% ''A Bayesian-MRF Approach for PRNU-based Image Forgery Detection''
% IEEE Transactions on Information Forensics and Security, 2014.
%
%
clear all; close all; clc;
directory = fileparts(which(mfilename()));
addpath( genpath(fullfile(directory, 'code')), '-end' );

% input image
% camera: CanonEOS_10D or Nikon_D200
% photo: img0i.jpg (i=1,2,3,4)
camera = 'CanonEOS_10D';
photo  = 'img01.jpg';    

% parameters
%filterName = 'mihcak';
filterName = 'bm3d';  

opt_mrf.likelihood = 'bayes';
opt_mrf.norm    = 'L2';         % alternative option: L1
opt_mrf.decimate_factor = 1;
opt_mrf.dilate  = 20;

% N.B. the following parameters are camera-dependent
opt_mrf.beta    = 120;   
opt_mrf.p0      = 0.5;

% load image
[tmp,photoname] = fileparts(photo);
x_pristine = imread(fullfile(directory, 'photos', camera, 'pristine',[photoname,'.jpg']));
x_forged   = imread(fullfile(directory, 'photos', camera,  photo ));
x_mask     = imread(fullfile(directory, 'photos', camera, 'masks', [photoname,'.mask.png']));

% load data
pattern    = load(fullfile(directory, 'data', camera, ['pattern_',filterName,'.mat']) );
hypothesis = load(fullfile(directory, 'data', camera, ['hypothesis_',filterName,'_R64.mat']) );

% detection
getResidue = makeResidueFun(pattern.filterOpt{:});
mask_mrf  = detect_forgery_mrf( x_forged, pattern.prnu, getResidue, hypothesis, opt_mrf);
    
% show
figure;
subplot(1,3,1); imshow(x_pristine); title('Original');
subplot(1,3,2); imshow(x_forged  ); title('Tampered');

[col_mrf,map] = getFalseColoredResult(mask_mrf, x_mask);
measure_mrf = getEvaluationMeasures(mask_mrf, x_mask),
subplot(1,3,3); imshow(col_mrf,map);
title( sprintf('Output (FM=%2.2f%%)', ....
    measure_mrf.FM*100) );

