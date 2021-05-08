function [ A ] = findOrientation( I, showFigures )
%find the Airlight orientation
% 
n = 10; % patch size
mxSize = max(size(I,1), size(I,2));
if  mxSize<600
    factor = max(600/mxSize,2);
    I = imresize(I,factor,'bilinear');
    I(I<0) = 0;
    I(I>1) = 1;
end
if(showFigures)
    figure, imagesc(I), axis image, truesize;
end
%gray = rgb2gray(I);
% detect the edge, canny operator
%edges = edge(gray,'canny',0.1);
%if(showFigures)
%    figure, imagesc(edges), axis image, truesize;
%end

w = size(I,2);
h = size(I,1);

counter = 0;
%disp('calc all patches...')
indLocs = zeros(w*h,2);
for ind=1:w*h
    y = 1 + floor((ind-1)/w);
    x = ind - (y-1)*w;
    % prevent the index cross the border
    if(x > w-n+1 || y > h-n+1)
        continue;
    end
    % detect the existance of edge, if it does, discard this patch
    if(any(any(edges(y:y+n-1,x:x+n-1))))
        continue;
    end
    counter = counter + 1;
    % save the index of each patch
    indLocs(counter,:) = [y x];
end
L = zeros(counter,3);
P = zeros(counter,6);
locs = zeros(counter,2);

%if(~matlabpool('size'))
%    matlabpool
%end
for ind=1:counter
%parfor ind=1:counter
    loc = indLocs(ind,:);
    y = loc(1);
    x = loc(2);
    [lambdas,p1,p2,~,~] = patchLine(I(y:y+n-1,x:x+n-1,:),true);
    if(any(lambdas>0.00001))
        L(ind,:) = lambdas;
        P(ind,:) = [p1 p2];  
        locs(ind,:) = [y x];
    end
end

legits = any(L,2);
L = L(legits,:);
P = P(legits,:);
locs = locs(legits,:);

N = cross(P(:,1:3),P(:,4:6));
Nnorms = sqrt(N(:,1).^2 + N(:,2).^2 + N(:,3).^2);
N = [N(:,1)./Nnorms N(:,2)./Nnorms N(:,3)./Nnorms];

L1 = L(:,1);
L2 = L(:,2);
L3 = L(:,3);

L1 = sort(L1,'descend');
L2 = sort(L2,'descend');
L3 = sort(L3,'descend');

thresh = [L1(50) L2(50) L3(50)];

T = repmat(thresh,size(L,1),1);
Diff = sum(L >= T,2);
goodInds = find(Diff==3);
nGood = length(goodInds);
%disp('choose good patches...')
%lower thresholds until there are 10 patches
found = false;
ang = 15;
othresh = thresh;

while(~found)
    ang = ang-1;
    thresh = othresh;
    good = ones(size(L,1),1);
    approvedNormals = [];
    approvedPoints = [];
    approvedLocations = [];
    while(nGood < 10 && sum(good)>0)
        thresh = thresh*0.97;
        T = repmat(thresh,size(L,1),1);
        Diff = sum(L >= T,2) + good;
        goodInds = find(Diff==4);
        nGood = length(goodInds) + size(approvedNormals,1);
        if(nGood>=10)
            normals = N(goodInds,:);
            points = P(goodInds,:);
            locations = locs(goodInds,:);
            [normals,points,locations,deleted] =deleteParallelVecs(...
                normals,points,locations,goodInds,ang);
            approvedNormals = [approvedNormals;normals];
            approvedPoints = [approvedPoints;points];
            approvedLocations = [approvedLocations;locations];
            good(deleted) = 0;
            for i=1:size(normals,1)
                good = good & dot(N,repmat(normals(i,:)...
                    ,size(N,1),1),2)<=cos(deg2rad(ang));
            end
            
            nGood = size(approvedNormals,1);
        end
    end
    if(nGood>=10)
        found = true;
    end
end

normals = approvedNormals;
points = approvedPoints;

%disp('calc A/norm(A)...')
As = zeros((nGood*(nGood-1))/2,3);
counter = 0;
%get candidates from all intersections
for i=1:nGood
    for j=i+1:nGood
        curA = cross(normals(i,:),normals(j,:));
        sig = sign(curA);
        %if planes are not parallel, 
        %and A is all positive direction (or all negative)
        if(norm(curA) > 10^-7 && ~any(sig-sig(1))) 
            counter = counter + 1;
            curA = sig(1)*curA/norm(curA);
            As(counter,:) = curA;
        end
    end
end
nAs = counter;
As = As(1:nAs,:);
distances = zeros(nAs,nGood);
%evaluate the distances from the candidates
for i=1:nAs
    for j=1:nGood
        p2 = points(j,4:6);
        p1 = points(j,1:3);
        ori = p2 - p1;
        oriXA = cross(ori,As(i,:));
        distances(i,j) = abs(dot(p1,oriXA)/norm(oriXA));
    end
end
%remove 2 smallest distances from each candidate(they should be 0..)
distances = sort(distances,2);
distances = distances(:,3:end);
%find medians of each line
meds = median(distances,2);
%return A(argmin(medians))
argmin = find(meds == min(meds));
argmin = argmin(1);
A = As(argmin,:);

end





function [N,P,L,deleted]=deleteParallelVecs(N,P,L,inds,ang)
sz = size(N,1);
deleted = [];
for i=sz:-1:1
    for j=1:i-1
        %if the angle is less than 15
        if(dot(N(i,:),N(j,:))>cos(deg2rad(ang)))
            N(i,:) = [];
            P(i,:) = [];
            L(i,:) = [];
            deleted = [deleted inds(i)];
            break;
        end
        
    end
end
end

