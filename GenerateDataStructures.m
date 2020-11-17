%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSYCH 221 : Google Pixel 4A Noise Model - Compiles the Data Structures
% for all the various scripts.
% Authors : Melissa Horowitz, Joey Yurgelon
% Date : 11/3/2020
% Required File Structure : 
%          See 'project/README.txt' - MATLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

disp('Running PRNU / DSNU')
run('PRNU_DSNU.m')

close all
clear all
clc

disp('Running Dark Current Rate')
run('DarkCurrentRate.m')

close all
clear all
clc

disp('Running Read Noise')
run('ReadNoise.m')