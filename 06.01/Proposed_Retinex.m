%clc,
%clear,
%****************************add the folder path***************************
% addpath(genpath('./ImageGuidedFilter'));
% addpath(genpath('./DT-CWT'));
% addpath(genpath('./HFEnhancement'));
% addpath(genpath('./Image Evaluate'));
% addpath(genpath('./PyrTools'));
addpath(('D:/A-Collection-Of-Underwater-Image-Restoration-And-Enhancement-With-Mean-Squared-Error-Measuring/06.01/ImageGuidedFilter'));
addpath(('D:/A-Collection-Of-Underwater-Image-Restoration-And-Enhancement-With-Mean-Squared-Error-Measuring/06.01/DT-CWT'));
addpath(('D:/A-Collection-Of-Underwater-Image-Restoration-And-Enhancement-With-Mean-Squared-Error-Measuring/06.01/HFEnhancement'));
addpath(('D:/A-Collection-Of-Underwater-Image-Restoration-And-Enhancement-With-Mean-Squared-Error-Measuring/06.01/Image Evaluate'));
addpath(('D:/A-Collection-Of-Underwater-Image-Restoration-And-Enhancement-With-Mean-Squared-Error-Measuring/06.01/PyrTools'));


%********************************Load image********************************
% vargin contains 16 images, which are from the folder 'images'
%vargin = load_vargin;
%I = image_load(vargin{2});
%vargin = 'liahthouse.png';
%I = image_load(vargin);
vargin=sprintf('D:/RefPic/water (%d).png',5);% image filename
I = imread(vargin);
%I=image_load(vargin);
%vargin='greenwich-reference.png';
%ref=image_load(vargin);

%*********************Transform RGB image to HSV space*********************
hsv = rgb2hsv(I); % Hue, Saturation and Value layers
H = hsv(:,:,1);
S = hsv(:,:,2);
V = hsv(:,:,3);
%***********Details enhancement process using Laplacian operator***********
%lap=[0 -1 0; -1 4 -1; 0 -1 0];
%G = imfilter(V, lap, 'replicate', 'conv');
%k = 0.05; % Set the positive parameter
%V = abs(V - k * G);
%V = (V - min(min(V))) / (max(max(V)) - min(min(V)));

%******One layer decomposition using Dual-tree real wavelet transform******
[Faf, Fsf] = FSfarras; % set decomposition and recover parameters
[af, sf] = dualfilt1;
J = 1;
w = cplxdual2D(V, J, Faf, af);

%**************************Processing the HF signal************************
Imag = sqrt(-1);
T = 50 / 255;
for j = 1 : J
    for s1 = 1 : 2
        for s2 = 1 : 3
            D = w{j}{1}{s1}{s2} + Imag * w{j}{2}{s1}{s2};
            %D = HFEnphasizeFilter(D);
            %D = soft(D, T);
            w{j}{1}{s1}{s2} = real(D);
            w{j}{2}{s1}{s2} = imag(D);
        end
    end
end

%*************************Processing the LF signal*************************
Imag = sqrt(-1);
for s = 1 : 2
    C = w{J + 1}{1}{s} + Imag * w{J + 1}{2}{s};
    wout = altm_method(C);
    w{J+1}{1}{s} = real(wout);
    w{J+1}{2}{s} = imag(wout);
end

%**************************Inverse transformation**************************
V = icplxdual2D(w, J, Fsf, sf);
[a1, b1] = size(V);
[a2, b2] = size(H);
if a1 ~= a2 || b1 ~= b2
    V = imresize(V, [a2, b2]);
end
%V = SimplestColorBalance(V, 0.001, 0.02, 1);
%******************************Image synthesis*****************************
hsv = cat(3, H, S, V);
%*********************Transform HSV image to RGB space*********************
rgb = hsv2rgb(hsv);
%figure,imshow(rgb)
rgb = adjustment(rgb,I);
imshow([I,uint8(rgb*255)])
imwrite(uint8(rgb*255),'proposed.png');
%PSNR = psnr(uint8(rgb*255), uint8(ref))
%[SSIMVAL, ~] = ssim(uint8(rgb*255), uint8(ref))
%[FSIM, ~] = FeatureSIM(uint8(ref), uint8(rgb*255))
%rgb1 = rgb2gray(uint8(rgb*255));
%ref1 = rgb2gray(uint8(ref));
%vif = vifvec(ref1,rgb1)

%**************************Remove the folder path**************************
rmpath 'Image Evaluate';
rmpath 'HFEnhancement';
rmpath 'DT-CWT';
rmpath 'ImageGuidedFilter';
rmpath 'PyrTools';