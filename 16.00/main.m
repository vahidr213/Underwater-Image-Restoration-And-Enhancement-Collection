function imrestored = main(doDegradation,inpath)
% Implementation of the work "Hue preserving-based approach for
% underwater colour image enhancement" Guojia Hou,Zhenkuan Pan
% ,Baoxiang Huang, Guodong Wang, Xin Luan, in :IET Image Processing
% 12(2)(2018).


% I_in=imread('.\images\test12.png');
pwd0=cd('..');
I_in = load_image(doDegradation,inpath);     
cd(pwd0);

I_out= wdf_chs(I_in);
figure;imshow([I_in I_out],'Border','tight');

imrestored = I_out;
