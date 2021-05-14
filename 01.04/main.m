function  main(im,imref,method,prefixaddress)
% % % im is normalized 0-1
% % % imref is uint8
% % % prefixaddress='I:\';
% % %%%%%%%%%%%
% % % This method is almost completely alike to method 1.01. the only difference is in saliency detection algorithm. This is another saliency detection algorithm which is highly slow.

% % % •	Normalized UDCP Medium Transmission Matrix

% % % •	Normalized Saliency Map for UDCP Matrix

% % % •	4-Level Gaussian Pyramid for Normalized Saliency Map

% % % •	4-Level Residual Pyramid for Normalized UDCP Matrix

% % % •	Normalized IATP Medium Transmission Matrix

% % % •	Normalized Saliency Map for IATP Matrix

% % % •	4-Level Gaussian Pyramid for Normalized Saliency Map

% % % •	4-Level Residual Pyramid for Normalized IATP Matrix

% % % •	Multiplying UDCP Saliency Pyramid by UDCP Residual Pyramid to Build UDCP Pyramid

% % % •	Reconstructing UDCP Pyramid to Build Refined UDCP Matrix + Normalization

% % % •	Scene Depth by Log (Refined UDCP Matrix)/Log (0.8) Eq.16 [1]

% % % •	Final UDCP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

% % % •	Get Restored Red Channel Intensities with Final UDCP Matrix Eq.18 [1]

% % % •	Multiplying IATP Saliency Pyramid by IATP Residual Pyramid to Build IATP Pyramid

% % % •	Reconstructing IATP Pyramid to Build Refined IATP Matrix + Normalization

% % % •	Scene Depth by Log (Refined IATP Matrix)/Log (0.8) Eq.16 [1]

% % % •	Final IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

% % % •	Get Restored Red Channel Intensities with Final IATP Matrix Eq.18 [1]

% % % •	Joint UDCP + IATP Pyramids as Summation of Corresponding Pyramids

% % % •	Reconstructing Joint UDCP + IATP Pyramid to Build Joint UDCP + IATP Matrix + Normalization

% % % •	Scene Depth by Log (Joint UDCP + IATP Matrix)/Log (0.8) Eq.16 [1]

% % % •	Final Joint UDCP + IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

% % % •	Get Restored Red Channel Intensities with Final Joint UDCP + IATP Matrix Eq.18 [1]



printf('\nmethod %.2f\n',method);
gs = 3;
%%% % % calculate medium transmission for degraded picture
[medtransMat, globalBackgLight] =  mediumtransmissionMat (im, gs, 1);% 1=UDCP
medtransMat3=cat(3,medtransMat,medtransMat,medtransMat);% make a 3 channel
saliencymap = saliency_detection(im2uint8(medtransMat3),2);% 2nd saliency method

%%%%%%%% Gaussian and residual Pyramid of the saliencymap
%%%%%%the below code supports both gray and 3D images
num_levels = 4; % num of gauss and residual pyr levels
pyr=cell(1,num_levels);
residualPyr=cell(1,num_levels);
salGaussPyr = cell(1,num_levels);
finalmedtransPyr = cell(1,num_levels);

salGaussPyr=buildpyramid(saliencymap,num_levels,1);%gauss pyr of saliency
residualPyr=buildpyramid(medtransMat,num_levels,2);%residual pyr of medium transmission

%%%%% multiplying saliency map gaussian pyramid
%%%%% with residual pyramid of medium transmission
for i = 1 : (num_levels)
  finalmedtransPyr{i} = salGaussPyr{i} .* residualPyr{i};  
  %%%%% normalizing to 0-1
  % if size(finalmedtransPyr{i},3)==1 %%% for 2D image
  %   finalmedtransPyr{i}=(finalmedtransPyr{i}-min(finalmedtransPyr{i}(:)))/(max(finalmedtransPyr{i}(:)) - min(finalmedtransPyr{i}(:)) );
  % endif
end
finalmedtransPyr1=finalmedtransPyr;

%%%%%%                       2nd medium transmission with IATP
medtransMat =  mediumtransmissionMat (im, gs, 2); %%% 2 = IATP medium transmission
medtransMat3=cat(3,medtransMat,medtransMat,medtransMat);%%% make it 3 channel

saliencymap = saliency_detection(im2uint8(medtransMat3), 2);%%% 2nd saliency method

%%%%%%%% Gaussian and residual Pyramid of the saliencymap
%%%%%%the below code supports both gray and 3D images
salGaussPyr=buildpyramid(saliencymap,num_levels,1);%gauss pyr of saliency
residualPyr=buildpyramid(medtransMat,num_levels,2);%residual pyr of medium transmission
%%%%% multiplying saliency map gaussian pyramid with residual pyramid of medium transmission
for i = 1 : (num_levels)
  finalmedtransPyr{i} = salGaussPyr{i} .* residualPyr{i};
  %%%%% normalizing to 0-1
  % if size(finalmedtransPyr{i},3)==1 %%% for 2D image
  %   finalmedtransPyr{i}=(finalmedtransPyr{i}-min(finalmedtransPyr{i}(:)))/(max(finalmedtransPyr{i}(:)) - min(finalmedtransPyr{i}(:)) );
  % endif
  % finalmedtransPyr{i}=guided_filter(finalmedtransPyr{i}, pyr{i}, 0.01, 5);
end
finalmedtransPyr2 = finalmedtransPyr;

finalmedtransMat=pyramid_reconstruct(finalmedtransPyr1);
finalmedtransMat=im_unity(finalmedtransMat);
finalmedtransMat=log(max(finalmedtransMat,0.01*ones(size(finalmedtransMat))))/log(0.8);
finalmedtransMat=0.85.^finalmedtransMat;
im2=( im(:,:,1)-globalBackgLight(1)*(1-finalmedtransMat) )./max(0.3*ones(size(finalmedtransMat)) , globalBackgLight(1)*finalmedtransMat);
im2=im_unity(im2);
mse = immse (im2uint8(im2(:,:,1)) , imref (:,:,1) );
imrestored=im;% restored image 3 channel
imrestored(:,:,1)=im2;% assign new restored red channel
resfilename=sprintf('method %.2f restored vs original - UDCP',method);
disp('');
disp('using UDCP medium transmission:');
disp(['mse bw ref image and restored image is:    ',num2str(mse)]);
figure('name',resfilename),imshow(cat(2, im2uint8(imrestored), imref ));
resfilename=sprintf('%s%s.jpg',prefixaddress,resfilename);
imwrite(cat(2, im2uint8(imrestored), imref ) , resfilename);


finalmedtransMat=pyramid_reconstruct(finalmedtransPyr2);
finalmedtransMat=im_unity(finalmedtransMat);
finalmedtransMat=log(max(finalmedtransMat,0.01*ones(size(finalmedtransMat))))/log(0.8);
finalmedtransMat=0.85.^finalmedtransMat;
im2=( im(:,:,1)-globalBackgLight(1)*(1-finalmedtransMat) )./max(0.3*ones(size(finalmedtransMat)) , globalBackgLight(1)*finalmedtransMat);
im2=im_unity(im2);
imrestored=im;% restored image 3 channel
imrestored(:,:,1)=im2;% assign new restored red channel
resfilename=sprintf('method %.2f restored vs original - IATP',method);
mse = immse (im2uint8(im2(:,:,1)) , imref (:,:,1) );
disp('');
disp('using IATP medium transmission:');
disp(['mse bw ref image and restored image is:    ',num2str(mse)]);
figure('name',resfilename),imshow(cat(2, im2uint8(imrestored), imref ));
resfilename=sprintf('%s%s.jpg',prefixaddress,resfilename);
imwrite(cat(2, im2uint8(imrestored), imref ) , resfilename);

% %%%%%% combining 2 final medium transmission pyramids into one
for i=1:num_levels
  finalmedtransPyr{i}=finalmedtransPyr{i}+finalmedtransPyr1{i};
endfor
finalmedtransMat=pyramid_reconstruct(finalmedtransPyr);
finalmedtransMat=im_unity(finalmedtransMat);
finalmedtransMat=log(max(finalmedtransMat,0.01*ones(size(finalmedtransMat))))/log(0.8);
finalmedtransMat=0.85.^finalmedtransMat;
im2=( im(:,:,1)-globalBackgLight(1)*(1-finalmedtransMat) )./max(0.3*ones(size(finalmedtransMat)) , globalBackgLight(1)*finalmedtransMat);
im2=im_unity(im2);
imrestored=im;% restored image 3 channel
imrestored(:,:,1)=im2;% assign new restored red channel
resfilename=sprintf('method %.2f restored vs original - UDCP+IATP',method);
mse = immse (im2uint8(im2(:,:,1)) , imref (:,:,1) );
disp('');
disp('using IATP + UDCP medium transmission:')
disp(['mse bw ref image and restored image is:    ',num2str(mse)]);
figure('name',resfilename),imshow(cat(2, im2uint8(imrestored), imref ));
resfilename=sprintf('%s%s.jpg',prefixaddress,resfilename);
imwrite(cat(2, im2uint8(imrestored), imref ) , resfilename);



end
