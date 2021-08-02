clc
clear all
close all
if (exist ('OCTAVE_VERSION', 'builtin'))% for Octave
    pkg load image
    pkg load signal
end
inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\raw-890\';%path for reading image
delete I:\pic890\*.png
mkdir I:\pic890
outpath = 'I:\pic890\';% path for saving results
doDegradation = 0;
warning('off', 'all')% suppress all warnings
pwd0=pwd;%current dir
cd(pwd0);
listing = dir(fullfile(inpath,'*.png'));
size(listing)
listing = natsortfiles(listing);
method = 16.02;
n = 0;
msetotal =0;
totalpercentimprov = 0;
a=1;
b=size(listing);
for i = a:b
    inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\raw-890\';
    inpath = fullfile(inpath,listing(i).name);
    im = imread(inpath);
    if size(im,3) == 3
        n=n+1;
        v = [0.01 0.1 1];
        cd('./16.00/');
        imrestored = main2(doDegradation,inpath,v,7);
        cd(pwd0);
        imwrite(cat(2,imrestored,imread(inpath)),[outpath,listing(i).name]);        
        inpath = 'E:\MS\VisualStudio\opencv4.2exampleproject\reference 890\reference-890\';
        inpath = fullfile(inpath,listing(i).name);
        imref = imread(inpath);
        mse0 = immse(im,imref);
        mse1 = immse(imref,imrestored);
        msetotal = msetotal + mse1;
        percentimprov = 100*(1-mse1/mse0);
        totalpercentimprov = totalpercentimprov + percentimprov;
        fileID = fopen('I:\result.txt','a');
        fprintf(fileID,'%s\n',listing(i).name);
        fprintf(fileID,'mse: %.2f  per: %.2f  ', mse1, percentimprov);
        for j = 1:length(v)
            fprintf(fileID,'v: %.4f  ',v(j));
        end
        fprintf(fileID,'\n');
        fclose(fileID);% close the result.txt file
        % montage({imrestored imread(inpath)})
        fprintf('%d- avg mse: %.2f percentImpr:  %.2f\n',i, msetotal/n, percentimprov);
    end
end
fileID = fopen('I:\result.txt','a');
fprintf(fileID, 'avg mse: %.3f avg improve: %.3f \n\n\n\n', msetotal/n, totalpercentimprov/n);
fclose(fileID);%close the result.txt file