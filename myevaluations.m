function  myevaluations(im,imref,method,framenum,inpath,outpath)
% im is normalized 0-1
% imref is uint8
% outpath='I:\';
%%%%%%%%%%%
if method == 1.01
  cd('./01.01/');
  main(im,imref,method,outpath);
elseif method == 1.02
  cd('./01.02/');
  main(im,imref,method,outpath);
elseif method == 1.03
  cd('./01.03/');
  main(im,imref,method,outpath);
elseif method == 2.00
  if (exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')    
  else% for matlab
    cd('./02.00/');
    imrestored=main(framenum,inpath);
    resfilename=sprintf('method %.2f restored vs original',method);
    resfilename=sprintf('%s%s.jpg',outpath,resfilename);
    imwrite(cat(2, imrestored, imref ) , resfilename);
  endif
elseif method == 2.01
  cd('./02.01/');
  imrestored = main(framenum,inpath);
  resfilename=sprintf('method %.2f restored vs original',method);
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);
elseif method == 3.00
  % Adaptive Local Tone Mapping Based on Retinex for HDR Image
  cd('./03.00/');
  imrestored = im2uint8( ALTM_Retinex(im) );
  resfilename=sprintf('method %.2f ALTM Retinex restored vs original',method);
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);

elseif method == 4.00
  cd('./04.00/');  
  imrestored = AtmLight(framenum,inpath);
  resfilename=sprintf('method %.2f Atmosphere Light restored vs original',method);
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);

elseif method == 5.0
  cd('./05.00/');
  imrestored = ex_darkchannel_guildfilter(framenum,inpath);
  resfilename=sprintf('method %.2f Dark Channel restored vs original',method);
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);

elseif method == 6.00
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./06.00/');
    Proposed_Retinex(framenum,inpath,outpath,method);
  endif

elseif method == 6.01
  cd('./06.01/');
  Proposed_Retinex(framenum,inpath,outpath,method);
elseif method == 7.00
  cd('./07.00/');
  imrestored=demo(framenum,inpath);
  resfilename=sprintf('method %.2f all channels restored vs original',method);
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);

elseif method == 8.00
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./08.00/');
    imrestored=main(framenum,inpath);
    resfilename=sprintf('method %.2f restored vs original',method);
    resfilename=sprintf('%s%s.jpg',outpath,resfilename);
    imwrite(cat(2, imrestored, imref ) , resfilename);
  endif
  
elseif method == 8.01
  cd('./08.01/');
  imrestored=main(framenum,inpath);
  resfilename=sprintf('method %.2f restored vs original',method);
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);

elseif method == 9.00
  cd('./09.00/');
  imrestored = demo(framenum,inpath);
  resfilename=sprintf('method %.2f restored vs original',method);
  resfilename=sprintf('%s%s.jpg',outpath,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);

elseif method == 10.00
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    % this method requires reference images
    cd('./10.00/');
    imrestored=correction_gui();
    resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method);
    imwrite(cat(2, imrestored, imref ) , resfilename);
  endif
  
elseif method == 11.00
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./11.00/');
    imrestored=main(framenum,inpath);
    resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method);
    imwrite(cat(2, imrestored, imref ) , resfilename);
  endif
  
elseif method ==12.00
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./12.00/');
    imrestored=demo(framenum,inpath,outpath,method);
    resfilename=sprintf('method %.2f restored vs original',method);
    resfilename=sprintf('%s%s.jpg',outpath,resfilename);
    imwrite(cat(2, imrestored, imref ) , resfilename);

  endif
elseif method ==12.01
  cd('./12.01/');  
  imrestored=demo(framenum,inpath,outpath,method);
  resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method);
  imwrite(cat(2, imrestored, imref ) , resfilename);

elseif method == 13.01
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./13.01/')
    imrestored=main_underwater_restoration(framenum,inpath,outpath);
    resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method);
    imwrite(cat(2, imrestored, imref ) , resfilename);
  endif
endif % if method
end
