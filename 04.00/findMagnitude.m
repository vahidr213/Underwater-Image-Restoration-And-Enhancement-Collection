function [ mag,alpha ] = findMagnitude( I, A, showFigures )

[h w c] = size(I);
A3 = reshape(A,1,1,3);
repA = repmat(A3,h,w);

disp('estimate transmission...')
patch_size = 10;
alpha_est = makeDarkChannel(I./repA,patch_size);
[alpha] = generateLaplacian(I,alpha_est);

clear aPart
for c=1:3
    aPart(:,:,c) = alpha.*repA(:,:,c);
end

withoutA = I-aPart;
withoutA(withoutA<0)=0;
if(showFigures)
    figure, imagesc(alpha),colormap gray, axis image, truesize;
    figure, imagesc(withoutA), axis image, truesize;
end

disp('calc l*...')
initMag = 0.5;
isNegative = true;
while(isNegative)
    initMag = initMag + 0.1;
    for c=1:3
        L(:,:,c) = withoutA(:,:,c)./(1-alpha./initMag);
    end
    isNegative = false;
    if(any(any(any(L<0))))
        isNegative = true;
    end
end

for c=1:3
    L(:,:,c) = withoutA(:,:,c)./(1-alpha./initMag);
end
gray = sqrt(L(:,:,1).^2 + L(:,:,2).^2 + L(:,:,3).^2);
shading = reshape(gray,w*h,1);
T = (1-alpha./initMag);% T is the transmission map
transmission = reshape(T,w*h,1);


maxAlpha =  max(transmission);
minAlpha = min(transmission);
numBins = 50;
binW = (maxAlpha-minAlpha)/numBins;
mtrans = [minAlpha:binW:maxAlpha];
mshading = zeros(size(mtrans));
for i=1:size(mtrans,2);
    val = mtrans(i)+binW/2;
    inBin = shading(transmission < val+binW/2 & transmission >= val - binW/2);
    numInBin = max(size(inBin,1));
    if(numInBin>100)
        inBin = sort(inBin);
        mshading(i) = inBin(round(0.995*numInBin));
    end
end
disp('fit a,k...')
[ak] = fminsearch(@(x) fitError(x,withoutA, alpha,mshading,initMag, 0),[1,1]);
a = ak(1);
mag = initMag/a;




if(showFigures)
    [h w c] = size(withoutA);
    for c=1:3
        L(:,:,c) = withoutA(:,:,c)./(1-alpha./mag);
    end
    all = reshape(L,w*h*c,1);
    all=sort(all);
    L = L - all(1);
    all = all - all(1);
    L = L/all(round(w*h*c*0.9999));
    L(L>1) = 1;
    figure,imagesc(L),axis image, truesize;
end

end

