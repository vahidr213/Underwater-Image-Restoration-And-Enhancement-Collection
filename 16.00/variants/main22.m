function imrestored = main2(doDegradation,inpath,parvars)
% subtract an optimum constant at level 1 from Approximation + Horizontal + Vertical band
% for a 1-level wavelet decomposition for Hue + Saturation channels
% post processing = stretch optimum
v1 = parvars(1);
v2 = parvars(2);

pwd0=cd('..');
[I_in,imref] = load_image(doDegradation,inpath);     
cd(pwd0);
% I_in = SimplestColorBalance(I_in, 0.005, 0.005, 255);
if (v1 < 0) || (v1 > 0.1) || (v2 > 0.1) || (v2 < 0)
    imrestored = zeros(size(imref),'uint8');
else
    I = im2double(I_in);
    I = rgb2hsv(I);
    namewavelet = 'sym3';
    N = 3;
    n=1;
    [imheight imwidth ~] = size(I);
    for i = 1:2
        [c,s]= wavedec2(I(:,:,i),n,namewavelet);
        [H,V,D] = detcoef2('a',c,s,1);
        A = appcoef2(c,s,namewavelet,1);
        Anew = zeros(size(A));
        idx = find( abs(A) >= v1 );
        Anew(idx) = ( abs(A(idx)) - v1 ) .* sign(A(idx));
        Hnew = zeros(size(H));
        idx = find( abs(H) >= v1 );
        Hnew(idx) = ( abs(H(idx)) - v1 ) .* sign(H(idx));
        Vnew = zeros(size(V));
        idx = find( abs(V) >= v1 );
        Vnew(idx) = ( abs(V(idx)) - v1 ) .* sign(V(idx));
        I_out(:,:,n) = idwt2(Anew,Hnew,Vnew,D,namewavelet);
        n = n + 1;
    end
    % I_out= imresize(I_out, [imheight imwidth], 'bicubic');
    
    I_out(find(I_out > 1)) = 1.0;
    I_out(find(I_out < 0)) = 0.0;

    imfinal(:,:,3) = I(:,:,3);
    imfinal(:,:,1) = I_out(1:imheight,1:imwidth,1);
    imfinal(:,:,2) = I_out(1:imheight,1:imwidth,2);

    imfinal = hsv2rgb(imfinal);%convert to rgb

    imfinal(:,:,2) = strechimage1(imfinal(:,:,2),v2);
    imfinal(:,:,3) = strechimage1(imfinal(:,:,3),v2);

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