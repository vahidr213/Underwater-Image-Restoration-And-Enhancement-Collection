% calculate the transmission map in the block
function Trans = blkTrsEstimate_each(blk_im, A, lambda)
fTrans = 0.3;
nTrans = floor(1 / fTrans * 128);
fMinCost = inf;
numberofPixels = size(blk_im,1) * size(blk_im,2);
nCounter = 0;
while nCounter < (1 - fTrans) * 10
    % initial dehazing process to calculate the loss information
    nOut = ((blk_im - A) * nTrans + 128 * A) / 128;
    % find the pixels with over-255 value and below-0 value
    over = max(nOut, 255); below = min(nOut, 0);
    % calculate the sum of information loss
    nSumofLoss = sum(sum((over - 255) .* (over - 255) + ...
        below .* below));
    % count the number of pixels with loss information
%     [x1,~] = find(over > 255); [x2,~] = find(below < 0);
%     LossCount = length(x1) + length(x2);
    % calculate the value of sum of square out
    nSumofSquareOuts = sum(sum(nOut .* nOut));
    % calculate the value of sum of out
    nSumofOuts = sum(sum(nOut));
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
    fTrans = fTrans + 0.1;
    nTrans = 1 / fTrans * 128;
    nCounter = nCounter + 1;
end