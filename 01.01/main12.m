function  varargout = main9(inpath,outpath,doDegradation,method)
% % % im is normalized 0-1
% % % imref is uint8
% % % •	Normalized UDCP Medium Transmission Matrix

% % % •	Normalized Saliency Map for UDCP Matrix

% % % •	4-Level Gaussian Pyramid for Normalized Saliency Map

% % % •	4-Level Laplacian Pyramid for Normalized UDCP Matrix

% % % •	Normalized IATP Medium Transmission Matrix

% % % •	Normalized Saliency Map for IATP Matrix

% % % •	4-Level Gaussian Pyramid for Normalized Saliency Map

% % % •	4-Level Laplacian Pyramid for Normalized IATP Matrix

% % % •	Multiplying UDCP Saliency Pyramid by UDCP Laplacian Pyramid to Build UDCP Pyramid + Normalizing 

% % % •	Reconstructing UDCP Pyramid to Build Refined UDCP Matrix

% % % •	Scene Depth by Log (Refined UDCP Matrix)/Log (0.8) Eq.16 [1]

% % % •	Final UDCP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

% % % •	Get Restored Red Channel Intensities with Final UDCP Matrix Eq.18 [1]

% % % •	Multiplying IATP Saliency Pyramid by IATP Laplacian Pyramid to Build IATP Pyramid + Normalization

% % % •	Reconstructing IATP Pyramid to Build Refined IATP Matrix 

% % % •	Scene Depth by Log (Refined IATP Matrix)/Log (0.8) Eq.16 [1]

% % % •	Final IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

% % % •	Get Restored Red Channel Intensities with Final IATP Matrix Eq.18 [1]

% % % •	Joint UDCP + IATP Pyramids as Summation of Corresponding Pyramids + Normalization

% % % •	Reconstructing Joint UDCP + IATP Pyramid to Build Joint UDCP + IATP Matrix

% % % •	Scene Depth by Log (Joint UDCP + IATP Matrix)/Log (0.8) Eq.16 [1]

% % % •	Final Joint UDCP + IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

% % % •	Get Restored Red Channel Intensities with Final Joint UDCP + IATP Matrix Eq.18 [1]



%%%%%%%%%%%
  % Since Laplacian pyramid contains negative values, each pyramid will have negative values too. In this case, the pyramids are normalized to unity 0-1 before reconstructing medium transmission matrix from.
  fprintf('\nmethod %.2f\n',method);
  pwd0=cd('..');
  [im,imref] = load_image(doDegradation,inpath);
  im = im2double(im);
  cd(pwd0);  

  minmse = 0; % to find the best mse out of three mse
  gs = 3;
  %%% % % calculate medium transmission for degraded picture
  [medtransMat, globalBackgLight] =  mediumtransmissionMat (im, gs, 1);% 1=UDCP
  medtransMat3=cat(3,medtransMat,medtransMat,medtransMat);% make a 3 channel
  saliencymap = saliency_detection(im2uint8(medtransMat3),1);
  
  %%%%%%%% Gaussian and Laplacian Pyramid of the saliencymap
  %%%%%%the below code supports both gray and 3D images
  num_levels = 4; % num of gauss and Laplacian pyr levels
  pyr=cell(1,num_levels);
  laplacianPyr=cell(1,num_levels);
  salGaussPyr = cell(1,num_levels);
  finalmedtransPyr = cell(1,num_levels);
  
  salGaussPyr=buildpyramid(saliencymap,num_levels,1);%gauss pyr of saliency
  laplacianPyr=buildpyramid(medtransMat,num_levels,4);%Laplacian pyr of medium transmission
  
  %%%%% multiplying saliency map gaussian pyramid
  %%%%% with Laplacian pyramid of medium transmission
  for i = 1 : (num_levels)
    finalmedtransPyr{i} = salGaussPyr{i} .* laplacianPyr{i};  
    %%%%% normalizing pyramid to 0-1
    if size(finalmedtransPyr{i},3)==1 %%% for 2D image
      finalmedtransPyr{i}=(finalmedtransPyr{i}-min(finalmedtransPyr{i}(:)))/(max(finalmedtransPyr{i}(:)) - min(finalmedtransPyr{i}(:)) );
    end
  end
  finalmedtransPyr1=finalmedtransPyr;
  
  %%%%%%                       2nd medium transmission with IATP
  medtransMat =  mediumtransmissionMat (im, gs, 2); %%% 2 = IATP medium transmission
  medtransMat3=cat(3,medtransMat,medtransMat,medtransMat);%%% make it 3 channel
  
  saliencymap = saliency_detection(im2uint8(medtransMat3), 1);%%%% 1 = method 1
  
  %%%%%%%% Gaussian and Laplacian Pyramid of the saliencymap
  %%%%%%the below code supports both gray and 3D images
  salGaussPyr=buildpyramid(saliencymap,num_levels,1);%gauss pyr of saliency
  laplacianPyr=buildpyramid(medtransMat,num_levels,4);%Laplacian pyr of medium transmission
  %%%%% multiplying saliency map gaussian pyramid with Laplacian pyramid of medium transmission
  for i = 1 : (num_levels)
    finalmedtransPyr{i} = salGaussPyr{i} .* laplacianPyr{i};
    %%%%% normalizing pyramid to 0-1
    if size(finalmedtransPyr{i},3)==1 %%% for 2D image
      finalmedtransPyr{i}=(finalmedtransPyr{i}-min(finalmedtransPyr{i}(:)))/(max(finalmedtransPyr{i}(:)) - min(finalmedtransPyr{i}(:)) );
    end
    % finalmedtransPyr{i}=guided_filter(finalmedtransPyr{i}, pyr{i}, 0.01, 5);
  end
  finalmedtransPyr2 = finalmedtransPyr;
  
  finalmedtransMat=pyramid_reconstruct(finalmedtransPyr1);
  % finalmedtransMat=im_unity(finalmedtransMat);
  finalmedtransMat=log(max(finalmedtransMat,0.01*ones(size(finalmedtransMat))))/log(0.8);
  finalmedtransMat=0.85.^finalmedtransMat;
  im2=( im(:,:,1)-globalBackgLight(1)*(1-finalmedtransMat) )./max(0.3*ones(size(finalmedtransMat)) , globalBackgLight(1)*finalmedtransMat);
  im2=im_unity(im2);
  mse = immse (im2uint8(im2(:,:,1)) , imref (:,:,1) );
  minmse = mse;% save a copy for upcoming min finding
  imrestored=im;% restored image 3 channel
  imrestored(:,:,1)=im2;% assign new restored red channel
  resfilename=sprintf('method %.2f restored vs original - UDCP',method);
  if doDegradation == 1
    disp('');
    disp('using UDCP medium transmission:');
    disp(['mse bw ref image and restored image is:    ',num2str(mse)]);
  end  
  figure('name',resfilename),imshow(cat(2, im2uint8(imrestored), imref ));
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, im2uint8(imrestored), imref ) , resfilename);
  
  
  finalmedtransMat=pyramid_reconstruct(finalmedtransPyr2);
  % finalmedtransMat=im_unity(finalmedtransMat);
  finalmedtransMat=log(max(finalmedtransMat,0.01*ones(size(finalmedtransMat))))/log(0.8);
  finalmedtransMat=0.85.^finalmedtransMat;
  im2=( im(:,:,1)-globalBackgLight(1)*(1-finalmedtransMat) )./max(0.3*ones(size(finalmedtransMat)) , globalBackgLight(1)*finalmedtransMat);
  im2=im_unity(im2);
  imrestored=im;% restored image 3 channel
  imrestored(:,:,1)=im2;% assign new restored red channel
  resfilename=sprintf('method %.2f restored vs original - IATP',method);
  mse = immse (im2uint8(im2(:,:,1)) , imref (:,:,1) );
  minmse = min(mse,minmse);% min mse between 2 min
    if doDegradation == 1
      disp('');
      disp('using IATP medium transmission:');
      disp(['mse bw ref image and restored image is:    ',num2str(mse)]);
    end
  figure('name',resfilename),imshow(cat(2, im2uint8(imrestored), imref ));
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, im2uint8(imrestored), imref ) , resfilename);
  
  % %%%%%% combining 2 final medium transmission pyramids into one
  for i=1:num_levels
    finalmedtransPyr{i}=finalmedtransPyr{i}+finalmedtransPyr1{i};
    %%%%% normalizing pyramid to 0-1
    if size(finalmedtransPyr{i},3)==1 %%% for 2D image
      finalmedtransPyr{i}=(finalmedtransPyr{i}-min(finalmedtransPyr{i}(:)))/(max(finalmedtransPyr{i}(:)) - min(finalmedtransPyr{i}(:)) );
    end
  end
  finalmedtransMat=pyramid_reconstruct(finalmedtransPyr);
  % finalmedtransMat=im_unity(finalmedtransMat);
  finalmedtransMat=log(max(finalmedtransMat,0.01*ones(size(finalmedtransMat))))/log(0.8);
  finalmedtransMat=0.85.^finalmedtransMat;
  im2=( im(:,:,1)-globalBackgLight(1)*(1-finalmedtransMat) )./max(0.3*ones(size(finalmedtransMat)) , globalBackgLight(1)*finalmedtransMat);
  im2=im_unity(im2);
  imrestored=im;% restored image 3 channel
  imrestored(:,:,1)=im2;% assign new restored red channel
  resfilename=sprintf('method %.2f restored vs original - UDCP+IATP',method);
  mse = immse (im2uint8(im2(:,:,1)) , imref (:,:,1) );
  if doDegradation == 1
    disp('');
    disp('using IATP + UDCP medium transmission:')
    disp(['mse bw ref image and restored image is:    ',num2str(mse)]);
  end
  figure('name',resfilename),imshow(cat(2, im2uint8(imrestored), imref ));
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, im2uint8(imrestored), imref ) , resfilename);

  minmse = min(mse,minmse);% min mse between 2 min
  if nargout == 1
    varargout{1} = uint8(255*imrestored);
  end
end
