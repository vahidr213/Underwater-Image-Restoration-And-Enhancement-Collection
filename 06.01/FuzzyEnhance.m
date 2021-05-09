function outval = FuzzyEnhance(img)
xt=graythresh(real(img)) + sqrt(-1) * graythresh(imag(img));
x=img;
[m,n]=size(x);
xmax=max(max(x));
p=zeros(m,n);
p1=zeros(m,n);
I=zeros(m,n);
%Fe=2;
%Fd=52;

for i=1:m
    for j=1:n
        if x(i,j)<=xt
            p(i,j)=(1/2)*(x(i,j)/xt)^2;
        else
            p(i,j)=1-(1/2)*((xmax-x(i,j))/(xmax-xt))^2;
        end
    end
end
times=1;
for k=1:times
    for i=1:m
        for j=1:n
            if p(i,j)<=0.500
                p1(i,j)=2*p(i,j)^2;
            else
                p1(i,j)=1-2*(1-p(i,j)^2);
            end
        end
    end
    p=p1;
end
for i=1:m
    for j=1:n
        if x(i,j)<=xt
            I(i,j)=((2*p(i,j))^(1/2))*xt;
        else
            I(i,j)=xmax-((2*(1-p(i,j)))^(1/2))*(xmax-xt);
        end
    end
end
outval = I;