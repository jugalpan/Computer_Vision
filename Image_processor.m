function varargout = Asg1(varargin)
% ASG1 MATLAB code for Asg1.fig
%      ASG1, by itself, creates a new ASG1 or raises the existing
%      singleton*.
%
%      H = ASG1 returns the handle to a new ASG1 or the handle to
%      the existing singleton*.
%
%      ASG1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASG1.M with the given input arguments.
%
%      ASG1('Property','Value',...) creates a new ASG1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Asg1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Asg1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Asg1

% Last Modified by GUIDE v2.5 13-Feb-2017 14:09:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Asg1_OpeningFcn, ...
                   'gui_OutputFcn',  @Asg1_OutputFcn, ...
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


% --- Executes just before Asg1 is made visible.
function Asg1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Asg1 (see VARARGIN)

% Choose default command line output for Asg1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Asg1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Asg1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = imread('C:\Users\JUGAL\Documents\MATLAB\CV\see.jpg');
[rows,columns] = size(img);
T=128;
Newimg = zeros(rows,columns);
for x=1:1:rows
    for y=1:1:columns
        if(img(x,y) < T)
            Newimg(x,y) = 0;
        else
            Newimg(x,y) = 255;
        end
    end
end
imwrite(Newimg,'bw.jpg');
subplot(1,3,1);
imshow(img);
title('Image extracted from the byte code file');

subplot(1,3,2);
imshow(Newimg/256);
title('Binary image obtained by with thresholding (T=128)');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Component Labeling

B = imread('C:\Users\JUGAL\Documents\MATLAB\CV\see.jpg');
[rows,columns] = size(B);
T=128;
BT = zeros(rows,columns);
C = zeros(rows,columns);
for x=1:1:rows
    for y=1:1:columns
        if(B(x,y) < T)
            BT(x,y) = 0;
        else
            BT(x,y) = 255;
        end
    end
end
subplot(2,3,1);
imshow(B);
subplot(2,3,2);
imshow(BT/256);

lab = 30;

%check for uppermost and leftmost boundary
for x=2:1:rows
    if(BT(1,x)==0)
        if(BT(1,x-1)~=0)
            C(1,x)=lab;
            lab=lab+0.5;
%            lab = round(lab);
        else
            C(1,x)=C(1,x-1);
        end 
    end
end
for y=2:1:columns
    if(BT(y,1)==0)
        if(BT(y-1,1)~=0)
            C(y,1)=lab;
            lab=lab+0.5;
 %           lab = round(lab);
        else
            C(y,1)=C(y-1,1);
        end 
    end
end

%check for remaining region: parse 1
for x=2:1:rows
    for y=2:1:columns
        if(BT(x,y)==0)
            if(BT(x-1,y) == 255 && BT(x,y-1) == 255)
                C(x,y) = lab;
                lab = lab+0.5;
  %              lab = round(lab);
            elseif(BT(x-1,y) == 0 || BT(x,y-1) == 0)
                if(BT(x,y-1)==0)
                    C(x,y) = C(x,y-1);
                else
                    C(x,y) = C(x-1,y);
                end
            else
                C(x,y) = BT(x-1,y);
            end
        end
    end
end
subplot(2,3,4);
imshow(C/256);
    for x=2:1:rows
        for y=2:1:columns
            if(C(x,y)~=0 && C(x-1,y)~=0 && C(x,y-1)~=0 && C(x-1,y)~=C(x,y-1))
                L1 = C(x,y-1);
                L2 = C(x-1,y);
                for k=2:1:rows
                    for l=2:1:columns
                        if(C(k,l)==L1)
                            C(k,l)=L2;
                        end
                    end
                end
            end
        end 
    end
for x=1:1:rows
    for y=1:1:columns
        C(x,y) = round(C(x,y));
    end
end
subplot(2,3,5);
imshow(C/256);

H = zeros(256,1);
total = 0; total_c = 0; total_comp = 0;
for x=1:1:rows
    for y=1:1:columns
        H(C(x,y)+1) = H(C(x,y)+1) + 1;
    end
end

% Total area of the picture
for i=1:1:255
    total = H(i)+total;
end
fprintf('total area %d\n',total);

% Total area occupied by components
for i=2:1:255
    total_c = H(i)+total_c;
end
fprintf('covered by components %d\n',total_c);

% Area of components greater than 16000
for i=2:1:255
    if(H(i)>16000)
        total_comp = H(i)+total_comp;
    else
        H(i)=0;
    end
end
fprintf('Covered area by Components with area greater than 16000 %d\n',total_comp);


% removing components with area less than 8000 pixels
    for x=1:1:rows
        for y=1:1:columns
            if(H(C(x,y)+1) < 8000)
                C(x,y) = 0;
            end
        end
    end
    
% Recovering Individual components
for x=1:1:rows
    for y=1:1:columns
        if(C(x,y) == 31)
            C1(x,y) = 255;
        else
            C1(x,y) = 0;
        end
    end
end
for x=1:1:512
    C1(x,1) = 0;
end

for x=1:1:rows
    for y=1:1:columns
        if(C(x,y) == 43)
            C2(x,y) = 255;
        else
            C2(x,y) = 0;
        end
    end
end
for x=1:1:rows
    for y=1:1:columns
        if(C(x,y) == 56)
            C3(x,y) = 255;
        else
            C3(x,y) = 0;
        end
    end
end
for x=1:1:rows
    for y=1:1:columns
        if(C(x,y) == 130)
            C4(x,y) = 255;
        else
            C4(x,y) = 0;
        end
    end
end
for x=1:1:rows
    for y=1:1:columns
        if(C(x,y) == 163)
            C5(x,y) = 255;
        else
            C5(x,y) = 0;
        end
    end
end

imwrite(C1,'cp1.png');
imwrite(C2,'cp2.png');
imwrite(C3,'cp3.png');
imwrite(C4,'cp4.png');
imwrite(C5,'cp5.png');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Boundaries and perimeter

global BT;
global P;
B = imread('C:\Users\JUGAL\Documents\MATLAB\CV\c2.jpg');
[rows,columns] = size(B);
T=128;
BT = zeros(rows,columns);
P = zeros(rows,columns);
for x=1:1:rows
    for y=1:1:columns
        if(B(x,y) < T)
            BT(x,y) = 250;
        else
            BT(x,y) = 5;
        end
    end
end
subplot(2,3,1);
imshow(B);
subplot(2,3,2);
imshow(BT/256);

for x=2:1:rows
    for y=2:1:columns
        if(BT(x,y)-BT(x,y-1) == 245)
            P = bound(BT,P,x,y);
            fprintf('in');
        end
    end
end

subplot(2,3,4);
imshow(P/256);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Centroid

CP1 = imread('C:\Users\JUGAL\Documents\MATLAB\CV\cp1.png');
[rows,columns] = size(CP1);
C1 = im2double(CP1);
area1 = 0;
for x=1:1:rows
    for y=1:1:columns
        if(C1(x,y)==1)
            area1 = area1+1;
        end
    end
end
fprintf('Object 1. Area = %d\n',area1);

u1 = 0;    v1 = 0;
for x=1:1:rows
    for y=1:1:columns
        if (C1(x,y)>0)
            im1 =  x * C1(x,y);
            u1 = u1 + im1;
        end
    end
end
ic1 = round(u1/area1);
for x=1:1:rows
    for y=1:1:columns
        if(C1(x,y)>0)
            jm1 = y * C1(x,y);
            v1 = v1 + jm1;
        end
    end
end
jc1 = round(v1/area1);
fprintf('Centroid is %d, %d\n',ic1,jc1);

if(C1(ic1,jc1) == 0)
    C1(ic1,jc1) = 1;
else
    C1(ic1,jc1) = 0;
end

sum11 = 0;
for x=1:1:rows
    for y=1:1:columns
        id11 = abs(x - ic1);
        tea11 = id11 * id11 * C1(x,y);
        sum11 = sum11 + tea11;
    end
end
a1 = sum11;

sum12 = 0;
for x=1:1:rows
    for y=1:1:columns
        id12 = abs(x - ic1);
        jd12 = abs(y - jc1);
        teb12 = id12 * jd12 * C1(x,y);
        sum12 = sum12 + teb12;
    end
end
b1 = sum12 * 2;

sum13 = 0;
for x=1:1:rows
    for y=1:1:columns
        jd13 = abs(y - jc1);
        tec12 = jd13 * jd13 * C1(x,y);
        sum13 = sum13 + tec12;
    end
end
c1 = sum13;

theta11 = round(atan(b1/(a1-c1))/2);
theta12 = theta11 + 90;
fprintf('a = %d\tb = %d\tc=%d\nOrientations of axes = %d\t%d\n',a1,b1,c1,theta11,theta12);

subplot(2,3,1);
imshow(C1);

CP2 = imread('C:\Users\JUGAL\Documents\MATLAB\CV\cp2.png');
[rows,columns] = size(CP2);
C2 = im2double(CP2);
area2 = 0;
for x=1:1:rows
    for y=1:1:columns
        if(C2(x,y)==1)
            area2 = area2+1;
        end
    end
end
fprintf('\nObject 2. Area = %d\n',area2);

u2 = 0;    v2 = 0;
for x=1:1:rows
    for y=1:1:columns
        if (C2(x,y)>0)
            im2 =  x * C2(x,y);
            u2 = u2 + im2;
        end
    end
end

ic2 = round(u2/area2);
for x=1:1:rows
    for y=1:1:columns
        if(C2(x,y)>0)
            jm2 = y * C2(x,y);
            v2 = v2 + jm2;
        end
    end
end
jc2 = round(v2/area2);
fprintf('Centroid is %d, %d\n',ic2,jc2);
if(C2(ic2,jc2) == 0)
    C2(ic2,jc2) = 1;
else
    C2(ic2,jc2) = 0;
end
a2 = 0;
sum21 = 0;
for x=1:1:rows
    for y=1:1:columns
        id21 = abs(x - ic2);
        tea21 = id21 * id21 * C2(x,y);
        sum21 = sum21 + tea21;
    end
end
a2 = sum21;

sum22 = 0;
for x=1:1:rows
    for y=1:1:columns
        id22 = abs(x - ic2);
        jd22 = abs(y - jc2);
        teb22 = id22 * jd22 * C2(x,y);
        sum22 = sum22 + teb22;
    end
end
b2 = sum22;

sum23 = 0;
for x=1:1:rows
    for y=1:1:columns
        jd23 = abs(y - jc2);
        tec23 = jd23 * jd23 * C2(x,y);
        sum23 = sum23 + tec23;
    end
end
c3 = sum23;

theta21 = round(atan(b2/(a2-c3))/2);
theta22 = theta21 + 90;
fprintf('a = %d\tb = %d\tc=%d\nOrientation of axes = %d\t%d\n',a2,b2,c3,theta21,theta22);

subplot(2,3,2);
imshow(C2);

CP3 = imread('C:\Users\JUGAL\Documents\MATLAB\CV\cp3.png');
[rows,columns] = size(CP3);
C3 = im2double(CP3);
area3 = 0;
for x=1:1:rows
    for y=1:1:columns
        if(C3(x,y)==1)
            area3 = area3+1;
        end
    end
end
fprintf('\nObject 3. Area = %d\n',area3);

u3 = 0;    v3 = 0;
for x=1:1:rows
    for y=1:1:columns
        if (C3(x,y)>0)
            im3 =  x * C3(x,y);
            u3 = u3 + im3;
        end
    end
end

ic3 = round(u3/area3);
for x=1:1:rows
    for y=1:1:columns
        if(C3(x,y)>0)
            jm3 = y * C3(x,y);
            v3 = v3 + jm3;
        end
    end
end
jc3 = round(v3/area3);
fprintf('Centroid is %d, %d\n',ic3,jc3);
if(C3(ic3,jc3) == 0)
    C3(ic3,jc3) = 1;
else
    C3(ic3,jc3) = 0;
end

sum31 = 0;
for x=1:1:rows
    for y=1:1:columns
        id31 = abs(x - ic3);
        tea31 = id31 * id31 * C3(x,y);
        sum31 = sum31 + tea31;
    end
end
a3 = sum31;

sum32 = 0;
for x=1:1:rows
    for y=1:1:columns
        id32 = abs(x - ic3);
        jd32 = abs(y - jc3);
        teb32 = id32 * jd32 * C3(x,y);
        sum32 = sum32 + teb32;
    end
end
b3 = sum32;

sum33 = 0;
for x=1:1:rows
    for y=1:1:columns
        jd33 = abs(y - jc3);
        tec33 = jd33 * jd33 * C3(x,y);
        sum33 = sum33 + tec33;
    end
end
c3 = sum33;

theta31 = round(atan(b3/(a3-c3))/2);
theta32 = theta31 + 90;
fprintf('a = %d\tb = %d\tc=%d\nOrientation of axes = %d\t%d\n',a3,b3,c3,theta31,theta32);

subplot(2,3,4);
imshow(C3);

CP4 = imread('C:\Users\JUGAL\Documents\MATLAB\CV\cp4.png');
[rows,columns] = size(CP4);
C4 = im2double(CP4);
area4 = 0;
for x=1:1:rows
    for y=1:1:columns
        if(C4(x,y)==1)
            area4 = area4+1;
        end
    end
end
fprintf('\nObject 4. Area = %d\n',area4);

u4 = 0;    v4 = 0;
for x=1:1:rows
    for y=1:1:columns
        if (C4(x,y)>0)
            im4 =  x * C4(x,y);
            u4 = u4 + im4;
        end
    end
end

ic4 = round(u4/area4);
for x=1:1:rows
    for y=1:1:columns
        if(C4(x,y)>0)
            jm4 = y * C4(x,y);
            v4 = v4 + jm4;
        end
    end
end
jc4 = round(v4/area4);
fprintf('Centroid is %d, %d\n',ic4,jc4);
if(C4(ic4,jc4) == 0)
    C4(ic4,jc4) = 1;
else
    C4(ic4,jc4) = 0;
end

sum41 = 0;
for x=1:1:rows
    for y=1:1:columns
        id41 = abs(x - ic4);
        tea41 = id41 * id41 * C4(x,y);
        sum41 = sum41 + tea41;
    end
end
a4 = sum41;

sum42 = 0;
for x=1:1:rows
    for y=1:1:columns
        id42 = abs(x - ic4);
        jd42 = abs(y - jc4);
        teb42 = id42 * jd42 * C4(x,y);
        sum42 = sum42 + teb42;
    end
end
b4 = sum42;

sum43 = 0;
for x=1:1:rows
    for y=1:1:columns
        jd42 = abs(y - jc4);
        tec42 = jd42 * jd42 * C4(x,y);
        sum43 = sum43 + tec42;
    end
end
c4 = sum43;

theta41 = round(atan(b4/(a4-c4))/2);
theta42 = theta41 + 90;
fprintf('a = %d\tb = %d\tc=%d\nOrientation of axes = %d\t%d\n',a4,b4,c4,theta41,theta42);

subplot(2,3,5);
imshow(C4);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Individual Objects with area

C1 = imread('C:\Users\JUGAL\Documents\MATLAB\CV\cp1.png');
[rows,columns] = size(C1);
a1 = 0;
for x=1:1:rows
    for y=2:1:columns
        if(C1(x,y)==255)
            a1 = a1+1;
        end
    end
end
subplot(2,3,1);
imshow(C1);
fprintf('Object 1. Area = %d\n',a1);

C2 = imread('C:\Users\JUGAL\Documents\MATLAB\CV\cp2.png');
a2 = 0;
for x=1:1:rows
    for y=2:1:columns
        if(C2(x,y)==255)
            a2 = a2+1;
        end
    end
end
subplot(2,3,2);
imshow(C2);
fprintf('Object 2. Area = %d\n',a2);

C3 = imread('C:\Users\JUGAL\Documents\MATLAB\CV\cp3.png');
a3 = 0;
for x=1:1:rows
    for y=2:1:columns
        if(C3(x,y)==255)
            a3 = a3+1;
        end
    end
end
subplot(2,3,4);
imshow(C3);
fprintf('Object 3. Area = %d\n',a3);

C4 = imread('C:\Users\JUGAL\Documents\MATLAB\CV\cp4.png');
a4 = 0;
for x=1:1:rows
    for y=2:1:columns
        if(C4(x,y)==255)
            a4 = a4+1;
        end
    end
end
subplot(2,3,5);
imshow(C4);
fprintf('Object 4. Area = %d\n',a4);

