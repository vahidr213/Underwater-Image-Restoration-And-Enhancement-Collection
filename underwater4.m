clc
clear all
close all
format short g
format compact
if (exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    pkg load image
    pkg load signal
end
inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\';%path for reading image
outpath = 'I:\';% path for saving results
doDegradation = 1; % 0/1  - if 0, the image itself is restored.
%%% if 1, image is degraded at first, then the degraded image is restored back again by
%%% available methods to its original. use this only if you have perfect underwater image
%%% and you want to see the mean squared error.
warning('off', 'all')% suppress all warnings
pwd0=pwd;%current dir
cd(pwd0);

% im = imread('pears.png');
% cd('./16.00')
% im = im2double(im);
% im(:,:,1) = imagefiltering(im2double(im(:,:,1)),1,15,5);
% imshow(im,[])

% imref=imread('pears.png');
% imref = insertText(imref,[size(imref,2)-40 30],...
% 1234.02, 'AnchorPoint', 'Center','FontSize',18,'TextColor','white','Font','Consolas Bold');
% imshow(imref)
% X = double(imref(:,:,1));
% [c,s] = wavedec2(X,3,'sym3');
% for j=1:3
%     step(j)=s((j+1),1)*s((j+1),2);  % length of each coefficient
% end
% num(1,1)=s(1,1)*s(1,2)+1; % H|V|D
% num(1,2)=num(1,1)+s(2,1)*s(2,2);
% num(1,3)=num(1,2)+s(2,1)*s(2,2);
    
% num(2,1)=num(1,3)+s(2,1)*s(2,2);
% num(2,2)=num(2,1)+s(3,1)*s(3,2);
% num(2,3)=num(2,2)+s(3,1)*s(3,2);
    
% num(3,1)=num(2,3)+s(3,1)*s(3,2);
% num(3,2)=num(3,1)+s(4,1)*s(4,2);
% num(3,3)=num(3,2)+s(4,1)*s(4,2);
% ch = c(1,1:s(1,1)*s(1,2));
% v1 =0.003;
% idx = find( abs(ch) >= v1 );
% ch(idx) = ( abs(ch(idx)) - v1 ) .* sign(ch(idx));            
% c(1,1:s(1,1)*s(1,2)) = ch;
% a0 = waverec2(c,s,'sym3');
% max(max(abs(X-a0)))
% % imwrite(imref,'sdf.jpg')


% inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\DeepBlue';
% cd(inpath)
% % imref = imread('ref.jpg');
% im = imread('08.jpg');
% inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\';
% cd(inpath)
% imref=imread('ref_DeepBlue.jpg');
% immse(imref,im)
% N = 3;
% namewavelet = 'sym3';
% [c,s]= wavedec2(im(:,:,1), N, namewavelet);

% size(c)
% [H3,V3,D3] = detcoef2('all', c, s, N);
% [H2,V2,D2] = detcoef2('all', c, s, 2);
% [H,V,D] = detcoef2('all', c, s, 1);
% A3 = appcoef2(c, s, namewavelet, N);
% A2 = appcoef2(c, s, namewavelet, 2);
% A = appcoef2(c, s, namewavelet, 1);
% c=[A3(:) H3(:) V3(:) D3(:)];
% c2 = [A2(:) H2(:) V2(:) D2(:)];
% c3 = [A(:) H(:) V(:) D(:)];
% C 
% c = c(:)';
% size(c)
% X = double(im(:,:,1));
% [c,s] = wavedec2(X,3,'sym3');
% a0 = waverec2(c,s,'sym3');
% max(max(abs(X-a0)))

% image(im);
% k = waitforbuttonpress;
% point1 = get(gca,'CurrentPoint');    % mouse pressed
% rectregion = rbbox;  
% point2 = get(gca,'CurrentPoint');
% point1
% point2
% point1 = point1(1,1:2);% extract col/row min and maxs
% point2 = point2(1,1:2);
% lowerleft = min(point1, point2)
% upperright = max(point1, point2)
% cmin = round(lowerleft(1))
% cmax = round(upperright(1))
% rmin = round(lowerleft(2))
% rmax = round(upperright(2))
% imhsv = rgb2hsv(im);
% imsel = imhsv(rmin:rmax,cmin:cmax,1);
% imsel(1:10,1:10)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% imref = double(imref);
% im = double(im);
% X = reshape(imref,3,numel(imref(:,:,1)));
% b = ones(1,size(X,2));
% X = [X;b];
% Y = reshape(im,3,numel(im(:,:,1)));
% fun = @(A)(norm(A*X-Y));
% A = ones(3,4);
% A = [0.4065   -0.1705    0.4405    1.2755;
%     0.4053   -0.1892    0.4377    1.2725;
%     0.4017   -0.1767    0.4410    1.2855];

% [A fval] = fminunc(fun,A);
% A
% fval
% for i = 1:length(listing)
%     im = double(imread(fullfile(inpath,listing(i).name)));
%     X = reshape(im,3,numel(im(:,:,1)));
%     b = ones(1,size(X,2));
%     X = [X;b];
%     Y = A*X;
%     im2 = reshape(Y, size(im,1), size(im,2),3);
%     im2 = im_unity(im2)*255;
%     disp(i)
% end
% A = [0.5347    0.1112   -0.2740   36.0041
%    -0.2955   -0.2334    0.4273   36.1116
%    0.4121   -0.0925    0.4227   36.1568];
% inpath = 'F:\Picture\my wallpapers\';%path for reading image


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\';%path for reading image
% outpath = 'I:\';% path for saving results
% listing = dir(fullfile(inpath,'*.png'))
% for i = 1:length(listing)
%     im = double(imread(fullfile(inpath,listing(i).name)));
%     im2 = SimplestColorBalance(im);
%     imshow(cat(2,uint8(im),uint8(im2)))
%     waitforbuttonpress
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\

% %%%%%%%%%%%%%%%%%%%%%%5   kalman filter
% inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\';
% cd(inpath)
% imref=imread('ref_DeepBlue.jpg'); % read the reference pic
% inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\DeepBlue';
% cd(inpath)
% % imref = imread('ref.jpg');
% im = imread('08.jpg');
% immse(imref,im)
% listing = dir(fullfile(inpath,'*.jpg'));
% a = 1;
% b = 20;
% n=0;
% e=0.0;
% cd(pwd0)
% for i = b:-1:a
%     n = n+1;
%     inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\DeepBlue\';
%     % inpath = fullfile(inpath, listing(i).name);
%     cd(inpath)
%     imrgb = imread(listing(i).name);
%     avg = mean2(imrgb(:,:,3));
%     fprintf('mean:%f\n',avg);
%     im = rgb2hsv(imread(listing(i).name));
%     if i == 1
%         inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\ref_DeepBlue.jpg';
%         imref = rgb2hsv(imread(inpath));
%     else
%        imref = rgb2hsv(imread(listing(i-1).name));
%     end
%     cd(pwd0)
%     indata = [im(100,100,1);im(100,100,2)];
%     refdata = [imref(100,100,1);imref(100,100,2)];
%     dt=-1;
%     A=[    1 0 dt 0 0 0;...            
%         0 1 0 dt 0 0;...     
%         0 0 1 0 dt 0;...     
%         0 0 0 1 0 dt;...     
%         0 0 0 0 1 0 ;...     
%         0 0 0 0 0 1 ];       
%     Q = 1*eye(6);
%     R = 1 * eye(2);
%     B=[1 0;0 1;0 0;0 0;0 0;0 0];
%     if n == 1
%         initialdata = indata
%         point_kalman=kalmanfilter(A,B,Q,R,initialdata,initialdata);
%     else
%         point_kalman=kalmanfilter(A,B,Q,R,initialdata,indata);
%     end
%     v1(n,1) = refdata(1);
%     v1(n,2) = point_kalman(1);
%     v1(n,3) = 100*(v1(n,2)/v1(n,1) - 1);
%     v2(n,1) = refdata(2);
%     v2(n,2) = point_kalman(2);
%     v2(n,3) = 100*(v2(n,2)/v2(n,1) -1);
%     v1(n,4) = avg;
%     e = e + (refdata - point_kalman).^2;
% end
% v1
% v2
% e = sqrt(e)/n
% x = v1(:,4);
% y = v1(:,1);
% f=fit(x,y,'poly3','Normalize','on','Robust','Bisquare')
% plot(f,x,y)


% clear x_est p_est