clc
clear all
close all
if (exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    pkg load image
    pkg load signal
end
inpath = 'D:\RefPic\';%path for reading image
outpath = 'I:\';% path for saving results
doDegradation = 1; % 0/1  - if 0, the image itself is restored.
%%% if 1, image is degraded at first, then the degraded image is restored back again by
%%% available methods to its original. use this only if you have perfect underwater image
%%% and you want to see the mean squared error.
warning('off', 'all')% suppress all warnings
num = 5;%suffix for reading frame
inpath=sprintf('%swater (%d).png',inpath,num);% image filename
% % % fast methods
% method = [17.00 16.00 15.00 14.00 13.00 12.01 12.00 11.00 10.00 9.00 8.01 8.00 7.00 6.01 5.00 4.00 3.00 2.01 2.00 1.01 1.02 1.03 1.07 1.08 1.09 1.10 1.11 1.12];
 method = 3.00;
 mse = zeros(size(method));
pwd0=pwd;%current dir

cd(pwd0);
% parpool(2)

%%% the following for loop evaluates several methods on just one image (not a dataset)
%%% each image is first degraded and then restored back. the restored result
%%% is then compared with the initial source image.
for i = 1:length(method)
    tic
    mse(i)=evaluations(inpath,outpath,doDegradation,method(i));
    toc
    cd(pwd0);
    fprintf('\n\n');
    % close all
end

% %%% this case will process the main image, not the degraded image
%%% the following for loop evaluates several methods on just one image(not a dataset)
% doDegradation = 0;
% parfor i = 1:length(method)
%     tic
%     evaluations(inpath,outpath,doDegradation,method(i));    
%     toc
%     cd(pwd0);
%     fprintf('\n\n');
%     % close all
% end
% %%%return


% figure('name','mse for all methods'),plot(method, mse)
% save('mse for all methods','method', 'mse')

%%%% running one method over a big dataset
%%%% comment the following lines if you don't 
%%%% need to evaluate a method over a dataset
% ['D:\RefPic\','*.png']
% % listing = cat(1, dir(fullfile('D:\RefPic\','*.png')), dir(fullfile('D:\RefPic\','*.jpg')));
% listing = cat(1, dir(fullfile('F:\Picture\my wallpapers\w\','*.png')), dir(fullfile('F:\Picture\my wallpapers\w\','*.jpg')));
% % listing.name
% doDegradation = 1;
% mse = [0 0];
% method = 1.12;
% for i = 1:length(listing)
%     % inpath = fullfile('D:\RefPic\',listing(i).name);
%     inpath = fullfile('F:\Picture\my wallpapers\w\',listing(i).name);
%     if size(imread(inpath),3)==3
%         mse(1)=evaluations(inpath,outpath,doDegradation,method);
%         cd(pwd0);
%         close all
%         if i == 1
%             mse(2) = mse(1);
%         end
%         mse(2) = (mse(1) + mse(2))/2.0;
%         disp([i mse(2)])
%     end
% end
