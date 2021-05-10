function [X,C] = CCFind(I)
% CCFind.m will detect the Macbeth color checker inside an image. It will
% return the coordinates for the center points of the squares.
%
%    [X,C]=CCFind(I)
%        I: input image (grayscale, color, multispectral)
%        X: center points of colorchecker squares
%        C: colors corresponding to the squares
%     X and C are empty if the detection was unsuccessful.
%
% This code is copyrighted by PI Keigo Hirakawa. The softwares are for 
% research use only. Use of software for commercial purposes without a 
% prior agreement with the authors is strictly prohibited. We do not 
% guarantee the code’s accuracy. We would appreciate if acknowledgments 
% were made for the use of CCFind in your projects and publications.  
% Please cite it as:
%
% K. Hirakawa, "Color Checker Finder," accessed from 
%    http://campus.udayton.edu/~ISSL/software.
%


%% parameters
K = round(min(size(I,1),size(I,2))/15);

%% initialization
if isstr(I)
   I = imread(I); % read if string
end
I = max(double(I),0); 

if size(I,3)==3
    I = rgb2gray(I/max(I(:))); % color => grayscale
elseif size(I,3)>1
    I = mean(I,3); % multispectral => grayscale
end
I = I/max(I(:));


%% find edge
[E,E0] = findedge(I);

%% find shape
W = findshape(E0,K);

%% locate shape
Q = locateshape(E0,W);

%% locate CC
 X = locatecc(Q,I);

%% analyze CC
C = analyzecc(X,I);

%% visualize CC
% uncomment below to see results.
% visualizecc(I.^(1/2.2),X);

