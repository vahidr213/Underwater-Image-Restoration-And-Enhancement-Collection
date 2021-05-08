function out = pyramid_reconstruct(pyramid)
    % % % https://github.com/IsaacChanghau/OptimizedImageEnhance/tree/master/matlab/FusionEnhance
    % % % https://github.com/IsaacChanghau/OptimizedImageEnhance/blob/master/matlab/FusionEnhance/FusionEnhance.zip

level = length(pyramid);
for i = level : -1 : 2
    %temp_pyramid = pyramid{i};
    [m, n] = size(pyramid{i - 1});
    %out = pyramid{i - 1} + imresize(temp_pyramid, [m, n]);
    pyramid{i - 1} = pyramid{i - 1} + imresize(pyramid{i}, [m, n]);
end
out = pyramid{1};