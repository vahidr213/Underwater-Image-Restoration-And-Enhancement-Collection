% 执行图像读入操作
function out=image_load(vargin)
% 输入：
%   vargin是一字符串，代表读入的图像，格式为--名称.后缀名
% 输出：
%   out为调用的图像
% 所有的图像默认保存在如下文件中
str1='/Users/HyrumCheung/Documents/MATLAB/Retinex/image_set/';
if nargin==0
    str2='whitehouse.png';
else
    str2=vargin;
end
out=imread([str1,str2]);