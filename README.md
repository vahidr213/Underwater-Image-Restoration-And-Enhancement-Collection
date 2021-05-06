# A-Collection-Of-Underwater-Image-Restoration-And-Enhancement-With-Mean-Squared-Error-Measuring

Underwater images typically exhibit color distortion and low contrast as a result of the exponential decay that light suffers as it travels. Moreover, colors associated to different wavelengths have different attenuation rates, being the red wavelength the one that attenuates the fastest.

To restore underwater images, red channel prior is used which is a concept captured from dark channel prior. The Red Channel method can be interpreted as a variant of the Dark Channel method used for images degraded by the atmosphere when exposed to haze.

The possibility of improving underwater images by just using image processing techniques is very appealing due to the low cost of implementation when compared with more sophisticated techniques. These methodologies enjoy a wide range of applications, from marine biology and archaeology to ecological research. The improvement of unmanned vehicles (ROV) navigation capabilities is also a very important field of application.

The provided Source Code is compiled with octave without problem. In case you have MATLAB software, you may possibly need to change some functions with their MATLAB counterparts ( the source code is is mostly compatible with MATLAB).

If you are using MATLAB you need to comment the 'pkg load image' command (other lines are ok).

The source code starts with reading and underwater image. You can use any underwater image you have.
The process starts with degrading the red channel of the reference image. In or case, we have provided a few high quality underwater images where the red channel was perfect (it has wide range of intensities). This way leads to have a reference and a degraded red channel image.

Then, the reference and degraded images are given to function 'myevaluations()' where this function tries to estimate the initial reference red channel again. Now we can measure the mean squared error between the red channel of the reference image and the restored red channel.

If you want to only restore your image, not the degraded version of your Image, just uncomment the line with this command (im(:,:,1) = imref(:,:,1)).

To make numeral structure for several restoration methods that may differ slightly with each other, each method has a decimal or integer part followed by a floating point where the floating point is assigned for variants of each method.

Description of functions:

•	mediumtransmissionMat (im, gs, method)

This function calculates the medium transmission matrix with available methods provided in scientific papers. 

The first input argument is the input underwater image in unity (0-1) range and double data type. The second argument is the grid size for local patch. The patch will be a square with gs as its length/width. The 3rd argument for medium transmission calculation (e.g. 1 is UDCP and 2 is IATP).

•	saliency_detection(img,method)

Saliency detection is an effective way to determine objects and separate them from the background. Machine vision systems extract general purpose saliency as facing unpredictable and innumerable categories of visual patterns. The saliency detection function contains a few popular saliency detectors that you can choose them by specifying a number (e.g. 1,2,…) to the 2nd argument. 


Through the code, "imref" is the initial or almost nearly perfect Image. This variable is the image that is almost Haze and Blur free image which we are going to destruct using medium transmission by the following equation (1).
I(x) = J(x) t(x)   		(1)
Where J(x) is the reference image ('imref' var), t(x) is the medium transmission (medtransMat) and I(x) is the red channel degraded image ('im' var).
We have implemented medium transmission based on paper "Underwater Image Restoration Based on A New Underwater Image Formation Model" (equation 10).
Notice that only red Channel of J(x) is affected by medium transmission.

Method  1.0:

This method is the octave script for paper underwater image restoration based on a new underwater image formation model. The given source code for saliency detection contains a variety of saliency detectors that capables you to choose among different saliency detectors. Saliency detectors can be selected by changing the second input to image saliency function (im_saliency()).

This method starts with medium transmission computation of the degraded image. Medium transmission matrix contains values in unity range, showing high values at foreground or non-water regions and low values at background or water regions. Medium transmission computation is computationally low.


Method 1.0
The work that is done in this Method 1.0 and its variants is described in [1]. This variant can be charted as below:
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


[1] 	Underwater Image Restoration Based On a New Underwater Image Formation Model




Method 2:

This method is the reverse order of the method one. The degraded image is first smoothed by bilateral filtering and then compensated by medium transmission equation.



Method 4:

At first, the input image is smoothed by bilateral filtering. Then, the rest is Method 3.

Method 5:

At first, Method 3 is performed then the restored image is smoothed by bilateral filtering.

Method 6:

This method only checks wiener deconvolution effect on the degraded red channel. A brief explanation of wiener deconvolution is described below. 
wiener deconvolution tries to find an estimation for x(t) through Fourier transform. We have used this method to apply minor deburring of underwater images. 
The wiener deconvolution method requires two initial known parameters that play the most important roles in estimating the deblurred and denoised images. Our intuitive investigations showed that underwater images can be deblurred by choosing the length of blurring as low as 3 to 5. The noise to signal ratio must be lower than 0.1 as well. In our experiments, we chose 3 for blurring length and 0.07 for noise to signal ratio.
Increasing blurring length or noise to signal ratio above a threshold will cause the image to be more blurred or become darker. Blurring length is a parameter required for building point spread function matrix.

Method 7:

This method is Method 6 plus a bilateral filtering.

Method 8:

This method starts with a bilateral filtering and then applies the wiener deconvolution.

Method 9:

This method is the parametric version of the Method 6. In this case, there are two parameters to be tweaked. The first one is the estimated noise to signal ratio that presents the amount of noise that is supposed to be in the image. The second parameter is the length of blurring to be considered.


Method 10:

This method is as same as Method 9 (parametric wiener deconvolution) plus a bilateral filtering in each loop iteration.

Method 11:

This is a parametric evaluation that starts with bilateral filtering and then finishes with wiener deconvolution.

Method 12:

This method is based on blending median filtered green and median filtered blue channels with coefficients ‘a’ and ‘b’. The result of blending green and blue channels are added to the red channel to restore the degraded red channel based on the equation below:


Ired=Ired + a * Igreen_median + b * Iblue_median


This method evaluates different ‘a’ and ‘b’ coefficients in the unity range with an increment step set to 5e-5. Therefore, you can find out the best coefficients that minimizes the mean squared error.

Method 13:

This method is the same as Method 12, but a bilateral filtering is applied before median filtering.

Method 14:

This method is the same as Method 12 plus a bilateral filtering after each median filtering.

Method 15:

This method chooses all different permutations of 3 functions. These functions are median filtering, bilateral filtering and wiener deconvolution. All 3 above mentioned functions are evaluated under different ranges of their input parameters. In brief, this method is a parametric evaluation of all permutations of the 3 functions that are part of image enhancement tools.

Method 16:

This method is a parametric evaluation of all possible permutations of 3 methods shown below:

•	Perona & Malik, Anisotropic Diffusion image smoothing

•	2-D Median filtering

•	Bilateral filtering

This method evaluates the sequence of the above mentioned functions to produce a better image. You can deliberately change the values of parameters in each method just by changing loop ranges. The mean square error shows the quality of each of sequences functions in estimating the reference image.
The outputs are the current used parameters (mse , … ) and the best minimum mean square error along with its parameter values are shown in two consequential lines.


Method 17:

This method is a parametric evaluation of all possible permutations of 3 methods shown below:

•	Perona & Malik, Anisotropic Diffusion image smoothing

•	2-D Median filtering

•	Wiener deconvolution

This method evaluates the sequence of the above mentioned functions to produce a better image. You can deliberately change the values of parameters in each method just by changing loop ranges. The mean square error shows the quality of each of sequences functions in estimating the reference image.
The outputs are the current used parameters (mse , … ) and the best minimum mean square error along with its parameter values are shown in two consequential lines.


Method 18:

This method is a parametric evaluation of all possible permutations of 3 methods shown below:

•	Anisotropic Gaussian smoothing

•	Wiener deconvolution

•	2-D median filtering

This method also checks the permutation of 2 functions as well as 3 functions. Therefore, the first 6 permutations are for combination of 3 functions and the other 4 permutations are for 2-function combinations. The variables could also be changed deliberately by your desired ranges.



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

    %%%%%%%%%%%
    %%%%%   2
    im2 = im(:,:,1);
    method = method + 1;
      ####Bilateral filtering to enhance edge
    im2 = im2double( imsmooth ( im2uint8( im2 ) , 'bilateral' ) );
    im2 = ( im2  .* medtransMat + ( globalBackgLight(1) ) * ( 1 - medtransMat) );
    mse = immse ( im2uint8(im2) , imref (:,:,1) );
    disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);

    %%%%%%%%%%
    %%%%%  3
    im2 = im(: , : , 1);
    method = method + 1;
    minmedtransMat = 0.1 * ones( size(medtransMat) );
    maxmedtransMat = max(minmedtransMat, medtransMat);
    im2 = ( im2 - globalBackgLight(1) ) ./ maxmedtransMat;
    im2 = im2 + globalBackgLight(1) * ( 1 - globalBackgLight(1) );
    
    
    %%%%%%
    %%%%method 4
    im2 = im(: , : , 1);
    method = method + 1;
    ####Bilateral filtering to enhance edge
    im2 = im2double( imsmooth ( im2uint8( im2 ) , 'bilateral' ) );
    minmedtransMat = 0.1 * ones( size(medtransMat) );
    maxmedtransMat = max(minmedtransMat, medtransMat);
    im2 = ( im2 - globalBackgLight(1) ) ./ maxmedtransMat;
    im2 = im2 + globalBackgLight(1) * ( 1 - globalBackgLight(1) );
    if min( im2(:) ) < 0
      im2 = im2 + abs(min(im2(:)));
      im2 = im2 / max( im2(:) );
    endif
    if min( im2(:) ) > 0
      error(['method ', num2str(method), ' min( im2(:) ) is > 0']);
    endif
    mse = immse ( im2uint8(im2) , imref (:,:,1) );
    disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);


    %%%%%%
    %%%%method 5
    im2 = im(: , : , 1);
    method = method + 1;
    minmedtransMat = 0.1 * ones( size(medtransMat) );
    maxmedtransMat = max(minmedtransMat, medtransMat);
    im2 = ( im2 - globalBackgLight(1) ) ./ maxmedtransMat;
    im2 = im2 + globalBackgLight(1) * ( 1 - globalBackgLight(1) );
    if min( im2(:) ) < 0
      im2 = im2 + abs(min(im2(:)));
      im2 = im2 / max( im2(:) );
    endif
    if min( im2(:) ) > 0
      error(['method ', num2str(method), ' min( im2(:) ) is > 0']);
    endif
    ####Bilateral filtering to enhance edge
    im2u = imsmooth ( im2uint8( im2 ) , 'bilateral' );
    mse = immse ( im2u , imref (:,:,1) );
    disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);
    
    %%%%%%
    %%%% method 6
    im2 = im(: , : , 1);
    method = method + 1;
    psf = fspecial ("motion", 3, 0);
    estimated_nsr = 0.07;
    im2 = deconvwnr (im2, psf, estimated_nsr);
    mse = immse ( im2uint8(im2) , imref (:,:,1) );
    disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);


    %%%%%%
    %%%% method 7
    im2 = im(: , : , 1);
    method = method + 1;
    psf = fspecial ("motion", 3, 0);
    estimated_nsr = 0.07;
    im2 = deconvwnr (im2, psf, estimated_nsr);
    %%%% bilateral filtering
    im2u = imsmooth ( im2uint8( im2 ) , 'bilateral' );
    mse = immse ( im2u , imref (:,:,1) );
    disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);


    %%%%%%
    %%%% method 8
    im2 = im(: , : , 1);
    method = method + 1;
    im2 = im2double( imsmooth ( im2uint8( im2 ) , 'bilateral' ) );
    psf = fspecial ("motion", 3, 0);
    estimated_nsr = 0.07;
    im2 = deconvwnr (im2, psf, estimated_nsr);
    %%%% bilateral filtering
    mse = immse ( im2uint8(im2)  , imref (:,:,1) );
    disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);

    %%%%%%
    %%%% method 9
    method = method + 1;
    for estimated_nsr = 0.01:0.01:0.1
      for motion = 2:10
        im2 = im(: , : , 1);
        psf = fspecial ("motion", motion, 0);
        im2 = deconvwnr (im2, psf, estimated_nsr);
        mse = immse ( im2uint8(im2) , imref (:,:,1) );
        disp ( ' (NSR,Motion)=' );
        disp ( [ estimated_nsr , motion ] ) ;
        disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);
      endfor
    endfor

    %%%%%%
    %%%% method 10
    method = method + 1;
    for estimated_nsr = 0.01:0.01:0.1
      for motion = 2:10
        im2 = im(: , : , 1);
        psf = fspecial ("motion", motion, 0);
        im2 = deconvwnr (im2, psf, estimated_nsr);
        %%%% bilateral filtering
        im2 = imsmooth ( im2 , 'bilateral' );
        mse = immse ( im2uint8( im2 ), imref (:,:,1) );
        disp ( ' (NSR,Motion)=' );
        disp ( [ estimated_nsr , motion ] ) ;
        disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);
      endfor
    endfor


    %%%%%%
    %%%% method 11
    method = method + 1;
    for estimated_nsr = 0.01:0.01:0.1
      for motion = 2:10
        im2 = im(: , : , 1);
        %%%% bilateral filtering
        im2 = imsmooth ( im2 , 'bilateral' );
        psf = fspecial ("motion", motion, 0);
        im2 = deconvwnr (im2, psf, estimated_nsr);    
        mse = immse ( im2uint8( im2 ), imref (:,:,1) );
        disp ( ' (NSR,Motion)=' );
        disp ( [ estimated_nsr , motion ] ) ;
        disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);
      endfor
    endfor
    

        %%%%%
    %%% method 12
    method = method + 1;
    minmse=1e6;
    abest=0.0;
    bbest=0.0;
    for a = 5e-5:5e-5:1
      for b = 5e-5:5e-5:1
      im2=im(:,:,1)+a*medfilt2(im(:,:,2),[3,3])+b*...
      medfilt2(im(:,:,3),[3,3]);
      im2=im2/max(im2(:));
      mse = immse ( im2uint8(im2) , imref (:,:,1) );
      if mse < minmse
        minmse = mse;
        abest = a;
        bbest = b;
      endif

      disp('a, b, mse, best a, best b, min mse:');
      printf('%.5f   %.5f  %.3f  %.5f  %.5f %.3f\n',a,b,mse,abest,bbest,minmse);
    endfor
    endfor

    %%%%%
    %%% method 13
    method = method + 1;
    for gs = 3:15
      im2 = im(: , : , 1);
      im2 = imsmooth ( im2 , 'bilateral' );
      im2 = medfilt2( im2 , [gs,gs] );
      mse = immse ( im2uint8(im2) , imref (:,:,1) );
      disp ( [' Grid Size = ' , num2str(gs) , ':']);    
      disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);
    endfor

    %%% method 14
    method = method + 1;
    for gs = 3:15
      im2 = im(: , : , 1);  
      im2 = medfilt2( im2 , [gs,gs] );
      im2 = imsmooth ( im2 , 'bilateral' );
      mse = immse ( im2uint8(im2) , imref (:,:,1) );
      disp ( [' Grid Size = ' , num2str(gs) , ':']);    
      disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);
    endfor


    %%% method 15
    method = method + 1;
    for sigmaR = 5/255 : 5/255 : 20/255
      for sigmaD = 1 : 6
        for gs = 2 : 10
          for estimated_nsr = 0.01:0.01:0.1
            for motion = 2:10
    %%%          permutation 1
              im2 = im(: , : , 1);
              psf = fspecial ("motion", motion, 0);
              im2 = deconvwnr (im2, psf, estimated_nsr);
              im2 = medfilt2( im2 , [gs gs] );
              im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              disp ( ' (sigmaR , sigmaD , gs , estimated_nsr , motion ) =' );
              disp ( [ sigmaR , sigmaD , gs , estimated_nsr , motion ] ) ;
              disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);

              %%%          permutation 2
              im2 = im(: , : , 1);
              psf = fspecial ("motion", motion, 0);
              im2 = deconvwnr (im2, psf, estimated_nsr);
              im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
              im2 = medfilt2( im2 , [gs gs] );          
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              disp ( ' (sigmaR , sigmaD , gs , estimated_nsr , motion ) =' );
              disp ( [ sigmaR , sigmaD , gs , estimated_nsr , motion ] ) ;
              disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);

              %%%          permutation 3
              im2 = im(: , : , 1);
              im2 = medfilt2( im2 , [gs gs] );
              psf = fspecial ("motion", motion, 0);
              im2 = deconvwnr (im2, psf, estimated_nsr);
              im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);          
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              disp ( ' (sigmaR , sigmaD , gs , estimated_nsr , motion ) =' );
              disp ( [ sigmaR , sigmaD , gs , estimated_nsr , motion ] ) ;
              disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);

              %%%          permutation 4
              im2 = im(: , : , 1);
              im2 = medfilt2( im2 , [gs gs] );
              im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
              psf = fspecial ("motion", motion, 0);
              im2 = deconvwnr (im2, psf, estimated_nsr);          
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              disp ( ' (sigmaR , sigmaD , gs , estimated_nsr , motion ) =' );
              disp ( [ sigmaR , sigmaD , gs , estimated_nsr , motion ] ) ;
              disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);

              %%%          permutation 5
              im2 = im(: , : , 1);
              im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
              psf = fspecial ("motion", motion, 0);
              im2 = deconvwnr (im2, psf, estimated_nsr);          
              im2 = medfilt2( im2 , [gs gs] );
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              disp ( ' (sigmaR , sigmaD , gs , estimated_nsr , motion ) =' );
              disp ( [ sigmaR , sigmaD , gs , estimated_nsr , motion ] ) ;
              disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);          

              %%%          permutation 
              im2 = im(: , : , 1);
              im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
              im2 = medfilt2( im2 , [gs gs] );
              psf = fspecial ("motion", motion, 0);
              im2 = deconvwnr (im2, psf, estimated_nsr);                    
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              disp ( ' (sigmaR , sigmaD , gs , estimated_nsr , motion ) =' );
              disp ( [ sigmaR , sigmaD , gs , estimated_nsr , motion ] ) ;
              disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);
            endfor
          endfor
        endfor
      endfor
    endfor


    %%% method 16
    method = method + 1;
    minmse = 1e6;
    permmin = [0,0,0,0,0,0,0,0];
    for sigmaR = 5/255 : 5/255 : 20/255
      for sigmaD = 1 : 6
        for gs = 2 : 10
          for peronaIteration = 1:2
            for lambda = 0.1:0.15:0.25
    %%%          permutation 1          
              permutation = 1;
              im2 = im(: , : , 1);          
              im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
              im2 = medfilt2( im2 , [gs gs] );
              im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
              mse = immse ( im2uint8(im2) , imref (:,:,1) );          
              if mse < minmse
                minmse = mse;
                permmin = [permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration, lambda];
              endif
              disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda ) =' );
              disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda]) ;
              disp ( permmin );


              %%%          permutation 2
              permutation = permutation + 1;
              im2 = im(: , : , 1);
              im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
              im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
              im2 = medfilt2( im2 , [gs gs] );          
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              if mse < minmse
                minmse = mse;
                permmin = [permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration, lambda];
              endif
              disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda ) =' );
              disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda]) ;
              disp ( permmin );

              %%%          permutation 3
              permutation = permutation + 1;
              im2 = im(: , : , 1);
              im2 = medfilt2( im2 , [gs gs] );          
              im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
              im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              if mse < minmse
                minmse = mse;
                permmin = [permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration, lambda];
              endif
              disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda ) =' );
              disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda]) ;
              disp ( permmin );

              %%%          permutation 4
              permutation = permutation + 1;
              im2 = im(: , : , 1);
              im2 = medfilt2( im2 , [gs gs] );
              im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);

              im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              if mse < minmse
                minmse = mse;
                permmin = [permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration, lambda];
              endif
              disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda ) =' );
              disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda]) ;
              disp ( permmin );

              %%%          permutation 5
              permutation = permutation + 1;
              im2 = im(: , : , 1);
              im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);          
              im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
              im2 = medfilt2( im2 , [gs gs] );
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              if mse < minmse
                minmse = mse;
                permmin = [permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration, lambda];
              endif
              disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda ) =' );
              disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda]) ;
              disp ( permmin );

              %%%          permutation 6
              permutation = permutation + 1;
              im2 = im(: , : , 1);
              im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
              im2 = medfilt2( im2 , [gs gs] );          
              im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              if mse < minmse
                minmse = mse;
                permmin = [permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration, lambda];
              endif
              disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda ) =' );
              disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda]) ;
              disp ( permmin );

            endfor
          endfor
        endfor
      endfor
    endfor



    %%% method 17
    method = 17;
    minmse = 1e6;
    permmin = [0,0,0,0,0,0,0,0];
    for estimated_nsr = 0.005:0.005:0.015
      for motion = 2:5
        for gs = 2 : 10
          for peronaIteration = 1:2
            for lambda = 0.1:0.15:0.25
    %%%          permutation 1          
              permutation = 1;
              im2 = im(: , : , 1);          
              im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
              im2 = medfilt2( im2 , [gs gs] );
              psf = fspecial ("motion", motion, 0);
              im2 = deconvwnr (im2, psf, estimated_nsr);
              mse = immse ( im2uint8(im2) , imref (:,:,1) );          
              if mse < minmse
                minmse = mse;
                permmin = [permutation, method, mse, estimated_nsr , motion , gs , peronaIteration, lambda];
              endif
              disp ( '(permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda ) =' );
              disp ( [ permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda]) ;
              disp ( permmin );


              %%%          permutation 2
              permutation = permutation + 1;
              im2 = im(: , : , 1);
              im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
              psf = fspecial ("motion", motion, 0);
              im2 = deconvwnr (im2, psf, estimated_nsr);
              im2 = medfilt2( im2 , [gs gs] );          
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              if mse < minmse
                minmse = mse;
                permmin = [permutation, method, mse, estimated_nsr , motion , gs , peronaIteration, lambda];
              endif
              disp ( '(permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda ) =' );
              disp ( [ permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda]) ;
              disp ( permmin );

              %%%          permutation 3
              permutation = permutation + 1;
              im2 = im(: , : , 1);
              im2 = medfilt2( im2 , [gs gs] );          
              im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
              psf = fspecial ("motion", motion, 0);
              im2 = deconvwnr (im2, psf, estimated_nsr);
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              if mse < minmse
                minmse = mse;
                permmin = [permutation, method, mse, estimated_nsr , motion , gs , peronaIteration, lambda];
              endif
              disp ( '(permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda ) =' );
              disp ( [ permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda]) ;
              disp ( permmin );

              %%%          permutation 4
              permutation = permutation + 1;
              im2 = im(: , : , 1);
              im2 = medfilt2( im2 , [gs gs] );
              psf = fspecial ("motion", motion, 0);
              im2 = deconvwnr (im2, psf, estimated_nsr);
              im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              if mse < minmse
                minmse = mse;
                permmin = [permutation, method, mse, estimated_nsr , motion , gs , peronaIteration, lambda];
              endif
              disp ( '(permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda ) =' );
              disp ( [ permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda]) ;
              disp ( permmin );

              %%%          permutation 5
              permutation = permutation + 1;
              im2 = im(: , : , 1);
              psf = fspecial ("motion", motion, 0);
              im2 = deconvwnr (im2, psf, estimated_nsr);
              im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
              im2 = medfilt2( im2 , [gs gs] );
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              if mse < minmse
                minmse = mse;
                permmin = [permutation, method, mse, estimated_nsr , motion , gs , peronaIteration, lambda];
              endif
              disp ( '(permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda ) =' );
              disp ( [ permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda]) ;
              disp ( permmin );

              %%%          permutation 6
              permutation = permutation + 1;
              im2 = im(: , : , 1);
              psf = fspecial ("motion", motion, 0);
              im2 = deconvwnr (im2, psf, estimated_nsr);
              im2 = medfilt2( im2 , [gs gs] );          
              im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              if mse < minmse
                minmse = mse;
                permmin = [permutation, method, mse, estimated_nsr , motion , gs , peronaIteration, lambda];
              endif
              disp ( '(permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda ) =' );
              disp ( [ permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda]) ;
              disp ( permmin );

            endfor
          endfor
        endfor
      endfor
    endfor


    %%%%% method 18
    %%%%%% v1=lambda1=lambda2 for Gaussian
    %%%%%% v2 = estimated_nsr
    %%%%%% v3 = motion
    %%%%%% v4 = grid size
    method = 18;
    minmse = 1e6;
    funorder=perms([1 2 3]);
    funorder2=cat(1,perms([1 2]),perms([1 3]),perms([2,3]));
    funorder3=cat(2,funorder2,[0;0;0;0;0;0]);
    funorder=cat(1,funorder,funorder3);
    for v1=1:3
      for v2=0.005:0.005:0.02
        for v3=1:3
          for v4=3:2:5
            for i=1:size(funorder,1)
              im2=im(:,:,1);
              for j=1:size(funorder,2)
                if funorder(i,j)==1
                  im2=imsmooth(im2,'custom gaussian',v1,v1);
                elseif funorder(i,j)==2
                  psf=fspecial('motion',v3);
                  im2=deconvwnr(im2,psf,v2);
                elseif funorder(i,j)==3
                  im2=medfilt2(im2,[v4,v4]);
                endif
              endfor % j
              mse = immse ( im2uint8(im2) , imref (:,:,1) );
              if mse < minmse
                minmse = mse;
                permmin = [i, method, mse, v1, v2, v3, v4];
              endif
              disp ( '(permutation, method, mse, v1, v2, v3, v4) =' );
              printf ('%.3f  %.3f  %.3f  %.3f  %.3f  %.3f  %.3f\n',i, method, mse, v1,v2,v3,v4) ;
              printf( '%.3f  %.3f  %.3f  %.3f  %.3f  %.3f  %.3f\n',permmin(1),permmin(2),permmin(3),permmin(4),permmin(5),permmin(6),permmin(7) );

            endfor % i
          endfor % v4
        endfor % v3
      endfor % v2
    endfor % v1


    end
    

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
      
      
