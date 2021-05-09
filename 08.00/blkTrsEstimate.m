% calculate the transmission map in the block
function Trans = blkTrsEstimate(blk_im, A, lambda)
fTrans = 0.7;
nTrans = floor(1 / fTrans * 128);
fMinCost = inf;
numberofPixels = size(blk_im,1) * size(blk_im,2) * 3;
nCounter = 0;
while nCounter < (1 - fTrans) * 10
    % initial dehazing process to calculate the loss information
    nOutR = ((blk_im(:,:,1) - A(1)) * nTrans + 128 * A(1)) / 128;
    nOutG = ((blk_im(:,:,2) - A(2)) * nTrans + 128 * A(2)) / 128;
    nOutB = ((blk_im(:,:,3) - A(3)) * nTrans + 128 * A(3)) / 128;
    % find the pixels with over-255 value and below-0 value
    overR = max(nOutR, 255); belowR = min(nOutR, 0);
    overG = max(nOutG, 255); belowG = min(nOutG, 0);
    overB = max(nOutB, 255); belowB = min(nOutB, 0);
    % calculate the sum of information loss
    nSumofLoss = sum(sum((overR - 255) .* (overR - 255) + ...
        belowR .* belowR +...
        (overG - 255) .* (overG - 255) + belowG .* belowG +...
        (overB - 255) .* (overB - 255) + belowB .* belowB));
    % count the number of pixels with loss information
%     [x1,~] = find(overR > 255); [x2,~] = find(belowR < 0);
%     [x3,~] = find(overG > 255); [x4,~] = find(belowG < 0);
%     [x5,~] = find(overB > 255); [x6,~] = find(belowB < 0);
%     LossCount = length(x1) + length(x2) + length(x3) + length(x4) + ...
%         length(x5) + length(x6);
    % calculate the value of sum of square out
    nSumofSquareOuts = sum(sum(nOutR .* nOutR + nOutG .* nOutG + ...
        nOutB .* nOutB));
    % calculate the value of sum of out
    nSumofOuts = sum(sum(nOutR + nOutG + nOutB));
    % calculate the mean value of the block image
    fMean = nSumofOuts / numberofPixels;
    % calculate the cost function
    fCost = lambda * nSumofLoss / numberofPixels - ...
        (nSumofSquareOuts / numberofPixels - fMean * fMean);
    % find the minimum cost and the related transmission
    if nCounter == 0 || fMinCost > fCost
       fMinCost = fCost;
       Trans = fTrans;
    end
    fTrans = fTrans + 0.05;
    nTrans = 1 / fTrans * 128;
    nCounter = nCounter + 1;
end