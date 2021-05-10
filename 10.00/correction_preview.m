function varargout = correction_preview(varargin)
% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @correction_preview_OpeningFcn, ...
        'gui_OutputFcn',  @correction_preview_OutputFcn, ...
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


% --- Executes just before correction_preview is made visible.
function correction_preview_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for correction_preview
    handles.output = hObject;
    clc
    handles.input_im = varargin{1}.input_im;
    handles.picked_colors = varargin{1}.picked_colors;
    handles.basedir = pwd;
     
    picked_colors_presets=dir(fullfile(handles.basedir,'picked_colors/*.mat'));
    for i=1:length(picked_colors_presets)
        load([fullfile(handles.basedir,'picked_colors/') picked_colors_presets(i).name],...
            'picked_rbg','output_rbg');
        preset_picked_colors{i} = struct('picked_rbg', picked_rbg,'output_rbg',output_rbg);
        T = estimate_initial_color_t_matrix(...
            output_rbg(1,:)', output_rbg(2,:)', output_rbg(3,:)',...
            picked_rbg(1,:)', picked_rbg(2,:)', picked_rbg(3,:)',0);
        result_img=transform_by_color_matrix(T, handles.input_im);
        preset_images{i} = result_img;
    end
    handles.preset_images = preset_images;
    handles.preset_picked_colors = preset_picked_colors;
   
    handles.max_pages = ceil(length(picked_colors_presets)/4);
    handles.current_page = 1;
    handles.offset = (handles.current_page-1)*4;
    update_view(handles);
    % Update handles structure
    guidata(hObject, handles);
    uiwait(handles.correction_preview);

% --- Outputs from this function are returned to the command line.
function varargout = correction_preview_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.picked_colors;
    delete(handles.correction_preview);

function update_view(handles)   
    offset = handles.offset;
    imshow(handles.preset_images{1+offset},'InitialMagnification', 'fit', 'parent', handles.preset_1_axes);
    if offset+2 < length(handles.preset_images)
        imshow(handles.preset_images{2+offset},'InitialMagnification', 'fit', 'parent', handles.preset_2_axes);
    else
        imshow(zeros(100),'InitialMagnification', 'fit', 'parent', handles.preset_2_axes);
    end
    if offset+3 < length(handles.preset_images)
        imshow(handles.preset_images{3+offset},'InitialMagnification', 'fit', 'parent', handles.preset_3_axes);
    else
        imshow(zeros(100),'InitialMagnification', 'fit', 'parent', handles.preset_3_axes);
    end
    if offset+4 < length(handles.preset_images)
        imshow(handles.preset_images{4+offset},'InitialMagnification', 'fit', 'parent', handles.preset_4_axes);
    else
        imshow(zeros(100),'InitialMagnification', 'fit', 'parent', handles.preset_4_axes);
    end
    set(handles.text_page_indicator, 'String', ['Page: ' num2str(handles.current_page) '/' num2str(handles.max_pages)]);
    
function preset_1_Callback(hObject, eventdata, handles)
    handles.picked_colors = handles.preset_picked_colors{1+handles.offset}
    guidata(hObject, handles);
    close(handles.correction_preview);

function preset_2_Callback(hObject, eventdata, handles)
    handles.picked_colors = handles.preset_picked_colors{2+handles.offset}
    guidata(hObject, handles);
    close(handles.correction_preview);

function preset_3_Callback(hObject, eventdata, handles)
    handles.picked_colors = handles.preset_picked_colors{3+handles.offset}
    guidata(hObject, handles);
    close(handles.correction_preview);

function preset_4_Callback(hObject, eventdata, handles)
    handles.picked_colors = handles.preset_picked_colors{4+handles.offset}
    guidata(hObject, handles);
    close(handles.correction_preview);

function enlarge_preset_1_Callback(hObject, eventdata, handles)
    figure();
    imshow(handles.preset_images{1+handles.offset});

function enlarge_preset_2_Callback(hObject, eventdata, handles)
    figure();
    imshow(handles.preset_images{2+handles.offset});

function enlarge_preset_3_Callback(hObject, eventdata, handles)
    figure();
    imshow(handles.preset_images{3+handles.offset});

function enlarge_preset_4_Callback(hObject, eventdata, handles)
    figure();
    imshow(handles.preset_images{4+handles.offset});


function prev_Callback(hObject, eventdata, handles)
    if handles.current_page ~= 1
        handles.current_page = handles.current_page - 1;
        handles.offset = (handles.current_page-1)*4;
        update_view(handles);
        guidata(hObject, handles);
    end

function next_Callback(hObject, eventdata, handles)
    if handles.current_page ~= handles.max_pages
        handles.current_page = handles.current_page + 1;
        handles.offset = (handles.current_page-1)*4;
        update_view(handles);
        guidata(hObject, handles);
    end


function correction_preview_CloseRequestFcn(hObject, eventdata, handles)
    if isequal(get(hObject, 'waitstatus'), 'waiting')
        uiresume(hObject);
    else
        delete(hObject);
    end
