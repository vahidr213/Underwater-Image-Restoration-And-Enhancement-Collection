function outval = adjustment(rgb,I)
II = im2double(I);
Ir=double(II(:,:,1)); Ig=double(II(:,:,2)); Ib=double(II(:,:,3));
% Global Adaptation
Lw = 0.299 * Ir + 0.587 * Ig + 0.114 * Ib;% input world luminance values
Lwmax = max(max(Lw));% the maximum luminance value
[m, n] = size(Lw);
Lwaver = exp(sum(sum(log(0.001 + Lw))) / (m * n));% log-average luminance
Lg = log(Lw / Lwaver + 1) / log(Lwmax / Lwaver + 1);
% Local Adaptation
kenlRatio = 0.01;
krnlsz = floor(max([3, m * kenlRatio, n * kenlRatio]));
Lg1 = maxfilt2(Lg, [krnlsz, krnlsz]);
Lg1 = imresize(Lg1, [m, n]);
Hg = guidedfilter(Lg, Lg1, 10, 0.01);
eta = 36;
alpha = 1 + eta * Lg / max(max(Lg));
alpha = alpha .* (alpha .^ (1 ./ alpha));
b = max(max(alpha));
a = 1.35;
alpha = 2 * atan(a * alpha / b) / pi * b;
Lgaver = exp(sum(sum(log(0.001 + Lg))) / (m * n));
lambda = 10;
beta = lambda * Lgaver;
Lout = alpha .* log(Lg ./ Hg + beta);
Lout = normfun(Lout, 1);
Lout = SimplestColorBalance(Lout, 0.005, 0.001, 1);
gain = Lout ./ Lw;
gain(find(Lw == 0)) = 0;
rgb_offset = cat(3, gain .* Ir, gain .* Ig, gain .* Ib);
outval = (4/4) * rgb_offset + (0/4) * rgb;
%outval(find(outval > 1)) = 1;
%outval = SimplestColorBalance(outval, 0.001, 0.02, 1);
%[H, S, V] = rgb2hsv(outval);
%V = adapthisteq(V, 'NumTiles', [4, 4], 'ClipLimit', 0.0025, 'NBins', 256, ...
%    'Range', 'full', 'Distribution', 'exponential', 'Alpha', 0.4);
%outval = hsv2rgb(cat(3, H, S, V));