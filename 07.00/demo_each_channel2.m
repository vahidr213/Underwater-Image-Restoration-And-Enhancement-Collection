
%load image
frame = 5;
fileNameDataSet=sprintf('D:/RefPic/water (%d).png',frame);% image filename
img = imread(fileNameDataSet);
img = double(img);
[m, n, ~] = size(img);
%**********************find the airlight**********************
blocksize = 200;
showFigure = false;
A = AirlightEstimate(img, blocksize, showFigure);
%*************find and refine the transmission map************
patchsz = 8; % the size of a patch
lambda = 1; % control importance of contrast loss and info. loss
r = 20; % kernel size of guided filter
eps = 10^-6;
T = TransEstimate_each(img(:, :, 1), patchsz, A(1), lambda);
t1 = guidedfilter(img(:, :, 1) / 255, 1-T, r, eps);
T = TransEstimate_each(img(:, :, 2), patchsz, A(2), lambda);
t2 = guidedfilter(img(:, :, 2) / 255, 1-T, r, eps);
T = TransEstimate_each(img(:, :, 3), patchsz, A(3), lambda);
t3 = guidedfilter(img(:, :, 3) / 255, 1-T, r, eps);

temp{1} = t1; temp{2} = t2; temp{3} = t3;
Mean_img = [mean2(img(:,:,1)), mean2(img(:,:,2)), mean2(img(:,:,3))];
Mean_t = [mean2(temp{1}), mean2(temp{2}), mean2(temp{3})];
t{find(Mean_img == min(Mean_img))} = ...
    temp{find(Mean_t == min(Mean_t))};
t{find(Mean_img == median(Mean_img))} = ...
    temp{find(Mean_t == median(Mean_t))};
t{find(Mean_img == max(Mean_img))} = ...
    temp{find(Mean_t == max(Mean_t))};

t_r = t{1}; t_g = t{2}; t_b = t{3};

%figure,imshow([T_R,T_G,T_B])
%figure,imagesc([t_r,t_g,t_b]), axis image, truesize; colorbar

%*********************restore the image***********************
J(:,:,1) = (img(:,:,1) - A(1)) ./ t_r + A(1);
J(:,:,2) = (img(:,:,2) - A(2)) ./ t_g + A(2);
J(:,:,3) = (img(:,:,3) - A(3)) ./ t_b + A(3);
figure,imshow([uint8(img), uint8(J)])
%*********************gamma correction************************
%J = (J / 255) .^ 0.8;
%figure,imshow(J)
