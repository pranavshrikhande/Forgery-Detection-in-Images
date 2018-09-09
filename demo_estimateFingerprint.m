%
% demo for PRNU extraction
%
% change correctly the "datasetFolder" variable, before to execute this script
clear all; close all;
directory = fileparts(which(mfilename()));
addpath( genpath(fullfile(directory, 'code')), '-end' );


% parameters
datasetFolder = fullfile(directory, '..', 'prnuDB','dataset');
camera = 'CanonEOS_10D';   % camera name

filterOpt = {'bm3d', 5};   % denoising filter + noise sigma
%filterOpt = {'mihcak', 3};
radius = 64;
params = [250 6 0.03]; 

% make lists of images
all_cameras = discover_folders(datasetFolder);
prnu_dir = fullfile(datasetFolder, camera, 'train');
hyp0_dir = fullfile(datasetFolder, setdiff(all_cameras,camera), 'predictor_train' );
hyp1_dir = fullfile(datasetFolder, camera, 'predictor_train');
prnu_images = discover_images(prnu_dir, 'jpg');
hyp0_images = discover_images(hyp0_dir, 'jpg', 50 );
hyp1_images = discover_images(hyp1_dir, 'jpg' );

% PRNU extraction
getResidue = makeResidueFun(filterOpt{:});
pattern = struct();
pattern.camera = camera;
pattern.filterOpt = filterOpt;
pattern.prnu = getFingerprint_Binghamton(prnu_images, getResidue);

% Hypothesis extraction
hypothesis = getHypothesisSliding(hyp0_images, hyp1_images, pattern.prnu, getResidue, radius, params);

% write files
file_pattern    = sprintf('%s_pattern_%s.mat'       , pattern.camera, pattern.filterOpt{1});
file_hypothesis = sprintf('%s_hypothesis_%s_R%d.mat', pattern.camera, pattern.filterOpt{1}, radius);

save(file_pattern   , '-struct', 'pattern'   );
save(file_hypothesis, '-struct', 'hypothesis');
            
