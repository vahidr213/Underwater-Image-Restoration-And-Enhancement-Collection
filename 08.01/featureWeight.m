function [W1, W2] = featureWeight(img1, img2)
% for img1
R1 = double(rgb2gray(img1)) / 255;
% Luminance weight
WC1 = sqrt(( (double(img1(:,:,1))/255 - double(R1)).^2 + ...
            (double(img1(:,:,2))/255 - double(R1)).^2 + ...
            (double(img1(:,:,3))/255 - double(R1)).^2 ) / 3);
%figure,imshow(WC1,[])
% saliency weight
WS1 = saliencyDetection(img1);
%figure,imshow(WS1,[])
% exposedness weight
sigma = 0.125;
aver = 0.25;
WE1 = exp(-(R1 - aver).^2 / (2*sigma^2));
%figure,imshow(WE1,[])

% for img1
R2 = double(rgb2gray(img2)) / 255;
% Luminance weight
WC2 = sqrt(( (double(img2(:,:,1))/255 - double(R2)).^2 + ...
            (double(img2(:,:,2))/255 - double(R2)).^2 + ...
            (double(img2(:,:,3))/255 - double(R2)).^2 ) / 3);
%figure,imshow(WC2,[])
% saliency weight
WS2 = saliencyDetection(img2);
%figure,imshow(WS2,[])
% exposedness weight
sigma = 0.125;
aver = 0.25;
WE2 = exp(-(R2 - aver).^2 / (2*sigma^2));
%figure,imshow(WE2,[])

% calculate the normalized weight
W1 = (WC1 + WS1 + WE1) ./ ...
     (WC1 + WS1 + WE1 + WC2 + WS2 + WE2) * 2;
%figure,imshow(W1,[])
W2 = (WC2 + WS2 + WE2) ./ ...
     (WC1 + WS1 + WE1 + WC2 + WS2 + WE2) * 2;
%figure,imshow(W2,[])