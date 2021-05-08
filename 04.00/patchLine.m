function [ lambdas ,p1 ,p2, v, p] = patchLine( I , onlyPositive )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

showGraph = 0;
w = size(I,1);
numPx = w*w;

D = zeros(numPx,1);

P = reshape(I,numPx,3);
P = P(any(P,2),:);
numPx = size(P,1);

[d v] = pca(P);
p = mean(P);
v = v'*0.3;
p1 = p+v;
p2 = p-v;
if(showGraph)
    figure, plot3(P(:,1),P(:,2),P(:,3),'.');
    L = [p1;p2];
    hold on
    plot3(L(:,1),L(:,2),L(:,3));
    hold off
end

sig = sign(v);
if(~onlyPositive || ~any(sig-sig(1)))
    v = v*sig(1);
    p1 = p-v;
    p2 = p+v;
    V = repmat(v,numPx,1);
    PQ = P-repmat(p1,numPx,1);
    
    PQxV = cross(PQ,V);
    D = sqrt(PQxV(:,1).^2 + PQxV(:,2).^2 + PQxV(:,3).^2)/norm(v);
    

    [D IX] = sort(D);

    numClose = round(0.8*numPx);

    P = P(IX(1:numClose),:);

    [d v] = pca(P);
    p = mean(P);
    v = v'*0.3;
    p1 = p+v;
    p2 = p-v;

    distFromOrigin = norm(cross(v,-p1))/norm(v);

    lambdas = [d(3) d(3)/(d(2)+0.00000001) distFromOrigin];
    if(showGraph)
        figure, plot3(P(:,1),P(:,2),P(:,3),'.');
        L = [p1;p2];
        hold on
        plot3(L(:,1),L(:,2),L(:,3));
        hold off
    end
    v = v/norm(v);
    sig = sign(v);
    
    if(onlyPositive && sum(sig-sig(1))~=0)
        lambdas = [0 0 0];
    end
    
    v = v * sig(1);
else
    lambdas = [0 0 0];
end

end

