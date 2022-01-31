
function imrestored = main(doDegradation,inpath)
    pwd0=cd('..');
    img = load_image(doDegradation,inpath);     
    cd(pwd0);
    im1 = img;
    load('net1');
    load('net2');
    load('net3');
    x = feature_extract(img);
    y=net1(x');
    [~ , label1] = max(y);
    y=net2(x');
    [~ , label2] = max(y);
    y=net3(x');
    [~, label3] = max(y);
    im1 = permutefunction([label1 label2 label3],img,im1);
    imrestored=im1;
end

