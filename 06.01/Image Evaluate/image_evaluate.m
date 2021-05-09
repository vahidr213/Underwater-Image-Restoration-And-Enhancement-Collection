function outval=image_evaluate(I,Iref)
% Input: I和Iorg的值域为[0,255]
% Output: 图像均值，标准方差，信息熵，PSNR，平均梯度，SSIM，FSIM，VIF
I = double(I);
Iref = double(Iref);
n = ndims(I);
if n == 3
    % 图像均值
    Mean = (mean2(I(:, :, 1)) + mean2(I(:, :, 2)) + mean2(I(:, :, 3))) / 3;
    % 图像方差
    Std = (std2(I(:, :, 1)) + std2(I(:, :, 2)) + std2(I(:, :, 3))) / 3;
else
    % 图像均值
    Mean = mean2(I);
    % 图像方差
    Std = std2(I);
end

% 图像信息熵
%Entropy = entropy(I);

% 与原图的均方差
%MSE=immse(I, I_original);

% 与原图的峰值信噪比
%PSNR = psnr(I, Iref);

% 平均梯度
Gradval = meangrad(I);

% 与原图的SSIM(Structural SIMilarity index)
[SSIM, ssimmap]=ssim(I, Iref);

% 与原图的FSIM(Feature SIMilarity index)
[FSIM, FSIMc] = FeatureSIM(Iref, I);

% 与原图的QILV(Quality Index based on Local Variance)
%imorg = rgb2gray(I_original);
%imdist = rgb2gray(I);
%QILV = qilv(imdist, imorg, 0);

% 与原图的VIF(Visual Information Fidelity)
imorg = double(rgb2gray(uint8(Iref)));
imdist = double(rgb2gray(uint8(I)));
VIF = vifvec(imdist, imorg);

% Final output
outval = [Mean, Std, Gradval, SSIM, FSIM, VIF];