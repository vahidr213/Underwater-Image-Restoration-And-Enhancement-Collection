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





% % half=floor(gs*gs/2);
% % paddedim=padarray(im,[half,half],'both');
% % immin =ones(size(paddedim));
% % %%%%%%%%immin(:,:,1) = zeros(size(immin(:,:,1)));
% % imheight = size ( im , 1 ) ;
% % imwidth = size ( im , 2 ) ;

% % %%%% find brightest pixel in the dark channel- red
% % maxvalred=max(max(im(:,:,1))) ;
% % indxmaxvalred = find ( im ( : , : , 1 )  == maxvalred ) ;
% % %%%% green global background light- scalar
% % greenglobalBackLight = im ( indxmaxvalred ( 1 ) +imheight*imwidth ) ;
% % %%%% blue global background light- scalar
% % blueglobalBackLight = im ( indxmaxvalred ( 1 ) +2*imheight*imwidth ) ;

% % globalBackgLight = double ( [maxvalred , greenglobalBackLight , blueglobalBackLight] );
% % %%%%printf('globalBackgLight: %f\n',globalBackgLight);
% % for k=2:3  
% %   for i=-half:half
% %     for j=-half:half
% %       immin(:,:,k)=min(immin(:,:,k) , circshift(paddedim(:,:,k),[i,j]));
% %     endfor
% %   endfor
% % endfor

% % for i=-half:half
% %   for j=-half:half
% %     immin(:,:,1)=min( immin(:,:,1) , ones(size(paddedim(:,:,1)))-circshift(paddedim(:,:,1),[i,j]));
% %   endfor
% % endfor

% % immin(:,:,1)=immin(:,:,1)/(1-globalBackgLight(1)+eps);
% % immin(:,:,2)=immin(:,:,2)/(globalBackgLight(2)+eps);
% % immin(:,:,3)=immin(:,:,3)/(globalBackgLight(3)+eps);
% % %%%%dispcheck(immin)

% % imminnopad=immin(half+1:end-half,half+1:end-half,:);

% % medtransMat=min(imminnopad,[],3);
% % %%%%disp('minimum taking of medtransMat')
% % %%%%dispcheck(medtransMat)
% % medtransMat=medtransMat/max(medtransMat(:));
% % medtransMat=1.0-medtransMat;
% % %%%%disp('min of medtransMat')
% % %%%%dispcheck(medtransMat)









%%%%im = im2double(im);
%%imheight = size ( im , 1 ) ;
%%imwidth = size ( im , 2 ) ;
%%
%%%% find brightest pixel in the dark channel- red
%%maxvalred  =  max  ( max ( im (  :  ,  :  ,  1  )   )   ) ;
%%indxmaxvalred = find ( im ( : , : , 1 )  == maxvalred ) ;
%%%% green global background light- scalar
%%greenglobalBackLight = im ( indxmaxvalred ( 1 ) +imheight*imwidth ) ;
%%%% blue global background light- scalar
%%blueglobalBackLight = im ( indxmaxvalred ( 1 ) +2*imheight*imwidth ) ;
%%
%%globalBackgLight = double ( [maxvalred , greenglobalBackLight , blueglobalBackLight] );
%%
%%%%  medium transmission size is as im
%%mediumtransmission = zeros ( imheight , imwidth ) ;
%%
%%%%  gs is grid size
%%
%%for r = 1:imheight
%%    for c = 1:imwidth
%%%%      four corners of rect
%%      rmin = r- ( gs-1 ) /2;
%%      rmax = r+ ( gs-1 ) /2;
%%      cmin = c- ( gs-1 ) /2;
%%      cmax = c+ ( gs-1 ) /2;
%%%%      if rmin is out of boundary
%%      if  ( rmin<1 ) 
%%        rmin = 1;
%%        rmax = rmin + gs - 1;
%%      endif
%%%%      if cmin is out of boundary
%%      if  ( cmin<1 ) 
%%        cmin = 1;
%%        cmax = cmin+gs - 1;
%%      endif
%%%%      if rmax is out of boundary
%%      if  ( rmax>imheight ) 
%%        rmax = imheight;
%%        rmin = rmax - gs - 1;
%%      endif
%%%%      if cmax is out of boundary
%%      if  ( cmax>imwidth ) 
%%        cmax = imwidth;
%%        cmin = cmax - gs - 1;
%%      endif
%%    
%%%%    get gs by gs patch from image
%%      patchImage =  im ( rmin:rmax , cmin:cmax , 1:3 );
%%
%%%%    find the min of each patch- scalar
%%      minpatchred = min ( min ( 1.0 - patchImage ( : , : , 1 ) ) );
%%      minpatchgreen = min ( min ( patchImage ( : , : , 2 )  )  ) ;
%%      minpatchblue = min ( min ( patchImage ( : , : , 3 )  )  ) ;
%%
%%%%    normalize green and blue by local back light
%%      patchImage ( : , : , 1 ) = patchImage ( : , : , 1 ) / ( 1.0 - maxvalred );
%%      patchImage ( : , : , 2 )  = patchImage ( : , : , 2 ) /greenglobalBackLight;
%%      patchImage ( : , : , 3 )  = patchImage ( : , : , 3 ) /blueglobalBackLight;
%%
%%%%    min of green and blue patches-scalar
%%      minpatch = min ( minpatchgreen , minpatchblue ) ;
%%      minpatch = min ( minpatch , minpatchred );
%%      
%%%%    medium transmission- scalar
%%      mediumtransmission ( r , c )  = 1.0 - minpatch;
%%      if mediumtransmission ( r , c ) > 1.0
%%        mediumtransmission ( r , c ) = 1.0;
%%      endif
%%      
%%    endfor % for c
%%    
%%endfor  % for r
%%medtransMat = mediumtransmission;
