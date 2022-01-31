
function imrestored = colorcorrection(option,img,varargin)
switch option
    case 1 % shift the red mean + combining with green channel+ sharping
    rgbImage=im2double(img);
    grayImage = rgb2gray(rgbImage); 
    % White Balancing
    meanR = mean2(rgbImage(:,:,1));
    meanG = mean2(rgbImage(:,:,2));
    meanGray = mean2(grayImage);

    % Make all channels have the same mean
    rgbImage(:,:,1) = (double(rgbImage(:,:,1)) * meanGray / meanR);
    %redChannel
    rgbImage(:,:,1)=rgbImage(:,:,1)+varargin{1}*(meanG-meanR).*rgbImage(:,:,2).*(1-rgbImage(:,:,1));
    rgbImage(:,:,1)=mat2gray(rgbImage(:,:,1));
    imrestored=uint8(255*rgbImage);
    imrestored=imsharpen(imrestored);
    case 2
        imrestored=Global_Compression_RGB(img);
    case 3
        imrestored=Global_Compression(img);
    case 4
        imrestored=pyramid1(img,varargin{1},varargin{2});
    case 5
        imrestored = img;
    case 6
        stBin = varargin{1};
        im1 = img;
        lut = uint8(0:255);
        lut(stBin:end) = uint8(linspace(0,256-stBin,257-stBin));
        im1(:,:,1) = intlut(img(:,:,1),lut);
        imrestored = Global_Compression(im1);
    case 7
        im1=im2double(img);
        imrestored = img;
        m=mean2(im1(:,:,1));
        sig=std2(im1(:,:,1));
        gamma=exp((1-(m+sig))/2);
        k=im1(:,:,1).^gamma; 
        k=k+(1-k)*(m^gamma);
        c=1./(1+(k-1)*heaviside(0.5-m+eps));
        imrestored(:,:,1)=uint8(255*(c.*im1(:,:,1).^gamma));

        % m=mean2(im1(:,:,2));sig=std2(im1(:,:,2));
        % gamma=exp((1-(m+sig))/2);
        % k=im1(:,:,1).^gamma; k=k+(1-k)*(m^gamma);
        % c=1./(1+(k-1)*heaviside(0.5-m+eps));
        % im2(:,:,2)=uint8(255*(c.*im1(:,:,2).^gamma));
        % 
        % m=mean2(im1(:,:,3));sig=std2(im1(:,:,3));
        % gamma=exp((1-(m+sig))/2);
        % k=im1(:,:,3).^gamma; k=k+(1-k)*(m^gamma);
        % c=1./(1+(k-1)*heaviside(0.5-m+eps));
        % im2(:,:,3)=uint8(255*(c.*im1(:,:,3).^gamma));
    case 8
        % luminosity stretch 
        % ex. colorcorrection(8,img,0.996)
        lab=rgb2lab(img);
        lab(:,:,1)=lab(:,:,1)/100;
        lab(:,:,1)=imadjust(lab(:,:,1))*100;
        imrestored=uint8(255*lab2rgb(lab));
    case 9
        hsv=rgb2hsv(img);
        hsv(:,:,2)=imadjust(hsv(:,:,2));%
        imrestored=im2uint8(hsv2rgb(hsv));
    case 10 %% global adaptation for H or S or V, #channel is in varargin{1}
        hsv=rgb2hsv(img);
        satmax=max(max(hsv(:,:,varargin{1})));
        sataver = exp(sum(sum(log(0.001 + hsv(:,:,varargin{1})))) / numel(hsv(:,:,varargin{1})));% log-average luminance
        satg = log(hsv(:,:,varargin{1}) / sataver + 1) / log(satmax / sataver + 1);
        hsv(:,:,varargin{1})=satg;
        imrestored=im2uint8(hsv2rgb(hsv));
    case 11
        imrestored=pyramidHaar(img,varargin{1});
    case 12
        pwd0=cd('./02.00/');imrestored=main(img);cd(pwd0);
     case 13
        imrestored=pyramidsaturation(img,varargin{1},varargin{2});
     case 14
        lift = varargin{1};
        gain = varargin{2};
        gamma = varargin{3};
        im1 = im2double(img);
        imout=( gain * (im1 + lift.*(1-im1))  ).^gamma;
        imrestored = im2uint8(imout);
%        gain=varargin{1};
%        imd=im2double(img);
%        imdmask=double(imd>0.6).*imd;
%        imdmask=gain*imdmask;
%        imdmask(imdmask>1)=1.0;
%        imdout=imdmask+double(imd<=0.6).*imd;
%        imrestored=im2uint8(imdout);
     case 15
        imrestored = white_balance3(img,varargin{1});
     case 16
        im2=im2double(img);
        im2 = exp(-im2./mean(mean(im2)));
        im2 = im2 - min(min(im2));
        imrestored=im2uint8(im2);
     case 17
        pwd0=cd('./05.00/');imrestored=main(img);cd(pwd0);
     case 18
        im1=im2double(img);
        im1 = im1.^varargin{1};
        imrestored = im2uint8(im1);
     case 19
        imrestored=pullbacklift(img,varargin{1});
     case 20
        im1=img;
         mu=mean(mean(double(img)));
         lut(1,1:256,1)=0:255;
         lut(1,1:256,2)=0:255;
         lut(1,1:256,3)=0:255;
         lut=lut.*exp( varargin{1}*(lut-mu)/255 );
         lut=uint8(lut);
         im1(:,:,1) = intlut(img(:,:,1),lut(:,:,1));
         im1(:,:,2) = intlut(img(:,:,2),lut(:,:,2));
         im1(:,:,3) = intlut(img(:,:,3),lut(:,:,3));
         imrestored=im1;
         
%        im=im2double(img);
%        for i = 1:3
%%           [h,binloc]=imhist(im(:,:,i),256);
%%           [~,idm]=max(h);
%%           cent=binloc(idm);
%           cent = mean2(im(:,:,i));
%           im(:,:,i)=im(:,:,i).*exp((im(:,:,i)-cent)/varargin{1});
%        end
%        imrestored = im2uint8(im);
     case 21
        lut = uint8(0:255);
        for i = 8:250
           if mod(lut(i),2)==0
              lut(i) = lut(i-1);
           end
        end
        imrestored = intlut(img,lut);
        
        
     case 22
        
        for j=1:size(img,3)
            histim=imhist(img(:,:,j),256);
            histim=histim/sum(histim);
            sumh=0;
            for i=1:256
                sumh=sumh+histim(i);
                if sumh>0.3 % if cdf is more than 0.01 break the loop
                    Imin(1,1,j)=i;
                    break;
                end
            end
        end

        for j=1:size(img,3)
            histim=imhist(img(:,:,j),256);
            histim=histim/sum(histim);
            sumh=0;
            for i=1:256
                sumh=sumh+histim(i);
                if sumh>0.97 % if cdf is more than 0.01 break the loop
                    Imax(1,1,j)=i;
                    break;
                end
            end
        end
         lut(1,1:256,1)=0:255;
         lut(1,1:256,2)=0:255;
         lut(1,1:256,3)=0:255;
         lut=lut.*exp( varargin{1}*(lut-Imin)/255 );
         lut(1,1:Imin(1,1,1),1)=1:Imin(1,1,1);
         lut(1,1:Imin(1,1,2),2)=1:Imin(1,1,2);
         lut(1,1:Imin(1,1,3),3)=1:Imin(1,1,3);
         lut=uint8(lut);
         im1(:,:,1) = intlut(img(:,:,1),lut(:,:,1));
         im1(:,:,2) = intlut(img(:,:,2),lut(:,:,2));
         im1(:,:,3) = intlut(img(:,:,3),lut(:,:,3));
         imrestored=im1;

     case 23
        imrestored = img;
        imrestored(:,:,1) = imadjust(img(:,:,1));
        imrestored(:,:,2) = imadjust(img(:,:,2));
        imrestored(:,:,3) = imadjust(img(:,:,3));
      case 24
        imrestored = imlocalbrighten(img,0.1);
      case 25
        X = double(img(:,:,1));
        pdr = fitdist(X(:),'Normal');
        X = double(img(:,:,2));
        pdg = fitdist(X(:),'Normal');
        pdr.sigma = pdg.sigma;
%         GMModel = fitgmdist(X,2);
        t=linspace(0,255,256)';
        y = pdf(pdr,t);
        y = y/sum(y);
        imrestored = img;
        imrestored(:,:,1) = histeq(img(:,:,1),y);
end
end

function imrestored=pyramid1(img1,img2,opt)
%[meanRG, deltaRG, meanYB, deltaYB, uicm] = UICM(img)
% white balance
%img1 = white_balance(img);
img1 = SimplestColorBalance(img1);
%img1 = white_balance(img);
% input1
% calculate the saliency weight
WS1 = saliency_detection(img1);
% input2
if opt == 2
   % CLAHE
   lab2 = rgb_to_lab(img2);
   lab2(:, :, 1) = adapthisteq(lab2(:, :, 1));
   img2 = lab_to_rgb(lab2);
end
% calculate the saliency weight
WS2 = saliency_detection(img2);
% % calculate the normalized weight
W1=(WS1)./(WS1+WS2);
W2=(WS2)./(WS1+WS2);
%W1=imfilter(W1,fspecial('gaussian',5,0.5));
%W2=imfilter(W2,fspecial('gaussian',5,0.5));
% calculate the gaussian pyramid
level = 5;
Weight1 = gaussian_pyramid(W1, level);
Weight2 = gaussian_pyramid(W2, level);

% calculate the laplacian pyramid
% input1
R1 = laplacian_pyramid(double(double(img1(:, :, 1))), level);
G1 = laplacian_pyramid(double(double(img1(:, :, 2))), level);
B1 = laplacian_pyramid(double(double(img1(:, :, 3))), level);
% input2
R2 = laplacian_pyramid(double(double(img2(:, :, 1))), level);
G2 = laplacian_pyramid(double(double(img2(:, :, 2))), level);
B2 = laplacian_pyramid(double(double(img2(:, :, 3))), level);
R_r=cell(1,level);    R_g=cell(1,level);    R_b=cell(1,level);
% fusion
for i = 1 : level
  R_r{i} = Weight1{i} .* R1{i} + Weight2{i} .* R2{i};
  R_g{i} = Weight1{i} .* G1{i} + Weight2{i} .* G2{i};
  R_b{i} = Weight1{i} .* B1{i} + Weight2{i} .* B2{i};
end

% reconstruct & output
R = pyramid_reconstruct(R_r);
G = pyramid_reconstruct(R_g);
B = pyramid_reconstruct(R_b);
fusion = cat(3, uint8(R), uint8(G), uint8(B));
%uiconm = UIConM(fusion)
%[meanRG, deltaRG, meanYB, deltaYB, uicm] = UICM(fusion)
imrestored = fusion;
end
function lab = rgb_to_lab(rgb)
cform = makecform('srgb2lab');
lab = applycform(rgb,cform);
end
function rgb = lab_to_rgb(lab)
cform = makecform('lab2srgb');
rgb = applycform(lab,cform);
end
function sm = saliency_detection(img)
%
%---------------------------------------------------------
% Read image and blur it with a 3x3 or 5x5 Gaussian filter
%---------------------------------------------------------
%img = imread('input_image.jpg');%Provide input image path
gfrgb = imfilter(img, fspecial('gaussian', 3, 3), 'symmetric', 'conv');
%---------------------------------------------------------
% Perform sRGB to CIE Lab color space conversion (using D65)
%---------------------------------------------------------
%cform = makecform('srgb2lab', 'whitepoint', whitepoint('d65'));
cform = makecform('srgb2lab');
lab = applycform(gfrgb,cform);
%---------------------------------------------------------
% Compute Lab average values (note that in the paper this
% average is found from the unblurred original image, but
% the results are quite similar)
%---------------------------------------------------------
l = double(lab(:,:,1)); lm = mean(mean(l));
a = double(lab(:,:,2)); am = mean(mean(a));
b = double(lab(:,:,3)); bm = mean(mean(b));
%---------------------------------------------------------
% Finally compute the saliency map and display it.
%---------------------------------------------------------
sm = (l-lm).^2 + (a-am).^2 + (b-bm).^2;
end
function out = pyramid_reconstruct(pyramid)
level = length(pyramid);
for i = level : -1 : 2
    %temp_pyramid = pyramid{i};
    [m, n] = size(pyramid{i - 1});
    %out = pyramid{i - 1} + imresize(temp_pyramid, [m, n]);
    pyramid{i - 1} = pyramid{i - 1} + imresize(pyramid{i}, [m, n]);
end
out = pyramid{1};
end
function out = gaussian_pyramid(img, level)
h = 1/16* [1, 4, 6, 4, 1];
filt = h'*h;
out{1} = imfilter(img, filt, 'replicate', 'conv');
temp_img = img;
for i = 2 : level
    temp_img = temp_img(1 : 2 : end, 1 : 2 : end);
    out{i} = imfilter(temp_img, filt, 'replicate', 'conv');
end
end
function out = laplacian_pyramid(img, level)
h = 1/16* [1, 4, 6, 4, 1];
%filt = h'*h;
out{1} = img;
temp_img = img;
for i = 2 : level
    temp_img = temp_img(1 : 2 : end, 1 : 2 : end);
    %out{i} = imfilter(temp_img, filt, 'replicate', 'conv');
    out{i} = temp_img;
end
% calculate the DoG
for i = 1 : level - 1
    [m, n] = size(out{i});
    out{i} = out{i} - imresize(out{i+1}, [m, n]);
end
end
function outval = SimplestColorBalance(im_org)
num = 255;
% SimplestColorBalance(im_orig, satLevel)
% Performs color balancing via histogram normalization.
% satLevel controls the percentage of pixels to clip to white and black.
% Set plot = 0 or 1 to turn diagnostic plots on or off.
if ndims(im_org) == 3
    
    R = sum(sum(im_org(:,:,1)));
    G = sum(sum(im_org(:,:,2)));
    B = sum(sum(im_org(:,:,3)));
    Max = max([R, G, B]);
    ratio = [Max / R, Max / G, Max / B];

    satLevel1 = 0.005 * ratio;
    satLevel2 = 0.005 * ratio;
    
    [m, n, p] = size(im_org);
    imRGB_orig = zeros(p, m * n);
    for i = 1 : p
        imRGB_orig(i, :) = reshape(double(im_org(:, :, i)), [1, m * n]);
        %imRGB_orig(i, :) = imRGB_orig(i, :) / max(imRGB_orig(i, :)) * 255;
    end
else
    
    satLevel1 = 0.001;
    satLevel2 = 0.005;
    [m, n] = size(im_org);
    p = 1;
    imRGB_orig = reshape(double(im_org), [1, m * n]);
    %imRGB_orig = imRGB_orig / max(imRGB_orig) * 255;
end
% full width histogram method
% percentage of the image to saturate to black or white, tweakable param
imRGB = zeros(size(imRGB_orig));
for ch = 1 : p
    q = [satLevel1(ch), 1 - satLevel2(ch)];
    tiles = quantile(imRGB_orig(ch, :), q);
    temp = imRGB_orig(ch, :);
    temp(find(temp < tiles(1))) = tiles(1);
    temp(find(temp > tiles(2))) = tiles(2);
    imRGB(ch, :) = temp;
    bottom = min(imRGB(ch, :)); 
    top = max(imRGB(ch, :));
    imRGB(ch, :) = (imRGB(ch, :) - bottom) * num / (top - bottom); 
end
if ndims(im_org) == 3
    outval = zeros(size(im_org));
    for i = 1 : p
        outval(:, :, i) = reshape(imRGB(i, :), [m, n]); 
    end
else
    outval = reshape(imRGB, [m, n]); 
end
outval = uint8(outval);
%imshow([im_orig,uint8(outval)])
end

function imrestored=Global_Compression(img)
    I = im2double(img);
    % Global Adaptation
    lab=rgb_to_lab(I);
    Lw=lab(:,:,1)/100;
    Lwmax = max(max(Lw));% the maximum luminance value
    [m, n] = size(Lw);
    Lwaver = exp(sum(sum(log(0.001 + Lw))) / (m * n));% log-average luminance
    Lg = log(Lw / Lwaver + 1) / log(Lwmax / Lwaver + 1);
    lab(:,:,1)=Lg*100;
    I=lab_to_rgb(lab);
    imrestored=uint8(255*I);
    % imrestored=pyramid1(II,img);
end
function imrestored=Global_Compression_RGB(img)
    I = im2double(img);
    % Global Adaptation
    Imax = max(max(I));% the maximum intensity value
    [m, n] = size(I);
    Iaver = exp(sum(sum(log(0.001 + I))) / (m * n));% log-average Intensity
    Ig(:,:,1) = log(I(:,:,1) / Iaver(:,:,1) + 1) / log(Imax(1) / Iaver(:,:,1) + 1);
    Ig(:,:,2) = log(I(:,:,2) / Iaver(:,:,2) + 1) / log(Imax(2) / Iaver(:,:,2) + 1);
    Ig(:,:,3) = log(I(:,:,3) / Iaver(:,:,3) + 1) / log(Imax(3) / Iaver(:,:,3) + 1);
    imrestored=uint8(255*Ig);
end

function imrestored=pyramidHaar(img1,img2)
    %[meanRG, deltaRG, meanYB, deltaYB, uicm] = UICM(img)
    %img1 = white_balance(img);    % white balance
    [M,N,~] = size(img1);
    img1 = imresize(img1,[640 640]);
    img2 = imresize(img2,[640 640]);
    img1 = SimplestColorBalance(img1);
    %img1 = white_balance(img);
    %lab2(:, :, 1) = uint8(bilateralFilter(double(lab2(:, :, 1))));
    % input1
    % calculate the saliency weight
    WS1 = saliency_detection(img1);
    % input2
    % calculate the saliency weight
    WS2 = saliency_detection(img2);

    W1=(WS1)./(WS1+WS2);
    W2=(WS2)./(WS1+WS2);
    % calculate the gaussian pyramid
    level = 5;
    H=cell(1,level); V=cell(1,level); D=cell(1,level);
    Weight1 = gaussian_pyramid(W1,level);
    Weight2 = gaussian_pyramid(W2,level);
    % calculate the laplacian pyramid
    [A1,H1,V1,D1]=haart2(imresize(img1,2),level);
    [A2,H2,V2,D2]=haart2(imresize(img2,2),level);
    % A1 = double(imresize(rgb2gray(img1),2^(-level)));
    % A2 = double(imresize(rgb2gray(img2),2^(-level)));
    A1=repmat(Weight1{end},[1 1 3]).*A1;
    A2=repmat(Weight2{end},[1 1 3]).*A2;
    A = A1 + A2;
    for i1=1:level
        for i2=1:3
            H1{i1}(:,:,i2)=Weight1{i1}.*H1{i1}(:,:,i2);
            V1{i1}(:,:,i2)=Weight1{i1}.*V1{i1}(:,:,i2);
            D1{i1}(:,:,i2)=Weight1{i1}.*D1{i1}(:,:,i2);
            H2{i1}(:,:,i2)=Weight2{i1}.*H2{i1}(:,:,i2);
            V2{i1}(:,:,i2)=Weight2{i1}.*V2{i1}(:,:,i2);
            D2{i1}(:,:,i2)=Weight2{i1}.*D2{i1}(:,:,i2);
        end
        H{i1} = H1{i1} + H2{i1};
        V{i1} = V1{i1} + V2{i1};
        D{i1} = D1{i1} + D2{i1};
    end
    fusion = ihaart2(A,H,V,D);
    fusion = uint8(255*mat2gray(fusion));
    fusion = imresize(fusion,[M N]);
    imrestored = fusion;
end

function out=highPassGauss(A,param)
    sz = 5; r0 = param(1); sgma = param(2);
    [f1,f2] = freqspace(sz,'meshgrid');
    r = sqrt(f1.^2 + f2.^2);
    Hd = ones(sz); 
    Hd(r<r0) = 0;
    win = fspecial('gaussian',sz,sgma);
    win = win ./ max(win(:));
    % win = 1 - win;
    h = fwind2(Hd,win);
    out = imfilter(A,h);
end

function imrestored=pyramidsaturation(img1,img2,opt)
hsv=rgb2hsv(img2);
%[meanRG, deltaRG, meanYB, deltaYB, uicm] = UICM(img)
% white balance
%img1 = white_balance(img);
img1 = SimplestColorBalance(img1);
hsv1=rgb2hsv(img1);
%img1 = white_balance(img);
% input1
% calculate the saliency weight
WS1 = saliency_detection(img1);
% input2
if opt == 2
   % CLAHE
   lab2 = rgb_to_lab(img2);
   lab2(:, :, 1) = adapthisteq(lab2(:, :, 1));
   img2 = lab_to_rgb(lab2);
end
hsv2=rgb2hsv(img2);
% calculate the saliency weight
WS2 = saliency_detection(img2);
% % calculate the normalized weight
W1=(WS1)./(WS1+WS2);
W2=(WS2)./(WS1+WS2);
% calculate the gaussian pyramid
level = 5;
Weight1 = gaussian_pyramid(W1, level);
Weight2 = gaussian_pyramid(W2, level);

% calculate the laplacian pyramid
% input1
S1 = laplacian_pyramid(double(double(hsv1(:, :, 2))), level);
% input2
S2 = laplacian_pyramid(double(double(hsv2(:, :, 2))), level);
S_s=cell(1,level);
% fusion
for i = 1 : level
  S_s{i} = Weight1{i} .* S1{i} + Weight2{i} .* S2{i};
end

% reconstruct & output
hsv(:,:,2)= pyramid_reconstruct(S_s);

%uiconm = UIConM(fusion)
%[meanRG, deltaRG, meanYB, deltaYB, uicm] = UICM(fusion)
imrestored=im2uint8(hsv2rgb(hsv));
end


%my own white-balance function, created by Qu Jingwei
function new_image = white_balance3(src_image,opt)
switch opt
   case 1
      rgbImage=im2double(src_image);
       grayImage = rgb2gray(rgbImage); 
       % White Balancing
       meanR = mean2(rgbImage(:,:,1));
       meanG = mean2(rgbImage(:,:,2));
       meanB = mean2(rgbImage(:,:,3));
       meanGray = mean2(grayImage);

       % Make all channels have the same mean
       rgbImage(:,:,1) = (double(rgbImage(:,:,1)) * meanGray / meanR);
       rgbImage(:,:,2) = (double(rgbImage(:,:,2)) * meanGray / meanG);
       rgbImage(:,:,3) = (double(rgbImage(:,:,3)) * meanGray / meanB);
       new_image=im2uint8(rgbImage);
    case 2
      [height,width,dim] = size(src_image);
      temp = zeros(height,width);
      %transform the RGB color space to YCbCr color space 
      ycbcr_image = rgb2ycbcr(src_image);
      Y = ycbcr_image(:,:,1);
      Cb = ycbcr_image(:,:,2);
      Cr = ycbcr_image(:,:,3);
      %calculate the average value of Cb,Cr
      Cb_ave = mean(mean(Cb));
      Cr_ave = mean(mean(Cr));
      %calculate the mean square error of Cb, Cr
      Db = sum(sum(abs(Cb-Cb_ave))) / (height*width);
      Dr = sum(sum(abs(Cr-Cr_ave))) / (height*width);
      %find the candidate reference white point
      %if meeting the following requriments
      %then the point is a candidate reference white point
      temp1 = abs(Cb - (Cb_ave + Db * sign(Cb_ave)));
      temp2 = abs(Cb - (1.5 * Cr_ave + Dr * sign(Cr_ave)));
      idx_1 = find(temp1<1.5*Db);
      idx_2 = find(temp2<1.5*Dr);
      idx = intersect(idx_1,idx_2);
      point = Y(idx);
      temp(idx) = Y(idx);
      count = length(point);
      count = count - 1;
      %sort the candidate reference white point set with descend value of Y
      temp_point = sort(point,'descend');
      %get the 10% points of the candidate reference white point set, which is
      %closer to the white region, as the reference white point set
      n = round(count/10);
      white_point(1:n) = temp_point(1:n);
      temp_min = min(white_point);disp(temp_min )
      idx0 = find(temp<temp_min);
      temp(idx0) = 0;
      idx1 = find(temp>=temp_min);
      temp(idx1) = 1;
      %get the reference white points' R,G,B
      white_R = double(src_image(:,:,1)).*temp;
      white_G = double(src_image(:,:,2)).*temp;
      white_B = double(src_image(:,:,3)).*temp;
      %get the averange value of the reference white points' R,G,B
      white_R_ave = mean(mean(white_R));
      white_G_ave = mean(mean(white_G));
      white_B_ave = mean(mean(white_B));
      %the maximum Y value of the source image
      Ymax = double(max(max(Y))) / 15;
      %calculate the white-balance gain
      R_gain = Ymax / white_R_ave;
      G_gain = Ymax / white_G_ave;
      B_gain = Ymax / white_B_ave;
      %white-balance correction
      new_image(:,:,1) = R_gain * src_image(:,:,1);
      new_image(:,:,2) = G_gain * src_image(:,:,2);
      new_image(:,:,3) = B_gain * src_image(:,:,3);
      new_image = uint8(new_image);
       
end
end

function lift=pullbacklift(img,newlow)
   lift = zeros(1,1,size(img,3));
for j=1:size(img,3)
   histim=imhist(img(:,:,j),256);
   histim=histim/sum(histim);
   sumh=0;
   for i=1:256
       sumh=sumh+histim(i);
       if sumh>0.01 % if cdf is more than 0.01 break the loop
           BIN=i;
           break;
       end
   end
   BIN=BIN/256;
   lift(1,1,j)=(newlow/256-BIN)/(1-BIN);
%   lift(1,1,j)=-BIN/(1-BIN);
end

end

