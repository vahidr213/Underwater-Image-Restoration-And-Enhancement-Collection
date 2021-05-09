function T = TransEstimate(img, patchsz, A, lambda, r, eps, gamma)
[m, n, ~] = size(img);
% resize the input image to match the patch size
if mod(m, patchsz) ~= 0 || mod(n,patchsz) ~= 0
    im = imresize(img, [m - mod(m, patchsz) + patchsz, ...
        n - mod(n, patchsz) + patchsz]);
else
    im = img;
end
% calculate the transmission map
T = zeros(size(im,1),size(im,2));% initial the transmission map
for i = 1 : patchsz : size(im, 1)
    for j = 1 : patchsz : size(im, 2)
        sz = patchsz - 1;
        blk_im = im(i:i+sz,j:j+sz,:);
        Trans = blkTrsEstimate(blk_im, A, lambda);
        T(i:i+sz,j:j+sz) = Trans;
    end
end
T = imresize(T, [m, n]);
%Std1 = std2(T) * 255
%averGrad1 = meangrad(T) * 255
%figure,imshow(T)
% refine the transmission map
guidedImg = double(rgb2gray(uint8(img * 255))) / 255;
T = guidedfilter(guidedImg, T, r, eps);
%Std2 = std2(T) * 255
%averGrad2 = meangrad(T) * 255
%figure,imshow(T)
% enhance the transmission map
Tsmooth=imfilter(T,fspecial('gaussian',[80,80],80),...
                'replicate','conv');
Tdetail = T - Tsmooth;
T = Tsmooth + gamma * Tdetail;
%Std3 = std2(T) * 255
%averGrad3 = meangrad(T) * 255
%figure,imshow(T)