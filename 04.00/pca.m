function [d v] = pca(A)
%function pca

m = mean(A,1)'  ;
 
for c=1:3
    A(:,c) = A(:,c) - m(c) ;
end
 
A = A' * A ;
A = A / size(A,1) ;
 
 
[V D] = eig(A) ;
d = diag(D) ;
v = V(:,3) ;

end