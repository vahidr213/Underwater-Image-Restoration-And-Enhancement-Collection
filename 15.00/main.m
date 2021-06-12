function imrestored = main(doDegradation,inpath)
pwd0=cd('..');
Sc = load_image(doDegradation,inpath);     
cd(pwd0);

% Sc = imread('input1.jpg');

[m,n,o] = size(Sc);
Smin = zeros(3,1);
Smax = zeros(3,1);
Smean = zeros(3,1);
P = zeros(3,1);

Scr = zeros(m,n,o,'uint8');
ScrP = zeros(m,n,o,'uint8');
lam = 0.1;

for k=1:3
    Smin(k) = min(min(Sc(:,:,k)));
    Smax(k) = max(max(Sc(:,:,k)));
    Smean(k) = round(mean(mean(Sc(:,:,k))));
    P(k) = sum(sum(Sc(:,:,k)<=40))/(m*n);
end
disp(P);

for i=1:m
    for j=1:n
        for k=1:3
            if(Smean(k)<128)
                Scr(i,j,k) = min(max((Sc(i,j,k)-Smean(k))*((Smin(k)-128)/(Smin(k)-Smean(k)))+128,0),255);
            else
                Scr(i,j,k) = min(max((Sc(i,j,k)-Smean(k))*((Smax(k)-128)/(Smax(k)-Smean(k)))+128,0),255);
            end
            
            if(P(k)>0.7)
                ScrP(i,j,k) = round(min(max(Sc(i,j,k)-lam*(Smean(k)-128),0),255));
            elseif(Smean(k)<128)
                ScrP(i,j,k) = min(max((Sc(i,j,k)-Smean(k))*((Smin(k)-128)/(Smin(k)-Smean(k)))+128,0),255);
            else
                ScrP(i,j,k) = min(max((Sc(i,j,k)-Smean(k))*((Smax(k)-128)/(Smax(k)-Smean(k)))+128,0),255);
            end
        end
    end
end
figure,imshow(ScrP)
ScrLab = rgb2lab(ScrP);
L = ScrLab(:,:,1)/100;

ScrAEq = ScrLab;
ScrAEq(:,:,1) = adapthisteq(L)*100;
ScrAEq = lab2rgb(ScrAEq);

figure;
subplot(2,2,1);
imshow(Sc);
title('Original');

subplot(2,2,2);
imshow(Scr);
title('Enhanced Eq 1');

subplot(2,2,3);
imshow(ScrP);
title('Enhanced Eq 2');

subplot(2,2,4);
imshow(ScrAEq);
title('Adaptive Histogram Equalized');
imrestored = ScrAEq;
imrestored = im_unity(imrestored);
imrestored = im2uint8(imrestored);