clc
clear all
close all
format short g
format compact
if (exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    pkg load image
    pkg load signal
end
inpath = 'E:\raw-890\';%path for reading degraded image
inrefpath = 'E:\reference-890\'; % path for reading refence image
savePicResults = false;% true = save results on the disk
outpath = 'E:\';% path for saving results
doDegradation = 2.0; % 0/2  - if 0, the image itself is restored and there is no reference image.
%%% if doDegradation = 2.0, the image is restored and the reference image is also available for it. 
warning('off', 'all')% suppress all warnings
listing = dir(fullfile(inpath,'*.png'));% list of files in the specified folder
listing = natsortfiles(listing);% alphabetical sorting of files
n = 2; % number of image e.g. 1
% listing(n).name
inpath = [inpath,listing(n).name];
% % %  methods
% %  all the methods are labeled in below
% method = [18.01 18.00 17.00 16.00 15.00 14.00 13.00 12.01 12.00 11.00 10.00 9.00 8.01 8.00 7.00 6.01 5.00 4.00 3.00 2.01 2.00 1.01 1.02 1.03 1.07 1.08 1.09 1.10 1.11 1.12];
method =18.00;
pwd0=pwd;%current dir
fe=1;
% if fe=0 : only mse, Pmse, FP=False positive, TP=True Positive are
% calculated for each image
% if fe=1 : mse, Pmse, FP=False positive, TP=True Positive , PSNR, SSIM are
% computed
sumMSE = 0.0; Pmse = 0.0; sumPmse = 0.0;sumSSIM = 0.0; sumPSNR = 0.0;FP=0;TP=0;

%%% the following for loop evaluates several methods on just one image (not a dataset)
tic
for i = 1:length(method)
    outpath = ['E:\',listing(n).name,' '];
    imrestored = evaluations(inpath,outpath,doDegradation,method(i));
    if (savePicResults) 
        resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method(i));
        % write the result on the disk
        imwrite(cat(2, imrestored, imref ) , resfilename);
    end
    if doDegradation == 2.0 %for images with reference images
        % read the reference image
        im = imread(inpath);
        imref = imread(fullfile(inrefpath,listing(n).name));
[mse0,mse1,Pmse,sumMSE,sumPmse,sumSSIM,sumPSNR,FP,TP] = errormeasure(im,imref,imrestored,sumMSE,sumPmse,sumSSIM,sumPSNR,FP,TP,fe);
    end
fprintf('<mse:%.1f><Pmse:%.1f><FP:%d><TP:%d><PSNR:%.4f><SSIM:%.4f>\n',sumMSE/n, sumPmse/n,FP,TP,sumPSNR/n,sumSSIM/n);%<PSNR:%.4f><SSIM:%.4f>   ,sumPSNR/n,sumSSIM/n
    cd(pwd0);
    close all
end
toc

