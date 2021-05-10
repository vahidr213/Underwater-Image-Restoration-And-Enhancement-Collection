function Q=locateshape(E,W)

%% create mask
H = bwconvhull(W>0.5);
H = H-5*ordfilt2(H,1,ones(ceil(0.125*sqrt(sum(H(:))))*2+1));
H = H(end:-1:1,end:-1:1);

%% find cost
Q = conv2(double(E),H,'same');
