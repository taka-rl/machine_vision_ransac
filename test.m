% Define RANSAC parameters
% ransac_linedetection(testimage, numIterations, thresholdDistance, minInliers)
% numIterations: Number of iteration
% thresholdDistance:Distance threshold to consider a point as an inlier
% minInliers:Minimum number of inliers to accept a line

% test
clc;
clear;
ransac_linedetection('testimage.png', 120, 0.1, 20);

