function g=homomorphic(f)


J=double(f);
f_high = 2.5;
f_low = 0.5;

%gauss_low_filter = fspecial('gaussian', [7 7], 1.414);
gauss_low_filter = fspecial('gaussian', [3 3], 1);
matsize = size(gauss_low_filter);

gauss_high_filter = zeros(matsize);
gauss_high_filter(ceil(matsize(1,1)/2) , ceil(matsize(1,2)/2)) = 1.0;
gauss_high_filter = f_high*gauss_high_filter - (f_high-f_low)*gauss_low_filter;

log_img = log(double(f)+1);
 high_log_part = imfilter(log_img, gauss_high_filter, 'symmetric', 'conv');

high_part = exp(high_log_part);
minv = min(min(high_part));
maxv = max(max(high_part));
g=(high_part-minv)/(maxv-minv);



