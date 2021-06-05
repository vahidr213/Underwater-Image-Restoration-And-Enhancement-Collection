function imrestored = main(doDegradation,inpath)
% % % degradation on input image
LABcolorTransform = makecform('srgb2lab');
RGBcolorTransform = makecform('lab2srgb');
% ref_im = imread('.\reference\2.jpg');
ref_im = imread('.\reference\2.jpg');
input_im = imread(inpath);

imref = input_im; % save a copy of the input image for error measuring
%     degrade input image
if doDegradation == 1
    im = im2double(input_im);
    pwd0 = cd('..');
    gsdestruction = 3; % size of the window or patch around each point    
    medtransMat  =  mediumtransmissionMat(im, gsdestruction, 1);% 1 = UDCP(more degradation), 2 = IATP(less degradation)    
    im(:,:,1) = im(:,:,1) .* medtransMat;
    input_im = im2uint8(im);
    cd(pwd0);
end

load(fullfile(pwd,'picked_colors','sample_4_picked_colors.mat'))
load(fullfile(pwd,'params','sample_4_params.mat'))
% picked_rbg = load('.\picked_colors\sample_1_picked_colors.mat');
% output_rbg = handles.picked_colors.output_rbg;

ref_im_lab = applycform(im2double(ref_im), LABcolorTransform);
input_im_lab = applycform(im2double(input_im), LABcolorTransform);
l1=lambds(1);% from load mat
if (l1==0)
    msgbox(sprintf('Variable lambda_1 must be different than 0'),'Error','Error')
    return
end

l2= lambds(2);% from load mat

l3= lambds(3);% from load mat
w2=[1 0 0;0 1 0;0 0 1];
[A,B]=estimate_Ab_matrix_trust_region_method(picked_rbg,output_rbg,input_im_lab,ref_im_lab,l1,l2,l3,w2);  
AB=[A B];
AB_Transformation = AB;
result_image=transform_by_color_matrix(AB,input_im);
% figure;
% imshow(result_image);
imrestored = im2uint8(result_image);





% % % %  no degradation of input image
% 
% ref_im = imread('.\reference\2.jpg');
% input_im = imread('.\input_images\sample_4.jpg');
% load(fullfile(pwd,'picked_colors','sample_4_picked_colors.mat'))
% load(fullfile(pwd,'params','sample_4_params.mat'))
% 
% ref_im_lab = applycform(im2double(ref_im), LABcolorTransform);
% input_im_lab = applycform(im2double(input_im), LABcolorTransform);
% l1=lambds(1);% from load mat
% if (l1==0)
%     msgbox(sprintf('Variable lambda_1 must be different than 0'),'Error','Error')
%     return
% end
% 
% l2= lambds(2);% from load mat
% 
% l3= lambds(3);% from load mat
% w2=[1 0 0;0 1 0;0 0 1];
% [A,B]=estimate_Ab_matrix_trust_region_method(picked_rbg,output_rbg,input_im_lab,ref_im_lab,l1,l2,l3,w2);  
% AB=[A B];
% AB_Transformation = AB;
% result_image=transform_by_color_matrix(AB,input_im);
% figure;
% imshow(result_image);
