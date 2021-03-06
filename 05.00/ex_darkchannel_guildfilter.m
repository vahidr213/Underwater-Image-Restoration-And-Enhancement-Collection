function J=ex_darkchannel_guildfilter(doDegradation,inpath)
kenlRatio = 0.01;
minAtomsLight = 240;
%image_name =  'test1.jpg';
pwd0=cd('..');
img = load_image(doDegradation,inpath);     
cd(pwd0);
figure,imshow(uint8(img)), title('src');
sz=size(img);
w=sz(2);
h=sz(1);
dc = zeros(h,w);
%derive the dark channel from original image
for y=1:h
    for x=1:w
        dc(y,x) = min(img(y,x,:));
    end
end
figure,imshow(uint8(dc)), title('Min(R,G,B)/dark channel');
%minimum filter
krnlsz = floor(max([3, w*kenlRatio, h*kenlRatio]));
dc2 = minfilt2(dc, [krnlsz,krnlsz]);
dc2(h,w)=0;
figure,imshow(uint8(dc2)), title('After filter ');
t = 255 - dc2;
figure,imshow(uint8(t)),title('t');
t_d=double(t)/255;
%sum(sum(t_d))/(h*w)
A = min([minAtomsLight, max(max(dc2))]);
J = zeros(h,w,3);
img_d = double(img);
J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
figure,imshow(uint8(J)), title('J');
% figure,imshow(rgb2gray(uint8(abs(J-img_d)))), title('J-img_d');
% a = sum(sum(rgb2gray(uint8(abs(J-img_d))))) / (h*w)
% return;
%----------------------------------
r = krnlsz*4;
eps = 10^-6;
% filtered = guidedfilter_color(double(img)/255, t_d, r, eps);
filtered = guidedfilter(double(rgb2gray(img))/255, t_d, r, eps);
t_d = filtered;
figure,imshow(t_d,[]),title('filtered t');
J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
img_d(1,3,1);
%imwrite(uint8(J),'c:\11.bmp');
figure,imshow(uint8(J)), title('J_guild_filter');
J=uint8(J);
%----------------------------------
% imwrite(uint8(J), ['_', image_name])