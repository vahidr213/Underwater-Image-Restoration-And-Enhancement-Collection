function [img,varargout] = load_image(doDegradation,inpath)
if doDegradation == 1
    imref = imread(inpath);
    im = im2double(imref);
    gsdestruction = 3; % size of the window or patch around each point    
    medtransMat  =  mediumtransmissionMat (im, gsdestruction, 1);% 1 = UDCP(more degradation), 2 = IATP(less degradation)    
    im(:,:,1) = im(:,:,1) .* medtransMat;
    img = im2uint8(im);
elseif doDegradation == 0
    imref = imread(inpath);
    img = imref;
elseif doDegradation == 2.0
    img = imread(inpath);
    
% elseif doDegradation == 2.1
%     img = imread(inpath);
%     imref = imread('E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\ref_front.jpg');
% elseif doDegradation == 2.2
%     img = imread(inpath);
%     imref = imread('E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\ref_side.jpg');
% elseif doDegradation == 2.3
%     img = imread(inpath);
%     imref = imread('E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\ref_milk.jpg');

end%if

if nargout == 2
    varargout{1} = imref;
end

end


