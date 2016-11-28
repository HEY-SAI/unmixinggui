function varargout = organ_viewer(varargin)
% ORGAN_VIEWER M-file for organ_viewer.fig
%      ORGAN_VIEWER, by itself, creates a new ORGAN_VIEWER or raises the existing
%      singleton*.
%
%      H = ORGAN_VIEWER returns the handle to a new ORGAN_VIEWER or the handle to
%      the existing singleton*.
%
%      ORGAN_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ORGAN_VIEWER.M with the given input arguments.
%
%      ORGAN_VIEWER('Property','Value',...) creates a new ORGAN_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before organ_viewer_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to organ_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help organ_viewer

% Last Modified by GUIDE v2.5 07-Jul-2008 14:33:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @organ_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @organ_viewer_OutputFcn, ...
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


% --- Executes just before organ_viewer is made visible.
function organ_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to organ_viewer (see VARARGIN)

% Choose default command line output for organ_viewer
clc;

handles.output = hObject;
handles.X = evalin('base','tblob');
handles.N = size(handles.X);
for i = 1:5;   handles.populated(i) = 1;   end

handles.colormap = [0 0 0; 0.25 0.25 0.25; 0.5 0.5 0.5; 1 1 1 ];
guidata(hObject,handles);
selectAll_Callback(handles.selectAll,eventdata,handles);
guidata(hObject,handles);
show(hObject, eventdata, handles);
guidata(hObject, handles);

% UIWAIT makes organ_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = organ_viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function change_State(hObject,index)
get(hObject,'Value')
if get(hObject,'Value') == 0 
    set(hObject,'Value',1);
    handles.populated(index) = 1;
else
    set(hObject,'Value',0);
    handles.populated(index) = 0;
end
guidata(hObject,handles);

function setTo1(hObject,index)
set(hObject,'Value',1);
handles.populated(index) = 1;
guidata(hObject,handles);

function setTo0(hObject,index)
set(hObject,'Value',0);
handles.populated(index) = 0;
guidata(hObject,handles);

function show(hObject,eventdata, handles)
temp = zeros(handles.N(1),handles.N(2));
for i = 1:5
    if handles.populated(i) == 1 
        temp = temp + handles.X(:,:,i);
    end
end
axes(handles.axes1);
imagesc(sum(handles.X,3));
colormap(handles.colormap);
axis image off

% --- Executes on button press in organ buttons.
function organ1_Callback(hObject, eventdata, handles)
change_State(hObject,1);
show(handles);
guidata(hObject,handles);

function organ2_Callback(hObject, eventdata, handles)
change_State(hObject,2);
guidata(hObject,handles);
function organ3_Callback(hObject, eventdata, handles)
change_State(hObject,3);
guidata(hObject,handles);
function organ4_Callback(hObject, eventdata, handles)
change_State(hObject,4);
guidata(hObject,handles);
function organ5_Callback(hObject, eventdata, handles)
change_State(hObject,5);
guidata(hObject,handles);

% --- Executes on button press in clearAll.
function clearAll_Callback(hObject, eventdata, handles)
% hObject    handle to clearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setTo0(handles.organ1,1);
setTo0(handles.organ2,2);
setTo0(handles.organ3,3);
setTo0(handles.organ4,5);
setTo0(handles.organ5,5);
guidata(hObject, handles);

% --- Executes on button press in selectAll.
function selectAll_Callback(hObject,eventdata, handles)
% hObject    handle to selectAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setTo1(handles.organ1,1);
setTo1(handles.organ2,2);
setTo1(handles.organ3,3);
setTo1(handles.organ4,5);
setTo1(handles.organ5,5);
guidata(hObject, handles);