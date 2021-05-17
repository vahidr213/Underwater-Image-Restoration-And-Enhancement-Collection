function  evaluations(inpath,outpath,doDegradation,method)
% im is normalized 0-1
% imref is uint8
% outpath='I:\';
%%%%%%%%%%%
pwd0=pwd;
imref = imread(inpath);
im = im2double(imref);
if doDegradation == 1
  gsdestruction  = 3;
  cd('./01.01/');
  im = im2double(imref);
  medtransMat  =  mediumtransmissionMat (im, gsdestruction, 1);% 1 = UDCP(more degradation), 2 = IATP(less degradation)
  cd(pwd0);
  im(:,:,1) = im(:,:,1) .* medtransMat;
end%if


if method == 1.01
  cd('./01.01/');
  main(inpath,outpath,doDegradation,method);
elseif method == 1.02
  cd('./01.02/');
  main(inpath,outpath,doDegradation,method);
elseif method == 1.03
  cd('./01.03/');
  main(inpath,outpath,doDegradation,method);
elseif method == 1.04
  cd('./01.04/');
  main(inpath,outpath,doDegradation,method);
elseif method == 1.05
  cd('./01.05/');
  main(inpath,outpath,doDegradation,method);
elseif method == 1.06
  cd('./01.06/');
  main(inpath,outpath,doDegradation,method);

elseif method == 2.00
  printf('\nmethod %.2f\n',method);
  if (exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    printf('\nthis method requires Matlab.\n\n');
  else% for matlab
    cd('./02.00/');
    imrestored=main(doDegradation,inpath);
    resfilename=sprintf('method %.2f restored vs original',method);
    resfilename=sprintf('%s%s.jpg',outpath,resfilename);
    imwrite(cat(2, imrestored, imref ) , resfilename);
    if doDegradation == 1
      mse = immse (imrestored(:,:,1) , imref (:,:,1) );
      printf('mse bw ref image and restored image is:    %.3f\n',mse);
    end
  endif
elseif method == 2.01
  printf('\nmethod %.2f\n',method);
  cd('./02.01/');
  imrestored = main(doDegradation,inpath);
  resfilename=sprintf('method %.2f restored vs original',method);
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);
  if doDegradation == 1
    mse = immse (imrestored(:,:,1) , imref (:,:,1) );
    printf('mse bw ref image and restored image is:    %.3f\n',mse);
  end
elseif method == 3.00
  printf('\nmethod %.2f\n',method);
  % Adaptive Local Tone Mapping Based on Retinex for HDR Image
  cd('./03.00/');
  imrestored = im2uint8( ALTM_Retinex(doDegradation,inpath) );
  resfilename=sprintf('method %.2f ALTM Retinex restored vs original',method);
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);
  if doDegradation == 1
    mse = immse (imrestored(:,:,1) , imref (:,:,1) );
    printf('mse bw ref image and restored image is:    %.3f\n',mse);
  end

elseif method == 4.00
  printf('\nmethod %.2f\n',method);
  cd('./04.00/');  
  imrestored = AtmLight(doDegradation,inpath);
  resfilename=sprintf('method %.2f Atmosphere Light restored vs original',method);
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);
  if doDegradation == 1
    mse = immse (imrestored(:,:,1) , imref (:,:,1) );
    printf('mse bw ref image and restored image is:    %.3f\n',mse);
  end

elseif method == 5.0
  printf('\nmethod %.2f\n',method);
  cd('./05.00/');
  imrestored = ex_darkchannel_guildfilter(doDegradation,inpath);
  resfilename=sprintf('method %.2f Dark Channel restored vs original',method);
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);
  if doDegradation == 1
    mse = immse (imrestored(:,:,1) , imref (:,:,1) );
    printf('mse bw ref image and restored image is:    %.3f\n',mse);
  end

elseif method == 6.00
  printf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./06.00/');
    Proposed_Retinex(doDegradation,inpath,outpath,method);
  endif

elseif method == 6.01
  printf('\nmethod %.2f\n',method);
  cd('./06.01/');
  Proposed_Retinex(doDegradation,inpath,outpath,method);

elseif method == 7.00
  printf('\nmethod %.2f\n',method);
  cd('./07.00/');  
  imrestored=demo(doDegradation,inpath);
  resfilename=sprintf('method %.2f all channels restored vs original',method);
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);
  if doDegradation == 1
    mse = immse (imrestored(:,:,1) , imref (:,:,1) );
    printf('mse bw ref image and restored image is:    %.3f\n',mse);
  end

elseif method == 8.00
  printf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./08.00/');
    imrestored=main(doDegradation,inpath);
    resfilename=sprintf('method %.2f restored vs original',method);
    resfilename=sprintf('%s%s.jpg',outpath,resfilename);
    imwrite(cat(2, imrestored, imref ) , resfilename);
    if doDegradation == 1
      mse = immse (imrestored(:,:,1) , imref (:,:,1) );
      printf('mse bw ref image and restored image is:    %.3f\n',mse);
    end
  endif
  
elseif method == 8.01
  printf('\nmethod %.2f\n',method);
  cd('./08.01/');
  imrestored=main(doDegradation,inpath);
  resfilename=sprintf('method %.2f restored vs original',method);
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);
  if doDegradation == 1
    mse = immse (imrestored(:,:,1) , imref (:,:,1) );
    printf('mse bw ref image and restored image is:    %.3f\n',mse);
  end

elseif method == 9.00
  printf('\nmethod %.2f\n',method);
  cd('./09.00/');
  imrestored = demo(doDegradation,inpath);
  resfilename=sprintf('method %.2f restored vs original',method);
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);
  if doDegradation == 1
    mse = immse (imrestored(:,:,1) , imref (:,:,1) );
    printf('mse bw ref image and restored image is:    %.3f\n',mse);
  end

elseif method == 10.00
  printf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    % this method requires reference images
    cd('./10.00/');
    imrestored=correction_gui();
    resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method);
    imwrite(cat(2, imrestored, imref ) , resfilename);
    if doDegradation == 1
      mse = immse (imrestored(:,:,1) , imref (:,:,1) );
      printf('mse bw ref image and restored image is:    %.3f\n',mse);
    end
  endif
  
elseif method == 11.00
  printf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./11.00/');
    imrestored=main(doDegradation,inpath);
    resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method);
    imwrite(cat(2, imrestored, imref ) , resfilename);
    if doDegradation == 1
      mse = immse (imrestored(:,:,1) , imref (:,:,1) );
      printf('mse bw ref image and restored image is:    %.3f\n',mse);
    end
  endif
  
elseif method ==12.00
  printf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./12.00/');
    imrestored=demo(doDegradation,inpath,outpath,method);
    resfilename=sprintf('method %.2f restored vs original',method);
    resfilename=sprintf('%s%s.jpg',outpath,resfilename);
    imwrite(cat(2, imrestored, imref ) , resfilename);
    if doDegradation == 1
      mse = immse (imrestored(:,:,1) , imref (:,:,1) );
      printf('mse bw ref image and restored image is:    %.3f\n',mse);
    end

  endif
elseif method ==12.01
  printf('\nmethod %.2f\n',method);
  cd('./12.01/');  
  imrestored=demo(doDegradation,inpath,outpath,method);
  imrestored = uint8(imrestored);
  class(imrestored)
  class(imref)
  max(imrestored(:))
  resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method);
  imwrite(cat(2, imrestored, imref ) , resfilename);
  if doDegradation == 1
    mse = immse (imrestored(:,:,1) , imref (:,:,1) );
    printf('mse bw ref image and restored image is:    %.3f\n',mse);
  end

elseif method == 13.01
  printf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./13.01/')
    imrestored=main_underwater_restoration(doDegradation,inpath,outpath);
    resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method);
    imwrite(cat(2, imrestored, imref ) , resfilename);
    if doDegradation == 1
      mse = immse (imrestored(:,:,1) , imref (:,:,1) );
      printf('mse bw ref image and restored image is:    %.3f\n',mse);
    end
  endif
endif % if method
end
