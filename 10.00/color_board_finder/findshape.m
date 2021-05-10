function W = findshape(E,K)

[L,N]=bwlabel(E);

%% distance map for non-edge pixels
[D,Di]=bwdist(E);
G=fspecial('gaussian',7);
D=conv2(D,G,'same');
P = double(imregionalmax(D));
Q = conv2(P.*D,G,'same');

H = 0;
for n=1:N
    
    M = L==n;
    
    % centroids
    [x,y]= find(M);
        
    xbar = round(mean(x));
    ybar = round(mean(y));

    if (L(Di(xbar,ybar))==n)&(xbar>K)&(ybar>K)&(xbar<size(E,1)-K)&(ybar<size(E,2)-K)

        % crop neighborhood
        M0 = M(xbar+[-K:K],ybar+[-K:K]);
        
        if sum(M0(:))>0
            % distance map
            D0 = bwdist(M0).^.5;
            
            % recentered distnace map
            H = H + D0*(Q(xbar,ybar));
        end
    end

end

H = H-min(H(:));
H = H/max(H(:));
W = exp(-H/.2);


