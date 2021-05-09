function outval = SimplestColorBalanceP(im_org , num, type)
satLevel1 = 0.005;
satLevel2 = 0.005;
%num = 255;
% SimplestColorBalance(im_orig)
% Performs color balancing via histogram normalization.
% satLevel controls the percentage of pixels 
% to clip to white and black.
% Set plot = 0 or 1 to turn diagnostic plots on or off.
if ndims(im_org) == 3
    [m, n, p] = size(im_org);
    imRGB_orig = zeros(p, m * n);
    for i = 1 : p
        imRGB_orig(i, :) = reshape(double(im_org(:,:,i)), [1, m * n]);
    end
else
    [m, n] = size(im_org);
    p = 1;
    imRGB_orig = reshape(double(im_org), [1, m * n]);
end
% full width histogram method
% percentage of the image to saturate to black or white, 
% tweakable param
q = [satLevel1, 1 - satLevel2];
imRGB = zeros(size(imRGB_orig));
for ch = 1 : p
    tiles = quantile(imRGB_orig(ch, :), q);
    temp = imRGB_orig(ch, :);
    temp(find(temp < tiles(1))) = tiles(1);
    temp(find(temp > tiles(2))) = tiles(2);
    imRGB(ch, :) = temp;
    bottom = min(imRGB(ch, :)); 
    top = max(imRGB(ch, :));
    imRGB(ch, :) = (imRGB(ch, :) - bottom) * num / (top - bottom); 
end
if ndims(im_org) == 3
    outval = zeros(size(im_org));
    for i = 1 : p
        outval(:, :, i) = reshape(imRGB(i, :), [m, n]); 
    end
else
    outval = reshape(imRGB, [m, n]); 
end
if strcmp(type, 'uint8')
    outval = uint8(outval);
end