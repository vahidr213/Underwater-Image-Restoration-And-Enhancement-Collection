% This is the implementation and modification of the paper:
% <A Novel Retinex Based Approach for Image Enhancement... 
% with Illumination Adjustment>
function outval = novel_retinex_method(I)
%**************************Seting fixed parameters*************************
alpha = 10; % setting the iteration parameters
beta = 0.15;
gamma = 0.001;
a = 0.04; % setting the Sigmoid function's parameters
maxIter = 4; % Seting the maximal iterations
%**********Initialization L, L0, R using Gaussian low-pass filter**********
L = guidedfilter(I / 255, I / 255, 10, 1);
L = L * 255;
L0 = L;
R = I ./ L;
R = R / max(max(R));
%*************Seting the edge detection operator and iteration*************
[m, n] = size(I); % get the size of I
hx = fspecial('Sobel'); % horizontal direction
hy = hx'; % vertical direction
for iter = 1 : maxIter
    % Geting the horizontal map of R
    DxR = abs(imfilter(R, hx, 'replicate', 'conv'));
    % Geting the vertical map of R
    DyR = abs(imfilter(R, hy, 'replicate', 'conv'));
    % updating L by component-wise
    for i = 1 : m
        for j = 1 : n
            mole = fft(I(i,j) / L(i,j));
            deno = fft(1) + beta * (conj(fft(DxR(i,j))) * fft(DxR(i,j)) + ...
                conj(fft(DyR(i,j))) * fft(DyR(i,j)));
            R(i,j) = ifft(mole / deno);
            R(i,j) = min(1, max(R(i,j), 0)); % Normalization process
        end
    end
    % Geting the horizontal map of L
    DxL = abs(imfilter(L, hx, 'replicate', 'conv'));
    % Geting the vertical map of L
    DyL = abs(imfilter(L, hy, 'replicate', 'conv'));
    % updating L by component-wise
    for i = 1 : m
        for j = 1 : n
            mole = fft(gamma * L0(i,j) + I(i,j) / R(i,j));
            deno = fft(1 + gamma) + alpha * (conj(fft(DxL(i,j))) * ...
                fft(DxL(i,j)) + conj(fft(DyL(i,j))) * fft(DyL(i,j)));
            L(i,j) = ifft(mole / deno);
            L(i,j) = max(L(i,j), I(i,j));
        end
    end
end
%*************Illumination adjustment is adopted to enhance L**************
% a is the shrink parameter to control the shape of the arctan function,
% the effect of sigmoid function can lighten dark areas to enhance details 
% while compress intensities in bright areas to avoid over-enhancement.
% 
L_adjusted = 2 * atan(a * L) / pi; % Sigmoid function
% J = adapthisteq(I,PARAM1,VAL1,PARAM2,VAL2...) sets various parameters.
%    Parameter names can be abbreviated, and case does not matter. Each 
%    string parameter is followed by a value as indicated below:
%    'NumTiles'     Two-element vector of positive integers: [M N].
%                   [M N] specifies the number of tile rows and
%                   columns.  Both M and N must be at least 2. 
%                   The total number of image tiles is equal to M*N. 
%                   Default: [8 8].
%    'ClipLimit'    Real scalar from 0 to 1.
%                   'ClipLimit' limits contrast enhancement. Higher numbers 
%                   result in more contrast.         
%                   Default: 0.01. 
%    'NBins'        Positive integer scalar.
%                   Sets number of bins for the histogram used in building a
%                   contrast enhancing transformation. Higher values result 
%                   in greater dynamic range at the cost of slower processing
%                   speed. 
%                   Default: 256. 
%    'Range'        One of the strings: 'original' or 'full'.
%                   Controls the range of the output image data. If 'Range' 
%                   is set to 'original', the range is limited to 
%                   [min(I(:)) max(I(:))]. Otherwise, by default, or when 
%                   'Range' is set to 'full', the full range of the output 
%                   image class is used (e.g. [0 255] for uint8). 
%                   Default: 'full'. 
%    'Distribution' Distribution can be one of three strings: 'uniform',
%                   'rayleigh', 'exponential'.
%                   Sets desired histogram shape for the image tiles, by 
%                   specifying a distribution type. 
%                   Default: 'uniform'. 
%    'Alpha'        Nonnegative real scalar.
%                   'Alpha' is a distribution parameter, which can be 
%                   supplied when 'Dist' is set to either 'rayleigh' 
%                   or 'exponential'. 
%                   Default: 0.4.
L_final = adapthisteq(L_adjusted, 'NumTiles', [8, 8], 'ClipLimit', 0.02,...
    'NBins', 256, 'Range', 'full', 'Distribution', 'exponential',...
    'Alpha', 0.4);
%**************Reflectance adjustment is adopted to ehchance R*************
% After study the features of R, we find that all the values of R 
% is near to 1, so we just set R as ones matrix
R = guidedfilter(R, R, 10, 0.4);
%*************************Synthesizing the R and L*************************
outval = R .* L_final;