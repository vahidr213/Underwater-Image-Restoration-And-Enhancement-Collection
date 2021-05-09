
%load image
% num = 57; % 57,51,50,47,36,37,38
% img = double(load_image(num));
frame = 5;
fileNameDataSet=sprintf('D:/RefPic/water (%d).png',frame);% image filename
img = imread(fileNameDataSet);
img = double(img);
[m, n, ~] = size(img);

%**********************find the airlight**********************
blocksize = 100;
showFigure = false;
A = AirlightEstimate(img, blocksize, showFigure);

%******************find the transmission map******************
patchsz = 8; % the size of a patch
% lambda control the relative importance of contrast loss and info loss
lambda = 5;
T = TransEstimate(img, patchsz, A, lambda);
figure,imshow(T)

%*****************refine the transmission map*****************
I = double(rgb2gray(uint8(img))) / 255;
r = 10;
eps = 10^-6;
t = guidedfilter(I, T, r, eps);
figure,imshow(t)

%*********************restore the image***********************
J(:,:,1) = (img(:,:,1) - A(1)) ./ t + A(1);
J(:,:,2) = (img(:,:,2) - A(2)) ./ t + A(2);
J(:,:,3) = (img(:,:,3) - A(3)) ./ t + A(3);
%figure,imshow([img, uint8(J)])
J(:,:,1) = (J(:, :, 1) - min(min(J(:, :, 1)))) / ...
    (max(max(J(:, :, 1))) - min(min(J(:, :, 1)))) * 255;
J(:,:,2) = (J(:, :, 2) - min(min(J(:, :, 2)))) / ...
    (max(max(J(:, :, 2))) - min(min(J(:, :, 2)))) * 255;
J(:,:,3) = (J(:, :, 3) - min(min(J(:, :, 3)))) / ...
    (max(max(J(:, :, 3))) - min(min(J(:, :, 3)))) * 255;
figure,imshow([img, uint8(J)])
%*********************gamma correction************************
%J = (J / 255) .^ 0.8;
%figure,imshow(uint8(J))

% figure,imhist(img(:,:,1)/255),title('red channel')
% figure,imhist(img(:,:,2)/255),title('green channel')
% figure,imhist(img(:,:,3)/255),title('blue channel')
% 
% figure,imhist(J(:,:,1)/255),title('red channel')
% figure,imhist(J(:,:,2)/255),title('Green channel')
% figure,imhist(J(:,:,3)/255),title('blue channel')

%*********************color correction************************
%SCB_J = SimplestColorBalance(J);
%SCB_img = SimplestColorBalance(img);
%figure,imshow([uint8(img), uint8(J); uint8(SCB_img), uint8(SCB_J)])