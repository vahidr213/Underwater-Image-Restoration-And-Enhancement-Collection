function imrestored = main2(doDegradation,inpath)
% Implementation of the work "Hue preserving-based approach for
% underwater colour image enhancement" Guojia Hou,Zhenkuan Pan
% ,Baoxiang Huang, Guodong Wang, Xin Luan, in :IET Image Processing
% 12(2)(2018).


% I_in=imread('.\images\test12.png');
pwd0=cd('..');
[I_in,imref] = load_image(doDegradation,inpath);     
cd(pwd0);
msetotal = 100000;
sigmabest = 0.0;
gsbest = 0.0;
for gs = 3:2:13
    for sigma = 0.3:0.2:0.9
        I_out= wdf_chs1(I_in,gs,sigma);
        % figure;imshow([I_in I_out],'Border','tight');
        mse = immse(imref,I_out);
        if mse < msetotal
            msetotal = mse;
            gsbest = gs;
            sigmabest = sigma;
            disp([gs,sigma,msetotal])       
        end
    end
end
fileID = fopen('I:\result.txt','a');
fprintf(fileID,'%s\n',inpath);
fprintf(fileID, '%.1f\t%.1f\t%.1f\n',gsbest,sigmabest,msetotal);
fclose(fileID);
imrestored = I_out;
end



function I_final = wdf_chs1(I,gs,sigma)
    
    I(:,:,1) = adapthisteq(I(:,:,1));
    I(:,:,2) = adapthisteq(I(:,:,2));
    I(:,:,3) = adapthisteq(I(:,:,3));    
    % I = SimplestColorBalance(I,0.005,0.005,255);
    I = im2double(I);
    I1 = rgb2hsi(I);
    I_wdf(:,:,1) = I1(:,:,1);
    for i=2:3
        I_wdf(:,:,i) = homomorphic1(I1(:,:,i),gs,sigma);
        I_wdf(:,:,i) = wav_dno(I_wdf(:,:,i));
    end    
    I2=hsi2rgb(I_wdf);
    
    for i=1:3
        I_rs(:,:,i)=strechimage(double(I2(:,:,i)));
    %     I_rs(:,:,i) = wav_dno(I_rs(:,:,i));
    end
    
    I3=rgb2hsv(I_rs);
    I_chs(:,:,1) = I3(:,:,1);
    for i=2:3
        I_chs(:,:,i) = strechimage(I3(:,:,i));
    end
    I_final= uint8(hsv2rgb(I_chs).*255);
    
    
    % figure;
    % subplot(131);imshow(I);title('Raw');
    % subplot(132);imshow(I2);title('After WDF'); 
    % subplot(133);imshow(I_final);title('After CHS');
end


function g=homomorphic1(f,gs,sigma)


    J=double(f);
    f_high = 2.5;
    f_low = 0.5;
    
    %gauss_low_filter = fspecial('gaussian', [7 7], 1.414);
    gauss_low_filter = fspecial('gaussian', [gs gs], sigma);
    matsize = size(gauss_low_filter);
    
    gauss_high_filter = zeros(matsize);
    gauss_high_filter(ceil(matsize(1,1)/2) , ceil(matsize(1,2)/2)) = 1.0;
    gauss_high_filter = f_high*gauss_high_filter - (f_high-f_low)*gauss_low_filter;
    
    log_img = log(double(f)+1);
     high_log_part = imfilter(log_img, gauss_high_filter, 'symmetric', 'conv');
    
    high_part = exp(high_log_part);
    minv = min(min(high_part));
    maxv = max(max(high_part));
    g=(high_part-minv)/(maxv-minv);
end