function varargout = Redes_Neuronales(varargin)
% REDES_NEURONALES MATLAB code for Redes_Neuronales.fig
%      REDES_NEURONALES, by itself, creates a new REDES_NEURONALES or raises the existing
%      singleton*.
%
%      H = REDES_NEURONALES returns the handle to a new REDES_NEURONALES or the handle to
%      the existing singleton*.
%
%      REDES_NEURONALES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REDES_NEURONALES.M with the given input arguments.
%
%      REDES_NEURONALES('Property','Value',...) creates a new REDES_NEURONALES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Redes_Neuronales_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Redes_Neuronales_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Redes_Neuronales

% Last Modified by GUIDE v2.5 13-Dec-2016 15:57:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Redes_Neuronales_OpeningFcn, ...
                   'gui_OutputFcn',  @Redes_Neuronales_OutputFcn, ...
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

% --- Executes just before Redes_Neuronales is made visible.
function Redes_Neuronales_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Redes_Neuronales (see VARARGIN)

%axis off
% Choose default command line output for Redes_Neuronales
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Redes_Neuronales wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Redes_Neuronales_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Entradas_entrenamiento.
function Entradas_entrenamiento_Callback(hObject, eventdata, handles)
% hObject    handle to Entradas_entrenamiento (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Entrada_train;
[nombre direc]=uigetfile({'*.xlsx'},'Abrir Archivo');
Entrada_train=strcat(direc, nombre);
Entrada_train = xlsread (Entrada_train);
set(handles.text5, 'String', nombre)
assignin('base','Entrada_train',Entrada_train)

% --- Executes on button press in Salida_entrenamiento.
function Salida_entrenamiento_Callback(hObject, eventdata, handles)
% hObject    handle to Salida_entrenamiento (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Salida_train;
[nombre direc]=uigetfile({'*.xlsx'},'Abrir Archivo');
Salida_train=strcat(direc, nombre);
Salida_train = xlsread (Salida_train);
set(handles.text6, 'String', nombre)
assignin('base','Salida_train',Salida_train)

% --- Executes on button press in Comenzar.
function Comenzar_Callback(hObject, eventdata, handles)
% hObject    handle to Comenzar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This script assumes these variables are defined:
%
%   entrada - input data.
%   salida - target data.

global Entrada_train;
global Salida_train;
global Entrada_sim;
global Salida_sim;

inputs = Entrada_train;
targets = Salida_train;

% Create a Fitting Network
hiddenLayerSize = 5;
net = fitnet(hiddenLayerSize);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};


% Setup Division of Data for Training, Validation, Testing
% For a list of all data división functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% For help on training function ‘trainlm’ type: help trainlm
% For a list of all training functions type: help nntrain
net.trainFcn = 'trainlm';  % Levenberg-Marquardt

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean squared error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit'};


% Train the Network
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);

%Weights
wi = net.IW{1,1};
assignin('base','Pesos_entradas',wi)
whl = net.LW{2,1};
assignin('base','Pesos_capa_oculta',whl)

% Recalculate Training, Validation and Test Performance 
trainTargets = targets .* tr.trainMask{1};
valTargets = targets  .* tr.valMask{1};
testTargets = targets  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,outputs);
valPerformance = perform(net,valTargets,outputs);
testPerformance = perform(net,testTargets,outputs);

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, plotregression(targets,outputs)
figure, ploterrhist(errors)

%DATASET DE PRUEBA
inputs1 = Entrada_sim;
targets1 = Salida_sim;

% Test the Network – Dataset de Prueba
outputs1 = net(inputs1);
errors1 = gsubtract(targets1,outputs1);
performance1 = perform(net,targets1,outputs1);

%Plots
%figure, plotperform(tr) %Es el mismo que para el entrenamiento
Salida_sim = Salida_sim*100;
outputs1 = outputs1*100;

assignin('base','Salida_estimada',outputs1)
assignin('base','Salida_real',Salida_sim)

axes(handles.axes2);
plot(Salida_sim, '-b.') % vector energía real
hold on
plot(outputs1, '-r.') % vector energía predicha
hold off
title('Energia generada vs Predicción')
legend('Energía generada', 'Predicción')
xlabel('Día') % Etiqueta el eje x
ylabel('kwh diarios') % Etiqueta el eje y

S_Salida_sim = sum(Salida_sim);
S_outputs1 = sum(outputs1);

MAPE_sim = (abs(Salida_sim - outputs1)/Salida_sim)*100;

set(handles.mape2,'String',num2str(MAPE_sim));

% --- Executes on button press in Ayuda.
function Ayuda_Callback(hObject, eventdata, handles)
% hObject    handle to Ayuda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

helpdlg ({'Pasos para ejecutar la aplicación:','    - Pulse el botón superior izquierdo y seleccione el fichero "entradas_12_meses_norm".','    - Pulse el botón superior derecho y seleccione el fichero "salida_12_meses_norm".','    - Con el botón inferior izquierdo, seleccione el fichero de entrada semanal que desee.','    - Con el botón inferior derecho, seleccione el fichero de salida semanal que desee.','    - Pulse COMENZAR.'});


% --- Executes on button press in Entradas_simulacion.
function Entradas_simulacion_Callback(hObject, eventdata, handles)
% hObject    handle to Entradas_simulacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Entrada_sim;
[nombre direc]=uigetfile({'*.xlsx'},'Abrir Archivo');
Entrada_sim=strcat(direc, nombre); 
Entrada_sim = xlsread (Entrada_sim);
set(handles.text7, 'String', nombre)

assignin('base','Entrada_sim',Entrada_sim)




% --- Executes on button press in Salida_simulacion.
function Salida_simulacion_Callback(hObject, eventdata, handles)
% hObject    handle to Salida_simulacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Salida_sim;
[nombre direc]=uigetfile({'*.xlsx'},'Abrir Archivo');
Salida_sim=strcat(direc, nombre);
Salida_sim = xlsread (Salida_sim);
set(handles.text8, 'String', nombre)
assignin('base','Salida_sim',Salida_sim)




% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

