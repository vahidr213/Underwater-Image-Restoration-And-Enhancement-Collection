% =========================================================================
%% Deep Lowlight image enhancement %%
% =========================================================================
function imrestored = demo(doDegradation,inpath)

addpath(genpath('.'));
r=1.7;
%% read image
% [fn,pn,fi]=uigetfile('*.bmp;*.jpg;*.png;*.tif','select image');
% im=imread([pn fn]);
pwd0=cd('..');
im = load_image(doDegradation,inpath);     
cd(pwd0);

figure,imshow(im),title('input');
IM=im2double(im);
[height,width,channel]=size(IM);
LB=IM;
%% deep enhancement
model= 'lowlight4layersfinal.mat';
im_b=LB;
load(model);
%% conv1
f1=convolution(im_b, weights_conv1, biases_conv1);
%% conv2
f2=convolution(f1, weights_conv2, biases_conv2);
%% conv3
f3=convolution(f2, weights_conv3, biases_conv3);
%% conv4
f4=convolution1(f3, weights_conv4, biases_conv4);
map=f4.^r;% gammar correction, ajust the brightness by paramter r 

%% %% guided filtering
p = map;
batch_size = 33;
eps = 10^-3; 
map = guidedfilter(IM(:,:,1), p, batch_size, eps); 

%% Retinex model
new(:,:,1)=LB(:,:,1)./(map);
new(:,:,2)=LB(:,:,2)./(map);
new(:,:,3)=LB(:,:,3)./(map);
new = abs(new);
figure,imshow(abs(new),[]),title('enhanced');
imrestored = im2uint8(new);
end