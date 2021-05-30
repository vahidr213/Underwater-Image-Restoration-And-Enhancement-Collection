function imu = im_unity(im)
% imu is double type in range 0-1
im = double(im);
immin = repmat(min(min(im)), size(im,1), size(im,2));
immax = repmat(max(max(im)), size(im,1), size(im,2));
imu = (im - immin)./(immax - immin);
end%% function