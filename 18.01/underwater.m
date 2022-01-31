clc
clear all
close all
% delete(gcp('nocreate'))
inpath = 'E:\raw-890\';%path for reading image
inrefpath = 'E:\reference-890\';
outputTxtfilename = 'E:\result.xlsx'; averageresultsfilename='H:\average results.xlsx';
savePicResults = false;
if isfile(outputTxtfilename), delete(outputTxtfilename); end
% delete E:\pic890\*.png
% mkdir E:\pic890
outpath = 'E:\';% path for saving results
warning('off', 'all')% suppress all warnings
pwd0=pwd;%current dir
listing = dir(fullfile(inpath,'*.png'));listing = natsortfiles(listing);
sumMSE = 0.0; Pmse = 0.0; sumPmse = 0.0;sumSSIM = 0.0; sumPSNR = 0.0;FP=0;TP=0;
cv=[15 200 5 0.92 0.5];
n = 0; a=1; b=max(size(listing));res = zeros(b,10); %resultCell = cell(b,8);
load('indexofgroupr3.mat');load('MDL1');load('MDL2');load('MDL3');load('X');
dh=false;fe=0;colorspace=1;dclass=0; indx4r=(1:890)';
% v = optim_fun2(linspace(0.2,0.9,8),cv,indx4r',inpath,inrefpath,listing,MDL);cv(end)=v;return
tic;
for i = indx4r'
    im = imread(fullfile(inpath,listing(i).name));
    imref = imread(fullfile(inrefpath,listing(i).name));
    [imrestored,meanstd,classofimg,s] = main(im,cv,MDL1,MDL2,MDL3);
    if savePicResults == true, imwrite(cat(2,imrestored,imref),[outpath,listing(i).name]);end
%         if classofimg == 1.1, mse1=0;end
[mse0,mse1,Pmse,sumMSE,sumPmse,sumSSIM,sumPSNR,FP,TP] = errormeasure(im,imref,imrestored,sumMSE,sumPmse,sumSSIM,sumPSNR,FP,TP,fe);
    n=n+1;
    res(i,:)=[mse1,Pmse,meanstd,classofimg,i];
if classofimg==dclass,fprintf('%.1f\t%+.1f\t  c:%.1f  i:%d  S: %.2f  %.2f  %.2f  %.2f\n',res(i,[1 2 9 10]),s);end
if dh && classofimg==dclass,drawhistogram(im,imrestored,imref,sprintf('%.1f  %+.1f  c:%.1f i:%d  S: %.2f  %.2f  %.2f  %.2f',res(i,[1 2 9 10]),s),colorspace);end
end
fprintf('<mse:%.1f><Pmse:%.1f><FP:%d><TP:%d><PSNR:%.4f><SSIM:%.4f>\n',sumMSE/n, sumPmse/n,FP,TP,sumPSNR/n,sumSSIM/n);%<PSNR:%.4f><SSIM:%.4f>   ,sumPSNR/n,sumSSIM/n
timelapsed=toc/60;
sound(sin(1:3000));
saveresultsdialog(cv,sumMSE,n, sumPmse,FP,TP,res,outputTxtfilename,timelapsed)

function imrestored = main(img,varargin)
    im1 = img;
    MDL1=varargin{2};
    MDL2=varargin{3};
    MDL3=varargin{4};
    x = feature_extract(img);
    label1 = predict(MDL1,x);
    label2 = predict(MDL2,x);
    label3 = predict(MDL3,x);
    im1 = permutefunction([label1 label2 label3],img,im1);
    imrestored=im1;
end

function opt_v = optim_fun2(vec,cv,listofimages,inpath,inrefpath,listing,MDL)
msemin = 1e10;FPBEST=0;TPBEST=0;SUMPMSEBEST=0;fe=0;
for v1 = vec
   sumMSE=0;sumPmse=0;sumSSIM=0;sumPSNR=0;FP=0;TP=0;
    for i = listofimages
        im = imread(fullfile(inpath,listing(i).name));
        imref = imread(fullfile(inrefpath,listing(i).name));
        imrestored=main(im,[cv,v1],MDL);
[mse0,mse1,Pmse,sumMSE,sumPmse,sumSSIM,sumPSNR,FP,TP] = errormeasure(im,imref,imrestored,sumMSE,sumPmse,sumSSIM,sumPSNR,FP,TP,fe);        
%         mse0 = immse(im,imref);mse1=immse(imrestored,imref);Pmse=100*(1-mse1/mse0);
%         summse = summse + mse1;sumPmse = sumPmse + Pmse;
%         if Pmse<0,FP=FP+1;end
%         if Pmse>0,TP=TP+1;end
    end
    sumMSE = sumMSE/length(listofimages);
    sumPmse=sumPmse/length(listofimages);
    if msemin > sumMSE
        v = v1;msemin = sumMSE;FPBEST=FP;TPBEST=TP;SUMPMSEBEST=sumPmse;
    end
fprintf('<v:%+.3f><mse:%.1f><Pmse:%.1f><FP:%d><TP:%d>\n',v1,sumMSE, sumPmse,FP,TP);
end
fprintf('<v:%+.3f><mse:%.1f><Pmse:%.1f><FP:%d><TP:%d>\n',v,msemin,SUMPMSEBEST,FPBEST,TPBEST);
opt_v = v;
end

function result = cumul_sat(x,option)%cumulative saturation
switch option
case 1
    result = median(x)/mean(x)/255;
case 2
    result = 2*median(x)/mean(x)/255;
case 3
    result = std(x)/mean(x)/255;
case 4
    result = std(x)/(std(x)+mean(x))/255;
case 5
    result = median(x)/(median(x)+mean(x))/255;
end
end


function saveresultsdialog(cv,summse,n, sumPmse,FP,TP,res,outputTxtfilename,timelapsed)
currentfilename= mfilename('fullpath');
prompt =['\fontsize{20}',sprintf('%.2f <mse:%.1f><Pmse:%.1f><FP:%d><TP:%d >',timelapsed,summse/n, sumPmse/n,FP,TP)];
dlgtitle = currentfilename;
definput = {'0'};
dims = [1 150];
opts.Interpreter = 'tex';
answer = inputdlg(prompt,dlgtitle,dims,definput,opts);
if str2num(answer{1})>0
    load lastversion.mat
    res(:,1:8)=floor(res(:,1:8));
    Tableoffinalresults = table({'<mse>', summse/n, '<Pmse>', ...
        sumPmse/n,'<FP>',FP,'<TP>',TP,'<consts>',cv});
    Tableofallresults = table(res);
    if str2num(answer{1}) == 1
        lastversion = lastversion + 1;
    end
    writetable(Tableofallresults,outputTxtfilename);
    writetable(Tableoffinalresults,outputTxtfilename, 'WriteMode','Append');    
    outpath = ['E:\restorationtests\main',num2str(lastversion),'.xlsx'];
    copyfile(outputTxtfilename, outpath);
    outpath = ['E:\restorationtests\main',num2str(lastversion),'.m'];
    copyfile([currentfilename,'.m'], outpath);
    pause(1)
    fileID=fopen(outpath,'a');
    fwrite(fileID,fileread('E:\restorationtests\colorcorrection.m'));
    save lastversion.mat 'lastversion'
    delete(outputTxtfilename);
end

end



