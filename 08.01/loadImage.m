function img = loadImage(num)
% num is the num of image with 

% prefix = '/Users/zhanghao/Documents/MATLAB/Dissertation/Images/';
% suffix = '.jpg';
% path = [prefix,num2str(num),suffix];

path=sprintf('D:/RefPic/water (%d).png',num);% image filename

img = imread(path);