function X=locatecc(Q,I)

% ColorChecker will be located on the peaks of Q.

%% find Q peaks
K = Qpeaks(Q); 
[x,y]=find(K>0);

%% construct a distance matrix

% (X,Y)=difference vector in cartesian
X = x*ones(1,length(x))-ones(length(x),1)*x';
Y = y*ones(1,length(y))-ones(length(y),1)*y';
Y(X~=0) = Y(X~=0).*sign(X(X~=0)); % standardize vector angles to 0-pi
X = abs(X);

% (D,T)=difference vector in polar
[T,D] = cart2pol(Y,X);

%% resort by distance
[D,ind]=sort(D,1); % sort by neighbors
X = resort(X,ind); % sort in the same order as D
Y = resort(Y,ind); % sort in the same order as D
T = resort(T,ind); % sort in the same order as D


%% choose "top 24 reliable" estimates ( C(1:24) below )

if length(x)<18
    X=[];
    disp(['CCFind ERROR: Could not find recurring shapes.\n']);
    return;
end
[~,C]=sort(sum(D(2:6,:),1));% closest 3 neighbors

x = x(C(1:min(24,length(x))));
y = y(C(1:min(24,length(x))));
X = X(:,C(1:min(24,length(x))));
Y = Y(:,C(1:min(24,length(x))));
T = T(:,C(1:min(24,length(x))));
D = D(:,C(1:min(24,length(x))));


%% find a "top 1 reliable" estimate
% land inside CC
xbar = median(x);
ybar = median(y);
% find an actual peak closest to the median
d = (x-xbar).^2+(y-ybar).^2;
[~,ind]=min(d);
Xbar = x(ind); Ybar = y(ind);


%% find the distance between neighboring squares
tol=10/180*pi;

% find most popular angle/directions
t = popular(T(2:6,:));

% select two most popular angles
dt1 = abs(T(2:4,:)-t(1)); % deviations
dt2 = abs(T(2:4,:)-t(2)); 
it1 = find(dt1(:)<tol); % index
it2 = find(dt2(:)<tol);
d = D(2:4,:);
d1 = median(d(it1)); % representative magnitude
d2 = median(d(it2));

[dy1,dx1] = pol2cart(t(1),d1);
[dy2,dx2] = pol2cart(t(2),d2);


%% template for ColorChecker
% two possibilities, since we don't know if V1/V2 corresponds to
% horizontal/vertical

% template candidate 1
DX1 = dx1*([0:3]'*[1 1 1 1 1 1])+dx2*([1;1;1;1]*[0:5]);
DY1 = dy1*([0:3]'*[1 1 1 1 1 1])+dy2*([1;1;1;1]*[0:5]);

% template candidate 2
DX2 = dx2*([0:3]'*[1 1 1 1 1 1])+dx1*([1;1;1;1]*[0:5]);
DY2 = dy2*([0:3]'*[1 1 1 1 1 1])+dy1*([1;1;1;1]*[0:5]);

%% test 48 possible scenarios

S1 = zeros(24,1);
for m=1:24
    for n=1:24
        x = round(Xbar + DX1(n)-DX1(m));
        y = round(Ybar + DY1(n)-DY1(m));
        
        if (x>0)&(y>0)&(x<size(Q,1))&(y<size(Q,2))
            S1(m)=S1(m)+Q(x,y);
        else 
            S1(m)=-inf;
        end
    end
end

S2 = zeros(24,1);
for m=1:24
    for n=1:24
        x = round(Xbar + DX2(n)-DX2(m));
        y = round(Ybar + DY2(n)-DY2(m));
        
        if (x>0)&(y>0)&(x<size(Q,1))&(y<size(Q,2))
            S2(m)=S2(m)+Q(x,y);
        else 
            S2(m)=-inf;
        end
    end
end

%% find maximum Q arrangement
[s1,m1] = max(S1);
[s2,m2] = max(S2);

if max(s1,s2)<0
  X=[];
  disp(['CCFind ERROR: Could not find a match.\n']);
  return;
end

if s1>s2
    X=Xbar + DX1-DX1(m1);
    Y=Ybar + DY1-DY1(m1);
else
    X=Xbar + DX2-DX2(m2);
    Y=Ybar + DY2-DY2(m2);
end

%% find the orientation of CC

% I1 = max(I(round(X(1)),round(Y(1)),:));
% I6 = max(I(round(X(6)),round(Y(6)),:));
% I19 = max(I(round(X(19)),round(Y(19)),:));
% I24 = max(I(round(X(24)),round(Y(24)),:));
% 
% [~,S]=min([I1,I6,I19,I24]);

%% override of finding the orientation of CC

%display image for picking white and black square
figure;
imshow(I,[]);%hold on
title('Specify orentation. Pick white square first, then black square.');
[squares_coordinates] = ginput(2);
squares_coordinates=floor(squares_coordinates+1);
close;

orentation_vector = [
    squares_coordinates(2)-squares_coordinates(1)
    squares_coordinates(4)-squares_coordinates(3) 
];

if abs(orentation_vector(1)) > abs(orentation_vector(2))
    if orentation_vector(1)> 0
        S = 3;
    else
        S = 2;
    end
else
    if orentation_vector(2)> 0
        S = 3;
    else
        S = 2;
    end
end
 
switch S
    case 1
        X = X(end:-1:1,end:-1:1);
        Y = Y(end:-1:1,end:-1:1);
    case 2
        X = X(end:-1:1,:);
        Y = Y(end:-1:1,:);
    case 3
        X = X(:,end:-1:1);
        Y = Y(:,end:-1:1);
end

X=X'; Y=Y';
%X=[X(:),Y(:)];
%X=round(X);

%% recenter X to the middle of the squares
G = fspecial('gaussian',11,3); 
P = imregionalmax(conv2(max(Q,0),G,'same')); % find peaks
[x,y]=find(P); 
I =  knnsearch([x,y],[X(:),Y(:)]);

d = min(dx1.^2+dy1.^2,dx2.^2+dy2.^2)/2;
D = (x(I(:))-X(:)).^2+(y(I(:))-Y(:)).^2;

X = [x(I(:)).*(D<d) + X(:).*(D>=d),y(I(:)).*(D<d) + Y(:).*(D>=d)];

X=round(X);
return;


%%%%%%%%%%%%%%%%%%%%%%%%
function K=Qpeaks(Q)

%% initialize
K=zeros(size(Q));
tol = 3^2;

%% find peaks of Q
G = fspecial('gaussian',11,3); 
P = imregionalmax(conv2(max(Q,0),G,'same')); % find peaks
[x,y]=find(P); 

%% various "checks" to eliminate unwanted ones
[L,N]=bwlabel(Q>0); % Q>0 is a candidate for the shape we want

for n = 1:length(x);

    %% find Q>0 regions connected to peak
    [X,Y] = find(L==L(x(n),y(n)));

    %% compute statistics of Q>0 region
    % centroids
    xbar = mean(X);
    ybar = mean(Y);
    
    % recenter
    X = X-xbar;
    Y = Y-ybar;
    % directional variances
    Vx = mean(X.^2); % vertical
    Vy = mean(Y.^2); % horizontal
    XY = sqrt(.5)*[1 -1;1 1]*[X';Y'];
    Vx0 = mean(XY(1,:).^2); % diagonal
    Vy0 = mean(XY(2,:).^2); % diagonal

    %% check #1: Q peaks == centroid of Q>0
    C1 = ((x(n)-xbar).^2 + (y(n)-ybar).^2)< tol;
    
    %% check #2: if Q>0 symmetric, variances are similar
    C2 = max([Vx,Vy,Vx0,Vy0])<min([Vx,Vy,Vx0,Vy0])*8;
    
    % my score
    K(x(n),y(n))=C1*C2;

end



function X = resort(X,ind)

for n=1:size(X,2)
    X(:,n)=X(ind(:,n),n);
end

function x = popular(X)

% histogram
[H,R] = hist(X(:),100);

% Gaussian filter
G = exp(-(-10:10).^2/(2*9));
h = conv2(H(:),G(:),'full');
% circular convolution
H = h(11:end-10);
H(1:10)=H(1:10)+h(end-9:end);
H(end-9:end)=h(1:10)+H(end-9:end);


% find peaks
P =[(H(1)>H(2))&(H(1)>H(end));(H(2:end-1)>H(1:end-2))&(H(2:end-1)>H(3:end));(H(end)>H(end-1))&(H(end)>H(1))];

% sort peak hights
H(P==0)=-inf;
[~,I]=sort(H);
I = I(end:-1:1);

x = R(I(P(I)==1));



