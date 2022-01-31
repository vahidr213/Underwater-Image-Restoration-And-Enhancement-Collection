function imrestored = permutefunction(funclist,img,im1)
for i = 1:length(funclist)
    switch funclist(i)
       case 0
          continue
        case 1
            im1 = colorcorrection(funclist(i),im1,0.1);
        case 10
            im1 = colorcorrection(funclist(i),im1,2);
        case 11
            im1=colorcorrection(funclist(i),img,im1);
         otherwise
            im1 = colorcorrection(funclist(i),im1);            
    end
end
imrestored = im1;
end