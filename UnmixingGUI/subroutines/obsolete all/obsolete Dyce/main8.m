function varargout = main8(varargin)
% MAIN8 M-file for main8.fig
%      MAIN8, by itself, creates a new MAIN8 or raises the existing
%      singleton*.
%
%      H = MAIN8 returns the handle to a new MAIN8 or the handle to
%      the existing singleton*.
%
%      MAIN8('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN8.M with the given input arguments.
%
%      MAIN8('Property','Value',...) creates a new MAIN8 or raises the
%      existing singleton*.  Starting from the leftFrame, property value pairs are
%      applied to the GUI before main8_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main8_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help main8

% Last Modified by GUIDE v2.5 07-Jul-2008 17:29:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main8_OpeningFcn, ...
                   'gui_OutputFcn',  @main8_OutputFcn, ...
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


% --- Executes just before main8 is made visible.
function main8_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main8 (see VARARGIN)

% Choose default command line output for main8
handles.output = hObject;

%% basic initialization: image size, staring frame, number of frames.
clc;
Nstart = 10; % default
set(handles.startingFrame,'String','10');
rect = [16 207 493 461]; %load CRI_margins;
N(1) = rect(3)-rect(1)+1 ; % imagesize in one dimension
N(2) = rect(4)-rect(2)+1;
N(3) = 60; %default
set(handles.numberOfFrames,'String','60');

%% loads one mouse and puts one image just to look good.
x = zeros(N);
for i = 1:N(3)
    temp = uint16(imread( ...
        [dir1 mouse '\' mouse '_' num2str(Nstart + i -1,'%03g') '.tif']));
    x(:,:,i) = temp(rect(1):rect(3),rect(2):rect(4));
end

axes(handles.axes1); imagesc(x(:,:,1)); colormap('gray'); colorbar('EastOutside'); axis image off;
handles.colorbar = 'EastOutside';

%% path
dir1 = 'C:\Hillman_062607\DYCE Day 0\';
mouse = 'Mouse1';
handles.mouse = mouse;
handles.path = [dir1 mouse '\'];
set(handles.pathStaticText,'String',[handles.path handles.mouse]);

%% colormap
handles.mapSize = 256;
handles.map = colormap(gray(handles.mapSize));
set(handles.maxSlider,'Value',1);
set(handles.minSlider,'Value',0.5);

%% assign to handles
%x = evalin('base','x'); 
handles.x = x;
handles.N = N;
handles.deriv = zeros(handles.N);
handles.deriv2 = zeros(handles.N);
handles.stdWidth = 11;

%% organs initialization
for i = 1:9
    handles.organs(i) = struct('name',{''},'array',{zeros(1,N(3))},'rect',{[1 1 N(2) N(1)]},'X',{1},'Y',{1},'leftFrame',{1},'rightFrame',{N(3)},'populated',{0});
end
handles.organs(1).name = '1 - lungs       ';
handles.organs(2).name = '2 - Heart       ';
handles.organs(3).name = '3 - Brain       ';
handles.organs(4).name = '4 - Kidneys     ';
handles.organs(5).name = '5 - Liver       ';
handles.organs(6).name = '6 - Food        ';
handles.organs(7).name = '7 - Various1    ';
handles.organs(8).name = '8 - Various2    ';
handles.organs(9).name = '9 - Various3    ';


%% more initialization
handles.populated = 0;
handles.organIndex = 1;
handles.currentSlide = 1;
set(handles.currentSlideNumber,'String',num2str(handles.currentSlide));

% handles.names(1,:) = '1 - lungs          ';
% handles.names(2,:) = '2 - Heart          ';
% handles.names(3,:) = '3 - Brain          ';
% handles.names(4,:) = '4 - Kidneys        ';
% handles.names(5,:) = '5 - Liver          ';
% handles.names(6,:) = '6 - Food           ';
% handles.names(7,:) = '7 - Various1       ';
% handles.names(8,:) = '8 - Various2       ';
% handles.names(9,:) = '9 - Various3       ';

% %% setting the right left controls
% set(handles.leftText,'String',num2str(handles.organs(handles.organIndex).leftFrame));
% set(handles.rightText,'String',num2str(handles.organs(handles.organIndex).rightFrame));

handles.timeSampled = 1:handles.N(3);

%assignin('base','organs',handles.organs);
guidata(hObject,handles);
handles.currentSlide

% UIWAIT makes main8 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = main8_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% determines the current slide position
slider_position = get(hObject,'Value');
currentSlide = round(handles.N(3)*slider_position);
set(handles.currentSlideNumber,'String',num2str(currentSlide));
handles.currentSlide = currentSlide;


% puts the image according to the slider position
axes(handles.axes1);
index = get(handles.show,'Value');
switch index
    case(1)
        if get(handles.scale,'Value') == 1
            imagesc(handles.x(:,:,currentSlide));
        else
            image(scale(handles.x(:,:,currentSlide),handles.mapSize,0,4095));
        end
    case(2)
        if get(handles.scale,'Value') == 1
            imagesc(handles.deriv(:,:,currentSlide));
        else
            image(scale(handles.deriv(:,:,currentSlide),handles.mapSize,0,4095));
        end
    case(3)
        if get(handles.scale,'Value') == 1
            imagesc(handles.deriv2(:,:,currentSlide));
        else
            image(scale(handles.deriv2(:,:,currentSlide),handles.mapSize,0,4095));
        end
end

axis image off; colorbar off; colorbar(handles.colorbar); colormap(handles.map);

guidata(hObject,handles);
handles.currentSlide

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in collect_point_pushbutton.
function collect_point_pushbutton_Callback(hObject, eventdata, handles)

%determine the point coordinates
bool = true;
while bool 
    [mouseX, mouseY] = getpts(handles.axes1);
    if length(mouseX) ~= 1 
        msgbox('Chose only one point','Note','modal');
        clear mouseX mouseY
    else bool = false;
    end
end

areaY = round(mouseY) - 5: round(mouseY) + 5;
areaX = round(mouseX) - 5: round(mouseX) + 5;

% plots the profile at the right frame axes screen 
axes(handles.axes2);
index = get(handles.show,'Value');
if ((index > 1) | (index < handles.N(3)))
    switch index
        case(1)
            array = shiftdim( mean(mean( handles.x(areaY,areaX, ...
            handles.organs(handles.organIndex).leftFrame : ...
            handles.organs(handles.organIndex).rightFrame ),1),2),1);
        case(2)
            array = shiftdim( mean(mean( handles.deriv(areaY,areaX, ...
            handles.organs(handles.organIndex).leftFrame : ...
            handles.organs(handles.organIndex).rightFrame ),1),2),1);
        case(3)
            array = shiftdim( mean(mean( handles.deriv2(areaY,areaX, ...
            handles.organs(handles.organIndex).leftFrame : ...
            handles.organs(handles.organIndex).rightFrame ),1),2),1);
    end
end

if get(handles.standardDeviation,'Value') == 1
    array = array
end
plot(array);
axis auto;
%axis([1 handles.N(3) 0 1000]);

if (handles.organs(handles.organIndex).populated == 0)
    handles.populated = handles.populated + 1;
    handles.organs(handles.organIndex).populated = 1;
end

% saves the data
handles.organs(handles.organIndex).X = mouseX;
handles.organs(handles.organIndex).Y = mouseY;
handles.organs(handles.organIndex).array = array;
guidata(hObject,handles);
update_Callback(handles.update,eventdata,handles);

% --- Executes on selection change in organ_popup.
function organ_popup_Callback(hObject, eventdata, handles)
% Hints: contents = get(hObject,'String') returns organ_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from organ_popup

handles.organIndex = get(hObject, 'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function organ_popup_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in collect_ROI_pushbutton.
function collect_ROI_pushbutton_Callback(hObject, eventdata, handles)

% determines the ROI region for the organ in the popup menu
% organIndex = handles.organIndex;

handles.organs(handles.organIndex).rect = round(getrect(handles.axes1));

%organs(organIndex).upperRight = [rect(2) rect(1)];
%organs(organIndex).lowerLeft = [rect(2) + rect(4) rect(1) + rect(3)];
%set(handles.ROI_text,'String','de si be');
%assignin('base','ROI',ROI)
%get(handles.ROI_text)

guidata(hObject,handles);
update_Callback(handles.update,eventdata,handles);

% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
axes(handles.axes2);
plot(handles.organs(handles.organIndex).array);
handles.map = colormap(gray(round(str2double(get(hObject,'String')))));

s = [];
for i = 1:9
    str = [handles.names(i,:) ' ' num2str(handles.organs(i).rect) '            p.' num2str(handles.organs(i).populated)];
    s = vertcat(s,[str blanks(80 - size(str,2))]);
end
set(handles.organInfo,'String',s);

% --- Executes on button press in colorbar_radio.
function colorbar_radio_Callback(hObject, eventdata, handles)
% hObject    handle to colorbar_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of colorbar_radio
if get(hObject,'Value') == 1
    handles.colorbar = 'EastOutside';
else
    handles.colorbar = 'East';
end
axes(handles.axes1);
colorbar off;
colorbar(handles.colorbar);
guidata(hObject,handles);

% --- Executes on button press in saveOrgans.
function saveOrgans_Callback(hObject, eventdata, handles)
%assignin('base','organs',handles.organs);
fid = fopen([handles.path handles.mouse '\' handles.mouse '.txt'],'w');
fprintf(fid,'%s%s\n',handles.path,handles.mouse);

fprintf(fid,'name populated X Y leftFrame rightFrame rect array\n');

for i = 1:9
    fprintf(fid,'%s %3d %6.2f %6.2f %s %s\n',handles.organs(i).name,handles.organs(i).populated,...
    handles.organs(i).X, handles.organs(i).Y, ...
    num2str(handles.organs(i).rect), num2str(handles.organs(i).array));
end
fclose(fid);

%warndlg('Save the variable ''organs'' imediatelly!       .','Do it');

% --- Executes on button press in loadOrgans.
function loadOrgans_Callback(hObject, eventdata, handles)
%msgbox('under construction');
handles.organs = evalin('base','organs');
handles.populated = 0;
for i = 1:size(handles.organs,2)
      handles.populated = handles.populated + handles.organs(i).populated;    
end
handles.populated
guidata(hObject,handles);

function G = resizeMovie(M,zoom)
% G = resizeMovie(M,zoom); resizes movie M for a factor of zoom

if nargin == 1
    zoom = floor(500/size(M(1).cdata,2));
end

G = M;
a = ones(zoom);
for i = 1:size(M,2)
    G(i).cdata = flipud(uint8(kron(double(M(i).cdata),double(a))));
end

% --- Executes on button press in movie.
function movie_Callback(hObject, eventdata, handles)

% section for making and displying the movie
for i = 1:handles.N(3)
    M(i) = im2frame( 1 + round(handles.x(:,:,i)),handles.map);
end
figure;
axis square off;
G = resizeMovie(M);
movie(G,1)
close;

% --- Executes on button press in findOrgans.
function findOrgans_Callback(hObject, eventdata, handles)

y = zeros(size(handles.x,1)*size(handles.x,2),size(handles.x,3));
for i = 1:handles.N(3) 
    temp = handles.x(:,:,i); 
    y(:,i) = temp(:); 
end

handles.mapRed = zeros(size(handles.map));
handles.mapGreen = zeros(size(handles.map));
handles.mapBlue = zeros(size(handles.map));
handles.mapRed(:,1) = handles.map(:,1);
handles.mapGreen(:,2) = handles.map(:,2);
handles.mapBlue(:,3) = handles.map(:,3);

i = 0;
j = 1;
while j<=size(handles.organs,2) 
    if handles.organs(j).populated == 1 
        i = i + 1;
        A(:,i) = (handles.organs(j).array)';
    end
    j = j + 1;
end
disp('handles.populated')
handles.populated

coeff = pinv(A)*y';

coeffReshaped = zeros(size(handles.x,1),size(handles.x,2),handles.populated);
h = figure;
set(h,'Position',[50 50 1800 1000]);



for i = 1:handles.populated;
    subplot(1,handles.populated + 1,i);
    switch i
        case 1
            handles.map = handles.mapRed;
        case 2 
            handles.map = handles.mapGreen;
        case 3 
            handles.map = handles.mapBlue;
        case 4
            handles.map = handles.mapRed + handles.mapGreen;
        case 5 
            handles.map = handles.mapGreen + handles.mapBlue;
        case 6 
            handles.map = handles.mapBlue + handles.mapRed;
    end
    coeffReshaped(:,:,i) = reshape(coeff(i,:),size(handles.x,1),size(handles.x,2));
    
    %for contours only
    subimage(250*uint8(coeffReshaped(:,:,i)/max(max(coeffReshaped(:,:,i)))),handles.map);
    
    %subimage(uint8(400*(coeffReshaped(:,:,i))),handles.map); %can be made better, but its working
    %image(200*coeffReshaped(:,:,i)); colormap(gray)
    axis image off;
    title(['comp ' num2str(i)]);
end
assignin('base','coeff',coeffReshaped);

subplot(1,handles.populated + 1,handles.populated + 1);
size(coeffReshaped)
image((coeffReshaped - min(coeffReshaped(:)))/max(coeffReshaped(:) - min(coeffReshaped(:))));
axis image off;
title('Components combined');
assignin('base','coeff',coeffReshaped);
guidata(hObject,handles);


% --- Executes on button press in clearOrgan.
function clearOrgan_Callback(hObject, eventdata, handles)

handles.organIndex
handles.organIndex = get(hObject, 'Value');

handles.organs(handles.organIndex).array = zeros(1,handles.N(3));
handles.organs(handles.organIndex).rect = [1 1 handles.N(2) handles.N(1)];
handles.organs(handles.organIndex).X = 1;
handles.organs(handles.organIndex).Y = 1;
handles.organs(handles.organIndex).leftFrame = 1;
handles.organs(handles.organIndex).rightFrame = handles.N(3);
handles.organs(handles.organIndex).populated = 0;

guidata(hObject,handles);


% --- Executes on selection change in show.
function show_Callback(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns show contents as cell array
%        contents{get(hObject,'Value')} returns selected item from show


index = get(handles.show,'Value');
if ((index > 0) | (index <= handles.N(3)))
    axes(handles.axes1); 
    switch index
        case(1)
            imagesc(handles.x(:,:,handles.currentSlide));
        case(2)
            imagesc(handles.deriv(:,:,handles.currentSlide));
        case(3)
            imagesc(handles.deriv2(:,:,handles.currentSlide));
    end
    axis image off; colorbar off; colorbar(handles.colorbar);
    guidata(hObject,handles);
else
    disp('out of bounds')
end



% --- Executes on button press in standardDeviation.
function standardDeviation_Callback(hObject, eventdata, handles)
% hObject    handle to standardDeviation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of standardDeviation


function stdWidth_Callback(hObject, eventdata, handles)
% hObject    handle to stdWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stdWidth as text
%        str2double(get(hObject,'String')) returns contents of stdWidth as a double

handles.stdWidth = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function stdWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stdWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject,'String','11');

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in loadMouse.
function loadMouse_Callback(hObject, eventdata, handles)
% hObject    handle to loadMouse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = get(handles.mouseList,'String');
mouse = contents{get(handles.mouseList,'Value')};
handles.mouse = mouse;

dir1 = 'C:\Hillman_062607\DYCE Day 0\';
handles.path = [dir1 mouse '\'];
N(3) = str2num(get(handles.numberOfFrames,'String'));
D = dir(handles.path);
lengthD = size(D,1) - 2;
if N(3) > lengthD
    msgbox(['There are only ' num2str(lengthD - 2,'%03g') ' images in the folder.           .';
            'Please choose diff'                          'erent number of frames.          .']); 
    return;
end

button = questdlg('Do you want to save data for the current mouse?  .');
if strcmp(button,'Yes')
    saveOrgans_Callback(handles.saveOrgans, eventdata, handles);
end

Nstart = str2num(get(handles.startingFrame,'String'));
rect = [16 207 493 461]; %load CRI_margins;
N(1) = rect(3)-rect(1)+1 ; % imagesize in one dimension
N(2) = rect(4)-rect(2)+1;

x = zeros(N);

for i = 1:N(3)
    temp = uint16(imread( ...
         [dir1 mouse '\' mouse '_' num2str(Nstart + i - 1,'%03g') '.tif']));
    x(:,:,i) = temp(rect(1):rect(3),rect(2):rect(4));
end

handles.N = N;
handles.x = x;

% puts the image according to the slider position
axes(handles.axes1);
set(handles.show,'Value',1);
imagesc(handles.x(:,:,handles.currentSlide));
axis image off; colorbar off; colorbar(handles.colorbar);
handles.deriv = zeros(handles.N);
handles.deriv2 = zeros(handles.N);

set(handles.pathStaticText,'String',[handles.path handles.mouse]);
guidata(hObject,handles);


% --- Executes on selection change in mouseList.
function mouseList_Callback(hObject, eventdata, handles)
% hObject    handle to mouseList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns mouseList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mouseList


% --- Executes during object creation, after setting all properties.
function mouseList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mouseList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in findDerivatives.
function findDerivatives_Callback(hObject, eventdata, handles)
% hObject    handle to findDerivatives (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.deriv = zeros(handles.N);
handles.deriv2 = zeros(handles.N);
delta = round( str2double(get(handles.delta,'String')))
h = waitbar(0,'Finding derivatives ...');
temp = zeros(handles.N(3),1);
for i = delta+1:handles.N(1)-delta
    waitbar(i/handles.N(1),h)
    for  j = delta+1:handles.N(2)-delta
        temp = shiftdim(mean(mean(...
            handles.x(i-delta:i+delta,j-delta:j+delta,:),1),2),1)';
        temp1 = [0; diff(temp)];
        temp2 = [0; 0; diff(temp1)];
        for k = 1:handles.N(3)
            handles.deriv(i,j,k) = temp1(k);
            handles.deriv2(i,j,k) = temp2(k);
        end
    end
end
close(h)
guidata(hObject,handles);


% --- Executes on button press in zoom.
function zoom_Callback(hObject, eventdata, handles)
% hObject    handle to zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
if get(hObject,'Value') == 0
    zoom off;
else
    zoom on;
end

function startingFrame_Callback(hObject, eventdata, handles)

function startingFrame_CreateFcn(hObject, eventdata, handles)



if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function numberOfFrames_Callback(hObject, eventdata, handles)

function numberOfFrames_CreateFcn(hObject, eventdata, handles)



if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function A = scale(B,n,Bmin,Bmax)
%Bmin = min(B(:));
%Bmax = max(B(:));
if Bmin==Bmax 
    A = ones(size(B)).*min(B(:)) + 1 ;
else
    A = n*(B - Bmin)/(Bmax - Bmin);
end

function exportTiffs_Callback(hObject, eventdata, handles)
% hObject    handle to exportTiffs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (exist([handles.path 'tiff'],'dir') == 0)
    mkdir([handles.path 'tiff']);
else
    button = questdlg('Do you want to overwrite data?  .');
    if ~strcmp(button,'Yes')
        disp('Export was canceled.');
        return;
    end
end
newMax = size(handles.map,1)
h = waitbar(0,'Exporting tiffs ...');
index = get(handles.show,'Value');
Bmin = -200;
Bmax = 800;
switch index
    case(1)
        if (exist([handles.path 'tiff\raw'],'dir') == 0)
            mkdir([handles.path 'tiff\raw']);
        end 
        name = 'raw';
        for i = 1:size(handles.timeSampled,2)
            waitbar(i/size(handles.timeSampled,2),h)
            imwrite(scale(handles.x(:,:,handles.timeSampled(i)),newMax,0,4095),handles.map,[handles.path 'tiff\raw\' name '_' num2str(handles.timeSampled(i),'%03g') '.tif']);
        end
    case(2)
        if (exist([handles.path 'tiff\deriv'],'dir') == 0)
            mkdir([handles.path 'tiff\deriv']);
        end 
        name = 'deriv';
        for i = 1:size(handles.timeSampled,2)
            waitbar(i/size(handles.timeSampled,2),h)
            imwrite(scale(handles.deriv(:,:,handles.timeSampled(i)),newMax,Bmin,Bmax),handles.map,[handles.path 'tiff\deriv\' name '_' num2str(handles.timeSampled(i),'%03g') '.tif']);
        end        
    case(3)
        if (exist([handles.path 'tiff\deriv2'],'dir') == 0)
            mkdir([handles.path 'tiff\deriv2']);
        end 
        name = 'deriv2';
        for i = 1:size(handles.timeSampled,2)
            waitbar(i/size(handles.timeSampled,2),h)
            imwrite(scale(handles.deriv2(:,:,handles.timeSampled(i)),newMax,Bmin,Bmax),handles.map,[handles.path 'tiff\deriv2\' name '_' num2str(handles.timeSampled(i),'%03g') '.tif']);
        end
end
close(h)
% --- Executes on button press in choseFrames.
function choseFrames_Callback(hObject, eventdata, handles)
% hObject    handle to choseFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = figure(1);
set(h,'Position',[50 50 1800 1000]);

% --- Executes during object creation, after setting all properties.
function currentSlideNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentSlideNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in doubleView.
function doubleView_Callback(hObject, eventdata, handles)
% hObject    handle to doubleView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.timeSampled = double_view(eventdata, handles);
guidata(hObject,handles);

function delta_Callback(hObject, eventdata, handles)
% hObject    handle to delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delta as text
%        str2double(get(hObject,'String')) returns contents of delta as a double


% --- Executes during object creation, after setting all properties.
function delta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String','5');
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in scale.
function scale_Callback(hObject, eventdata, handles)
% hObject    handle to scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scale




% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function colormap_Callback(hObject, eventdata, handles)
% hObject    handle to colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of colormap as text
%        str2double(get(hObject,'String')) returns contents of colormap as a double

handles.map = colormap(gray(round(str2double(get(hObject,'String')))));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function colormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String','256');
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function maxSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function maxSlider_Callback(hObject, eventdata, handles)
% hObject    handle to maxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

if get(handles.scale) == 0
    axes(handles.axis1);
    image(x(:,:,handles.currentSlide),handles.mapSize,0,get(hObject,'Value'));
    handles.max
    guidata(hObject,handles);
end











% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


