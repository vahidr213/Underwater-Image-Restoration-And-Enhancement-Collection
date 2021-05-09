function T = TransEstimate(img, patchsz, A, lambda)
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