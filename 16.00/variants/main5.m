function imrestored = main2(doDegradation,inpath,v1)
% Applying stretch with variable 's' on Approximate decomposition of RGB color space

% I_in=imread('.\images\test12.png');
pwd0=cd('..');
[I_in,imref] = load_image(doDegradation,inpath);     
cd(pwd0);
I = im2double(I_in);
namewavelet = 'sym3';
n = 3;
[imheight imwidth ~] = size(I);
for i = 1:3
    [c,s]= wavedec2(I(:,:,i),n,namewavelet);
    [H,V,D] = detcoef2('a',c,s,1);
    A = appcoef2(c,s,namewavelet,1);
    A = strechimage(A,v1);
    I_out(:,:,i) = idwt2(A,H,V,D,namewavelet);
end
I_out= imresize(I_out, [imheight imwidth], 'nearest');
% I_out = I_out(1:end-1,:,:); %for turbid
I_out = mat2gray(I_out);
imrestored = im2uint8(I_out);
end
function Is = strechimage(data,s)
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