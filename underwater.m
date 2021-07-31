clc
clear all
close all
format short g
format compact
if (exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    pkg load image
    pkg load signal
end
inpath = 'D:\RefPic\';%path for reading underwater image

outpath = 'I:\';% path for saving results
doDegradation = 2.0; % 0/2  - if 0, the image itself is restored and there is no reference image.
%%% if 2, the image is restored and the reference image is also available for it. 
warning('off', 'all')% suppress all warnings
listing = dir(fullfile(inpath,'*.jpg'));% list of files in the specified folder
n = 1; % first image in the image list
inpath = [inpath,listing(n).name];
% % % fast methods  
method = [17.00 16.00 15.00 14.00 13.00 12.01 12.00 11.00 10.00 9.00 8.01 8.00 7.00 6.01 5.00 4.00 3.00 2.01 2.00 1.01 1.02 1.03 1.07 1.08 1.09 1.10 1.11 1.12];
%  method = 06.01;
pwd0=pwd;%current dir

cd(pwd0);
% parpool(2)

%%% the following for loop evaluates several methods on just one image (not a dataset)
%%% each image is first degraded and then restored back. the restored result
%%% is then compared with the initial source image.
for i = 1:length(method)
    outpath = ['I:\',listing(n).name,' '];
    tic
    imrestored = evaluations(inpath,outpath,doDegradation,method(i));

    if doDegradation == 0.0 %for images with no reference images
        resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method(i));
        % write the result on the disk
        imwrite(cat(2, imrestored, imref ) , resfilename);
        close all
    end
    if doDegradation == 2.0 %for images with reference images
        % read the reference image
        imref = imread('D:\RefPic\ref_DeepBlue.jpg');
        % mean squared error bw reference and restored images
        mse = immse(double(imref),double(imrestored));
        resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method(i));
        % write the result on the disk
        imwrite(cat(2, imrestored, imref ) , resfilename);
    end
    toc
    cd(pwd0);
    fprintf('\n\n');
    close all
end

