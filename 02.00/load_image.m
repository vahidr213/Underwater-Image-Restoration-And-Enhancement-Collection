function img = load_image(num,inpath)
% num is the num of image with 

path=sprintf('%swater (%d).png',inpath,num);% image filename

img = imread(path);