function Is = strechimage(data)
s=0.003;bins=2000;
[ht,b]=imhist(data,bins);
[m,n]=size(data);
d=cumsum(ht)./double(m*n);
lmin=1;lmax=bins;
while lmin<bins
     if d(lmin)>s
         break;
     end    
     lmin=lmin+1;
end    
while lmax>1
     if d(lmax)<=1-s
         break;
     end    
     lmax=lmax-1;
end

Is=((data-b(lmin))./(b(lmax)-b(lmin))); 
Is(find(Is>1))=1;
Is(find(Is<0))=0;

end