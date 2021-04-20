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
