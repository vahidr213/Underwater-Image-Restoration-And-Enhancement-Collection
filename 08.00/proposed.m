function Fusion = proposed(img)
% parameters for finding the airlight
blksz = 5 * 5;
showFigure = false;
% parameters for estimating the transmission map
patchsz = 8; 
lambda = 10;
gamma = 1.5;
r = 10;
eps = 10^-6;

[RL,AL] = imgDecomposition(double(img) / 255);

% processing the reflectance component
RL = SimplestColorBalanceP(RL, 0.5, 'double');
RL = CLAHE(RL);

% processing the alluminance light
A = AirlightEstimate(AL, blksz, showFigure); % find the airlight

% estimate the transmission map
T = TransEstimate(AL, patchsz, A, lambda, r, eps, gamma);

% dehazing process
AL = dehazingProcess(AL, T, A);

% fusion process
[W1, W2] = featureWeight(uint8(RL * 255), uint8(AL * 255));
Fusion = pyramidFuse(W1, W2, uint8(RL * 255), uint8(AL * 255));