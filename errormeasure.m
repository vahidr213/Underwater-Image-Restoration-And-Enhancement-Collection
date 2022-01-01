function [mse0,mse1,Pmse,sumMSE,sumPmse,sumSSIM,sumPSNR,FP,TP] = errormeasure(im,imref,imrestored,...
   sumMSE,sumPmse,sumSSIM,sumPSNR,FP,TP,opt)
   mse0 = immse(im,imref);
   mse1 = immse(imrestored,imref);
   Pmse = 100*(1-mse1/mse0);
   sumMSE = sumMSE + mse1;
   sumPmse = sumPmse + Pmse;
   FP=FP+1-heaviside(Pmse+eps);
   TP = TP + heaviside(Pmse-eps);
   if opt == 1
      ssim1 = ssim(imrestored,imref);
      sumSSIM = sumSSIM + ssim1;
      psnr1 = psnr(imrestored,imref);
      sumPSNR = sumPSNR + psnr1;
   end
end
