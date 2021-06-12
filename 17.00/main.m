function imrestored = main(doDegradation,inpath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    File: UWB_VCE.m                                         %
%    Author: XinJie_Li                                       %
%    Date: Feb/2020                                          %
%    A Hybrid Framework for Underwater Image enhancement     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% I = im2double(imread('2.png')); 
pwd0=cd('..');
I = load_image(doDegradation,inpath);     
cd(pwd0);
I = im2double(I);

%----------------------------------
%Parameter configurations
para.alpha=0.2;
para.beta=0.06;
para.lambda =6;

para.t=0.5; % 0<t<1,the step size.
% __________________________________
Op=UWB_VCE(I,para);
% Op=strech_color(Op);%Histogram streching

figure, imshow([I Op], 'Border','tight');

imrestored = Op;