function J = dehazingProcess(img, T, A)
% J(:, :, 1) = (img(:, :, 1) - A(1)) ./ T + (1 - A(1)) * A(1);
% J(:, :, 2) = (img(:, :, 2) - A(2)) ./ T + (1 - A(2)) * A(2);
% J(:, :, 3) = (img(:, :, 3) - A(3)) ./ T + (1 - A(3)) * A(3);
% figure,imshow(J)
%
img = SimplestColorBalanceP(img, 0.5, 'double');
Max = max(mean2(img(:,:,1)), max(mean2(img(:,:,2)), mean2(img(:,:,3))));
r = double(Max / mean2(img(:,:,1)));
g = double(Max / mean2(img(:,:,2)));
b = double(Max / mean2(img(:,:,3)));
Tr = T.^(r*0.8);
Tg = T.^(g*0.8);
Tb = T.^(b*0.8);
%figure,imshow([Tr, ones(size(Tr,1), 50), Tg, ones(size(Tr,1), 50), Tb],[])
J(:, :, 1) = (img(:, :, 1) - A(1)) ./ Tr + A(1);
J(:, :, 2) = (img(:, :, 2) - A(2)) ./ Tg + A(2);
J(:, :, 3) = (img(:, :, 3) - A(3)) ./ Tb + A(3);
% figure,imshow(J)

% for x = 1 : size(T,1)
%     for y = 1 : size(T,2)
%         rgb(x,y) = max(img(x,y,1), max(img(x,y,2), img(x,y,3)));
%     end
% end
% 
% r = double(rgb) ./ double(img(:,:,1));
% g = double(rgb) ./ double(img(:,:,2));
% b = double(rgb) ./ double(img(:,:,3));

% Tr = T;
% Tg = T;
% Tb = T;
% 
% J(:, :, 1) = (img(:,:,1) - A(1)) ./ Tr + A(1);
% J(:, :, 2) = (img(:,:,2) - A(2)) ./ Tg + A(2);
% J(:, :, 3) = (img(:,:,3) - A(3)) ./ Tb + A(3);
%figure,imshow(J)

% J(:, :, 1)=(J(:, :, 1) - min(min(J(:, :, 1)))) / ...
%             (max(max(J(:, :, 1))) - min(min(J(:, :, 1)))) * 0.5;
% J(:, :, 2)=(J(:, :, 2) - min(min(J(:, :, 2)))) / ...
%             (max(max(J(:, :, 2))) - min(min(J(:, :, 2)))) * 0.5;
% J(:, :, 3)=(J(:, :, 3) - min(min(J(:, :, 3)))) / ...
%             (max(max(J(:, :, 3))) - min(min(J(:, :, 3)))) * 0.5;
