function imrestored = main2(doDegradation,inpath,paramvector,varargin)
% pre-processing: stretchlim on initail image with a constant threshold
% pre-process: homomorphic with constant gs and sigma
% subtract two optimum constant (parametric) from A1,H1,V1,D1
%  band of wavelet for Hue (paramvector(1)) + Saturation (paramvector(2)) channels

if nargin == 4, gs = varargin{1}; end
pwd0=cd('..');
[I_in,imref] = load_image(doDegradation,inpath);     
cd(pwd0);
% I_in = SimplestColorBalance(I_in, 0.001, 0.001, 255);
% I_in = stretchimagelocal(I_in,269,0.0001);
lowhigh = stretchlim(I_in,0.0001);
I_in = imadjust(I_in,lowhigh);

I = im2double(I_in);
I = rgb2hsv(I);
namewavelet = 'sym3';
N = 1;
n=1;
[imheight imwidth ~] = size(I);
for i = 1:2
    I(:,:,i) = imagefiltering(I(:,:,i), 1, gs, paramvector(3) );
    [c,s]= wavedec2(I(:,:,i),N,namewavelet);
    for j=1:N
        step(j)=s((j+1),1)*s((j+1),2);  % length of each coefficient from smaller to bigger
    end
    num(1,1)=s(1,1)*s(1,2)+1; % H|V|D
    num(1,2)=num(1,1)+s(2,1)*s(2,2);
    num(1,3)=num(1,2)+s(2,1)*s(2,2);
        
    num(2,1)=num(1,3)+s(2,1)*s(2,2);
    num(2,2)=num(2,1)+s(3,1)*s(3,2);
    num(2,3)=num(2,2)+s(3,1)*s(3,2);
        
    % num(3,1)=num(2,3)+s(3,1)*s(3,2);
    % num(3,2)=num(3,1)+s(4,1)*s(4,2);
    % num(3,3)=num(3,2)+s(4,1)*s(4,2);
    level = 1; % 1= first 2=2nd ... to smaller subbands
    whichcoef = 3; % 1=H 2=V 3=D
    % pos = num(N+1-level,1):num(N+1-level,whichcoef) + step(N+1-level) - 1;
    pos = 1:num(N+1-level,whichcoef) + step(N+1-level) - 1;
    % pos = num(1,1):num(3,3)+step(3)-1;% from H3 to D1
    % pos = 1:step(N+1-level);% for Approximate at any level
    ch = c(1,pos);
    idx = find( abs(ch) >= paramvector(i) );
    ch(idx) = ( abs(ch(idx)) - paramvector(i) ) .* sign(ch(idx));            
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