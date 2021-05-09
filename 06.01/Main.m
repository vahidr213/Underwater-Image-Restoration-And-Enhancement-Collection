function rgb = Proposed(vargin)
%****************************add the folder path***************************
addpath(genpath('ImageGuidedFilter'));
addpath(genpath('DT-CWT'));
addpath(genpath('HFEnhancement'));

%********************************Load image********************************
% vargin contains 16 images, which are from the folder 'images'
%vargin = load_vargin;
I = image_load(vargin);
%figure,imhist(I(:,:,1))
%hold on
%imhist(I(:,:,2))
%imhist(I(:,:,3))
%hold off
%figure,imshow(I)

%*********************Transform RGB image to HSV space*********************
[H, S, V] = rgb2hsv(I); % Hue, Saturation and Value layers

%***********Details enhancement process using Laplacian operator***********
lap=[0 -1 0; -1 4 -1; 0 -1 0];
G = imfilter(V, lap, 'replicate', 'conv');
k = 0.05; % Set the positive parameter
V = abs(V - k * G);
V = (V - min(min(V))) / (max(max(V)) - min(min(V)));

%******One layer decomposition using Dual-tree real wavelet transform******
[Faf, Fsf] = FSfarras; % set decomposition and recover parameters
[af, sf] = dualfilt1;
J = 1;
w = cplxdual2D(V, J, Faf, af);

%**************************Processing the HF signal************************
Imag = sqrt(-1);
T = 40 / 255;
for j = 1 : J
    for s1 = 1 : 2
        for s2 = 1 : 3
            D = w{j}{1}{s1}{s2} + Imag * w{j}{2}{s1}{s2};
            %D = soft(D, T);
            D = HFEnphasizeFilter(D);
            %D = FuzzyEnhance(D);
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

%******************************Image synthesis*****************************
hsv = cat(3, H, S, V);
%*********************Transform HSV image to RGB space*********************
rgb = hsv2rgb(hsv);
rgb = adjustment(rgb,I);
%Mean = (mean2(rgb(:,:,1))+mean2(rgb(:,:,2))+mean2(rgb(:,:,3)))/3 * 255
%Std = (std2(rgb(:,:,1))+std2(rgb(:,:,2))+std2(rgb(:,:,3)))/3 *255
%figure,imshow(rgb5)
%figure,imhist(rgb(:,:,1))
%hold on
%imhist(rgb(:,:,2))
%imhist(rgb(:,:,3))
%hold off

%**************************Remove the folder path**************************
rmpath 'HFEnhancement';
rmpath 'DT-CWT';
rmpath 'ImageGuidedFilter';