function sm = saliency_detection(img,method)
%%% img must be uint8
%%% sm is double 0-1
    if method == 1
%---------------------------------------------------------
% Copyright (c) 2009 Radhakrishna Achanta [EPFL]
% Contact: firstname.lastname@epfl.ch
%---------------------------------------------------------
% Citation:
% @InProceedings{LCAV-CONF-2009-012,
%    author      = {Achanta, Radhakrishna and Hemami, Sheila and Estrada,
%                  Francisco and S?strunk, Sabine},
%    booktitle   = {{IEEE} {I}nternational {C}onference on {C}omputer
%                  {V}ision and {P}attern {R}ecognition},
%    year        = 2009
% }
%---------------------------------------------------------
% Please note that the saliency maps generated using this
% code may be slightly different from those of the paper.
% This seems to be because the RGB to Lab conversion is
% different from the one used for the results in the C++ code.
% The C++ code is available on the same page as this matlab
% code (http://ivrg.epfl.ch/supplementary_material/RK_CVPR09/index.html)
% One should preferably use the C++ as reference and use
% this matlab implementation mostly as proof of concept
% demo code.
%---------------------------------------------------------

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
% cform = makecform('srgb2lab');
% lab = applycform(gfrgb,cform);
lab = rgb2lab( gfrgb );
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
sm = im_unity(sm);
%imshow(sm,[]);
%---------------------------------------------------------
elseif method == 2
    %%%%%%%%%calculate the saliency map for medium transmission
    width = size(im,2);
    height = size(im,1);
    md = min(width, height);%minimum dimension
    %---------------------------------------------------------
    % Perform sRGB to CIE Lab color space conversion (using D65)
    %---------------------------------------------------------
    imglab = rgb2lab(img);
    l = double(imglab(:,:,1));
    a = double(imglab(:,:,2));
    b = double(imglab(:,:,3));
    %---------------------------------------------------------
    %Saliency map computation
    %---------------------------------------------------------
    saliencymap = zeros(height, width);
    off1 = int32(md/2); off2 = int32(md/4); off3 = int32(md/8);
    for j = 1:height
        y11 = max(1,j-off1); y12 = min(j+off1,height);
        y21 = max(1,j-off2); y22 = min(j+off2,height);
        y31 = max(1,j-off3); y32 = min(j+off3,height);
        for k = 1:width
            x11 = max(1,k-off1); x12 = min(k+off1,width);
            x21 = max(1,k-off2); x22 = min(k+off2,width);
            x31 = max(1,k-off3); x32 = min(k+off3,width);
            % disp([j,k,y11,y12,y21,y22,y31,y32,x11,x12,x21,x22,x31,x32])
            lm1 = mean2(l(y11:y12,x11:x12));am1 = mean2(a(y11:y12,x11:x12));bm1 = mean2(b(y11:y12,x11:x12));
            lm2 = mean2(l(y21:y22,x21:x22));am2 = mean2(a(y21:y22,x21:x22));bm2 = mean2(b(y21:y22,x21:x22));
            lm3 = mean2(l(y31:y32,x31:x32));am3 = mean2(a(y31:y32,x31:x32));bm3 = mean2(b(y31:y32,x31:x32));
            %---------------------------------------------------------
            % Compute conspicuity values and add to get saliency value.
            %---------------------------------------------------------
            cv1 = (l(j,k)-lm1).^2 + (a(j,k)-am1).^2 + (b(j,k)-bm1).^2;
            cv2 = (l(j,k)-lm2).^2 + (a(j,k)-am2).^2 + (b(j,k)-bm2).^2;
            cv3 = (l(j,k)-lm3).^2 + (a(j,k)-am3).^2 + (b(j,k)-bm3).^2;
            saliencymap(j,k) = cv1 + cv2 + cv3;
        end
    end

    saliencymap = im_unity(saliencymap);% unity normalize 0-1

endif %%% end of if method

end %%%% end of function