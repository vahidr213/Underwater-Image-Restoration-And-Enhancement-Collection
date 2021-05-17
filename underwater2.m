clc;clear all;close all
pkg load image % comment this line if using Matlab
pkg load signal
inpath = 'D:\RefPic\';%path for reading image
outpath = 'I:\';% path for saving results
doDegradation = 0; % 0/1  - if 0, the image itself is restored.
%%% if 1, image is degraded at first, then the degraded image is restored back again by
%%% available methods to its original. use this only if you have perfect underwater image
%%% and you want to see the mean squared error.
warning('off', 'all')% suppress all warnings
num = 5;%suffix for reading frame
inpath=sprintf('%swater (%d).png',inpath,num);% image filename
% method = [1.01 1.02 1.03];
method = 1.05;
pwd0=pwd;%current dir
for i = 1:length(method)
    tic
    evaluations(inpath,outpath,doDegradation,method(i));
    cd(pwd0);    
    toc
    printf('\n\n');
    close all
end
%%%return

doDegradation = 1;
cd(pwd0);
for i = 1:length(method)
    tic
    evaluations(inpath,outpath,doDegradation,method(i));
    cd(pwd0);    
    toc
    printf('\n\n');
    close all
end