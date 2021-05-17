function L=AtmLight(doDegradation,inpath)
showFigures = 1;
%function [ A ] = AtmLight( imName ,showFigures)
%[ A, mag ] = AtmLight( imName ,showFigures)
%The function finds and returns the Atmospheric light color (orientation and magnitude) of the given image
pwd0=cd('..');
img = load_image(doDegradation,inpath);     
cd(pwd0);

I = double(img)/255;
%I = double(imread(imName))/255;
%I = I.^1.5; %gamma correction might help orientation recovery

A = findOrientation(I,showFigures);

[mag,alpha,L] = findMagnitude(I,A,showFigures);
L=im2uint8(L);
end
