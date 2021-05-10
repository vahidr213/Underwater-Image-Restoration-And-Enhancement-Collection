function [output_rbg,picked_rbg] = colors_picking( output_im, pick_im,n_samples,color_space)
%pick color coordinates from figures
%   output_im - reference color board
%   pick_im - testing condition color board
%   n_samples - number of colors to pick

    addpath('color_board_finder/');

    LABcolorTransform = makecform('srgb2lab');

    %preallcate arrays for picked colors
    picked_rbg=zeros(3,n_samples);
    output_rbg=zeros(3,n_samples);
    picked_red=zeros(n_samples);
    picked_green=zeros(n_samples);
    picked_blue=zeros(n_samples);
    output_red=zeros(n_samples);
    output_green=zeros(n_samples);
    output_blue=zeros(n_samples);
    
picking_method_choice = questdlg(...
    'Which method of picking colors would you choose? (Automatic - need Macbeth ColorBoard image)''', ...
    'Choose colors picking method', ...
    'Manual','Automatic','Manual');
switch picking_method_choice
    case 'Manual'      
        load_points_loc_choice = questdlg(...
        'Load picked points location?', ...
        'Load picked points location', ...
        'Yes','No','Yes');
    switch load_points_loc_choice
        case 'Yes'
            [mat_path,full_path] = uigetfile('*.mat;','Mat file (*.mat)',...
            fullfile(mfilename('fullpath'),'..','picked_points_loc.mat'));
            if (mat_path==0)
                return
            end
            full_mat_path=fullfile(full_path,mat_path);
            load(full_mat_path);
            points_loc_loaded = 1;
        case 'No'
            points_loc_loaded = 0;
    end

    if exist('p_in','var') == 0
        %display first image for picking
        figure;
        imshow(pick_im,[]);%hold on
        p_in = ginput(n_samples);
        p_in=floor(p_in+1);
        close;
    end

    if strcmp(color_space,'LAB')
        pick_im_lab = applycform(im2double(pick_im), LABcolorTransform);
    end

    for i=1:size(p_in,1)
        picked_red(i) = pick_im_lab(p_in(i,2),p_in(i,1),1);
        picked_green(i) = pick_im_lab(p_in(i,2),p_in(i,1),2);
        picked_blue(i) = pick_im_lab(p_in(i,2),p_in(i,1),3);
        picked_rbg(:,i) = [picked_red(i);picked_green(i);picked_blue(i)];
    end
    
    visualize_picked_color_points(picked_rbg, pick_im, p_in(:,1), p_in(:,2))
    
    results_ok = questdlg(...
        'Are you satisfied with picked colors?', ...
        'Picked colors check', ...
        'Yes','No','Yes');
    % Handle response
    switch results_ok
        case 'Yes'
            % pass
        case 'No'
            close
            return
    end
    
    pick_same_points_ok = questdlg(...
        'Pick same points coordinates as in previous image?', ...
        'Same coordinates', ...
        'Yes','No','Yes');
    % Handle response
    switch pick_same_points_ok
        case 'Yes'
            p_out = p_in;
        case 'No'
            %pass
    end
    
    if exist('p_out','var') == 0
        %display second image for picking
        figure;
        imshow(output_im,[]);hold on
        p_out = ginput(n_samples);
        p_out=floor(p_out+1);
        close;
    end
    
    if strcmp(color_space,'LAB')
        output_im_lab = applycform(im2double(output_im), LABcolorTransform);
    end

   
    for i=1:size(p_out,1)
        output_red(i) = output_im_lab(p_out(i,2),p_out(i,1),1);
        output_green(i) = output_im_lab(p_out(i,2),p_out(i,1),2);
        output_blue(i) = output_im_lab(p_out(i,2),p_out(i,1),3);
        output_rbg(:,i) = [output_red(i);output_green(i);output_blue(i)];
    end
    
    visualize_picked_color_points(output_rbg, output_im, p_out(:,1), p_out(:,2))
    
    if points_loc_loaded == 0
        save_points_loc_choice = questdlg(...
            'Save picked points location?', ...
            'Save picked points location', ...
            'Yes','No','Yes');
        switch save_points_loc_choice
            case 'Yes'
                [mat_path,full_path] = uiputfile('*.mat;','Mat file (*.mat)',...
                fullfile(mfilename('fullpath'),'..','picked_points_loc.mat'));
                if (mat_path==0)
                    return
                end
                full_mat_path=fullfile(full_path,mat_path);
                save(full_mat_path,'p_in','p_out');
            case 'No'
                %pass
        end
    end
    
case 'Automatic'
        
        [p1,~] = CCFind(imresize(pick_im,1/3));
        p1 = p1*3;
        if isempty(p1), [p1,~] = CCFind(pick_im); end
        if isempty(p1), return; end
        
        if strcmp(color_space,'LAB')
            pick_im_lab = applycform(im2double(pick_im), LABcolorTransform);
        end

        for i=1:size(p1,1)
            picked_red(i) = pick_im_lab(p1(i,1),p1(i,2),1);
            picked_green(i) = pick_im_lab(p1(i,1),p1(i,2),2);
            picked_blue(i) = pick_im_lab(p1(i,1),p1(i,2),3);
            picked_rbg(:,i) = [picked_red(i);picked_green(i);picked_blue(i)];
        end
        
        visualize_picked_color_points(picked_rbg, pick_im, p1(:,2), p1(:,1))
        
        if strcmp(color_space,'LAB')
            output_im_lab = applycform(im2double(output_im), LABcolorTransform);
        end
        [p2,~] = CCFind(imresize(output_im,1/3));
        p2 = p2*3;
        if isempty(p2), [p2,~] = CCFind(output_im); end
        if isempty(p2), return; end
        
        for i=1:size(p2,1)
            output_red(i) = output_im_lab(p2(i,1),p2(i,2),1);
            output_green(i) = output_im_lab(p2(i,1),p2(i,2),2);
            output_blue(i) = output_im_lab(p2(i,1),p2(i,2),3);
            output_rbg(:,i) = [output_red(i);output_green(i);output_blue(i)];
        end
        
        visualize_picked_color_points(output_rbg, output_im, p2(:,2), p2(:,1))

end

end

