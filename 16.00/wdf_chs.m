function I_final = wdf_chs(I)

I = im2double(I);
I1 = rgb2hsi(I);
I_wdf(:,:,1) = I1(:,:,1);
for i=2:3
    I_wdf(:,:,i) = homomorphic(I1(:,:,i));
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