function Fusion = pyramidFuse(W1, W2, img1, img2)

level = 5;

Weight1 = gaussianPyramid(W1, level);
Weight2 = gaussianPyramid(W2, level);

% calculate the laplacian pyramid
% input1
R1 = laplacianPyramid(double(img1(:, :, 1)), level);
G1 = laplacianPyramid(double(img1(:, :, 2)), level);
B1 = laplacianPyramid(double(img1(:, :, 3)), level);

% input2
R2 = laplacianPyramid(double(img2(:, :, 1)), level);
G2 = laplacianPyramid(double(img2(:, :, 2)), level);
B2 = laplacianPyramid(double(img2(:, :, 3)), level);

% fusion
for i = 1 : level
   R_r{i} = Weight1{i} .* R1{i} + Weight2{i} .* R2{i};
   R_g{i} = Weight1{i} .* G1{i} + Weight2{i} .* G2{i};
   R_b{i} = Weight1{i} .* B1{i} + Weight2{i} .* B2{i};
end

% reconstruct & output
R = pyramidReconstruct(R_r);
G = pyramidReconstruct(R_g);
B = pyramidReconstruct(R_b);

Fusion = cat(3, uint8(R), uint8(G), uint8(B));