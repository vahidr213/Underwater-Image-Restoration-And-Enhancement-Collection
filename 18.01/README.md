To generate targets easily from Y, we have used the following code which uses the heaviside function value 0.5 at input zero. This property can be used for using numeric label 5 as the null operation.

     load X
     load Y
     t = zeros(25,890);
     for i=1:890

         t(Y(i,3)+10*(1-heaviside(Y(i,3))),i) = 1;

     end
     net = patternnet(i);
     net = train(net,repmat(X',1,100),repmat(t,1,100));



