clc
clear all
close all
pkg load image
frame = 5;
fileNameDataSet=sprintf('D:/RefPic/water (%d).png',frame);
imref = imread(fileNameDataSet);
im = imref;
im2 = im;
%%%% convert im to normalize 0-1 range
im = im2double( im );
%%%%%% destructing ref image
%%square grid size or square patch size - e.g. 3x3
gsdestruction = 3;
medtransMat  =  mediumtransmissionMat (im, gsdestruction, 1);
im( : , : , 1) = im( : , : , 1)  .* medtransMat ;
mse = immse ( im2uint8( im(:,:,1) ) , imref (:,:,1) );
disp(['mse bw ref image and degraded image is:    ',num2str(mse)]);
%%figure,imshow(cat(2,im2uint8(im),imref))

%%%%%%%%%%% 

tic
% im(:,:,1) = guided_filter(im(:,:,1), medtransMat, 0.1, 5);
im2( : , : , 1) = im2uint8( myevaluations(im,imref) );
mse = immse (im2(:,:,1) , imref (:,:,1) );
% disp(['mse bw ref image and restored image is:    ',num2str(mse)]);
% figure('name','restored vs original'),imshow(cat(2, im2, imref));
figure('name','restored vs original'),imshow(cat(2, im2, im2uint8(im) ));

toc
%%%return