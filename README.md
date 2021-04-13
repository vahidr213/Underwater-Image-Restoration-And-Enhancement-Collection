# A-Collection-Of-Underwater-Image-Restoration-And-Enhancement-With-Mean-Squared-Error-Measuring

I need to look for an efficient and precise method. The collection of algorithms I've tested so far are gathered together in file myevaluation.m.
In the following code, "imref" is the initial or almost nearly perfect Image. This variable is the image that is almost Haze and Blur free image which we are going to destruct using medium transmission by the following equation (1).
I(x) = J(x) t(x)   		(1)
Where J(x) is the reference image ('imref' var), t(x) is the medium transmission (medtransMat) and I(x) is the red channel degraded image ('im' var).

Notice that only red Channel of J(x) is affected by medium transmission.

Method  1:

The medium transmission is computed for the degraded image and is used to compensate red Channel of image by the following equation (2).

I2 = I × t(x) + A × ( 1 - t(x) )   	(2)

Then, the compensated image is filtered by bilateral filter. At last, the mean Square error is computed between the red Channel of the reference image and compensated image.

Method 2:

This method is the reverse order of the method one. The degraded image is first smoothed by bilateral filtering and then compensated by medium transmission equation.

Method 3:

In this method, we have implemented some parts of paper automatic red Channel underwater image restoration. We have chosen the restoration equation of the paper shown in equation 3.
![image](https://user-images.githubusercontent.com/6873668/114383410-c1997900-9ba2-11eb-8e62-ba35e3fced07.png)
                      (3)

where superscript alpha denotes Red channel. The equation (3) is only used for the red channel restoration.
Then, the restored image is shifted and normalized toward unity ( 0 - 1 ) using the minimum value of the restored image for shifting and then taking the maximum of the shifted image to normalize toward unity.

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
      [medtransMat , globalBackgLight]  =  mediumtransmissionMat ( im , gsdestruction ) ;
      im( : , : , 1) = im( : , : , 1)  .* medtransMat ;
      mse = immse ( im2uint8( im(:,:,1) ) , imref (:,:,1) );
      disp(['mse bw ref image and degraded image is:    ',num2str(mse)]);
      toc
      %%%%%%%%% 
      %% here is the restoring part where we are going to reproduce imref (reference image) from im (destructed image). 
      im2( : , : , 1) = im2uint8( myevaluations(im,imref) );
      imshow(im2);


here is the medium transmission (mediumtransmissionMat.m) computation code:

      function [medtransMat , globalBackgLight]  =  mediumtransmissionMat ( im , gs ) 
      ###### gs must be an odd num

      ##im = im2double(im);
      imheight = size ( im , 1 ) ;
      imwidth = size ( im , 2 ) ;

      ## find brightest pixel in the dark channel- red
      maxvalred  =  max  ( max ( im (  :  ,  :  ,  1  )   )   ) ;
      indxmaxvalred = find ( im ( : , : , 1 )  == maxvalred ) ;
      ## green global background light- scalar
      greenglobalBackLight = im ( indxmaxvalred ( 1 ) +imheight*imwidth ) ;
      ## blue global background light- scalar
      blueglobalBackLight = im ( indxmaxvalred ( 1 ) +2*imheight*imwidth ) ;

      globalBackgLight = double ( [maxvalred , greenglobalBackLight , blueglobalBackLight] );

      ##  medium transmission size is as im
      mediumtransmission = zeros ( imheight , imwidth ) ;

      ##  gs is grid size

      for r = 1:imheight
          for c = 1:imwidth
      ##      four corners of rect
            rmin = r- ( gs-1 ) /2;
            rmax = r+ ( gs-1 ) /2;
            cmin = c- ( gs-1 ) /2;
            cmax = c+ ( gs-1 ) /2;
      ##      if rmin is out of boundary
            if  ( rmin<1 ) 
              rmin = 1;
              rmax = rmin + gs - 1;
            endif
      ##      if cmin is out of boundary
            if  ( cmin<1 ) 
              cmin = 1;
              cmax = cmin+gs - 1;
            endif
      ##      if rmax is out of boundary
            if  ( rmax>imheight ) 
              rmax = imheight;
              rmin = rmax - gs - 1;
            endif
      ##      if cmax is out of boundary
            if  ( cmax>imwidth ) 
              cmax = imwidth;
              cmin = cmax - gs - 1;
            endif

      ##    get gs by gs patch from image
            patchImage =  im ( rmin:rmax , cmin:cmax , 1:3 );

      ##    find the min of each patch- scalar
            minpatchred = min ( min ( 1.0 - patchImage ( : , : , 1 ) ) );
            minpatchgreen = min ( min ( patchImage ( : , : , 2 )  )  ) ;
            minpatchblue = min ( min ( patchImage ( : , : , 3 )  )  ) ;

      ##    normalize green and blue by local back light
            patchImage ( : , : , 1 ) = patchImage ( : , : , 1 ) / ( 1.0 - maxvalred );
            patchImage ( : , : , 2 )  = patchImage ( : , : , 2 ) /greenglobalBackLight;
            patchImage ( : , : , 3 )  = patchImage ( : , : , 3 ) /blueglobalBackLight;

      ##    min of green and blue patches-scalar
            minpatch = min ( minpatchgreen , minpatchblue ) ;
            minpatch = min ( minpatch , minpatchred );

      ##    medium transmission- scalar
            mediumtransmission ( r , c )  = 1.0 - minpatch;
            if mediumtransmission ( r , c ) > 1.0
              mediumtransmission ( r , c ) = 1.0;
            endif

          endfor # for c

      endfor  # for r
      medtransMat = mediumtransmission;
      end  % end of function


here is myevaluations.m codes:


    function  [im2] = myevaluations(im,imref)
    % im is normalized 0-1
    % imref is uint8
    method = 0;
    gsdestruction = 3;

    im2 = im(:,:,1);
    method = method +1;
    [medtransMat , globalBackgLight]  =  mediumtransmissionMat ( im , gsdestruction ) ;
    im2 = ( im2  .* medtransMat + ( globalBackgLight(1) ) * ( 1 - medtransMat) );
    im2u =  imsmooth ( im2uint8( im2 ) , 'bilateral' ) ;
    mse = immse ( im2u , imref (:,:,1) );
    disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);

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



    end
