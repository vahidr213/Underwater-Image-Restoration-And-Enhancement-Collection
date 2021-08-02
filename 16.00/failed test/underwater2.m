clc
clear all
close all
format short g
format compact

if (exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    pkg load image
    pkg load signal
end
foldern = 'DeepBlue';
inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\';%path for reading image
inpath = [inpath,foldern,'\'];
outpath = 'I:\';% path for saving results
doDegradation = 2.0; % 0/1  - if 0, the image itself is restored.
%%% if 1, image is degraded at first, then the degraded image is restored back again by
%%% available methods to its original. use this only if you have perfect underwater image
%%% and you want to see the mean squared error.
warning('off', 'all')% suppress all warnings
% num = 5;%suffix for reading frame
pwd0=pwd;%current dir
cd(pwd0);
% parpool(2)
%%%% running one method over a big dataset
%%%% comment the following lines if you don't 
listing = dir(fullfile(inpath,'*.jpg'));
% load listing.mat
% size(listing)
doDegradation = 2.0;
method = 16.02;
n = 1;
msetotal = 0;
a = 1;
b = 20;
mkdir I:\main
for i = a:b
    inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\';
    inpath = [inpath,foldern,'\'];
    outpath = 'I:\main\';% path for saving results
    outpath = [outpath,foldern,' '];
    inpath = fullfile(inpath, listing(i).name);
    if size(imread(inpath),3) == 3
        listing(i).name
        outpath = [outpath,listing(i).name,' '];
        options = optimset('TolFun', 5e-2, 'TolX', 5e-2, 'MaxFunEvals', 60, 'Display','iter','PlotFcns',@optimplotfval);
        v = [0.003 0.003 1];  gs = 11;        
        fun = @(v)(evaluations2(inpath,outpath,doDegradation,method,v,gs))
        [v, mse] = fmincon(fun,v,[],[],[],[],[0 0 0.3],[0.9 0.9 15],[],options);
        msetotal = msetotal + mse;
        cd(pwd0);
        close all
        fprintf('pic: %d   avg mse: %.4f    msetotal: %.4f \n',i, msetotal/n, msetotal);
        [im, imref] = load_image(doDegradation,inpath);
        mse0 = immse(im,imref);%error for initial image before restoration
        percentimprov = 100*(1-mse/mse0);
        fileID = fopen('I:\result.txt','a');
        fprintf(fileID,'%s \n',foldern);            
        fprintf(fileID,'%s\n',listing(i).name);
        for j = 1:length(v)
            fprintf(fileID,'v: %.4f  ',v(j));
        end
        fprintf(fileID,'mse: %.2f  per: %.2f\n', mse, percentimprov);
        fclose(fileID);%close the result.txt file
        n = n + 1;
        results1(i,:) = [i v gs mse];
    end
end
load I:\results.mat
results = cat(1,results,results1);
save('I:\results.mat','results');
fileID = fopen('I:\result.txt','a');
fprintf(fileID, 'avg mse: %.4f \n\n\n\n', msetotal/n);
fclose(fileID);




% %%%%% %%%%%%%%%%%%%%%%%%%%%
% foldern = 'frontView';
% inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\Chlorophyll\';%path for reading image
% inpath = [inpath,foldern,'\'];
% listing = dir(fullfile(inpath,'*.jpg'));
% % load listing.mat
% % size(listing)
% doDegradation = 2.1;
% method = 16.02;
% a = 16;
% b = 21;
% mkdir I:\main
% for i = a:b
%     inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\Chlorophyll\';%path for reading image
%     inpath = [inpath,foldern,'\'];
%     outpath = 'I:\main\';% path for saving results
%     outpath = [outpath,foldern,' '];
%     inpath = fullfile(inpath, listing(i).name);
%     if size(imread(inpath),3) == 3
%         listing(i).name
%         % try
%             % mse = evaluations(inpath,outpath,doDegradation,method);
%             outpath = [outpath,listing(i).name,' '];
%             options = optimset('TolFun', 1e-2, 'TolX', 1e-2, 'MaxFunEvals', 30, 'Display','iter','PlotFcns',@optimplotfval);
%             v = [0.003];
%             fun = @(v)(evaluations2(inpath,outpath,doDegradation,method,v))
%             [v, mse] = fminsearch(fun,v,options);
%             msetotal = msetotal + mse;
%             cd(pwd0);
%             close all
%             fprintf('pic: %d   avg mse: %.4f    msetotal: %.4f \n',i, msetotal/n, msetotal);
%             [im, imref] = load_image(doDegradation,inpath);
%             mse0 = immse(im,imref);%error for initial image before restoration
%             percentimprov = 100*(1-mse/mse0);
%             fileID = fopen('I:\result.txt','a');
%             fprintf(fileID,'%s \n',foldern);            
%             fprintf(fileID,'%s\n',listing(i).name);
%             for j = 1:length(v)
%                 fprintf(fileID,'v: %.4f  ',v(j));
%             end
%             fprintf(fileID,'mse: %.2f  per: %.2f\n', mse, percentimprov);
            
%             n = n + 1; 
%         % catch
%         %     disp('failure in the code')
%         %     continue
%         % end        
%     end
% end

% fileID = fopen('I:\result.txt','a');
% fprintf(fileID, 'avg mse: %.4f \n\n\n\n', msetotal/n);
% fclose(fileID);




% %%%%% %%%%%%%%%%%%%%%%%%%%%
% foldern = 'sideView';
% inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\Chlorophyll\';%path for reading image
% inpath = [inpath,foldern,'\'];
% listing = dir(fullfile(inpath,'*.jpg'));
% % load listing.mat
% % size(listing)
% doDegradation = 2.2;
% method = 16.02;
% a = 16;
% b = 21;
% mkdir I:\main
% for i = a:b
%     inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\Chlorophyll\';%path for reading image
%     inpath = [inpath,foldern,'\'];
%     outpath = 'I:\main\';% path for saving results
%     outpath = [outpath,foldern,' '];
%     inpath = fullfile(inpath, listing(i).name);
%     if size(imread(inpath),3) == 3
%         listing(i).name
%         % try
%             % mse = evaluations(inpath,outpath,doDegradation,method);
%             outpath = [outpath,listing(i).name,' '];
%             options = optimset('TolFun', 1e-2, 'TolX', 1e-2, 'MaxFunEvals', 30, 'Display','iter','PlotFcns',@optimplotfval);
%             v = [0.003];
%             fun = @(v)(evaluations2(inpath,outpath,doDegradation,method,v))
%             [v, mse] = fminsearch(fun,v,options);
%             msetotal = msetotal + mse;
%             cd(pwd0);
%             close all
%             fprintf('pic: %d   avg mse: %.4f    msetotal: %.4f \n',i, msetotal/n, msetotal);
%             [im, imref] = load_image(doDegradation,inpath);
%             mse0 = immse(im,imref);%error for initial image before restoration
%             percentimprov = 100*(1-mse/mse0);
%             fileID = fopen('I:\result.txt','a');
%             fprintf(fileID,'%s \n',foldern);            
%             fprintf(fileID,'%s\n',listing(i).name);
%             for j = 1:length(v)
%                 fprintf(fileID,'v: %.4f  ',v(j));
%             end
%             fprintf(fileID,'mse: %.2f  per: %.2f\n', mse, percentimprov);
            
%             n = n + 1; 
%         % catch
%         %     disp('failure in the code')
%         %     continue
%         % end        
%     end
% end

% fileID = fopen('I:\result.txt','a');
% fprintf(fileID, 'avg mse: %.4f \n\n\n\n', msetotal/n);
% fclose(fileID);





% %%%%% %%%%%%%%%%%%%%%%%%%%%
% foldern = 'Milk';
% inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\';%path for reading image
% inpath = [inpath,foldern,'\'];
% listing = dir(fullfile(inpath,'*.jpg'));
% % load listing.mat
% % size(listing)
% doDegradation = 2.3;
% method = 16.02;
% a = 7;
% b = 19;
% mkdir I:\main
% for i = a:b
%     inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\WaterDataSet\Turbid\TURBID 3D\';%path for reading image
%     inpath = [inpath,foldern,'\'];
%     outpath = 'I:\main\';% path for saving results
%     outpath = [outpath,foldern,' '];
%     inpath = fullfile(inpath, listing(i).name);
%     if size(imread(inpath),3) == 3
%         listing(i).name
%         % try
%             % mse = evaluations(inpath,outpath,doDegradation,method);
%             outpath = [outpath,listing(i).name,' '];
%             options = optimset('TolFun', 1e-2, 'TolX', 1e-2, 'MaxFunEvals', 30, 'Display','iter','PlotFcns',@optimplotfval);
%             v = [0.003];
%             fun = @(v)(evaluations2(inpath,outpath,doDegradation,method,v))
%             [v, mse] = fminsearch(fun,v,options);
%             msetotal = msetotal + mse;
%             cd(pwd0);
%             close all
%             fprintf('pic: %d   avg mse: %.4f    msetotal: %.4f \n',i, msetotal/n, msetotal);
%             [im, imref] = load_image(doDegradation,inpath);
%             mse0 = immse(im,imref);%error for initial image before restoration
%             percentimprov = 100*(1-mse/mse0);
%             fileID = fopen('I:\result.txt','a');
%             fprintf(fileID,'%s \n',foldern);            
%             fprintf(fileID,'%s\n',listing(i).name);
%             for j = 1:length(v)
%                 fprintf(fileID,'v: %.4f  ',v(j));
%             end
%             fprintf(fileID,'mse: %.2f  per: %.2f\n', mse, percentimprov);
            
%             n = n + 1; 
%         % catch
%         %     disp('failure in the code')
%         %     continue
%         % end        
%     end
% end

% fileID = fopen('I:\result.txt','a');
% fprintf(fileID, 'avg mse: %.4f \n\n\n\n', msetotal/n);
% fclose(fileID);
