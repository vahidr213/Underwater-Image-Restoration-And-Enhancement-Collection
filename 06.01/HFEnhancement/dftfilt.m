function g = dftfilt(f, H)
H1 = zeros(size(H, 1), size(H, 2));
H1(:, :) = H;
%H1(:, :, 2) = H;
%H1(:, :, 3) = H;
F = fft2(f, size(H, 1), size(H, 2));
g=real(ifft2(F .* H1));
g=g(1 : size(f, 1) ,1 : size(f, 2));