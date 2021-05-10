function C = analyzecc(X,I)

if isempty(X)
    C = [];
else
    
    % distance between squares
    DX = mean([mean(X(2:6,:)-X(1:5,:),1);mean(X(8:12,:)-X(7:11,:),1);mean(X(14:18,:)-X(13:17,:),1);mean(X(20:24,:)-X(19:23,:),1)]);
    DY = mean([mean(X(7:6:24,:)-X(1:6:18,:),1);mean(X(8:6:24,:)-X(2:6:18,:),1);mean(X(9:6:24,:)-X(3:6:18,:),1);mean(X(10:6:24,:)-X(4:6:18,:),1);mean(X(11:6:24,:)-X(5:6:18,:),1);mean(X(12:6:24,:)-X(6:6:18,:),1)]);
    
    % square
    DX = round(DX/4);
    DY = round(DY/4);
    
    % grab colors
    C = zeros(size(I,3),24);
    for n=1:24
        M = zeros(size(I,1),size(I,2));
        M(X(n,1)+DX(1)+DY(1),X(n,2)+DX(2)+DY(2)) = 1;
        M(X(n,1)+DX(1)-DY(1),X(n,2)+DX(2)-DY(2)) = 1;
        M(X(n,1)-DX(1)+DY(1),X(n,2)-DX(2)+DY(2)) = 1;
        M(X(n,1)-DX(1)-DY(1),X(n,2)-DX(2)-DY(2)) = 1;
        H = bwconvhull(M);
        
        for c=1:size(I,3)
            C(c,n) = sum(sum(I(:,:,c).*H))/sum(H(:));
        end
    end
end
