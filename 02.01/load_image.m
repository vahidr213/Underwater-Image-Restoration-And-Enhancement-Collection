function img = load_image(num)
% num is the num of image with 

path=sprintf('D:/RefPic/water (%d).png',num);% image filename

img = imread(path);