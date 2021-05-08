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