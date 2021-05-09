function [RL, AL] = imgDecomposition(img)
AL = zeros(size(img));
RL = zeros(size(img));
for i = 1 : 3
    k = 0.5 * img(:, :, i) / max(max(img(:, :, i)));
    AL(:, :, i) = (1 - k) .* img(:, :, i);
    RL(:, :, i) = k .* img(:, :, i);
end