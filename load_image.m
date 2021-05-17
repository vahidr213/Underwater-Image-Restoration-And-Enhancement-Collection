function [img,varargout] = load_image(doDegradation,inpath)
imref = imread(inpath);
im = im2double(imref);
if doDegradation == 1
    gsdestruction = 3; % size of the window or patch around each point    
    medtransMat  =  mediumtransmissionMat (im, gsdestruction, 1);% 1 = UDCP(more degradation), 2 = IATP(less degradation)    
    im(:,:,1) = im(:,:,1) .* medtransMat;
    img = im2uint8(im);
elseif doDegradation == 0
    img = imref;
end%if

if nargout == 2
    varargout{1} = imref;
end

end


