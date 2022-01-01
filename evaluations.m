function  varargout = evaluations(inpath,outpath,doDegradation,method)

pwd0=pwd;

if    method == 1.01
  cd('./01.01/');
  imrestored = main1(inpath,outpath,doDegradation,method);
elseif method == 1.02
  cd('./01.01/');
  imrestored = main2(inpath,outpath,doDegradation,method);
elseif method == 1.03
  cd('./01.01/');
  imrestored = main3(inpath,outpath,doDegradation,method);
elseif method == 1.04
  cd('./01.01/');
  imrestored = main4(inpath,outpath,doDegradation,method);
elseif method == 1.05
  cd('./01.01/');
  imrestored = main5(inpath,outpath,doDegradation,method);
elseif method == 1.06
  cd('./01.01/');
  imrestored = main6(inpath,outpath,doDegradation,method);
elseif method == 1.07
  cd('./01.01/');
  imrestored = main7(inpath,outpath,doDegradation,method);
elseif method == 1.08
  cd('./01.01/');
  imrestored = main8(inpath,outpath,doDegradation,method);
elseif method == 1.09
  cd('./01.01/');
  imrestored = main9(inpath,outpath,doDegradation,method);
elseif method == 1.10
  cd('./01.01/');
  imrestored = main10(inpath,outpath,doDegradation,method);
elseif method == 1.11
  cd('./01.01/');
  imrestored = main11(inpath,outpath,doDegradation,method);
elseif method == 1.12
  cd('./01.01/');
  imrestored = main12(inpath,outpath,doDegradation,method);

elseif method == 2.00
  fprintf('\nmethod %.2f\n',method);
  if (exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    fprintf('\nthis method requires Matlab.\n\n');
  else% for matlab
    cd('./02.00/');
    imrestored=main(doDegradation,inpath);
  end
elseif method == 2.01
  fprintf('\nmethod %.2f\n',method);
  cd('./02.01/');
  imrestored = main(doDegradation,inpath);
  
elseif method == 3.00
  fprintf('\nmethod %.2f\n',method);
  % Adaptive Local Tone Mapping Based on Retinex for HDR Image
  cd('./03.00/');
  imrestored = im2uint8( ALTM_Retinex(doDegradation,inpath) );

elseif method == 4.00
  fprintf('\nmethod %.2f\n',method);
  cd('./04.00/');  
  imrestored = AtmLight(doDegradation,inpath);

elseif method == 5.0
  fprintf('\nmethod %.2f\n',method);
  cd('./05.00/');
  imrestored = ex_darkchannel_guildfilter(doDegradation,inpath);

elseif method == 6.01
  % % % this method is slightly different than the original method
  % % % due to Unavailability of one function
  fprintf('\nmethod %.2f\n',method);
  cd('./06.01/');
  imrestored = Proposed_Retinex(doDegradation,inpath,outpath,method);

elseif method == 7.00
  fprintf('\nmethod %.2f\n',method);
  cd('./07.00/');  
  imrestored=demo(doDegradation,inpath);

elseif method == 8.00
  fprintf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./08.00/');
    imrestored=main(doDegradation,inpath);    
  end
elseif method == 8.01
  fprintf('\nmethod %.2f\n',method);
  cd('./08.01/');
  imrestored=main(doDegradation,inpath);  

elseif method == 9.00
  fprintf('\nmethod %.2f\n',method);
  cd('./09.00/');
  imrestored = demo(doDegradation,inpath);

elseif method == 10.00
  fprintf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    % this method requires nice quality reference images
    cd('./10.00/');
    imrestored = main(doDegradation, inpath);    
  end
  
elseif method == 11.00
  fprintf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./11.00/');
    imrestored=main(doDegradation,inpath);
  end
  
elseif method ==12.00
  fprintf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./12.00/');
    imrestored=demo(doDegradation,inpath,outpath,method);
  end
elseif method ==12.01
  fprintf('\nmethod %.2f\n',method);
  cd('./12.01/');  
  imrestored=demo(doDegradation,inpath,outpath,method);
  imrestored = uint8(imrestored);

elseif method == 13.00
  fprintf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./13.00/')
    imrestored = main_underwater_restoration(doDegradation,inpath,outpath);
  end

elseif method == 14.00
  fprintf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./14.00/');
    imrestored = main(doDegradation,inpath);
  end

elseif method == 15.00
  fprintf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./15.00/');
    imrestored = main(doDegradation,inpath);
  end

elseif method == 16.00
  fprintf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./16.00/');
    imrestored = main(doDegradation,inpath);
  end
elseif method == 16.01
  fprintf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./16.00/');
    imrestored = main1(doDegradation,inpath);
  end
elseif method == 16.02
  fprintf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./16.00/');
    imrestored = main2(doDegradation,inpath,paramvector);
  end

elseif method == 17.00
  fprintf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./17.00/');
    imrestored = main(doDegradation,inpath);
  end
  
elseif method == 18.00
  fprintf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./18.00/');
    imrestored = main(doDegradation,inpath);
  end
  
  
end % if method

varargout{1} = imrestored;

cd(pwd0)

% write the result on disk
% sprintf('%.3f',mse)


end
