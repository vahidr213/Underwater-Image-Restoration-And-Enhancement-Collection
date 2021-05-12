function J = demo_each_channel1(num,inpath)
%load image
path=sprintf('%swater (%d).png',inpath,num);% image filename
img = imread(path);
img = double(img);
[m, n, ~] = size(img);
%**********************find the airlight**********************
blocksize = 200;
showFigure = false;
A = AirlightEstimate(img, blocksize, showFigure);
%*************find and refine the transmission map************
patchsz = 8; % the size of a patch
lambda = 5; % control importance of contrast loss and info. loss
r = 20; % kernel size of guided filter
eps = 10^-6;
T = TransEstimate_each(img(:, :, 1), patchsz, A(1), lambda);
t_r = guidedfilter(img(:, :, 1) / 255, 1-T, r, eps);
T = TransEstimate_each(img(:, :, 2), patchsz, A(2), lambda);
t_g = guidedfilter(img(:, :, 2) / 255, 1-T, r, eps);
T = TransEstimate_each(img(:, :, 3), patchsz, A(3), lambda);
t_b = guidedfilter(img(:, :, 3) / 255, 1-T, r, eps);


%figure,imshow([T_R,T_G,T_B])
%figure,imagesc([t_r,t_g,t_b]), axis image, truesize; colorbar

%*********************restore the image***********************
J(:,:,1) = (img(:,:,1) - A(1)) ./ t_r + A(1);
J(:,:,2) = (img(:,:,2) - A(2)) ./ t_g + A(2);
J(:,:,3) = (img(:,:,3) - A(3)) ./ t_b + A(3);
%figure,imshow(uint8(J))
% J(:,:,1) = (J(:, :, 1) - min(min(J(:, :, 1)))) / ...
%     (max(max(J(:, :, 1))) - min(min(J(:, :, 1)))) * 255;
% J(:,:,2) = (J(:, :, 2) - min(min(J(:, :, 2)))) / ...
%     (max(max(J(:, :, 2))) - min(min(J(:, :, 2)))) * 255;
% J(:,:,3) = (J(:, :, 3) - min(min(J(:, :, 3)))) / ...
%     (max(max(J(:, :, 3))) - min(min(J(:, :, 3)))) * 255;
%figure,imshow([uint8(img),uint8(J)])
figure,imshow(uint8(J))
%SCB_J = SimplestColorBalance(J);
%figure,imshow([uint8(img), uint8(SCB_img), uint8(J), uint8(SCB_J)])