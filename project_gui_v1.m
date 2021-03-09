function varargout = project_gui_v1(varargin)
% PROJECT_GUI_V1 MATLAB code for project_gui_v1.fig
%      PROJECT_GUI_V1, by itself, creates a new PROJECT_GUI_V1 or raises the existing
%      singleton*.
%
%      H = PROJECT_GUI_V1 returns the handle to a new PROJECT_GUI_V1 or the handle to
%      the existing singleton*.
%
%      PROJECT_GUI_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT_GUI_V1.M with the given input arguments.
%
%      PROJECT_GUI_V1('Property','Value',...) creates a new PROJECT_GUI_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project_gui_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project_gui_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project_gui_v1

% Last Modified by GUIDE v2.5 14-Apr-2016 23:53:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project_gui_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @project_gui_v1_OutputFcn, ...
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


% --- Executes just before project_gui_v1 is made visible.
function project_gui_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project_gui_v1 (see VARARGIN)

% Choose default command line output for project_gui_v1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes project_gui_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project_gui_v1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadImage.
function loadImage_Callback(hObject, eventdata, handles)
% hObject    handle to loadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.jpg';'*.bmp'}, 'File Selector');
image = strcat(pathname, filename);
axes(handles.axes1)
imshow(image)
set(handles.edit1,'String',image);



% --- Executes on button press in estimateBlur.
function estimateBlur_Callback(hObject, eventdata, handles)
% hObject    handle to estimateBlur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ip=get(handles.edit1,'String');
ip=imread(ip);
ip=rgb2gray(ip);
ip = medfilt2(abs(ip));
fin = fft2(ip);

lgfin = abs(log(1 + abs(fin)));

cin = ifft2(lgfin);

THETA=0;

cinrot = imrotate(cin, -THETA);

for i=1:size(cinrot, 2)
    avg(i) = 0;
    for j=1:size(cinrot, 1)
        avg(i) = avg(i) + cinrot(j, i);
    end
    avg(i) = avg(i)/size(cinrot, 1);
end
avgr = real(avg);

index = 0;
for i = 1:round(size(avg,2)),
    if real(avg(i))<0,
        index = i;
        break;
    end
end

if index~=0,
    LEN = index;
else
    %If Zero Crossing not found then find the lowest peak
    %Calculating the blur length using Lowest Peak
    index = 1;
    startval = avg(index);
    for i = 1 : round(size(avg, 2)/2),
        if startval>avg(i),
            startval = avg(i);
            index = i;
        end
    end

    LEN = index;
end
LEN = num2str(LEN);
set(handles.edit2,'String',LEN);



% --- Executes on button press in speed.
function speed_Callback(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d=str2num(get(handles.dist,'String'));
cc=str2num(get(handles.ccd,'String'));
t=str2num(get(handles.shutterSpeed,'String'));
fl=str2num(get(handles.f,'String'));
bl=str2num(get(handles.edit2,'String'));

v=(d*bl*cc*18)/(1000*t*fl*5);

v=num2str(v);
set(handles.es,'String',v);



% --- Executes on button press in restoreImage.
function restoreImage_Callback(hObject, eventdata, handles)
% hObject    handle to restoreImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LEN=str2num(get(handles.edit2,'String'));
SNR=str2num(get(handles.snrtxt,'String'));
THETA = 0;
ip=get(handles.edit1,'String');
ip=imread(ip);
ip=rgb2gray(ip);

PSF = fspecial('motion', LEN, THETA);
% op = deconvwnr(ip, PSF, SNR);
op = deconvlucy(ip,PSF,10);
axes(handles.axes2)
imshow(op)

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function es_Callback(hObject, eventdata, handles)
% hObject    handle to es (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of es as text
%        str2double(get(hObject,'String')) returns contents of es as a double


% --- Executes during object creation, after setting all properties.
function es_CreateFcn(hObject, eventdata, handles)
% hObject    handle to es (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dist_Callback(hObject, eventdata, handles)
% hObject    handle to dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dist as text
%        str2double(get(hObject,'String')) returns contents of dist as a double


% --- Executes during object creation, after setting all properties.
function dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_Callback(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f as text
%        str2double(get(hObject,'String')) returns contents of f as a double


% --- Executes during object creation, after setting all properties.
function f_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ccd_Callback(hObject, eventdata, handles)
% hObject    handle to ccd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ccd as text
%        str2double(get(hObject,'String')) returns contents of ccd as a double


% --- Executes during object creation, after setting all properties.
function ccd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ccd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function shutterSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to shutterSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of shutterSpeed as text
%        str2double(get(hObject,'String')) returns contents of shutterSpeed as a double


% --- Executes during object creation, after setting all properties.
function shutterSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shutterSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in snr.
function snr_Callback(hObject, eventdata, handles)
% hObject    handle to snr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ip=get(handles.edit1,'String');
ip=imread(ip);
ip=rgb2gray(ip);
R = str2num(sprintf('%.4f', 1/size(ip, 2)));
R=num2str(R);
set(handles.snrtxt,'String',R);


function snrtxt_Callback(hObject, eventdata, handles)
% hObject    handle to snrtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of snrtxt as text
%        str2double(get(hObject,'String')) returns contents of snrtxt as a double


% --- Executes during object creation, after setting all properties.
function snrtxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to snrtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
