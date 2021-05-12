function img = loadImage(num,inpath)
% num is the num of image with 

% prefix = '/Users/zhanghao/Documents/MATLAB/Dissertation/Images/';
% suffix = '.jpg';
% path = [prefix,num2str(num),suffix];

path=sprintf('%swater (%d).png',inpath,num);% image filename

img = imread(path);