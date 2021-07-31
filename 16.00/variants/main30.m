function imrestored = main2(doDegradation,inpath,parvars)
% subtract an optimum constant from A3, H3, V3, D3, H2, V2, D2  band of wavelet
% for Hue + Saturation channels

v1 = parvars;
% v2 = parvars(2);

pwd0=cd('..');
[I_in,imref] = load_image(doDegradation,inpath);     
cd(pwd0);
% I_in = SimplestColorBalance(I_in, 0.005, 0.005, 255);
% || (v2 > 0.1) || (v2 < 0)
if (v1 < 0) || (v1 > 0.1) 
    imrestored = zeros(size(imref),'uint8');
else
    I = im2double(I_in);
    I = rgb2hsv(I);
    namewavelet = 'sym3';
    N = 3;
    n=1;
    [imheight imwidth ~] = size(I);
    for i = 1:2
        [c,s]= wavedec2(I(:,:,i),N,namewavelet);
        for j=1:3
            step(j)=s((j+1),1)*s((j+1),2);  % length of each coefficient
        end
        num(1,1)=s(1,1)*s(1,2)+1; % H|V|D
        num(1,2)=num(1,1)+s(2,1)*s(2,2);
        num(1,3)=num(1,2)+s(2,1)*s(2,2);
            
        num(2,1)=num(1,3)+s(2,1)*s(2,2);
        num(2,2)=num(2,1)+s(3,1)*s(3,2);
        num(2,3)=num(2,2)+s(3,1)*s(3,2);
            
        num(3,1)=num(2,3)+s(3,1)*s(3,2);
        num(3,2)=num(3,1)+s(4,1)*s(4,2);
        num(3,3)=num(3,2)+s(4,1)*s(4,2);
        level = 2;
        whichcoef = 3;
        pos = 1:num(4-level,whichcoef) + step(4-level) - 1;
        ch = c(1,pos);
        idx = find( abs(ch) >= v1 );
        ch(idx) = ( abs(ch(idx)) - v1 ) .* sign(ch(idx));            
        c(1,pos) = ch;
        I_out(:,:,n) = waverec2(c,s,namewavelet);
        n = n + 1;
    end
    % I_out= imresize(I_out, [imheight imwidth], 'bicubic');
    
    I_out(find(I_out > 1)) = 1.0;
    I_out(find(I_out < 0)) = 0.0;

    imfinal(:,:,3) = I(:,:,3);
    imfinal(:,:,1) = I_out(1:imheight,1:imwidth,1);
    imfinal(:,:,2) = I_out(1:imheight,1:imwidth,2);

    imfinal = hsv2rgb(imfinal);%convert to rgb

    imrestored = uint8(255*imfinal);
    
end

end

function Is = strechimage1(data,s)
    % s=0.003;
    bins=2000;
    [ht,b]=imhist(data,bins);
    [m,n]=size(data);
    d=cumsum(ht)./double(m*n);
    lmin=1;lmax=bins;
    while lmin<bins
         if d(lmin)>s
             break;
         end    
         lmin=lmin+1;
    end    
    while lmax>1
         if d(lmax)<=1-s
             break;
         end    
         lmax=lmax-1;
    end
    
    Is=((data-b(lmin))./(b(lmax)-b(lmin))); 
    Is(find(Is>1))=1;
    Is(find(Is<0))=0;
    
    end