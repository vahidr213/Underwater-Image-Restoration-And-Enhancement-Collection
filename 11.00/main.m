function imrestored=main(num,inpath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DIP-Assignment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Image input
% We take a RGB image as input and convert it to grayscale and store it in
% another variable, so we can get the mean luminance.
path=sprintf('%swater (%d).png',inpath,num);% image filename
rgbImage=imread(path);
rgbImage=im2double(rgbImage);
grayImage = rgb2gray(rgbImage); 
%% White Balancing
% Extract the individual red, green, and blue color channels.
redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);

meanR = mean2(redChannel);
meanG = mean2(greenChannel);
meanB = mean2(blueChannel);
meanGray = mean2(grayImage);

% Make all channels have the same mean
redChannel = (double(redChannel) * meanGray / meanR);
greenChannel = (double(greenChannel) * meanGray / meanG);
blueChannel = (double(blueChannel) * meanGray / meanB);

%redChannel and blueChannel Correction
redChannel=redChannel-0.3*(meanG-meanR).*greenChannel.*(1-redChannel);
blueChannel=blueChannel+0.3*(meanG-meanB).*greenChannel.*(1-blueChannel);


% Recombine separate color channels into a single, true color RGB image.
rgbImage_white_balance = cat(3, redChannel, greenChannel, blueChannel);

figure('Name','Color Enhancement');
subplot(221);
imshow(redChannel);
title('Suppressed Red Channel');

subplot(222);
imshow(blueChannel);
title('Enhanced Blue Channel');

subplot(223);
imshow(greenChannel);
title('Green Channel');

subplot(224);
imshow(rgbImage_white_balance);
title('After White balance');

%% Gamma Correction and sharpening
I = imadjust(rgbImage_white_balance,[],[],0.5);
            
J=(rgbImage_white_balance+(rgbImage_white_balance-imgaussfilt(rgbImage_white_balance)));

figure('Name','Step I-III');
subplot(221);
imshow(rgbImage);
title('Original Image');

subplot(222);
imshow(rgbImage_white_balance);
title('I. White Balance');

subplot(223);
imshow(I);
title('II. Gamma Corrected');
subplot(224);
imshow(J);
title('III. Sharpened');
%% Image Fusion using wavelet transform

XFUS = wfusimg(I,J,'sym4',3,'max','max');

figure('Name','Final Comparison');
subplot(121);
imshow(rgbImage);
title('Original');

subplot(122);
imshow((histeq(XFUS)));
title('IV. Wavelet fusion');
imrestored = histeq(XFUS);