function outval = HFEnphasizeFilter(I)

PQ = paddedsize(size(I));
% High Pass Filter
D0 = 0.05 * PQ(1);
HBW = hpfilter('btw', PQ(1), PQ(2), D0, 2);
 
% High Frequency Enphasize Filter
H = 0.5 + 2 * HBW;
outval = dftfilt(I, H);
% Contrast Limited Adaptive Histogram Equalization
%outval=adapthisteq(outval);
