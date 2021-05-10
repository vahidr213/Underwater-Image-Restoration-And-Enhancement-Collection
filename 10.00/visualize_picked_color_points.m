function visualize_picked_color_points( picked_colours, image, points_x,points_y)

    %display previously picked colors
    figure;
    subplot(3,1,1)
    picked_colours_rgb = lab2rgb(picked_colours(1:3,1:end)');
    picked_colours_array = cat(3,...
        picked_colours_rgb(1:end,1)',...
        picked_colours_rgb(1:end,2)',...
        picked_colours_rgb(1:end,3)');
    imshow(picked_colours_array,'InitialMagnification','fit')
    title('Colors picked previously')
    subplot(3,1,[2 3])
    imshow(image,[]);hold on
    title('Points Picked')
    labels = cellstr( num2str([1:size(picked_colours,2)]') );
    plot(points_x, points_y, 'rx')
    text(points_x, points_y, labels, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right')
end

