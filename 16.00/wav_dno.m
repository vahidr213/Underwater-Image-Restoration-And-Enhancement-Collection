function X0 = wav_dno(X)

[height width]=size(X);
Y1=double(X);
A=X;
wname='sym3 ';
n=3;
th=0.03; %固定阈值

[c,s]=wavedec2(A,n,wname);
 
for i=1:3
step(i)=s((i+1),1)*s((i+1),2);  %得到高频每层分解系数的长度
end
num(1,1)=s(1,1)*s(1,2)+1; %获取各层各高频分量在c向量中的坐标  H|V|D
num(1,2)=num(1,1)+s(2,1)*s(2,2);
num(1,3)=num(1,2)+s(2,1)*s(2,2);
 
num(2,1)=num(1,3)+s(2,1)*s(2,2);
num(2,2)=num(2,1)+s(3,1)*s(3,2);
num(2,3)=num(2,2)+s(3,1)*s(3,2);
 
num(3,1)=num(2,3)+s(3,1)*s(3,2);
num(3,2)=num(3,1)+s(4,1)*s(4,2);
num(3,3)=num(3,2)+s(4,1)*s(4,2);
 
C=c;
Y=c;
for i=1:3
    [H,V,D]=detcoef2('a',c,s,i);
    B=[H V D];
    [L,T]=size(B);

    ch=c(1,num(4-i,1):num(4-i,3)+step(4-i)-1);
    chl=length(ch);
    for j=1:chl
        if abs(ch(j))>=th
            ch(j)=sign(ch(j))*(abs(ch(j))-th);%软阈值处理函数
            ych(j)=ch(j);
        else
            ch(j)=0;
            ych(j)=0;
        end
    end

    C(1,num(4-i,1):num(4-i,3)+step(4-i)-1)=ch(1,1:chl); 
end
X0=waverec2(C,s,wname);

% figure
% imshow(X0);title('软阈值去噪后图像');
