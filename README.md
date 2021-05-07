# A-Collection-Of-Underwater-Image-Restoration-And-Enhancement-With-Mean-Squared-Error-Measuring
	Introduction

Underwater images typically exhibit color distortion and low contrast as a result of the exponential decay that light suffers as it travels. Moreover, colors associated to different wavelengths have different attenuation rates, being the red wavelength the one that attenuates the fastest.

To restore underwater images, red channel prior is used which is a concept captured from dark channel prior. The Red Channel method can be interpreted as a variant of the Dark Channel method used for images degraded by the atmosphere when exposed to haze.

The aim of underwater image restoration and enhancement is to improve the visual quality of images captured under different underwater scenes. In recent years, this research area has attracted increased attention since improving the visibility, contrast, and colors of underwater images is of significance for many computer applications. Nevertheless, enhancing and restoring underwater image from a single image is still challenging due to the complicated underwater environment. 

The received light by a camera suffers from color deviation due to the wavelength dependent light absorption. In general, the red light first disappears with the distance from objects, followed by the orange light, yellow light, purple light, yellow-green light, green light and blue light. This is the main reason why most underwater images are dominated by the bluish or greenish tone. Therefore, to improve the visual quality of underwater image, a method which can remove the effects of back scattering light and wavelength dependent light absorption is needed.

The possibility of improving underwater images by just using image processing techniques is very appealing due to the low cost of implementation when compared with more sophisticated techniques. These methodologies enjoy a wide range of applications, from marine biology and archaeology to ecological research. The improvement of unmanned vehicles (ROV) navigation capabilities is also a very important field of application.

	Methodologies 

Inspired by the observation that the existing number of open source methodologies on underwater image restoration and enhancement are limited, here we have obtained a combination of a couple of available methods with other proposed methods to weigh each combination whether alone or combined. As others, we were curious to find out the effect of small variants of each main method. 

Therefore, the materials provided here are a survey on underwater restoration and enhancement methods and their variants for researchers and students in order to avoid starting from scratch.

The provided source code is compiled with octave without problem. In case you have MATLAB software, you may possibly need to change some functions with their MATLAB counterparts ( the source code is is mostly compatible with MATLAB).

	Description of functions:

•	Underwater.m

If you are using MATLAB you need to comment the 'pkg load image' command (other lines are ok – this is an Octave Command). Then, an underwater image is loaded. You can use any underwater image you have. 

The process starts with degrading the red channel of the reference image. At this point, medium transmission using UDCP is computed for input underwater image. Then, the red channel of the input image J(x) is multiplied by the medium transmission t(x).

I(x) = J(x) t(x)

The result of the above equation would be an underwater image I(x) that has more haze and greenish/bluish tone. The purpose of doing this is to have a reference red channel and a degraded one in order to calculate mean square error after restoring the degraded red channel. In our case, we have provided a few high quality underwater images where the red channel was perfect (it has wide range of intensities). This way leads to have a reference and a degraded red channel image.

If you don’t want to degrade your underwater image, just uncomment the line with this command (im(:,:,1) = imref(:,:,1)) to undo what's done so far. If you bypass the degradation, your input image is restored in the next steps as it is. The reason behind this is to be able to calculate mean squared error between the main red channel and the degraded red channel. This way avoids requiring visual inspection of the restored image. Before any restoration, 'underwater.m' calculates the mean squared error between the initial and the degraded red channel as well as printing the MSE at command line. Then, when the restoration process completed, we can compute the MSE to compare the efficiency of the restoration method.

•	mediumtransmissionMat (im, gs, method)

This function calculates the medium transmission matrix with available methods provided in scientific papers. 

The first input argument is the input underwater image in unity (0-1) range and double data type. The second argument is the grid size for local patch. The patch will be a square with gs as its length/width. The 3rd argument for medium transmission calculation (e.g. 1 is UDCP and 2 is IATP).

Values for 3rd argument:

1	=	UDCP [2]

2	=	IATP [3]


•	saliency_detection(img,method)


Saliency detection is an effective way to determine objects and separate them from the background. Machine vision systems extract general purpose saliency as facing unpredictable and innumerable categories of visual patterns. The main idea behind the use of saliency extraction is that it is been experientially found that the salient regions of the medium transmission estimated by IATP or UDCP are relatively accurate.

Saliency detectors have long been used in machine vision systems. There are numerous proposed saliency detectors in scientific journals. Therefore, we are trying to evaluate some of them in function altogether. The saliency detection function provided in our source code, contains a few popular saliency detectors that you can choose them by specifying a number (e.g. 1,2,…) to the 2nd argument.

Option	      Reference	

1		      [4]

2		      [5]



•	myevaluations(im,imref,method)

This function holds all the methods and their variants. The first input is the degraded red channel in case you want to measure the mean squared error instead of visual inspection. Since the red channel of the first input is artificially degraded, we can measure the difference between the restored and the reference images. In this case, the reference image must be perfect. Otherwise you can copy the reference/initial image in the first argument to bypass error measurement.

Method 1.0:

The work that is done in this Method 1.0 and its variants is described in [1]. This variant computations process can be charted as below: 

•	Normalized UDCP Medium Transmission Matrix

•	Normalized Saliency Map for UDCP Matrix

•	4-Level Gaussian Pyramid for Normalized Saliency Map

•	4-Level Laplacian Pyramid for Normalized UDCP Matrix

•	Normalized IATP Medium Transmission Matrix

•	Normalized Saliency Map for IATP Matrix

•	4-Level Gaussian Pyramid for Normalized Saliency Map

•	4-Level Laplacian Pyramid for Normalized IATP Matrix

•	Multiplying UDCP Saliency Pyramid by UDCP Laplacian Pyramid to Build UDCP Pyramid

•	Reconstructing UDCP Pyramid to Build Refined UDCP Matrix + Normalization

•	Scene Depth by Log (Refined UDCP Matrix)/Log (0.8) Eq.16 [1]

•	Final UDCP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final UDCP Matrix Eq.18 [1]

•	Multiplying IATP Saliency Pyramid by IATP Laplacian Pyramid to Build IATP Pyramid

•	Reconstructing IATP Pyramid to Build Refined IATP Matrix + Normalization

•	Scene Depth by Log (Refined IATP Matrix)/Log (0.8) Eq.16 [1]

•	Final IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final IATP Matrix Eq.18 [1]

•	Joint UDCP + IATP Pyramids as Summation of Corresponding Pyramids

•	Reconstructing Joint UDCP + IATP Pyramid to Build Joint UDCP + IATP Matrix + Normalization

•	Scene Depth by Log (Joint UDCP + IATP Matrix)/Log (0.8) Eq.16 [1]

•	Final Joint UDCP + IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final Joint UDCP + IATP Matrix Eq.18 [1]


Method 1.01:

Since Laplacian pyramid contains negative values, each pyramid will have negative values too. In this case, the pyramids are normalized to unity 0-1 before reconstructing medium transmission matrix from.

Method 1.02:

This method normalizes the pyramids before reconstruction. It also doesn't normalize the medium transmission matrix after it is generated by pyramid reconstruction step.



[1] 	Underwater Image Restoration Based On a New Underwater Image Formation Model

[2]   P. L. J. Drews, Jr., E. R. Nascimento, S. S. C. Botelho, and M. F. M. Campos, ‘‘Underwater depth estimation and image restoration based on single images,’’ IEEE Comput. Graph. Appl., vol. 36, no. 2, pp. 24–35, Mar./Apr. 2016.

[3]   N. Carlevaris-Bianco, A. Mohan, and R. M. Eustice, ‘‘Initial results in underwater single image dehazing,’’ in Proc. IEEE Conf. OCEANS, Sep. 2010, pp. 1–8.

[4]	http://ivrg.epfl.ch/supplementary_material/RK_CVPR09/index.html

[5]	https://www.epfl.ch/labs/ivrl/research/saliency/salient-region-detection-and-segmentation/



Code: 
Run the following code to run the whole evaluations. While each of methods are executing, the mean square error is displayed in command line of MATLAB/Octave. 

      clc
      clear all
      close all
      pkg load image
      frame = 5;
      fileNameDataSet=sprintf('address to you underwater image dataset/water (%d).png',frame);
      imref = imread(fileNameDataSet);
      im = imref;
      im2 = im;
      #### convert im to normalize 0-1 range
      im = im2double( im );
      ###### destructing ref image
      ##square grid size or square patch size - e.g. 3x3
      gsdestruction = 3;
      tic
      medtransMat  =  mediumtransmissionMat ( im , gsdestruction ) ;
      im( : , : , 1) = im( : , : , 1)  .* medtransMat ;
      mse = immse ( im2uint8( im(:,:,1) ) , imref (:,:,1) );
      disp(['mse bw ref image and degraded image is:    ',num2str(mse)]);
      toc
      %%%%%%%%% 
      %% here is the restoring part where we are going to reproduce imref (reference image) from im (destructed image). 
      im2( : , : , 1) = im2uint8( myevaluations(im,imref) );
      imshow(im2);


here is the medium transmission (mediumtransmissionMat.m) definition:

      function [medtransMat, varargout] =  mediumtransmissionMat (im, gs, method)
      %%%%%%%% gs must be an odd num

      if method == 1 %%%% UDCP method
        half=floor(gs*gs/2);
        immin =ones(size(im));
        for k=2:3
          for i=-half:half
            for j=-half:half
              immin(:,:,k)=min(immin(:,:,k) , circshift(im(:,:,k),[i,j]));
            endfor
          endfor
        endfor

        medtransMat=1-min(immin,[],3);

        if nargout == 2
          imheight = size ( im , 1 ) ;
          imwidth = size ( im , 2 ) ;
          %%%% find brightest pixel in the dark channel- red
          maxvalred=max(max(im(:,:,1))) ;
          indxmaxvalred = find ( im ( : , : , 1 )  == maxvalred ) ;
          %%%% green global background light- scalar
          greenglobalBackLight = im ( indxmaxvalred(1) + imheight * imwidth ) ;
          %%%% blue global background light- scalar
          blueglobalBackLight = im ( indxmaxvalred ( 1 ) + 2*imheight*imwidth ) ;

          globalBackgLight = double ( [maxvalred, greenglobalBackLight, blueglobalBackLight] );

          varargout{1}=globalBackgLight;
        endif

      elseif method == 2  %%% Carlevaris-Bianco et al  
        % % % N. Carlevaris-Bianco, A. Mohan, and R. M. Eustice, ‘‘Initial results
        % % % in underwater single image dehazing,’’ in Proc. IEEE Conf. OCEANS
        half=floor(gs*gs/2);
        immax =zeros(size(im));%% zero filling for max comparisons
        for k=1:3
          for i=-half:half
            for j=-half:half
              immax(:,:,k)=max(immax(:,:,k) , circshift(im(:,:,k),[i,j]));
            endfor
          endfor
        endfor
        immax(:,:,2)=max(immax(:,:,2), immax(:,:,3));%%% max bw green and ble channels
        immax(:,:,1)=immax(:,:,1)-immax(:,:,2);%%% eq.8 paper(underwater image restoration based on a new underwater image formation)
        %%%% save a copy of immax(:,:,1) in immax(:,:,3) for eq.9 computation
        immax(:,:,3)=immax(:,:,1);
        % % % % finding local max in immax(:,:,1)
        for i=-half:half
          for j=-half:half
            immax(:,:,3)=max(immax(:,:,3) , circshift(immax(:,:,1),[i,j]));
          endfor
        endfor
        medtransMat=1+immax(:,:,1)-immax(:,:,3);


      endif

      end  % end of function


here is myevaluations.m codes:


    function  [im2] = myevaluations(im,imref)
    % im is normalized 0-1
    % imref is uint8
    method = 0;
    gsdestruction = 3;

    method = 1.0;
      gs = 3;
      %%% % % calculate medium transmission for degraded picture
      [medtransMat, globalBackgLight] =  mediumtransmissionMat (im, gs, 1);% 1=UDCP
      medtransMat3=cat(3,medtransMat,medtransMat,medtransMat);% make a 3 channel
      saliencymap = saliency_detection(medtransMat3,1);

      %%%%%%%% Gaussian and Laplacian Pyramid of the saliencymap
      %%%%%%the below code supports both gray and 3D images
      num_levels = 4; % num of gauss and laplacian pyr levels
      pyr=cell(1,num_levels);
      lappyr=cell(1,num_levels);
      salGaussPyr = cell(1,num_levels);
      finalmedtransPyr = cell(1,num_levels);

      salGaussPyr=buildpyramid(saliencymap,num_levels,1);%gauss pyr of saliency
      lappyr=buildpyramid(medtransMat,num_levels,2);%laplacian pyr of medium transmission

      %%%%% multiplying saliency map gaussian pyramid
      %%%%% with laplacian pyramid of medium transmission
      for i = 1 : (num_levels)
        finalmedtransPyr{i} = salGaussPyr{i} .* lappyr{i};  
        %%%%% normalizing to 0-1
        % if size(finalmedtransPyr{i},3)==1 %%% for 2D image
        %   finalmedtransPyr{i}=(finalmedtransPyr{i}-min(finalmedtransPyr{i}(:)))/(max(finalmedtransPyr{i}(:)) - min(finalmedtransPyr{i}(:)) );
        % endif
      end
      finalmedtransPyr1=finalmedtransPyr;

      %%%%%%                       2nd medium transmission with IATP
      medtransMat =  mediumtransmissionMat (im, gs, 2); %%% 2 = IATP medium transmission
      medtransMat3=cat(3,medtransMat,medtransMat,medtransMat);%%% make it 3 channel

      saliencymap = saliency_detection(im2uint8(medtransMat3), 1);%%%% 1 = method 1

      %%%%%%%% Gaussian and Laplacian Pyramid of the saliencymap
      %%%%%%the below code supports both gray and 3D images
      salGaussPyr=buildpyramid(saliencymap,num_levels,1);%gauss pyr of saliency
      lappyr=buildpyramid(medtransMat,num_levels,2);%laplacian pyr of medium transmission
      %%%%% multiplying saliency map gaussian pyramid with laplacian pyramid of medium transmission
      for i = 1 : (num_levels)
        finalmedtransPyr{i} = salGaussPyr{i} .* lappyr{i};
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
      disp('');
      disp('using UDCP medium transmission:');
      disp(['mse bw ref image and restored image is:    ',num2str(mse)]);

      finalmedtransMat=pyramid_reconstruct(finalmedtransPyr2);
      finalmedtransMat=im_unity(finalmedtransMat);
      finalmedtransMat=log(max(finalmedtransMat,0.01*ones(size(finalmedtransMat))))/log(0.8);
      finalmedtransMat=0.85.^finalmedtransMat;
      im2=( im(:,:,1)-globalBackgLight(1)*(1-finalmedtransMat) )./max(0.3*ones(size(finalmedtransMat)) , globalBackgLight(1)*finalmedtransMat);
      im2=im_unity(im2);
      mse = immse (im2uint8(im2(:,:,1)) , imref (:,:,1) );
      disp('');
      disp('using IATP medium transmission:');
      disp(['mse bw ref image and restored image is:    ',num2str(mse)]);

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
      mse = immse (im2uint8(im2(:,:,1)) , imref (:,:,1) );
      disp('');
      disp('using IATP + UDCP medium transmission:')
      disp(['mse bw ref image and restored image is:    ',num2str(mse)]);

    

definition of im_unity.m

      function imu = im_unity(im)
            im = double(im);
            imu=(im-min(im(:)))/(max(im(:)) - min(im(:)) );
      end%% function

definition of buildpyramid.m

      function varargout=buildpyramid(im, num_levels,option)

      if option == 1
          pyr = cell(1,num_levels);
          pyr{1}=im;
          for i=2:num_levels
              pyr{i}=impyramid(pyr{i-1},'reduce');
          endfor
          varargout{1} = pyr;
      elseif option == 2
          %%%%%% laplacian pyr
          pyr = cell(1,num_levels);
          lappyr=cell(1,num_levels);
          pyr{1}=im;
          for i=2:num_levels
              pyr{i}=impyramid(pyr{i-1},'reduce');
          endfor

          lappyr{num_levels} =  pyr{num_levels};
          for i = 1 : (num_levels-1)
              A = pyr{i};
              B = imresize( pyr{i+1},2 );
              [M,N,~] = size(A);
              lappyr{i} = A - B(1:M,1:N,:);
          endfor
          lappyr{end} = pyr{end};
          varargout{1}=lappyr;
      endif


      end% function
      
definition of pyramid_reconstruct.m

      function out = pyramid_reconstruct(pyramid)
          % % % https://github.com/IsaacChanghau/OptimizedImageEnhance/tree/master/matlab/FusionEnhance
          % % % https://github.com/IsaacChanghau/OptimizedImageEnhance/blob/master/matlab/FusionEnhance/FusionEnhance.zip

      level = length(pyramid);
      for i = level : -1 : 2
          %temp_pyramid = pyramid{i};
          [m, n] = size(pyramid{i - 1});
          %out = pyramid{i - 1} + imresize(temp_pyramid, [m, n]);
          pyramid{i - 1} = pyramid{i - 1} + imresize(pyramid{i}, [m, n]);
      end
      out = pyramid{1};
      end% function
      
definition of saliency_detection.m

      function sm = saliency_detection(img,method)
      %%% img must be uint8
      %%% sm is double 0-1
          if method == 1
      %---------------------------------------------------------
      % Copyright (c) 2009 Radhakrishna Achanta [EPFL]
      % Contact: firstname.lastname@epfl.ch
      %---------------------------------------------------------
      % Citation:
      % @InProceedings{LCAV-CONF-2009-012,
      %    author      = {Achanta, Radhakrishna and Hemami, Sheila and Estrada,
      %                  Francisco and S?strunk, Sabine},
      %    booktitle   = {{IEEE} {I}nternational {C}onference on {C}omputer
      %                  {V}ision and {P}attern {R}ecognition},
      %    year        = 2009
      % }
      %---------------------------------------------------------
      % Please note that the saliency maps generated using this
      % code may be slightly different from those of the paper.
      % This seems to be because the RGB to Lab conversion is
      % different from the one used for the results in the C++ code.
      % The C++ code is available on the same page as this matlab
      % code (http://ivrg.epfl.ch/supplementary_material/RK_CVPR09/index.html)
      % One should preferably use the C++ as reference and use
      % this matlab implementation mostly as proof of concept
      % demo code.
      %---------------------------------------------------------

      %
      %---------------------------------------------------------
      % Read image and blur it with a 3x3 or 5x5 Gaussian filter
      %---------------------------------------------------------
      %img = imread('input_image.jpg');%Provide input image path
      gfrgb = imfilter(img, fspecial('gaussian', 3, 3), 'symmetric', 'conv');
      %---------------------------------------------------------
      % Perform sRGB to CIE Lab color space conversion (using D65)
      %---------------------------------------------------------
      %cform = makecform('srgb2lab', 'whitepoint', whitepoint('d65'));
      % cform = makecform('srgb2lab');
      % lab = applycform(gfrgb,cform);
      lab = rgb2lab( gfrgb );
      %---------------------------------------------------------
      % Compute Lab average values (note that in the paper this
      % average is found from the unblurred original image, but
      % the results are quite similar)
      %---------------------------------------------------------
      l = double(lab(:,:,1)); lm = mean(mean(l));
      a = double(lab(:,:,2)); am = mean(mean(a));
      b = double(lab(:,:,3)); bm = mean(mean(b));
      %---------------------------------------------------------
      % Finally compute the saliency map and display it.
      %---------------------------------------------------------
      sm = (l-lm).^2 + (a-am).^2 + (b-bm).^2;
      sm = im_unity(sm);
      %imshow(sm,[]);
      %---------------------------------------------------------
      elseif method == 2
          %%%%%%%%%calculate the saliency map for medium transmission
          width = size(im,2);
          height = size(im,1);
          md = min(width, height);%minimum dimension
          %---------------------------------------------------------
          % Perform sRGB to CIE Lab color space conversion (using D65)
          %---------------------------------------------------------
          imglab = rgb2lab(img);
          l = double(imglab(:,:,1));
          a = double(imglab(:,:,2));
          b = double(imglab(:,:,3));
          %---------------------------------------------------------
          %Saliency map computation
          %---------------------------------------------------------
          saliencymap = zeros(height, width);
          off1 = int32(md/2); off2 = int32(md/4); off3 = int32(md/8);
          for j = 1:height
              y11 = max(1,j-off1); y12 = min(j+off1,height);
              y21 = max(1,j-off2); y22 = min(j+off2,height);
              y31 = max(1,j-off3); y32 = min(j+off3,height);
              for k = 1:width
                  x11 = max(1,k-off1); x12 = min(k+off1,width);
                  x21 = max(1,k-off2); x22 = min(k+off2,width);
                  x31 = max(1,k-off3); x32 = min(k+off3,width);
                  % disp([j,k,y11,y12,y21,y22,y31,y32,x11,x12,x21,x22,x31,x32])
                  lm1 = mean2(l(y11:y12,x11:x12));am1 = mean2(a(y11:y12,x11:x12));bm1 = mean2(b(y11:y12,x11:x12));
                  lm2 = mean2(l(y21:y22,x21:x22));am2 = mean2(a(y21:y22,x21:x22));bm2 = mean2(b(y21:y22,x21:x22));
                  lm3 = mean2(l(y31:y32,x31:x32));am3 = mean2(a(y31:y32,x31:x32));bm3 = mean2(b(y31:y32,x31:x32));
                  %---------------------------------------------------------
                  % Compute conspicuity values and add to get saliency value.
                  %---------------------------------------------------------
                  cv1 = (l(j,k)-lm1).^2 + (a(j,k)-am1).^2 + (b(j,k)-bm1).^2;
                  cv2 = (l(j,k)-lm2).^2 + (a(j,k)-am2).^2 + (b(j,k)-bm2).^2;
                  cv3 = (l(j,k)-lm3).^2 + (a(j,k)-am3).^2 + (b(j,k)-bm3).^2;
                  saliencymap(j,k) = cv1 + cv2 + cv3;
              end
          end

          saliencymap = im_unity(saliencymap);% unity normalize 0-1

      endif %%% end of if method

      end %%%% end of function
      
      
