function  varargout = evaluations2(inpath,outpath,doDegradation,method,paramvector,varargin)
% im is normalized 0-1
% imref is uint8
% outpath='I:\';
%%%%%%%%%%%
pwd0=pwd;

if method == 1.01
  cd('./01.01/');
  varargout{1} = main1(inpath,outpath,doDegradation,method);
elseif method == 1.02
  cd('./01.01/');
  varargout{1} = main2(inpath,outpath,doDegradation,method);
elseif method == 1.03
  cd('./01.01/');
  varargout{1} = main3(inpath,outpath,doDegradation,method);
elseif method == 1.04
  cd('./01.01/');
  varargout{1} = main4(inpath,outpath,doDegradation,method);
elseif method == 1.05
  cd('./01.01/');
  varargout{1} = main5(inpath,outpath,doDegradation,method);
elseif method == 1.06
  cd('./01.01/');
  varargout{1} = main6(inpath,outpath,doDegradation,method);
elseif method == 1.07
  cd('./01.01/');
  varargout{1} = main7(inpath,outpath,doDegradation,method);
elseif method == 1.08
  cd('./01.01/');
  varargout{1} = main8(inpath,outpath,doDegradation,method);
elseif method == 1.09
  cd('./01.01/');
  varargout{1} = main9(inpath,outpath,doDegradation,method);
elseif method == 1.10
  cd('./01.01/');
  varargout{1} = main10(inpath,outpath,doDegradation,method);
elseif method == 1.11
  cd('./01.01/');
  varargout{1} = main11(inpath,outpath,doDegradation,method);
elseif method == 1.12
  cd('./01.01/');
  varargout{1} = main12(inpath,outpath,doDegradation,method);

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
  if doDegradation == 1
    varargout{1} = Proposed_Retinex(doDegradation,inpath,outpath,method);
  end

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
    imrestored = main_underwater_restoration(doDegradation,'D:\RefPic\',outpath);
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
    gs = varargin{1};
    imrestored = main2(doDegradation,inpath,paramvector,gs);
  end

elseif method == 17.00
  fprintf('\nmethod %.2f\n',method);
  if(exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    disp('this method requires Matlab.')
  else
    cd('./17.00/');
    imrestored = main(doDegradation,inpath);
  end
  

end % if method



if doDegradation == 1
  imref = imread(inpath);
  mse = immse (imrestored(:,:,1) , imref (:,:,1) );
  resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method);
  imwrite(cat(2, imrestored, imref ) , resfilename);

  varargout{1} = mse;
  fprintf('mse bw ref image and restored image is:    %.3f\n',mse);
end

if doDegradation == 2.0
  imref = imread('E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\ref_DeepBlue.jpg'); 
  mse = immse(double(imref),double(imrestored));
  imref = insertText(imref,[size(imref,2)-150 150],...
      mse, 'AnchorPoint', 'Center','FontSize',100,...
          'TextColor','white','Font','Consolas Bold');

  resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method);
  % write the result on the disk
  imwrite(cat(2, imrestored, imref ) , resfilename);
  varargout{1} = mse;
end

if doDegradation == 2.1
  imref = imread('E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\ref_front.jpg');
  mse = immse(double(imref),double(imrestored));
  imref = insertText(imref,[size(imref,2)-150 150],...
      mse, 'AnchorPoint', 'Center','FontSize',100,...
          'TextColor','white','Font','Consolas Bold');

  resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method);
  % write the result on the disk
  imwrite(cat(2, imrestored, imref ) , resfilename);

  varargout{1} = mse;
end

if doDegradation == 2.2
  imref = imread('E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\ref_side.jpg');
  mse = immse(double(imref),double(imrestored));
  imref = insertText(imref,[size(imref,2)-150 150],...
      mse, 'AnchorPoint', 'Center','FontSize',100,...
          'TextColor','white','Font','Consolas Bold');

  resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method);
  % write the result on the disk
  imwrite(cat(2, imrestored, imref ) , resfilename);

  varargout{1} = mse;
end

if doDegradation == 2.3
  imref = imread('E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\ref_milk.jpg');
  mse = immse(double(imref),double(imrestored));
  imref = insertText(imref,[size(imref,2)-150 150],...
      mse, 'AnchorPoint', 'Center','FontSize',100,...
          'TextColor','white','Font','Consolas Bold');

  resfilename=sprintf('%smethod %.2f restored vs original.jpg',outpath,method);
  % write the result on the disk
  imwrite(cat(2, imrestored, imref ) , resfilename);

  varargout{1} = mse;
end

cd(pwd0) % back to top folder
end
