function imrestored = main2(doDegradation,inpath,v1)
% subtract a constant at all levels on a 3-level wavelet for Saturation + max value channels

% I_in=imread('.\images\test12.png');
pwd0=cd('..');
[I_in,imref] = load_image(doDegradation,inpath);     
cd(pwd0);
% I_in = SimplestColorBalance(I_in, 0.005, 0.005, 255);
if (v1 < 0) || (v1 > 0.08)
    imrestored = zeros(size(imref),'uint8');
else
    I = im2double(I_in);
    I = rgb2hsv(I);
    namewavelet = 'sym3';
    N = 3;
    n=1;
    [imheight imwidth ~] = size(I);
    for i = 2:3
        [c,s]= wavedec2(I(:,:,i), N, namewavelet);
        [H,V,D] = detcoef2('all', c, s, N);
        A = appcoef2(c, s, namewavelet, N);
        allcoeff{N}{1} = A;
        allcoeff{N}{2} = H;
        allcoeff{N}{3} = V;
        allcoeff{N}{4} = D;
        for j = N : -1 : 1
            for k = 1:4
                A = allcoeff{j}{k};
                Anew = zeros(size(A));
                idx = find( abs(A) >= v1 );
                Anew(idx) = ( abs(A(idx)) - v1 ) .* sign(A(idx));
                allcoeff{j}{k} = Anew;
            end
            if j > 1
                allcoeff{j-1}{1} = upcoef2('a', allcoeff{j}{1}, namewavelet, 1);
                allcoeff{j-1}{2} = upcoef2('h', allcoeff{j}{2}, namewavelet, 1);
                allcoeff{j-1}{3} = upcoef2('v', allcoeff{j}{3}, namewavelet, 1);
                allcoeff{j-1}{4} = upcoef2('d', allcoeff{j}{4}, namewavelet, 1);
            end
        end
        % Anew = zeros(size(A));
        % idx = find( abs(A) >= v1 );
        % Anew(idx) = ( abs(A(idx)) - v1 ) .* sign(A(idx));
        % I_out(:,:,n) = idwt2(Anew,H,V,D,namewavelet);
        I_out(:,:,n) = idwt2(allcoeff{1}{1},allcoeff{1}{2},allcoeff{1}{3},allcoeff{1}{4},namewavelet);
        n = n + 1;
    end
    % I_out= imresize(I_out, [imheight imwidth], 'bicubic');
    
    I_out(find(I_out > 1)) = 1.0;
    I_out(find(I_out < 0)) = 0.0;
    imfinal(:,:,1) = I(:,:,1);
    imfinal(:,:,2) = I_out(1:imheight,1:imwidth,1);
    imfinal(:,:,3) = I_out(1:imheight,1:imwidth,2);
    imfinal = hsv2rgb(imfinal);
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