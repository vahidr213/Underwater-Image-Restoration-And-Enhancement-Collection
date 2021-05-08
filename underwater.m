clc
clear all
close all
pkg load image % comment this line if using Matlab
frame = 5;%suffix for reading frame
fileNameDataSet=sprintf('D:/RefPic/water (%d).png',frame);% image filename
imref = imread(fileNameDataSet);% reference image
im = imref;% im holds the degraded image
im2 = im;
%%%% convert im to normalize 0-1 range
im = im2double( im );
%%%%%% destructing ref image
%%square grid size or square patch size - e.g. 3x3
gsdestruction = 3;
pwd0=pwd;
cd('./01.01/')
medtransMat  =  mediumtransmissionMat (im, gsdestruction, 1);
cd(pwd0);
im( : , : , 1) = im( : , : , 1)  .* medtransMat ;
mse = immse ( im2uint8( im(:,:,1) ) , imref (:,:,1) );
disp(['mse bw ref image and degraded image is:    ',num2str(mse)]);
%%figure,imshow(cat(2,im2uint8(im),imref))

%%%%%%%%%%% 
im(:,:,1)=im2double(imref(:,:,1));
tic
% im(:,:,1) = guided_filter(im(:,:,1), medtransMat, 0.1, 5);
myevaluations(im,imref,4.00,frame);
% mse = immse (im2(:,:,1) , imref (:,:,1) );
% disp(['mse bw ref image and restored image is:    ',num2str(mse)]);
% figure('name','restored vs original'),imshow(cat(2, im2, imref));


toc
%%%return