function img = load_image(num)
% num is the num of image with 

prefix = '/Users/zhanghao/Documents/MATLAB/Dissertation/Images/';
suffix = '.jpg';
path = [prefix,num2str(num),suffix];

img = imread(path);