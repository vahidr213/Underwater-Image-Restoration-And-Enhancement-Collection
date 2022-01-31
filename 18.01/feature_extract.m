function foi = feature_extract(img)
%   ex:    X(i,:)=feature_extract(img);
   histim = imhist(img(:,:,1), 256);
   st = sum(histim(:));
   s1 = sum(histim(1:64))/st;
   s2 = sum(histim(65:128))/st;
   s3 = sum(histim(129:192))/st;
   s4 = sum(histim(193:256))/st;
   foi(1:4)=[s1 s2 s3 s4];
   histim = imhist(img(:,:,2), 256);
   st = sum(histim(:));
   s1 = sum(histim(1:64))/st;
   s2 = sum(histim(65:128))/st;
   s3 = sum(histim(129:192))/st;
   s4 = sum(histim(193:256))/st;
   foi(5:8)=[s1 s2 s3 s4];
   histim = imhist(img(:,:,3), 256);
   st = sum(histim(:));
   s1 = sum(histim(1:64))/st;
   s2 = sum(histim(65:128))/st;
   s3 = sum(histim(129:192))/st;
   s4 = sum(histim(193:256))/st;
   foi(9:12)=[s1 s2 s3 s4];
   
end
