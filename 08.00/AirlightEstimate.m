% Airlight Estimation
function A = AirlightEstimate(img, blocksize, showFigure)
im = img;
[M, N, ~] = size(im);
point = [0,0];
y = 1;
while M * N > blocksize
    [M, N, ~] = size(im);
    % divided image into 4 rectangular region
    subim{1} = im(1:floor(M/2), 1:floor(N/2), :);
    subim{2} = im(1:floor(M/2), floor(N/2)+1:end, :);
    subim{3} = im(floor(M/2)+1:end, 1:floor(N/2), :);
    subim{4} = im(floor(M/2)+1:end, floor(N/2)+1:end, :);
    % for each sub-image, calculate its score (mean substract std)
    s(1) = mean2(subim{1}(:,:,1)) - std2(subim{1}(:,:,1)) + ...
        mean2(subim{1}(:,:,2)) - std2(subim{1}(:,:,2)) + ...
        mean2(subim{1}(:,:,3)) - std2(subim{1}(:,:,3));
    s(2) = mean2(subim{2}(:,:,1)) - std2(subim{2}(:,:,1)) + ...
        mean2(subim{2}(:,:,2)) - std2(subim{2}(:,:,2)) + ...
        mean2(subim{2}(:,:,3)) - std2(subim{2}(:,:,3));
    s(3) = mean2(subim{3}(:,:,1)) - std2(subim{3}(:,:,1)) + ...
        mean2(subim{3}(:,:,2)) - std2(subim{3}(:,:,2)) + ...
        mean2(subim{3}(:,:,3)) - std2(subim{3}(:,:,3));
    s(4) = mean2(subim{4}(:,:,1)) - std2(subim{4}(:,:,1)) + ...
        mean2(subim{4}(:,:,2)) - std2(subim{4}(:,:,2)) + ...
        mean2(subim{4}(:,:,3)) - std2(subim{4}(:,:,3));
    % choose the region with highest score
    x = find(s == max(s));
    im = subim{x};
    if showFigure
        % below used for draw the select region
        startpoint = [1,1;1,floor(N/2)+1;floor(M/2)+1,1;...
            floor(M/2)+1,floor(N/2)+1];
        if y > 1
            point = point + startpoint(x,:);% + [-1, -1];
        else
            point = point + startpoint(x,:);
        end
        y = y + 1;
    end
end
% get the selected region
[M, N, ~] = size(im);
im = double(im);
im1 = sqrt((im(:,:,1)-255.0).^2 + (im(:,:,2)-255.0).^2 + ...
            (im(:,:,3)-255.0).^2);
[p, q] = find(im1 == min(min(im1)));
A = reshape(im(p(1),q(1),:), [1, 3]);
if showFigure
    % draw the patch in the original image
    [~, ~]=draw_rect(img,point,[M,N]);
end

% draw image with selected region
function [state,result]=draw_rect(data,pointAll,windSize)
% [state,result]=draw_rect(data,pointAll,windSize)
%          pointAll start location
%          windSize the patch size

rgb = [255 0 0];                                 
lineSize = 1;

windSize(1,1)=windSize(1,1);
windSize(1,2) = windSize(1,2);
if windSize(1,1) > size(data,1) ||...
        windSize(1,2) > size(data,2)
    state = -1;                                     
    disp('the window size is larger then image...');
    return;
end

result = data;
if size(data,3) == 3
    for k=1:3
        for i=1:size(pointAll,1)   
            result(pointAll(i,1),pointAll(i,2):pointAll(i,2)...
                +windSize(i,1),k) = rgb(1,k);   
            result(pointAll(i,1):pointAll(i,1)+windSize(i,2),...
                pointAll(i,2)+windSize(i,1),k) = rgb(1,k);
            result(pointAll(i,1)+windSize(i,2),pointAll(i,2):...
                pointAll(i,2)+windSize(i,1),k) = rgb(1,k);  
            result(pointAll(i,1):pointAll(i,1)+windSize(i,2),...
                pointAll(i,2),k) = rgb(1,k);  
            if lineSize == 2 || lineSize == 3
                result(pointAll(i,1)+1,pointAll(i,2):...
                    pointAll(i,2)+windSize(i,1),k) = rgb(1,k);  
                result(pointAll(i,1):pointAll(i,1)+...
                    windSize(i,2),pointAll(i,2)+...
                    windSize(i,1)-1,k) = rgb(1,k);
                result(pointAll(i,1)+windSize(i,2)-1,...
                    pointAll(i,2):pointAll(i,2)+...
                    windSize(i,1),k) = rgb(1,k);
                result(pointAll(i,1):pointAll(i,1)+windSize(i,2),...
                    pointAll(i,2)+1,k) = rgb(1,k);
                if lineSize == 3
                    result(pointAll(i,1)+1,pointAll(i,2):...
                        pointAll(i,2)+windSize(i,1),k) = rgb(1,k);   
                    result(pointAll(i,1):pointAll(i,1)+...
                        windSize(i,2),pointAll(i,2)+...
                        windSize(i,1)+1,k) = rgb(1,k);
                    result(pointAll(i,1)+windSize(i,2)+1,...
                        pointAll(i,2):pointAll(i,2)+...
                        windSize(i,1),k) = rgb(1,k);
                    result(pointAll(i,1):pointAll(i,1)+...
                        windSize(i,2),pointAll(i,2)+1,k) = rgb(1,k);
                end
            end
        end
    end
end
state = 1;
figure, imshow(uint8(result));