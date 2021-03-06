function imrestored = main_underwater_restoration(doDegradation,inpath,outpath)
% A revised implementation of 
% "Diving Into Haze-Lines: Color restoration of Underwater Images",
% Dana Berman, Tali Treibitz, Shai Avidan, BMVC 2017.
%
% Author: Dana Berman, 2017. 
%
% This code is provided under the attached LICENSE.md.

%% Set paths, clear variables
% clear variables; dbstop if error;

% External libraries used: the toolbox by Piotr Dollar and the Structures Edge 
% Detector 
% https://github.com/pdollar/toolbox
toolbox_path = fullfile('utils', 'toolbox');
% https://github.com/pdollar/edges
edges_path = fullfile('utils', 'edges');

addpath('utils')
addpath(edges_path)
addpath(genpath(toolbox_path))

% Suppress Warning regarding image size
warning('off', 'Images:initSize:adjustingMag');
feature('DefaultCharacterSet', 'UTF8');

%% Folders etc.
% A few example input images are saves in this sub-directory. 
% The code can run on either sRGB or raw images
% images_dir = 'images';
% listing = cat(1, dir(fullfile(images_dir, '*_input.jpg')), ...
%     dir(fullfile(images_dir, '*.CR2')));
images_dir = inpath;
% pwd0 = cd(inpath);
% listing = dir('*.png');
% cd(pwd0);

% The final output will be saved in this directory:
% result_dir = fullfile(images_dir, 'results');
result_dir = outpath;
% Preparations for saving results.
if ~exist(result_dir, 'dir'), mkdir(result_dir); end
jetmap = jet(256);  % Colormap for transmission.
verbose = false;    % Whether to print and save verbose details.
max_width = 2010;   % Maximum image width - larger images will be resized.

%% Actual running
for i_img = 1:1%length(listing)
    [img_out, trans_out, A, estimated_water_type] = uw_restoration(...
        inpath, edges_path, max_width, ...
        result_dir, verbose);

    % [~, img_name, ~] = fileparts(listing(i_img).name);
    % % Some images have '_input' suffix, which is confusing in output
    % % filename, and therefore removed.
    % img_name = strrep(img_name, '_input', '');
    % % Save the enhanced image and the transmission map.
    % % imwrite(im2uint8(img_out), fullfile(result_dir, [img_name, '_output_img.jpg']));
    % % imwrite(im2uint8(trans_out), jetmap, fullfile(result_dir, [img_name, '_output_trans.jpg']));
    
end  % loop on different images

% imrestored = im2uint8(imresize(img_out,1/2));
imrestored = im2uint8(img_out);
im = imread(inpath);
imrestored = imresize(imrestored,[size(im,1),size(im,2)]);