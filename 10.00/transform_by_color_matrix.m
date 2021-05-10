function img = transform_by_color_matrix(T, im)
    
    %convert from RGB to LAB
    LABcolorTransform = makecform('srgb2lab');
    im = applycform(im2double(im), LABcolorTransform);

    imr = im(:,:,1);
    imr = imr(:);
    imgr = im(:,:,2);
    imgr = imgr(:);
    imb = im(:,:,3);
    imb = imb(:);

    rgb_vec = [imr'; imgr'; imb'; ones(1,size(imr,1))];


    transformed = T * rgb_vec;

    imr = transformed(1,:);
    imr = reshape(imr,size(im,1),size(im,2));

    imgr = transformed(2,:);
    imgr = reshape(imgr,size(im,1),size(im,2));

    imb = transformed(3,:);
    imb = reshape(imb,size(im,1),size(im,2));

    img = zeros(size(imr,1),size(imr,2),3);

    img(:,:,1) = imr;
    img(:,:,2) = imgr;
    img(:,:,3) = imb;
    
    %convert from LAB to RGB
    RGBcolorTransform = makecform('lab2srgb');
    img = applycform(img, RGBcolorTransform);
