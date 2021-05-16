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
tic
myevaluations(13.01,inpath,outpath,doDegradation);
% mse = immse (im2(:,:,1) , imref (:,:,1) );
% disp(['mse bw ref image and restored image is:    ',num2str(mse)]);
% figure('name','restored vs original'),imshow(cat(2, im2, imref));
toc
%%%return