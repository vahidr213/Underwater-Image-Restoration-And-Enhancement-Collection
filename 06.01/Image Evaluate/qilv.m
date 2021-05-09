function ind=qilv(I,I2,Ws)
%基于局部方差的质量评价方法(Quality Index based on Local Variance, QILV)
% QILV() --图像必须是灰度图
%==================================================================
% Quality Index based on Local Variance
% Santiago Aja-Fernandez
%
% santi@bwh.harhard.edu
% Accorging to
%
% S. Aja-Fernández, R. San José Estépar, C. Alberola-López and C.F. Westin,
% "Image quality assessment based on local variance", EMBC 2006, 
% New York, Sept. 2006.
%
%------------------------------------------------------------------
%
% The function calculates a global compatibility measure
% between two images, based on their local variance distribution.
%
%------------------------------------------------------------------
%
% INPUT:   (1) I: The first image being compared
%          (2) I2: the second image being compared
%          (3) Ws: window for the estimation of statistics:
%		If Ws=0: default gaussian window
%               If Ws=[M N] MxN square window
%  
%
% OUTPUT:
%          (1) ind: Quality index (between 0 and 1)
%
% Default usage:
%
%   ind=s_correct(I,I2,0);
%
% 
%==================================================================



%the following variables can be added to avoid NaN, but
%usually it is not necessary

%定义三个常量
L=255;
K=[0.01 0.03];
C1 = (K(1)*L)^2;
C2 = (K(2)*L)^2;
%初始化3个常量
%C1=0;
%C2=0;

%Window
%判断窗口参数，若为空，则采用默认值
if Ws==0
	window = fspecial('gaussian', 11, 1.5); %创建高斯低通滤波器
else
	window=ones(Ws);
end
window = window/sum(window(:));


%Local means
M1=filter2(window, I, 'valid') ; %使用指定的滤波器window对I[图像1]进行滤波，结果保存在M1中
M2=filter2(window, I2, 'valid') ;
%Local Variances差异
V1 = filter2(window, I.^ 2, 'valid') - M1.^ 2;
V2 = filter2(window, I2.^ 2, 'valid') - M2.^ 2;


%Global statistics:

m1=mean(V1(:)); %表示求矩阵的均值
m2=mean(V2(:));
s1=std(V1(:));  %std(x) 算出x的标准偏差
s2=std(V2(:));
s12=mean2((V1-m1).*(V2-m2));    %两幅协方差

%Index 基于结构相似度( SSIM )的图像质量测度，对两幅图像的亮度、对比度和相似度进行比较
ind1=((2*m1*m2+C1)./(m1.^2+m2.^ 2+C1));
ind2=(2*s1*s2+C2)./(s1.^ 2+s2.^ 2+C2);
ind3=(s12+C2/2)./(s1*s2+C2/2);
ind=ind1.*ind2.*ind3;
