function varargout = correction_preview_ref(varargin)
% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @correction_preview_ref_OpeningFcn, ...
        'gui_OutputFcn',  @correction_preview_ref_OutputFcn, ...
        'gui_LayoutFcn',  [], ...
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


% --- Executes just before correction_preview_ref is made visible.
function correction_preview_ref_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for correction_preview_ref
    handles.output = hObject;
    clc
    handles.input_im = varargin{1}.input_im;
    handles.ref_im = varargin{1}.ref_im;
    handles.picked_colors = varargin{1}.picked_colors;
    
    picked_rbg = handles.picked_colors.picked_rbg;
    output_rbg = handles.picked_colors.output_rbg;

    l1=str2double(get(varargin{1}.lambda1, 'string'));
    l2=str2double(get(varargin{1}.lambda2, 'string'));
    l3=str2double(get(varargin{1}.lambda3, 'string'));
    
    handles.basedir = pwd;
     
    refs_presets_list=dir(fullfile(handles.basedir,'reference/*.jpg'));
    for i=1:length(refs_presets_list)
        refs_presets{i} = imread([fullfile(handles.basedir,'reference/') refs_presets_list(i).name]);
        
        LABcolorTransform = makecform('srgb2lab');
        ref_im_lab = applycform(im2double(refs_presets{i}), LABcolorTransform);
        input_im_lab = applycform(im2double(handles.input_im), LABcolorTransform);
        [A,B]=estimate_Ab_matrix_trust_region_method(picked_rbg,output_rbg,input_im_lab,ref_im_lab,l1,l2,l3,eye(3));  
        result_img=transform_by_color_matrix([A B], handles.input_im);
        preset_images{i} = result_img;
    end
    handles.preset_images = preset_images;
    handles.refs_presets = refs_presets;
   
    handles.max_pages = ceil(length(refs_presets_list)/4);
    handles.current_page = 1;
    handles.offset = (handles.current_page-1)*4;
    update_view(handles);
    % Update handles structure
    guidata(hObject, handles);
    uiwait(handles.correction_preview_ref);

% --- Outputs from this function are returned to the command line.
function varargout = correction_preview_ref_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.ref_im;
    delete(handles.correction_preview_ref);

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
    
function preset_1_ref_Callback(hObject, eventdata, handles)
    handles.ref_im = handles.refs_presets{1+handles.offset};
    guidata(hObject, handles);
    close(handles.correction_preview_ref);

function preset_2_ref_Callback(hObject, eventdata, handles)
    handles.ref_im = handles.refs_presets{2+handles.offset};
    guidata(hObject, handles);
    close(handles.correction_preview_ref);

function preset_3_ref_Callback(hObject, eventdata, handles)
    handles.ref_im = handles.refs_presets{3+handles.offset};
    guidata(hObject, handles);
    close(handles.correction_preview_ref);

function preset_4_ref_Callback(hObject, eventdata, handles)
    handles.ref_im = handles.refs_presets{4+handles.offset};
    guidata(hObject, handles);
    close(handles.correction_preview_ref);

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

% --- Executes when user attempts to close correction_preview_ref.
function correction_preview_ref_CloseRequestFcn(hObject, eventdata, handles)
    if isequal(get(hObject, 'waitstatus'), 'waiting')
        uiresume(hObject);
    else
        delete(hObject);
    end
