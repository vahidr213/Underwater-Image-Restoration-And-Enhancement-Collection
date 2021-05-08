function [ diff ] = fitError(fitVars, withoutA,alpha, mshading,initMag,showFigures)
[h w c] = size(withoutA);

a = fitVars(1);
k = fitVars(2);

T = 1-a*alpha./initMag;

transmission = reshape(T,w*h,1);

maxAlpha =  max(transmission);
minAlpha = min(transmission);
numBins = size(mshading,2)-1;
binW = (maxAlpha-minAlpha)/numBins;
mtrans = [minAlpha:binW:maxAlpha];

if(showFigures)
    figure, plot(mtrans,mshading,'.');
    hold on
    plot(mtrans,abs((k*a*mtrans)./(a+mtrans-1)),'-');
end


sumErr = 0;
for i = 1:size(mtrans,2)
    if(mshading(i)>0)
        t = mtrans(i);
        currErr = abs(mshading(i) - abs((k*a*t)/(a+t-1)));
        sumErr = sumErr + currErr;
    end
end

diff = sumErr;

end

