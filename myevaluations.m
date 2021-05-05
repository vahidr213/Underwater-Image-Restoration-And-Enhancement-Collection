function  [im2] = myevaluations(im,imref)
% im is normalized 0-1
% imref is uint8
method = 0;
gsdestruction = 3;

%%%%%%%%%%%
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




%%%%%%%%%%%%%%
%%%%%%%%   method 2
%%im2 = im(:,:,1);
%%method = method + 1;
%%  %%%%Bilateral filtering to enhance edge
%%im2 = im2double( imsmooth ( im2uint8( im2 ) , 'bilateral' ) );
%%im2 = ( im2  .* medtransMat + ( globalBackgLight(1) ) * ( 1 - medtransMat) );
%%mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);
%%


%%%%%%%%%%%%% method 3
method = 3;



%%%%%%%
%%%%%  method 4
%%im2 = im(: , : , 1);
%%method = method + 1;
%%%%%Bilateral filtering to enhance edge
%%im2 = im2double( imsmooth ( im2uint8( im2 ) , 'bilateral' ) );
%%minmedtransMat = 0.1 * ones( size(medtransMat) );
%%maxmedtransMat = max(minmedtransMat, medtransMat);
%%im2 = ( im2 - globalBackgLight(1) ) ./ maxmedtransMat;
%%im2 = im2 + globalBackgLight(1) * ( 1 - globalBackgLight(1) );
%%if min( im2(:) ) < 0
%%  im2 = im2 + abs(min(im2(:)));
%%  im2 = im2 / max( im2(:) );
%%endif
%%if min( im2(:) ) > 0
%%  error(['method ', num2str(method), ' min( im2(:) ) is > 0']);
%%endif
%%mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);
%%
%%
%%%%%%%
%%%%%method 5
%%im2 = im(: , : , 1);
%%method = method + 1;
%%minmedtransMat = 0.1 * ones( size(medtransMat) );
%%maxmedtransMat = max(minmedtransMat, medtransMat);
%%im2 = ( im2 - globalBackgLight(1) ) ./ maxmedtransMat;
%%im2 = im2 + globalBackgLight(1) * ( 1 - globalBackgLight(1) );
%%if min( im2(:) ) < 0
%%  im2 = im2 + abs(min(im2(:)));
%%  im2 = im2 / max( im2(:) );
%%endif
%%if min( im2(:) ) > 0
%%  error(['method ', num2str(method), ' min( im2(:) ) is > 0']);
%%endif
%%%%%Bilateral filtering to enhance edge
%%im2u = imsmooth ( im2uint8( im2 ) , 'bilateral' );
%%mse = immse ( im2u , imref (:,:,1) );
%%disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);
%%
%%%%%%%
%%%%% method 6
%%im2 = im(: , : , 1);
%%method = method + 1;
%%psf = fspecial ("motion", 3, 0);
%%estimated_nsr = 0.07;
%%im2 = deconvwnr (im2, psf, estimated_nsr);
%%mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);
%%
%%%%%%%
%%%%% method 7
%%im2 = im(: , : , 1);
%%method = method + 1;
%%psf = fspecial ("motion", 3, 0);
%%estimated_nsr = 0.07;
%%im2 = deconvwnr (im2, psf, estimated_nsr);
%%%%% bilateral filtering
%%im2u = imsmooth ( im2uint8( im2 ) , 'bilateral' );
%%mse = immse ( im2u , imref (:,:,1) );
%%disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);
%%
%%%%%%%
%%%%% method 8
%%im2 = im(: , : , 1);
%%method = method + 1;
%%im2 = im2double( imsmooth ( im2uint8( im2 ) , 'bilateral' ) );
%%psf = fspecial ("motion", 3, 0);
%%estimated_nsr = 0.07;
%%im2 = deconvwnr (im2, psf, estimated_nsr);
%%%%% bilateral filtering
%%mse = immse ( im2uint8(im2)  , imref (:,:,1) );
%%disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);

%
%
%%%%%
%%%%% method 9
%%method = method + 1;
%%minmse = 1e6;
%%for estimated_nsr = 0.01:0.01:0.1
%%  for motion = 2:10
%%    im2 = im(: , : , 1);
%%    psf = fspecial ("motion", motion, 0);
%%    im2 = deconvwnr (im2, psf, estimated_nsr);
%%    mse = immse ( im2uint8(im2) , imref (:,:,1) );    
%%    if mse < minmse
%%      minmse = mse;
%%      disp(['method   minmse   estimated_nsr   motion']);
%%      disp([method,minmse,estimated_nsr,motion]);
%%    endif
%%    
%%  endfor
%%endfor
%
%
%%%%%%%%%
%%%%%%% method 10
%%method = method + 1;
%%minmse =1e6;
%%for estimated_nsr = 0.01:0.01:0.1
%%  for motion = 2:10
%%    im2 = im(: , : , 1);
%%    psf = fspecial ("motion", motion, 0);
%%    im2 = deconvwnr (im2, psf, estimated_nsr);
%%    %%%% bilateral filtering
%%    im2 = imsmooth ( im2 , 'bilateral' );
%%    mse = immse ( im2uint8( im2 ), imref (:,:,1) );
%%    if mse < minmse
%%      minmse = mse;
%%      disp(['   method   minmse   estimated_nsr   motion']);
%%      disp([method,minmse,estimated_nsr,motion]);
%%    endif
%%    
%%  endfor
%%endfor


%%%%%%%%%
%%%%%%% method 11
%%method = 11;
%%minmse=1e6;
%%for estimated_nsr = 0.01:0.01:0.1
%%  for motion = 2:10
%%    im2 = im(: , : , 1);
%%    %%%% bilateral filtering
%%    im2 = imsmooth ( im2 , 'bilateral' );
%%    psf = fspecial ("motion", motion, 0);
%%    im2 = deconvwnr (im2, psf, estimated_nsr);    
%%    mse = immse ( im2uint8( im2 ), imref (:,:,1) );
%%    if mse < minmse
%%      minmse = mse;
%%      disp(['   method   minmse   estimated_nsr   motion']);
%%      disp([method,minmse,estimated_nsr,motion]);
%%    endif
%%  endfor
%%endfor



% %%%%%%%%%
% %%%%%%% method 12
% method =12;
% minmse=1e6;
% abest=0.0;
% bbest=0.0;
% for a = 2e-2:2e-2:1
%   for b = 2e-2:2e-2:1
%     % im2=im(:,:,1)+a*medfilt2(im(:,:,2),[3,3])+b*...
%     % medfilt2(im(:,:,3),[3,3]);
%     im2=im(:,:,1)+a*im(:,:,2)+b*im(:,:,3);
%     im2=im2/max(im2(:));
%     mse = immse ( im2uint8(im2) , imref (:,:,1) );
%     if mse < minmse
%       minmse = mse;
%       abest = a;
%       bbest = b;
%     endif
    
    
%   endfor
% endfor
% disp('a, b, mse, best a, best b, min mse:');
% printf('%.3f   %.3f  %.3f  %.3f  %.3f %.3f\n',a,b,mse,abest,bbest,minmse);


%%
%%%%%%%
%%%%% method 13
%%method = method + 1;
%%for gs = 3:15
%%  im2 = im(: , : , 1);
%%  im2 = imsmooth ( im2 , 'bilateral' );
%%  im2 = medfilt2( im2 , [gs,gs] );
%%  mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%  disp ( [' Grid Size = ' , num2str(gs) , ':']);    
%%  disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);
%%endfor
%%
%%%%% method 14
%%method = method + 1;
%%for gs = 3:15
%%  im2 = im(: , : , 1);  
%%  im2 = medfilt2( im2 , [gs,gs] );
%%  im2 = imsmooth ( im2 , 'bilateral' );
%%  mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%  disp ( [' Grid Size = ' , num2str(gs) , ':']);    
%%  disp(['method ', num2str(method), ' mse is:    ',num2str(mse)]);
%%endfor



%%%%% method 15
%%method = method + 1;
%%minmse = 1e6;
%%permmin = [0,0,0,0,0,0,0,0];
%%for sigmaR = 5/255 : 5/255 : 15/255
%%  for sigmaD = 1 : 3
%%    for gs = 3:2:5 
%%      for estimated_nsr = 0.005:0.005:0.015
%%        for motion = 2:5
%%%%%          permutation 1          
%%          permutation = 1;
%%          im2 = im(: , : , 1);          
%%          psf = fspecial ("motion", motion, 0);
%%          im2 = deconvwnr (im2, psf, estimated_nsr);
%%          im2 = medfilt2( im2 , [gs gs] );
%%          im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );          
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr, motion];
%%          endif
%%          disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr , motion ) =' );
%%          disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr , motion]) ;
%%          disp ( permmin );
%%          
%%
%%          %%%          permutation 2
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          psf = fspecial ("motion", motion, 0);
%%          im2 = deconvwnr (im2, psf, estimated_nsr);
%%          im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
%%          im2 = medfilt2( im2 , [gs gs] );          
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr, motion];
%%          endif
%%          disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr , motion ) =' );
%%          disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr , motion]) ;
%%          disp ( permmin );
%%
%%          %%%          permutation 3
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          im2 = medfilt2( im2 , [gs gs] );          
%%          psf = fspecial ("motion", motion, 0);
%%          im2 = deconvwnr (im2, psf, estimated_nsr);
%%          im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr, motion];
%%          endif
%%          disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr , motion ) =' );
%%          disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr , motion]) ;
%%          disp ( permmin );
%%
%%          %%%          permutation 4
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          im2 = medfilt2( im2 , [gs gs] );
%%          im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
%%          psf = fspecial ("motion", motion, 0);
%%          im2 = deconvwnr (im2, psf, estimated_nsr);
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr, motion];
%%          endif
%%          disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr , motion ) =' );
%%          disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr , motion]) ;
%%          disp ( permmin );
%%
%%          %%%          permutation 5
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);          
%%          psf = fspecial ("motion", motion, 0);
%%          im2 = deconvwnr (im2, psf, estimated_nsr);
%%          im2 = medfilt2( im2 , [gs gs] );
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr, motion];
%%          endif
%%          disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr , motion ) =' );
%%          disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr , motion]) ;
%%          disp ( permmin );
%%
%%          %%%          permutation 6
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
%%          im2 = medfilt2( im2 , [gs gs] );          
%%          psf = fspecial ("motion", motion, 0);
%%          im2 = deconvwnr (im2, psf, estimated_nsr);
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr, motion];
%%          endif
%%          disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr , motion ) =' );
%%          disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , estimated_nsr , motion]) ;
%%          disp ( permmin );
%%
%%        endfor
%%      endfor
%%    endfor
%%  endfor
%%endfor






%%%%% method 16
%%method = method + 1;
%%minmse = 1e6;
%%permmin = [0,0,0,0,0,0,0,0];
%%for sigmaR = 5/255 : 5/255 : 20/255
%%  for sigmaD = 1 : 6
%%    for gs = 2 : 10
%%      for peronaIteration = 1:2
%%        for lambda = 0.1:0.15:0.25
%%%%%          permutation 1          
%%          permutation = 1;
%%          im2 = im(: , : , 1);          
%%          im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
%%          im2 = medfilt2( im2 , [gs gs] );
%%          im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );          
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration, lambda];
%%          endif
%%          disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda ) =' );
%%          disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda]) ;
%%          disp ( permmin );
%%          
%%
%%          %%%          permutation 2
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
%%          im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
%%          im2 = medfilt2( im2 , [gs gs] );          
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration, lambda];
%%          endif
%%          disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda ) =' );
%%          disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda]) ;
%%          disp ( permmin );
%%
%%          %%%          permutation 3
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          im2 = medfilt2( im2 , [gs gs] );          
%%          im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
%%          im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration, lambda];
%%          endif
%%          disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda ) =' );
%%          disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda]) ;
%%          disp ( permmin );
%%
%%          %%%          permutation 4
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          im2 = medfilt2( im2 , [gs gs] );
%%          im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
%%          
%%          im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration, lambda];
%%          endif
%%          disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda ) =' );
%%          disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda]) ;
%%          disp ( permmin );
%%
%%          %%%          permutation 5
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);          
%%          im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
%%          im2 = medfilt2( im2 , [gs gs] );
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration, lambda];
%%          endif
%%          disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda ) =' );
%%          disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda]) ;
%%          disp ( permmin );
%%
%%          %%%          permutation 6
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          im2 = imsmooth ( im2 , 'bilateral' , sigmaD , sigmaR);
%%          im2 = medfilt2( im2 , [gs gs] );          
%%          im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration, lambda];
%%          endif
%%          disp ( '(permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda ) =' );
%%          disp ( [ permutation, method, mse, sigmaR , sigmaD , gs , peronaIteration , lambda]) ;
%%          disp ( permmin );
%%
%%        endfor
%%      endfor
%%    endfor
%%  endfor
%%endfor



%%%%% method 17
%%method = 17;
%%minmse = 1e6;
%%permmin = [0,0,0,0,0,0,0,0];
%%for estimated_nsr = 0.005:0.005:0.015
%%  for motion = 2:5
%%    for gs = 2 : 10
%%      for peronaIteration = 1:2
%%        for lambda = 0.1:0.15:0.25
%%%%%          permutation 1          
%%          permutation = 1;
%%          im2 = im(: , : , 1);          
%%          im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
%%          im2 = medfilt2( im2 , [gs gs] );
%%          psf = fspecial ("motion", motion, 0);
%%          im2 = deconvwnr (im2, psf, estimated_nsr);
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );          
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, estimated_nsr , motion , gs , peronaIteration, lambda];
%%          endif
%%          disp ( '(permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda ) =' );
%%          disp ( [ permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda]) ;
%%          disp ( permmin );
%%          
%%
%%          %%%          permutation 2
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
%%          psf = fspecial ("motion", motion, 0);
%%          im2 = deconvwnr (im2, psf, estimated_nsr);
%%          im2 = medfilt2( im2 , [gs gs] );          
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, estimated_nsr , motion , gs , peronaIteration, lambda];
%%          endif
%%          disp ( '(permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda ) =' );
%%          disp ( [ permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda]) ;
%%          disp ( permmin );
%%
%%          %%%          permutation 3
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          im2 = medfilt2( im2 , [gs gs] );          
%%          im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
%%          psf = fspecial ("motion", motion, 0);
%%          im2 = deconvwnr (im2, psf, estimated_nsr);
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, estimated_nsr , motion , gs , peronaIteration, lambda];
%%          endif
%%          disp ( '(permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda ) =' );
%%          disp ( [ permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda]) ;
%%          disp ( permmin );
%%
%%          %%%          permutation 4
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          im2 = medfilt2( im2 , [gs gs] );
%%          psf = fspecial ("motion", motion, 0);
%%          im2 = deconvwnr (im2, psf, estimated_nsr);
%%          im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, estimated_nsr , motion , gs , peronaIteration, lambda];
%%          endif
%%          disp ( '(permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda ) =' );
%%          disp ( [ permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda]) ;
%%          disp ( permmin );
%%
%%          %%%          permutation 5
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          psf = fspecial ("motion", motion, 0);
%%          im2 = deconvwnr (im2, psf, estimated_nsr);
%%          im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
%%          im2 = medfilt2( im2 , [gs gs] );
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, estimated_nsr , motion , gs , peronaIteration, lambda];
%%          endif
%%          disp ( '(permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda ) =' );
%%          disp ( [ permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda]) ;
%%          disp ( permmin );
%%
%%          %%%          permutation 6
%%          permutation = permutation + 1;
%%          im2 = im(: , : , 1);
%%          psf = fspecial ("motion", motion, 0);
%%          im2 = deconvwnr (im2, psf, estimated_nsr);
%%          im2 = medfilt2( im2 , [gs gs] );          
%%          im2 = imsmooth (im2, 'Perona & Malik', peronaIteration, lambda);
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [permutation, method, mse, estimated_nsr , motion , gs , peronaIteration, lambda];
%%          endif
%%          disp ( '(permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda ) =' );
%%          disp ( [ permutation, method, mse, estimated_nsr , motion , gs , peronaIteration , lambda]) ;
%%          disp ( permmin );
%%
%%        endfor
%%      endfor
%%    endfor
%%  endfor
%%endfor


%%%%%%%%% method 18
%%%%%%%%%% v1=lambda1=lambda2 for Gaussian
%%%%%%%%%% v2 = estimated_nsr
%%%%%%%%%% v3 = motion
%%%%%%%%%% v4 = grid size
%%method = 18;
%%minmse = 1e6;
%%funorder=perms([1 2 3]);
%%funorder2=cat(1,perms([1 2]),perms([1 3]),perms([2,3]));
%%funorder3=cat(2,funorder2,[0;0;0;0;0;0]);
%%funorder=cat(1,funorder,funorder3);
%%for v1=1:3
%%  for v2=0.005:0.005:0.02
%%    for v3=1:3
%%      for v4=3:2:5
%%        for i=1:size(funorder,1)
%%          im2=im(:,:,1);
%%          for j=1:size(funorder,2)
%%            if funorder(i,j)==1
%%              im2=imsmooth(im2,'custom gaussian',v1,v1);
%%            elseif funorder(i,j)==2
%%              psf=fspecial('motion',v3);
%%              im2=deconvwnr(im2,psf,v2);
%%            elseif funorder(i,j)==3
%%              im2=medfilt2(im2,[v4,v4]);
%%            endif
%%          endfor % j
%%          mse = immse ( im2uint8(im2) , imref (:,:,1) );
%%          if mse < minmse
%%            minmse = mse;
%%            permmin = [i, method, mse, v1, v2, v3, v4];
%%          endif
%%          disp ( '(permutation, method, mse, v1, v2, v3, v4) =' );
%%          printf ('%.3f  %.3f  %.3f  %.3f  %.3f  %.3f  %.3f\n',i, method, mse, v1,v2,v3,v4) ;
%%          printf( '%.3f  %.3f  %.3f  %.3f  %.3f  %.3f  %.3f\n',permmin(1),permmin(2),permmin(3),permmin(4),permmin(5),permmin(6),permmin(7) );
%%          
%%        endfor % i
%%      endfor % v4
%%    endfor % v3
%%  endfor % v2
%%endfor % v1





%%%%%%%%% method 19
%%%%%%%% v1=lambda1=lambda2 for Gaussian
%%%%%%%% v2 = estimated_nsr
%%%%%%%% v3 = motion

% method = 19;
% minmse = 1e6;
% funorder=perms([1 2]);
% for v1=1:3
%   for v2=0.005:0.005:0.02
%     for v3=1:3
%       for i=1:size(funorder,1)
%         im2=im(:,:,1);
%         im2=im(:,:,1)+0.00005*medfilt2(im(:,:,2),[3,3])+0.1041*...
%           medfilt2(im(:,:,3),[3,3]);
%         for j=1:size(funorder,2)
%           if funorder(i,j)==1
%             im2=imsmooth(im2,'custom gaussian',v1,v1);
%           elseif funorder(i,j)==2
%             psf=fspecial('motion',v3);
%             im2=deconvwnr(im2,psf,v2);
%           elseif funorder(i,j)==3
            
%           endif
        
%         endfor % j
%         mse = immse ( im2uint8(im2) , imref (:,:,1) );
%         if mse < minmse
%           minmse = mse;
%           permmin = [i, method, mse, v1, v2, v3];
%         endif
%         disp ( '(permutation, method, mse, v1, v2, v3, v4) =' );
%         printf ('%.3f  %.3f  %.3f  %.3f  %.3f  %.3f\n',i, method, mse, v1,v2,v3) ;
%         printf( '%.3f  %.3f  %.3f  %.3f  %.3f  %.3f\n',permmin(1),permmin(2),permmin(3),permmin(4),permmin(5),permmin(6) );
        
%       endfor % i
%     endfor % v3
%   endfor % v2
% endfor % v1





end
