function varargout = correction_gui(varargin)
% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @correction_gui_OpeningFcn, ...
        'gui_OutputFcn',  @correction_gui_OutputFcn, ...
        'gui_LayoutFcn',  [] , ...
        'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
% End initialization code - DO NOT EDIT


% --- Executes just before correction_gui is made visible.
function correction_gui_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for correction_gui
    handles.output = hObject;
    clc;
    warning('off','all');
    handles.basedir = pwd;
    % Update handles structure
    guidata(hObject, handles);
    global LABcolorTransform;
    global RGBcolorTransform;
    LABcolorTransform = makecform('srgb2lab');
    RGBcolorTransform = makecform('lab2srgb');
    input_im=imread(fullfile(handles.basedir,'input_images','sample_4.jpg'));
    handles.input_im = input_im;
    axes(handles.input);
    imshow(input_im);
    ref_im=imread(fullfile(handles.basedir,'reference','2.jpg'));
    handles.ref_im = ref_im;
    axes(handles.reference);
    imshow(ref_im);
    load(fullfile(handles.basedir,'picked_colors','sample_4_picked_colors.mat'))
    load(fullfile(handles.basedir,'params','sample_4_params.mat'))
    handles.picked_colors = struct('picked_rbg', picked_rbg,'output_rbg',output_rbg);
    stt1 = sprintf('%1.3f',lambds(1));
    stt2 = sprintf('%1.3f',lambds(2));
    stt3 = sprintf('%1.3f',lambds(3));
    set(handles.lambda1, 'string',stt1);
    set(handles.lambda2, 'string',stt2);
    set(handles.lambda3, 'string',stt3);
    % Update handles structure
    guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = correction_gui_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;

% --- Executes on button press in load_input_im.
function load_input_im_Callback(hObject, eventdata, handles)
    global input_im_path
    [im_path,full_path] = uigetfile('*.jpg;*.png;','Image file (*.jpg,*.png)',fullfile(handles.basedir,'input_images'));
    if (im_path==0)
        return
    end
    full_im_path=fullfile(full_path,im_path);
    input_im_path = full_path;
    input_im=imread(full_im_path);
    axes(handles.input);
    imshow(input_im);
    handles.input_im = input_im;
    guidata(hObject, handles);

% --- Executes on button press in load_ref_im.
function load_ref_im_Callback(hObject, eventdata, handles)
    [im_path,full_path] = uigetfile('*.jpg;*.png;','Image file (*.jpg,*.png)',fullfile(handles.basedir,'reference'));
    if (im_path==0)
        return
    end
    full_im_path=fullfile(full_path,im_path);
    ref_im=imread(full_im_path);
    axes(handles.reference);
    imshow(ref_im);
    handles.ref_im = ref_im;
    guidata(hObject, handles);

function enlarge_input_Callback(hObject, eventdata, handles)
    figure();
    imshow(handles.input_im);

function enlarge_ref_Callback(hObject, eventdata, handles)
    figure();
    imshow(handles.ref_im);

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
    global LABcolorTransform;
    ref_im = handles.ref_im;
    input_im = handles.input_im;
    picked_rbg = handles.picked_colors.picked_rbg;
    output_rbg = handles.picked_colors.output_rbg;
    global result_image;
    global AB_Transformation
    ref_im_lab = applycform(im2double(ref_im), LABcolorTransform);
    input_im_lab = applycform(im2double(input_im), LABcolorTransform);
    lambda1=get(handles.lambda1, 'string');
    l1=str2double(lambda1);
    if (l1==0)
        msgbox(sprintf('Variable lambda_1 must be different than 0'),'Error','Error')
        return
    end
    lambda2=get(handles.lambda2, 'string');
    l2=str2double(lambda2);
    lambda3=get(handles.lambda3, 'string');
    l3=str2double(lambda3);
    w2=[1 0 0;0 1 0;0 0 1];
    [A,B]=estimate_Ab_matrix_trust_region_method(picked_rbg,output_rbg,input_im_lab,ref_im_lab,l1,l2,l3,w2);  
    AB=[A B];
    AB_Transformation = AB;
    result_image=transform_by_color_matrix(AB,input_im);
    figure;
    imshow(result_image);
    set(handles.save_result,'Enable','on');
    set(handles.Apply_All,'Enable','on');


function lambda1_Callback(hObject, eventdata, handles)

function lambda2_Callback(hObject, eventdata, handles)

function lambda3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function lambda1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function lambda2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function lambda3_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes on button press in demo1.
function demo1_Callback(hObject, eventdata, handles)
    input_im=imread(fullfile(handles.basedir,'input_images','sample_1.jpg'));
    axes(handles.input);
    imshow(input_im);
    ref_im=imread(fullfile(handles.basedir,'reference','3.jpg'));
    axes(handles.reference);
    imshow(ref_im);
    load(fullfile(handles.basedir,'picked_colors','sample_1_picked_colors.mat'))
    load(fullfile(handles.basedir,'params','sample_1_params.mat'))
    stt1 = sprintf('%1.3f',lambds(1));
    stt2 = sprintf('%1.3f',lambds(2));
    stt3 = sprintf('%1.3f',lambds(3));
    set(handles.lambda1, 'string',stt1);
    set(handles.lambda2, 'string',stt2);
    set(handles.lambda3, 'string',stt3);
    handles.picked_colors = struct('picked_rbg', picked_rbg,'output_rbg',output_rbg);
    handles.ref_im = ref_im;
    handles.input_im = input_im;
    guidata(hObject, handles);

% --- Executes on button press in demo2.
function demo2_Callback(hObject, eventdata, handles)
    input_im=imread(fullfile(handles.basedir,'input_images','sample_2.jpg'));
    axes(handles.input);
    imshow(input_im);
    ref_im=imread(fullfile(handles.basedir,'reference','6.jpg'));
    axes(handles.reference);
    imshow(ref_im);
    load(fullfile(handles.basedir,'picked_colors','sample_2_picked_colors.mat'))
    load(fullfile(handles.basedir,'params','sample_2_params.mat'))
    stt1 = sprintf('%1.3f',lambds(1));
    stt2 = sprintf('%1.3f',lambds(2));
    stt3 = sprintf('%1.3f',lambds(3));
    set(handles.lambda1, 'string',stt1);
    set(handles.lambda2, 'string',stt2);
    set(handles.lambda3, 'string',stt3);
    handles.picked_colors = struct('picked_rbg', picked_rbg,'output_rbg',output_rbg);
    handles.ref_im = ref_im;
    handles.input_im = input_im;
    guidata(hObject, handles);

% --- Executes on button press in demo3.
function demo3_Callback(hObject, eventdata, handles)
    input_im=imread(fullfile(handles.basedir,'input_images','sample_3.jpg'));
    axes(handles.input);
    imshow(input_im);
    ref_im=imread(fullfile(handles.basedir,'reference','2.jpg'));
    axes(handles.reference);
    imshow(ref_im);
    load(fullfile(handles.basedir,'picked_colors','sample_3_picked_colors.mat'))
    load(fullfile(handles.basedir,'params','sample_3_params.mat'))
    stt1 = sprintf('%1.3f',lambds(1));
    stt2 = sprintf('%1.3f',lambds(2));
    stt3 = sprintf('%1.3f',lambds(3));
    set(handles.lambda1, 'string',stt1);
    set(handles.lambda2, 'string',stt2);
    set(handles.lambda3, 'string',stt3);
    handles.picked_colors = struct('picked_rbg', picked_rbg,'output_rbg',output_rbg);
    handles.ref_im = ref_im;
    handles.input_im = input_im;
    guidata(hObject, handles);

function load_calib1_Callback(hObject, eventdata, handles)
    global calib_im_underwater
    [im_path,full_path] = uigetfile('*.jpg;*.png;','Image file (*.jpg,*.png)',fullfile(handles.basedir,'color_board_underwater\'));
    if (im_path==0)
        return
    end
    full_im_path=fullfile(full_path,im_path);
    calib_im_underwater=imread(full_im_path);

function load_calib2_Callback(hObject, eventdata, handles)
    global calib_im_abovewater
    [im_path,full_path] = uigetfile('*.jpg;*.png;','Image file (*.jpg,*.png)',fullfile(handles.basedir,'color_board_above_water\'));
    if (im_path==0)
        return
    end
    full_im_path=fullfile(full_path,im_path);
    calib_im_abovewater=imread(full_im_path);

function points_picking_Callback(hObject, eventdata, handles)
    global calib_im_underwater;
    global calib_im_abovewater;
    if (isempty(calib_im_underwater) || isempty(calib_im_abovewater))
        warndlg('Calib pictures not loaded');
        return
    end
    n_samples=get(handles.num_samples, 'string');
    n_samples=str2num(n_samples);
    if (n_samples==0)
        set(handles.num_samples,'string','24');
        warndlg('Number of picked colors must be different than 0')
        return
    end
    [output_rbg,picked_rbg] = colors_picking(calib_im_abovewater,calib_im_underwater,n_samples,'LAB');
    handles.picked_colors = struct('picked_rbg', picked_rbg,'output_rbg',output_rbg);
    guidata(hObject, handles);

function load_picked_points_Callback(hObject, eventdata, handles)
    [mat_path,full_path] = uigetfile('*.mat;','Mat file (*.mat)',fullfile(handles.basedir,'picked_colors','sample_1_picked_colors.mat'));
    if (mat_path==0)
        return
    end
    full_mat_path=fullfile(full_path,mat_path);
    load(full_mat_path);
    handles.picked_colors = struct('picked_rbg', picked_rbg,'output_rbg',output_rbg);
    guidata(hObject, handles);

function save_picked_points_Callback(hObject, eventdata, handles)
    picked_rbg = handles.picked_colors.picked_rbg;
    output_rbg = handles.picked_colors.output_rbg;
    [mat_path,full_path] = uiputfile('*.mat;','Mat file (*.mat)',fullfile(handles.basedir,'picked_colors','new_picked_colors.mat'));
    if (mat_path==0)
        return
    end
    full_mat_path=fullfile(full_path,mat_path);
    save(full_mat_path,'output_rbg','picked_rbg');

function num_samples_Callback(hObject, eventdata, handles)

function num_samples_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function save_result_Callback(hObject, eventdata, handles)
    global result_image;
    [im_path,full_path] = uiputfile('*.png;','Image file (*.png)',fullfile(handles.basedir,'results','new_image.png'));
    if (im_path==0)
        return
    end
    full_im_path=fullfile(full_path,im_path);
    imwrite(result_image,full_im_path);


% --- Executes on button press in Apply_All.
function Apply_All_Callback(hObject, eventdata, handles)
    global AB_Transformation;
    file_list=uipickfiles('Type',{ '*.jpg',   'JPG-files';'*.png', 'PNG-files' });
    if (iscell(file_list))
        if (isempty(file_list))
            return
        end
    elseif (file_list==0)
        return
    end
    output_folder = uigetdir('','Select save directory');
    if (output_folder==0)
            return
    end
    h= waitbar(0,'Processing...');
    for i=1:length(file_list)
        [~,name,ext] = fileparts(file_list{i});
        image_name = [name ext];
        dummy_image = imread(file_list{i});
        dummy_image_transformed = transform_by_color_matrix(AB_Transformation,dummy_image);
        imwrite(dummy_image_transformed,fullfile(output_folder,image_name))
        waitbar((i-2)/length(file_list),h,'Processing...')
    end
    delete(h);
    msgbox(sprintf('Multiple files processing finished!'),'Finished','Finished')


function visualize_color_mapping_Callback(hObject, eventdata, handles)
    picked_rbg = handles.picked_colors.picked_rbg;
    output_rbg = handles.picked_colors.output_rbg;
    output_points_rgb = lab2rgb(output_rbg(1:3,1:end)');
    picked_points_rgb = lab2rgb(picked_rbg(1:3,1:end)');
    
    output_colors_array = cat(3,...
        output_points_rgb(1:end,1)',...
        output_points_rgb(1:end,2)',...
        output_points_rgb(1:end,3)');
    
    picked_colors_array = cat(3,...
        picked_points_rgb(1:end,1)',...
        picked_points_rgb(1:end,2)',...
        picked_points_rgb(1:end,3)');
    figure;
    subplot(2,1,1)
    imshow(picked_colors_array,'InitialMagnification','fit')
    title('Colors picked from underwater image')
    subplot(2,1,2)
    imshow(output_colors_array,'InitialMagnification','fit')
    title('Colors picked from abovewater image')

% --- Executes on button press in back_button.
function back_button_Callback(hObject, eventdata, handles)
    main();
    close(handles.correction_gui);


function correction_presets_Callback(hObject, eventdata, handles)
    handles.picked_colors = correction_preview(handles);
    guidata(hObject, handles);


function correction_presets_by_ref_Callback(hObject, eventdata, handles)
    handles.ref_im = correction_preview_ref(handles);
    axes(handles.reference);
    imshow(handles.ref_im);
    guidata(hObject, handles);
