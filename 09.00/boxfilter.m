function imDst = boxfilter(imSrc, r)


 %   BOXFILTER   O(1) time box filtering using cumulative sum
 %
 %   - Definition imDst(x, y)=sum(sum(imSrc(x-r:x+r,y-r:y+r)));即窗口内部所有像素值的和
 %   - Running time independent of r;  运行时间独立于半径r，时间复杂度为 O(N)
 %   - Equivalent to the function: colfilt(imSrc, [2*r+1, 2*r+1], 'sliding', @sum);
 %   - But much faster.


 [hei, wid] = size(imSrc);
 imDst = zeros(size(imSrc));


 %cumulative sum over Y axis  Y轴上累积的和  在矩阵的列上累积
 imCum = cumsum(imSrc, 1);
 %difference over Y axis
 imDst(1:r+1, :) = imCum(1+r:2*r+1, :);
 imDst(r+2:hei-r, :) = imCum(2*r+2:hei, :) - imCum(1:hei-2*r-1, :);
 imDst(hei-r+1:hei, :) = repmat(imCum(hei, :), [r, 1]) - imCum(hei-2*r:hei-r-1, :);


 %cumulative sum over X axis   在矩阵的行上累积
 imCum = cumsum(imDst, 2);
 %difference over Y axis
 imDst(:, 1:r+1) = imCum(:, 1+r:2*r+1);
 imDst(:, r+2:wid-r) = imCum(:, 2*r+2:wid) - imCum(:, 1:wid-2*r-1);
 imDst(:, wid-r+1:wid) = repmat(imCum(:, wid), [1, r]) - imCum(:, wid-2*r:wid-r-1);
 end

