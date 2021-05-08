function  myevaluations(im,imref,method,framenum)
% im is normalized 0-1
% imref is uint8
prefixaddress='I:\';
%%%%%%%%%%%
if method == 1.01
  cd('./01.01/');
  main(im,imref,method);
elseif method == 1.02
  cd('./01.02/');
  main(im,imref,method);
elseif method == 1.03
  cd('./01.03/');
  main(im,imref,method);
elseif method == 2.00
  if (exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    printf('you are running OCTAVE %s - this method requires Matlab\n',OCTAVE_VERSION);
    reply=input('you can run its approximate Octave version in method 02.01. do you proceed:0/1?');
    if ( reply == 1)
      cd('./02.01/');
      imrestored=main(framenum);
      resfilename=sprintf('method %.2f restored vs original',method);
      resfilename=sprintf('%s%s.jpg',prefixaddress,resfilename);
      imwrite(cat(2, imrestored, imref ) , resfilename);
    endif
  else% for matlab
    cd('./02.00/');
    imrestored=main(framenum);
    resfilename=sprintf('method %.2f restored vs original',method);
    resfilename=sprintf('%s%s.jpg',prefixaddress,resfilename);
    imwrite(cat(2, imrestored, imref ) , resfilename);

  endif
elseif method == 2.01
  cd('./02.01/');
  imrestored = main(framenum);
  resfilename=sprintf('method %.2f restored vs original',method);
  resfilename=sprintf('%s%s.jpg',prefixaddress,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);
elseif method == 3.00
  % Adaptive Local Tone Mapping Based on Retinex for HDR Image
  cd('./03.00/');
  imrestored = im2uint8( ALTM_Retinex(im) );
  resfilename=sprintf('method %.2f ALTM Retinex restored vs original',method);
  resfilename=sprintf('%s%s.jpg',prefixaddress,resfilename);
  imwrite(cat(2, imrestored, imref ) , resfilename);

endif % if method
end
