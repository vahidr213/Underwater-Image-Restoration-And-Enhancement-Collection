
function imrestored = main(doDegradation,inpath)
    pwd0=cd('..');
    img = load_image(doDegradation,inpath);     
    cd(pwd0);
    im1 = img;
    load('MDL1');
    load('MDL2');
    load('MDL3');
    x = feature_extract(img);
    label1 = predict(MDL1,x);
    label2 = predict(MDL2,x);
    label3 = predict(MDL3,x);
    im1 = permutefunction([label1 label2 label3],img,im1);
    imrestored=im1;
end

