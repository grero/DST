function varargout = DSTgui(varargin)
% DSTGUI M-file for DSTgui.fig
%      DSTGUI, by itself, creates a new DSTGUI or raises the existing
%      singleton*.
%
%      H = DSTGUI returns the handle to a new DSTGUI or the handle to
%      the existing singleton*.
%
%      DSTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DSTGUI.M with the given input arguments.
%
%      DSTGUI('Property','Value',...) creates a new DSTGUI or raises
%      the existing singleton*.  Starting from the left, property value
%      pairs are
%      applied to the GUI before DSTgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property
%      application
%      stop.  All inputs are passed to DSTgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DSTgui

% Last Modified by GUIDE v2.5 18-Jan-2013 18:31:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DSTgui_OpeningFcn, ...
                   'gui_OutputFcn',  @DSTgui_OutputFcn, ...
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

% --- Executes just before DSTgui is made visible.
function DSTgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DSTgui (see VARARGIN)
global whichScreen
whichScreen = 1;
% Choose save command line output for DSTgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes DSTgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DSTgui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get save command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


homeDir = 'C:\Users\User\Desktop\dst\'; %DST_files
% homeDir = '/Volumes/Chimera/Users/elebjh/Desktop';
% homeDir = '~/Desktop';
cd(homeDir)

backgroundColor = [100 100 100];

%%% Save parameters in Results file
results.parameters.trainstep = handles.metricdata.trainstep;
results.parameters.monkeyname = handles.metricdata.monkeyname;
results.parameters.minITI = handles.metricdata.miniti/1000;
results.parameters.maxITI = handles.metricdata.maxiti/1000;
results.parameters.penalty = handles.metricdata.penalty/1000;
results.parameters.fixationOn = handles.metricdata.fixation/1000;
results.parameters.minprestim = handles.metricdata.minprestim/1000;
results.parameters.maxprestim = handles.metricdata.maxprestim/1000;
results.parameters.mindelay = handles.metricdata.mindelay/1000;
results.parameters.maxdelay = handles.metricdata.maxdelay/1000;
results.parameters.minsquareTimeON = handles.metricdata.mintarget/1000;
results.parameters.maxsquareTimeON = handles.metricdata.maxtarget/1000;
results.parameters.mininterSquareTime = handles.metricdata.minblank/1000;
results.parameters.maxinterSquareTime = handles.metricdata.maxblank/1000;
results.parameters.rangeRT = [100 handles.metricdata.response];
results.parameters.timeOnTarget = handles.metricdata.minresponse/1000;
results.parameters.maxnumtarget = handles.metricdata.maxnumtarget;
results.parameters.rangeDistractors = [handles.metricdata.mindistractor handles.metricdata.maxdistractor];
results.parameters.feedbackTime = handles.metricdata.feedback/1000;
results.parameters.buffertime = handles.metricdata.buffertime/1000;
results.parameters.fixSize = handles.metricdata.fixsize;
results.parameters.fixArea = handles.metricdata.fixwin;
results.parameters.fixcol = handles.metricdata.fixcol;
results.parameters.stimref = handles.metricdata.stimref;
results.parameters.timeFixation = handles.metricdata.minfix/1000;
results.parameters.horgnum = handles.metricdata.horgnum;
results.parameters.vergnum = handles.metricdata.vergnum;
results.parameters.gridcontrast = handles.metricdata.gridcontrast;
results.parameters.respondsizeratio = handles.metricdata.respondsizeratio;
results.parameters.targetcol = handles.metricdata.targetcol;
results.parameters.distractorcol = handles.metricdata.distractorcol;
results.parameters.rewardprob = handles.metricdata.rewardprob;
results.parameters.rewardduration = handles.metricdata.rewardduration;
results.parameters.manualrewardduration = handles.metricdata.manualrewardduration;
results.parameters.blocknum = handles.metricdata.blocknum;
results.parameters.maxcorrecttrials = handles.metricdata.maxcorrecttrials;
results.parameters.selected_target_locations = handles.metricdata.selected_target_locations;
results.parameters.selected_distractor_locations = handles.metricdata.selected_distractor_locations;
results.parameters.backgroundColor = backgroundColor;
results.parameters.mouse = handles.metricdata.mouse;
results.parameters.respond_center = handles.metricdata.respond_center;
results.parameters.fixtime = handles.metricdata.fixtime;
results.parameters.prestimcontrast = handles.metricdata.prestimcontrast;
results.parameters.stimcontrast = handles.metricdata.stimcontrast;
results.parameters.responsecontrast = handles.metricdata.responsecontrast;
results.parameters.channel = handles.metricdata.channel;
results.parameters.anode = handles.metricdata.anode;
results.parameters.serialport = handles.metricdata.serialport;
results.parameters.rate = handles.metricdata.rate;
results.parameters.first_pulseamp = handles.metricdata.first_pulseamp;
results.parameters.second_pulseamp = handles.metricdata.second_pulseamp;
results.parameters.first_pulsedur = handles.metricdata.first_pulsedur;
results.parameters.second_pulsedur = handles.metricdata.second_pulsedur;
results.parameters.numpulses = handles.metricdata.numpulses;
results.parameters.interdur = handles.metricdata.interdur;
results.parameters.stimprob = handles.metricdata.stimprob;
results.parameters.stimonset = handles.metricdata.stimonset/1000;
results.parameters.savefilename_ext = handles.metricdata.savefilename_ext;
% results.parameters.eyedatafile = handles.metricdata.eyedatafile;
results.parameters.date = date;
a = clock; time = [num2str( a(4),'%02i') ':' num2str( a(5),'%02i')];
results.parameters.time = time;
results.breakFixation = [];

if handles.metricdata.trainstep == 1
    % myDST1(homeDir,results);
    % eyeCalib1(homeDir,results);
    myDST1(homeDir,results);
elseif handles.metricdata.trainstep == 2
    myDST2(homeDir,results);
elseif handles.metricdata.trainstep == 3
    myDST3(homeDir,results);
elseif handles.metricdata.trainstep == 4
    myDST4(homeDir,results);
    % myDST4_old1(homeDir,results);
    % testing_el(homeDir,results);
elseif handles.metricdata.trainstep == 5
    myDST5(homeDir,results);
elseif handles.metricdata.trainstep == 6
    eyeCalib(homeDir,results);
elseif handles.metricdata.trainstep == 7
    eyeAutoCalib(homeDir,results);
elseif handles.metricdata.trainstep == 8
    eyeAutoCalib_el(homeDir,results);
end


% --- Executes on button press in start.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.process)
cla
if handles.metricdata.trainstep == 1
    line([0 0],[-1 1],'LineStyle','--')
    %fixation period
    newaddup_time = handles.metricdata.fixation;
    line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
    text((newaddup_time)/2,-0.2,'1')
    line([0,newaddup_time],[0.2 0.2],'Color','k')
    addup_time = newaddup_time;

    if handles.metricdata.feedback ~= 0
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.feedback;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'9')
        text((addup_time + newaddup_time)/2,0.2,'F')
    end
    
    if handles.metricdata.maxiti ~= 0
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.maxiti;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'11')
        text((addup_time + newaddup_time)/2,0.2,'ITI')
    end

    line([-100 newaddup_time + 50],[0 0])
    xlim([-100 newaddup_time + 50])
    ylim([-1 1])
    xlabel('Time (ms)')
    set(gca,'YTick',10)
elseif handles.metricdata.trainstep == 2
    line([0 0],[-1 1],'LineStyle','--')
    %fixation period
    newaddup_time = handles.metricdata.fixation;
    line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
    text((newaddup_time)/2,-0.2,'1')
    addup_time = newaddup_time;
    if handles.metricdata.maxprestim ~= 0
        %fixation period + minprestim period
        newaddup_time = addup_time + handles.metricdata.maxprestim;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'3')
        line([0,newaddup_time],[0.2 0.2],'Color','k')
        addup_time = newaddup_time;
    end

    %fixation period + minprestim period + mintarget
    newaddup_time = addup_time + handles.metricdata.response;
    line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
    text((addup_time + newaddup_time)/2,-0.2,'7')
    fill([addup_time,newaddup_time,newaddup_time,addup_time],[0.5,0.5,0.3,0.3],handles.metricdata.targetcol/255)
    text((addup_time + newaddup_time)/2,0.2,'R')
    addup_time = newaddup_time;
    if handles.metricdata.feedback ~= 0
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.feedback;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'9')
        text((addup_time + newaddup_time)/2,0.2,'F')
        addup_time = newaddup_time;
    end
    if handles.metricdata.maxiti ~= 0
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.maxiti;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'11')
        text((addup_time + newaddup_time)/2,0.2,'ITI')
    end

    line([-100 newaddup_time + 50],[0 0])
    xlim([-100 newaddup_time + 50])
    ylim([-1 1])
    xlabel('Time (ms)')
    set(gca,'YTick',10)
    
elseif handles.metricdata.trainstep == 3
    line([0 0],[-1 1],'LineStyle','--')
    %fixation period
    newaddup_time = handles.metricdata.fixation;
    line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
    text((newaddup_time)/2,-0.2,'1')
    addup_time = newaddup_time;
    if handles.metricdata.maxprestim ~= 0
        %fixation period + minprestim period
        newaddup_time = addup_time + handles.metricdata.maxprestim;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'3')
        line([0,newaddup_time],[0.2 0.2],'Color','k')
        addup_time = newaddup_time;
    end
    
    if handles.metricdata.maxtarget ~= 0
        
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.maxtarget;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'4')
        hold on
        fill([addup_time,newaddup_time,newaddup_time,addup_time],[0.5,0.5,0.3,0.3],handles.metricdata.targetcol/255)
        line([0,newaddup_time],[0.2 0.2],'Color','k')
        addup_time = newaddup_time;
    end
    
    for x = 1:handles.metricdata.maxdistractor
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.maxblank;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'5')
        addup_time = newaddup_time;
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.maxtarget;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'4')
        hold on
        fill([addup_time,newaddup_time,newaddup_time,addup_time],[0.5,0.5,0.3,0.3],handles.metricdata.distractorcol/255)
        addup_time = newaddup_time;
    end
    line([0,newaddup_time],[0.2 0.2],'Color','k')

    if handles.metricdata.maxdelay ~= 0
        newaddup_time = addup_time + handles.metricdata.maxdelay;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'6')
        line([0,newaddup_time],[0.2 0.2],'Color','k')
        addup_time = newaddup_time;
    end

    if handles.metricdata.feedback ~= 0
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.feedback;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'9')
        text((addup_time + newaddup_time)/2,0.2,'F')
        addup_time = newaddup_time;

    end
    
    if handles.metricdata.maxiti ~= 0
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.maxiti;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'11')
        text((addup_time + newaddup_time)/2,0.2,'ITI')
    end
    
    line([-100 newaddup_time + 50],[0 0])
    xlim([-100 newaddup_time + 50])
    ylim([-1 1])
    xlabel('Time (ms)')
    set(gca,'YTick',10)
elseif handles.metricdata.trainstep == 4
    line([0 0],[-1 1],'LineStyle','--')
    %fixation period
    newaddup_time = handles.metricdata.fixation;
    line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
    text((newaddup_time)/2,-0.2,'1')
    addup_time = newaddup_time;
    if handles.metricdata.maxprestim ~= 0
        %fixation period + minprestim period
        newaddup_time = addup_time + handles.metricdata.maxprestim;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'3')
        addup_time = newaddup_time;
    end

    %fixation period + minprestim period + mintarget
    newaddup_time = addup_time + handles.metricdata.maxtarget;
    line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
    text((addup_time + newaddup_time)/2,-0.2,'4')
    hold on
    fill([addup_time,newaddup_time,newaddup_time,addup_time],[0.5,0.5,0.3,0.3],handles.metricdata.targetcol/255)
    line([0,newaddup_time],[0.2 0.2],'Color','k')
    addup_time = newaddup_time;

    %fixation period + minprestim period + mintarget
    newaddup_time = addup_time + handles.metricdata.response;
    line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
    text((addup_time + newaddup_time)/2,-0.2,'7')
    fill([addup_time,newaddup_time,newaddup_time,addup_time],[0.5,0.5,0.3,0.3],handles.metricdata.targetcol/255)
    text((addup_time + newaddup_time)/2,0.2,'R')
    addup_time = newaddup_time;
    if handles.metricdata.feedback ~= 0
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.feedback;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'9')
        text((addup_time + newaddup_time)/2,0.2,'F')
        addup_time = newaddup_time;
    end
    if handles.metricdata.maxiti ~= 0
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.maxiti;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'11')
        text((addup_time + newaddup_time)/2,0.2,'ITI')
    end

    line([-100 newaddup_time + 50],[0 0])
    xlim([-100 newaddup_time + 50])
    ylim([-1 1])
    xlabel('Time (ms)')
    set(gca,'YTick',10)
elseif handles.metricdata.trainstep == 5

    line([0 0],[-1 1],'LineStyle','--')
    %fixation period
    newaddup_time = handles.metricdata.fixation;
    line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
    text((newaddup_time)/2,-0.2,'1')
    addup_time = newaddup_time;
    if handles.metricdata.maxprestim ~= 0
        %fixation period + minprestim period
        newaddup_time = addup_time + handles.metricdata.maxprestim;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'3')
        addup_time = newaddup_time;
    end

    %fixation period + minprestim period + mintarget
    newaddup_time = addup_time + handles.metricdata.maxtarget;
    line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
    text((addup_time + newaddup_time)/2,-0.2,'4')
    hold on
    fill([addup_time,newaddup_time,newaddup_time,addup_time],[0.5,0.5,0.3,0.3],handles.metricdata.targetcol/255)
    addup_time = newaddup_time;

    for x = 1:handles.metricdata.maxdistractor
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.maxblank;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'5')
        addup_time = newaddup_time;
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.maxtarget;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'4')
        hold on
        fill([addup_time,newaddup_time,newaddup_time,addup_time],[0.5,0.5,0.3,0.3],handles.metricdata.distractorcol/255)
        addup_time = newaddup_time;
    end

    %fixation period + minprestim period + mintarget
    newaddup_time = addup_time + handles.metricdata.maxdelay;
    line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
    text((addup_time + newaddup_time)/2,-0.2,'6')
    line([0,newaddup_time],[0.2 0.2],'Color','k')
    addup_time = newaddup_time;
    %fixation period + minprestim period + mintarget
    newaddup_time = addup_time + handles.metricdata.response;
    line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
    text((addup_time + newaddup_time)/2,-0.2,'7')
    text((addup_time + newaddup_time)/2,0.2,'R')
    addup_time = newaddup_time;
    if handles.metricdata.feedback ~= 0
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.feedback;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'9')
        text((addup_time + newaddup_time)/2,0.2,'F')
        addup_time = newaddup_time;
    end
    if handles.metricdata.maxiti ~= 0
        %fixation period + minprestim period + mintarget
        newaddup_time = addup_time + handles.metricdata.maxiti;
        line([newaddup_time newaddup_time],[-1 1],'LineStyle','--')
        text((addup_time + newaddup_time)/2,-0.2,'11')
        text((addup_time + newaddup_time)/2,0.2,'ITI')
    end

    line([-100 newaddup_time + 50],[0 0])
    xlim([-100 newaddup_time + 50])
    ylim([-1 1])
    xlabel('Time (ms)')
    set(gca,'YTick',10)
end

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

homeDir = 'C:\Users\neuro\Desktop\Camilo Matlab';
% homeDir = '/Volumes/Chimera/Users/elebjh/Desktop';
% homeDir = '~/Desktop';

% initialize_gui(gcbf, handles, true);
a = clock; a(1:3); % a = [year month day]
if ~exist([homeDir '/settings_DST/'])
    mkdir([homeDir '/settings_DST/']);
end

if handles.metricdata.trainstep ~= 5
    if ~isempty(handles.metricdata.savefilename_ext)
        setname = [handles.metricdata.monkeyname,'_Set',num2str(handles.metricdata.trainstep),'_',handles.metricdata.savefilename_ext];
    else
        setname = [handles.metricdata.monkeyname,'_Set',num2str(handles.metricdata.trainstep)];
    end
elseif handles.metricdata.trainstep == 5
    if ~isempty(handles.metricdata.savefilename_ext)
        setname = [handles.metricdata.monkeyname,'_DST','_',handles.metricdata.savefilename_ext];
    else
        setname = [handles.metricdata.monkeyname,'_DST'];
    end
end

filename = [homeDir '/settings_DST/settings_' setname '_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '.mat'];
k = 1;
while exist(filename)
    k = k + 1;
    filename = [homeDir '/settings_DST/settings_' setname '_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '(' num2str(k) ').mat'];
end
save(filename,'handles');

function load_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

homeDir = 'C:\Users\neuro\Desktop\Camilo Matlab';
% homeDir = '/Volumes/Chimera/Users/elebjh/Desktop';
% homeDir = '~/Desktop';

filepath1 = [homeDir '\settings_DST'];
cwd = pwd;
cd(filepath1)
[filename1,filepath1]=uigetfile({'*.*','All Files'},...
     'Select Settings File');
cd(cwd)

previoussettings = load([filepath1 filename1]);
handles.metricdata = previoussettings.handles.metricdata;

set(handles.fixation, 'String', handles.metricdata.fixation);
set(handles.minfix, 'String', handles.metricdata.minfix);
set(handles.minprestim, 'String', handles.metricdata.minprestim);
set(handles.maxprestim, 'String', handles.metricdata.maxprestim);
set(handles.mintarget, 'String', handles.metricdata.mintarget);
set(handles.maxtarget, 'String', handles.metricdata.maxtarget);
set(handles.minblank, 'String', handles.metricdata.minblank);
set(handles.maxblank, 'String', handles.metricdata.maxblank);
set(handles.mindelay, 'String', handles.metricdata.mindelay);
set(handles.maxdelay, 'String', handles.metricdata.maxdelay);
set(handles.response,  'String', handles.metricdata.response);
set(handles.minresponse, 'String', handles.metricdata.minresponse);
set(handles.feedback,  'String', handles.metricdata.feedback);
set(handles.penalty, 'String', handles.metricdata.penalty);
set(handles.miniti, 'String', handles.metricdata.miniti);
set(handles.maxiti, 'String', handles.metricdata.maxiti);
set(handles.buffertime, 'String', handles.metricdata.buffertime);
set(handles.fixsize, 'String', handles.metricdata.fixsize);
set(handles.fixwin, 'String', handles.metricdata.fixwin);
set(handles.horgnum, 'String', handles.metricdata.horgnum);
set(handles.vergnum, 'String', handles.metricdata.vergnum);
set(handles.gridcontrast, 'String', handles.metricdata.gridcontrast);
set(handles.respondsizeratio, 'String', handles.metricdata.respondsizeratio);
set(handles.maxnumtarget,  'String', handles.metricdata.maxnumtarget);
set(handles.mindistractor, 'String', handles.metricdata.mindistractor);
set(handles.maxdistractor,  'String', handles.metricdata.maxdistractor);
set(handles.rewardprob,  'String', handles.metricdata.rewardprob);
set(handles.rewardduration,  'String', handles.metricdata.rewardduration);
set(handles.manualrewardduration,  'String', handles.metricdata.manualrewardduration);
set(handles.blocknum,  'String', handles.metricdata.blocknum);
set(handles.maxcorrecttrials,  'String', handles.metricdata.maxcorrecttrials);
set(handles.prestimcontrast,  'String', handles.metricdata.prestimcontrast);
set(handles.stimcontrast,  'String', handles.metricdata.stimcontrast);
set(handles.responsecontrast,  'String', handles.metricdata.responsecontrast);
set(handles.channel, 'String', handles.metricdata.channel);
set(handles.anode, 'String', handles.metricdata.anode);
set(handles.serialport, 'String', handles.metricdata.serialport);
set(handles.rate, 'String', handles.metricdata.rate);
set(handles.first_pulseamp, 'String', handles.metricdata.first_pulseamp);
set(handles.second_pulseamp, 'String', handles.metricdata.second_pulseamp);
set(handles.first_pulsedur, 'String', handles.metricdata.first_pulsedur);
set(handles.second_pulsedur, 'String', handles.metricdata.second_pulsedur);
set(handles.numpulses, 'String', handles.metricdata.numpulses);
set(handles.interdur, 'String', handles.metricdata.interdur);
set(handles.stimprob, 'String', handles.metricdata.stimprob);
set(handles.stimonset, 'String', handles.metricdata.stimonset);
set(handles.savefilename_ext,  'String', handles.metricdata.savefilename_ext);

guidata(handles.figure1, handles);
plot_stimulus(handles)
updatepopupmenu(handles)

% function loadeyedata_Callback(hObject, eventdata, handles)
% % hObject    handle to save (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% homeDir = 'C:\Users\neuro\Desktop\Camilo Matlab';
% % homeDir = '/Volumes/Chimera/Users/elebjh/Desktop';
% % homeDir = '~/Desktop';
% [eyedatafile,filepath1]=uigetfile({'*.*','All Files'},...
%     'Select Settings File');
% 
% set(handles.eyedatafile,'String',eyedatafile);
% handles.metricdata.eyedatafile = eyedatafile;
% guidata(hObject,handles)

function starteyelink_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Eyelink('initialize');
Eyelink('StartRecording',1,1,1,1);


function stopeyelink_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Eyelink('StopRecording');

% --- Executes during object creation, after setting all properties.
% function eyedatafile_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to fixation (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the save flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to save the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

% time parameters.
minITI = 0.5; % time between end of previous trial and begin of new trial (s)
maxITI = 1.5; 
penalty = 2; % penalty duration
mindelay = 2; % delay duration
maxdelay = 3; 
minsquareTimeON = 0.5; % time cue, target and distractors are ON (s)
maxsquareTimeON = 0.6; % time cue, target and distractors are ON (s)
mininterSquareTime = 0.5; % time between cue and distractors and targets (s)
maxinterSquareTime = 0.6; % time between cue and distractors and targets (s)
rangeRT = [100 2000]; % range of allowed RT
timeOnTarget = 1; % time required to stay on target (s)
feedbackTime = 0.5;
timeFixation = 0.5; % time after fixation when trial begins (s)
fixationOn = 10;
minprestim = 0.2;
maxprestim = 0.4;
rewardprob = 1;
rewardduration = 0.5;
manualrewardduration = 0.5;
blocknum = 0;
maxcorrecttrials = 30;
selected_target_locations = 0;
selected_distractor_locations = 0;
buffertime = 0;
prestimcontrast = 0;
stimcontrast = 100;
responsecontrast = 0;
gridcontrast = 100;
respondsizeratio = 1.1;
savefilename_ext = '';

% stimulus parameters
maxnumtarget = 0;
rangeDistractors = [3 3];
squareSize = 150; % size of cue, target and distractors (px)
numDivisionsGrid = [5 5]; % number of division of grid in [x,y] axis
fixSize = 50; % size fixation spot (px)
fixArea = 150; % area where it is considered fixation (px)

% backgroundColor = [100 100 100];

handles.metricdata.trainstep = 1;
handles.metricdata.monkeyname = 'P';
handles.metricdata.fixation = fixationOn*1000;
handles.metricdata.minfix = timeFixation*1000;
handles.metricdata.minprestim = minprestim*1000;
handles.metricdata.maxprestim = maxprestim*1000;
handles.metricdata.mintarget = minsquareTimeON*1000;
handles.metricdata.maxtarget = maxsquareTimeON*1000;
handles.metricdata.minblank = mininterSquareTime*1000;
handles.metricdata.maxblank = maxinterSquareTime*1000;
handles.metricdata.mindelay = mindelay*1000;
handles.metricdata.maxdelay = maxdelay*1000;
handles.metricdata.response  = rangeRT(2);
handles.metricdata.minresponse = timeOnTarget*1000;
handles.metricdata.feedback  = feedbackTime*1000;
handles.metricdata.penalty  = penalty*1000;
handles.metricdata.miniti  = minITI*1000;
handles.metricdata.maxiti  = maxITI*1000;
handles.metricdata.buffertime  = buffertime*1000;
handles.metricdata.fixsize  = fixSize;
handles.metricdata.fixwin  = fixArea;
handles.metricdata.horgnum  = numDivisionsGrid(1);
handles.metricdata.vergnum  = numDivisionsGrid(2);
handles.metricdata.gridcontrast  = gridcontrast;
handles.metricdata.respondsizeratio  = respondsizeratio;
handles.metricdata.maxnumtarget  = maxnumtarget;
handles.metricdata.mindistractor = rangeDistractors(1);
handles.metricdata.maxdistractor  = rangeDistractors(2);
handles.metricdata.rewardprob  = rewardprob;
handles.metricdata.rewardduration  = rewardduration;
handles.metricdata.manualrewardduration  = manualrewardduration;
handles.metricdata.blocknum  = blocknum;
handles.metricdata.maxcorrecttrials  = maxcorrecttrials;
handles.metricdata.selected_target_locations  = selected_target_locations;
handles.metricdata.selected_distractor_locations  = selected_distractor_locations;
handles.metricdata.fixcol = [255 255 255];
handles.metricdata.stimref = 1;
handles.metricdata.targetcol = [255 0 0];
handles.metricdata.distractorcol  = [0 255 0];
handles.metricdata.mouse  = 0;
handles.metricdata.respond_center  = 0;
handles.metricdata.fixtime  = 0;
handles.metricdata.prestimcontrast  = prestimcontrast;
handles.metricdata.stimcontrast  = stimcontrast;
handles.metricdata.responsecontrast  = responsecontrast;
handles.metricdata.channel  = 1;
handles.metricdata.anode  = 2;
handles.metricdata.serialport = 'COM7';
handles.metricdata.rate = 100;
handles.metricdata.first_pulseamp = 100;
handles.metricdata.second_pulseamp = -100;
handles.metricdata.first_pulsedur = 50;
handles.metricdata.second_pulsedur = 50;
handles.metricdata.numpulses = 0;
handles.metricdata.interdur = 25;
handles.metricdata.stimprob = 0;
handles.metricdata.stimonset = 100;
handles.metricdata.savefilename_ext = savefilename_ext;

set(handles.fixation, 'String', handles.metricdata.fixation);
set(handles.minfix, 'String', handles.metricdata.minfix);
set(handles.minprestim, 'String', handles.metricdata.minprestim);
set(handles.maxprestim, 'String', handles.metricdata.maxprestim);
set(handles.mintarget, 'String', handles.metricdata.mintarget);
set(handles.maxtarget, 'String', handles.metricdata.maxtarget);
set(handles.minblank, 'String', handles.metricdata.minblank);
set(handles.maxblank, 'String', handles.metricdata.maxblank);
set(handles.mindelay, 'String', handles.metricdata.mindelay);
set(handles.maxdelay, 'String', handles.metricdata.maxdelay);
set(handles.response,  'String', handles.metricdata.response);
set(handles.minresponse, 'String', handles.metricdata.minresponse);
set(handles.feedback,  'String', handles.metricdata.feedback);
set(handles.penalty, 'String', handles.metricdata.penalty);
set(handles.miniti, 'String', handles.metricdata.miniti);
set(handles.maxiti, 'String', handles.metricdata.maxiti);
set(handles.buffertime, 'String', handles.metricdata.buffertime);
set(handles.fixsize, 'String', handles.metricdata.fixsize);
set(handles.fixwin, 'String', handles.metricdata.fixwin);
set(handles.horgnum, 'String', handles.metricdata.horgnum);
set(handles.vergnum, 'String', handles.metricdata.vergnum);
set(handles.gridcontrast, 'String', handles.metricdata.gridcontrast);
set(handles.respondsizeratio, 'String', handles.metricdata.respondsizeratio);
set(handles.maxnumtarget, 'String', handles.metricdata.maxnumtarget);
set(handles.mindistractor, 'String', handles.metricdata.mindistractor);
set(handles.maxdistractor,  'String', handles.metricdata.maxdistractor);
set(handles.rewardprob,  'String', handles.metricdata.rewardprob);
set(handles.rewardduration,  'String', handles.metricdata.rewardduration);
set(handles.manualrewardduration,  'String', handles.metricdata.manualrewardduration);
set(handles.blocknum,  'String', handles.metricdata.blocknum);
set(handles.maxcorrecttrials,  'String', handles.metricdata.maxcorrecttrials);
set(handles.prestimcontrast,  'String', handles.metricdata.prestimcontrast);
set(handles.stimcontrast,  'String', handles.metricdata.stimcontrast);
set(handles.responsecontrast,  'String', handles.metricdata.responsecontrast);
set(handles.savefilename_ext,  'String', handles.metricdata.savefilename_ext);

all_handles = [handles.fixation,handles.minfix,handles.minprestim,handles.maxprestim,handles.mintarget,handles.maxtarget,handles.minblank...
    ,handles.maxblank,handles.mindelay,handles.maxdelay,handles.response,handles.minresponse,handles.feedback,handles.penalty,handles.miniti...
    ,handles.maxiti,handles.fixsize,handles.fixwin,handles.fixcol,handles.horgnum,handles.vergnum,handles.gridcontrast,handles.respondsizeratio,handles.maxnumtarget,handles.mindistractor...
    ,handles.maxdistractor,handles.rewardprob,handles.rewardduration,handles.manualrewardduration,handles.blocknum,handles.maxcorrecttrials,handles.mouse...
    ,handles.respond_center,handles.targetcol,handles.distractorcol,handles.buffertime,handles.fixtime,handles.prestimcontrast,handles.stimcontrast,handles.responsecontrast...
    ,handles.savefilename_ext,handles.channel,handles.anode,handles.serialport,handles.rate,handles.first_pulseamp,handles.second_pulseamp,handles.first_pulsedur,handles.second_pulsedur,handles.numpulses...
    ,handles.interdur,handles.stimprob,handles.stimonset,handles.stimref];

set(all_handles,'Enable','off');

% Update handles structure
guidata(handles.figure1, handles);

plot_stimulus(handles)

function targetselect_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% selected_target_locations = advanced_gui(handles.metricdata.horgnum,handles.metricdata.vergnum);
% handles.metricdata.selected_target_locations = {selected_target_locations};

selected_target_locations = handles.metricdata.selected_target_locations;

if selected_target_locations == 0
    selected_target_locations = [];
end

horgnum = handles.metricdata.horgnum;
vergnum = handles.metricdata.vergnum;

if (horgnum > 31) || (vergnum > 31)
    error('The maximum grid size is 31x31')
end
% Create and hide the GUI figure as it is being constructed.
width = 350;
height= 350;
f = figure('Visible','off','Position',[200,500,width,height]);
hsurf = cell(horgnum,vergnum);

square_width = (width-20)/horgnum;
square_height = (height-20)/vergnum;

% Construct the components
for tempy = 1:horgnum
    left = 10 + (tempy-1)*square_width;
    for tempx = 1:vergnum
        if tempy == (horgnum+1)/2 && tempx == (vergnum+1)/2
        else
            if isempty(selected_target_locations)
                bottom = height-10 - tempx*square_height;
                hsurf{tempx,tempy} = uicontrol('Style','togglebutton',...
                    'Position',[left,bottom,square_width,square_height],...
                    'Callback',{@selectsquare_Callback,hObject,horgnum,vergnum,f,tempx,tempy});
            else
                selected = 0;
                for i = 1:size(selected_target_locations)
                    if selected_target_locations(i,1) == tempy && selected_target_locations(i,2) == tempx
                        bottom = height-10 - tempx*square_height;
                        hsurf{tempx,tempy} = uicontrol('Style','togglebutton',...
                            'Position',[left,bottom,square_width,square_height],...
                            'Callback',{@selectsquare_Callback,hObject,horgnum,vergnum,f,tempx,tempy},'Value',1);
                        selected = 1;
                        break
                    end
                end
                if selected == 1
                else
                    bottom = height-10 - tempx*square_height;
                    hsurf{tempx,tempy} = uicontrol('Style','togglebutton',...
                        'Position',[left,bottom,square_width,square_height],...
                        'Callback',{@selectsquare_Callback,hObject,horgnum,vergnum,f,tempx,tempy},'Value',0);
                end
            end
        end
    end
end

% Initialize the GUI.
% Change units to normalized so components resize
% automatically.
% Assign the GUI a name to appear in the window title.
set(f,'Name','Advanced')
% Move the GUI to the center of the screen.
movegui(f,'center')
% Make the GUI visible.
set(f,'Visible','on');


function selectsquare_Callback(source,eventdata,hObject,horgnum,vergnum,f,tempx,tempy)

x = tempy;
y = tempx;

handles = guidata(hObject);
selected_target_locations = handles.metricdata.selected_target_locations;

if selected_target_locations == 0
    selected_target_locations = [];
end

% selected_target_locations = handles.metricdata.selected_target_locations
button_state = get(source,'Value');
if button_state == get(source,'Max')
    % toggle button is pressed
    selected_target_locations = [selected_target_locations ;[x y]];
    
elseif button_state == get(source,'Min')
    % toggle button is not pressed
    numsquares = size(selected_target_locations,1);
    for i = 1:numsquares
        if sum(selected_target_locations(i,:) == [x y]) == 2
            if i ~= 1 && i ~= numsquares
                selected_target_locations = [selected_target_locations(1:(i-1),:);selected_target_locations((i+1):end,:)];
                break
            elseif i == 1
                selected_target_locations = selected_target_locations((i+1):end,:);
                break
            elseif i == numsquares
                selected_target_locations = selected_target_locations(1:(i-1),:);
                break
            end
        end
    end
end

% Save the new mintarget value
handles.metricdata.selected_target_locations = selected_target_locations;
guidata(hObject,handles)
plot_stimulus(handles);
figure(f)

function distractorselect_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selected_distractor_locations = handles.metricdata.selected_distractor_locations;

if selected_distractor_locations == 0
    selected_distractor_locations = [];
end

horgnum = handles.metricdata.horgnum;
vergnum = handles.metricdata.vergnum;

if (horgnum > 31) || (vergnum > 31)
    error('The maximum grid size is 31x31')
end

% Create and hide the GUI figure as it is being constructed.
width = 350;
height= 350;
f = figure('Visible','off','Position',[200,500,width,height]);
hsurf = cell(horgnum,vergnum);

square_width = (width-20)/horgnum;
square_height = (height-20)/vergnum;

% Construct the components
for tempy = 1:horgnum
    left = 10 + (tempy-1)*square_width;
    for tempx = 1:vergnum
        if tempy == (horgnum+1)/2 && tempx == (vergnum+1)/2
        else
            if isempty(selected_distractor_locations)
                bottom = height-10 - tempx*square_height;
                hsurf{tempx,tempy} = uicontrol('Style','togglebutton',...
                    'Position',[left,bottom,square_width,square_height],...
                    'Callback',{@selectdistractorsquare_Callback,hObject,horgnum,vergnum,f,tempx,tempy});
            else
                selected = 0;
                for i = 1:size(selected_distractor_locations)
                    if selected_distractor_locations(i,1) == tempy && selected_distractor_locations(i,2) == tempx
                        bottom = height-10 - tempx*square_height;
                        hsurf{tempx,tempy} = uicontrol('Style','togglebutton',...
                            'Position',[left,bottom,square_width,square_height],...
                            'Callback',{@selectdistractorsquare_Callback,hObject,horgnum,vergnum,f,tempx,tempy},'Value',1);
                        selected = 1;
                        break
                    end
                end
                if selected == 1
                else
                    bottom = height-10 - tempx*square_height;
                    hsurf{tempx,tempy} = uicontrol('Style','togglebutton',...
                        'Position',[left,bottom,square_width,square_height],...
                        'Callback',{@selectdistractorsquare_Callback,hObject,horgnum,vergnum,f,tempx,tempy},'Value',0);
                end
            end
        end
    end
end

% Initialize the GUI.
% Change units to normalized so components resize
% automatically.
% Assign the GUI a name to appear in the window title.
set(f,'Name','Advanced')
% Move the GUI to the center of the screen.
movegui(f,'center')
% Make the GUI visible.
set(f,'Visible','on');


function selectdistractorsquare_Callback(source,eventdata,hObject,horgnum,vergnum,f,tempx,tempy)

x = tempy;
y = tempx;

handles = guidata(hObject);
selected_distractor_locations = handles.metricdata.selected_distractor_locations;

if selected_distractor_locations == 0
    selected_distractor_locations = [];
end

button_state = get(source,'Value');
if button_state == get(source,'Max')
    % toggle button is pressed
    selected_distractor_locations = [selected_distractor_locations ;[x y]];
    
elseif button_state == get(source,'Min')
    % toggle button is not pressed
    numsquares = size(selected_distractor_locations,1);
    for i = 1:numsquares
        if sum(selected_distractor_locations(i,:) == [x y]) == 2
            if i ~= 1 && i ~= numsquares
                selected_distractor_locations = [selected_distractor_locations(1:(i-1),:);selected_distractor_locations((i+1):end,:)];
                break
            elseif i == 1
                selected_distractor_locations = selected_distractor_locations((i+1):end,:);
                break
            elseif i == numsquares
                selected_distractor_locations = selected_distractor_locations(1:(i-1),:);
                break
            end
        end
    end
end

% Save the new mintarget value
handles.metricdata.selected_distractor_locations = selected_distractor_locations;
guidata(hObject,handles)
plot_stimulus(handles);
figure(f)

% --- Executes on selection change in trainstep.
function trainstep_Callback(hObject, eventdata, handles)
% hObject    handle to trainstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns trainstep contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trainstep
str = get(hObject, 'String');
val = get(hObject,'Value');

all_handles = [handles.fixation,handles.minfix,handles.minprestim,handles.maxprestim,handles.mintarget,handles.maxtarget,handles.minblank...
    ,handles.maxblank,handles.mindelay,handles.maxdelay,handles.response,handles.minresponse,handles.feedback,handles.penalty,handles.miniti...
    ,handles.maxiti,handles.fixsize,handles.fixwin,handles.fixcol,handles.horgnum,handles.vergnum,handles.gridcontrast,handles.respondsizeratio,handles.maxnumtarget,handles.mindistractor...
    ,handles.maxdistractor,handles.rewardprob,handles.rewardduration,handles.manualrewardduration,handles.blocknum,handles.maxcorrecttrials,handles.mouse...
    ,handles.respond_center,handles.targetcol,handles.distractorcol,handles.buffertime,handles.fixtime,handles.prestimcontrast,handles.stimcontrast,handles.responsecontrast...
    ,handles.savefilename_ext,handles.channel,handles.anode,handles.serialport,handles.rate,handles.first_pulseamp,handles.second_pulseamp,handles.first_pulsedur,handles.second_pulsedur,handles.numpulses...
    ,handles.interdur,handles.stimprob,handles.stimonset,handles.stimref];

switch str{val};
    case 'Set 1' % User selects Peaks.
        handles.metricdata.trainstep = 1;
        on_handles = [handles.fixation,handles.minfix,handles.feedback,handles.miniti,handles.maxiti,handles.fixsize,handles.rewardprob...
            ,handles.rewardduration,handles.manualrewardduration,handles.fixwin,handles.fixcol,handles.mouse,handles.channel,handles.anode...
            ,handles.serialport,handles.rate,handles.first_pulseamp,handles.second_pulseamp,handles.first_pulsedur,handles.second_pulsedur,handles.numpulses, handles.interdur,handles.stimprob,handles.stimonset,handles.savefilename_ext];
        
        set(all_handles,'Enable','off');
        set(on_handles,'Enable','on');
    case 'Set 2' % User selects Peaks.
        handles.metricdata.trainstep = 2;
        on_handles = [handles.fixation,handles.minfix,handles.minprestim,handles.maxprestim,handles.response,handles.minresponse...
            ,handles.feedback,handles.penalty,handles.miniti,handles.maxiti,handles.fixsize,handles.fixwin,handles.horgnum,handles.mouse...
            ,handles.vergnum,handles.targetcol,handles.rewardprob,handles.rewardduration,handles.manualrewardduration,handles.blocknum,handles.fixcol,handles.buffertime,handles.savefilename_ext];
        
        set(all_handles,'Enable','off');
        set(on_handles,'Enable','on');
     case 'Set 3' % User selects Membrane.
        handles.metricdata.trainstep = 3;
        on_handles = [handles.fixation,handles.minfix,handles.minprestim,handles.maxprestim,handles.mintarget,handles.maxtarget,handles.minblank...
            ,handles.maxblank,handles.mindelay,handles.maxdelay,handles.feedback,handles.penalty,handles.miniti...
            ,handles.maxiti,handles.fixsize,handles.fixwin,handles.fixcol,handles.horgnum,handles.vergnum,handles.mindistractor,handles.maxdistractor...
            ,handles.rewardprob,handles.rewardduration,handles.manualrewardduration,handles.blocknum,handles.mouse,handles.targetcol,handles.distractorcol...
            ,handles.buffertime,handles.fixtime,handles.savefilename_ext];
        
        set(all_handles,'Enable','off');
        set(on_handles,'Enable','on');
    case 'Set 4' % User selects Membrane.
        handles.metricdata.trainstep = 4;
        on_handles = [handles.fixation,handles.minfix,handles.minprestim,handles.maxprestim,handles.mintarget,handles.maxtarget,handles.minblank...
            ,handles.maxblank,handles.mindelay,handles.maxdelay,handles.feedback,handles.penalty,handles.miniti...
            ,handles.maxiti,handles.fixsize,handles.fixwin,handles.fixcol,handles.horgnum,handles.vergnum,handles.mindistractor,handles.maxdistractor...
            ,handles.rewardprob,handles.rewardduration,handles.manualrewardduration,handles.blocknum,handles.mouse,handles.targetcol,handles.distractorcol...
            ,handles.buffertime,handles.fixtime,handles.savefilename_ext];
        
        set(all_handles,'Enable','off');
        set(on_handles,'Enable','on');
    case 'DST' % User selects Membrane.
        handles.metricdata.trainstep = 5;
        
        on_handles = [handles.fixation,handles.minfix,handles.minprestim,handles.maxprestim,handles.mintarget,handles.maxtarget,handles.minblank...
            ,handles.maxblank,handles.mindelay,handles.maxdelay,handles.response,handles.minresponse,handles.feedback,handles.penalty,handles.miniti...
            ,handles.maxiti,handles.fixsize,handles.fixwin,handles.fixcol,handles.horgnum,handles.vergnum,handles.gridcontrast,handles.respondsizeratio,handles.maxnumtarget,handles.mindistractor...
            ,handles.maxdistractor,handles.rewardprob,handles.rewardduration,handles.manualrewardduration,handles.blocknum,handles.maxcorrecttrials,handles.mouse...
            ,handles.respond_center,handles.targetcol,handles.distractorcol,handles.buffertime,handles.fixtime,handles.prestimcontrast,handles.stimcontrast,handles.responsecontrast...
            ,handles.savefilename_ext,handles.channel,handles.rate,handles.first_pulseamp,handles.second_pulseamp,handles.first_pulsedur,handles.second_pulsedur,handles.numpulses...
            ,handles.interdur,handles.stimprob,handles.stimonset,handles.stimref];
        set(all_handles,'Enable','off');
        set(on_handles,'Enable','on');
        
    case 'Eye Calib' % User selects Peaks.
        handles.metricdata.trainstep = 6;
        on_handles = [handles.fixsize,handles.fixcol];
        
        set(all_handles,'Enable','off');
        set(on_handles,'Enable','on');
        
    case 'Auto Eye Calib' % User selects Peaks.
        handles.metricdata.trainstep = 7;
        on_handles = [handles.fixation,handles.minfix,handles.feedback,handles.miniti,handles.maxiti,handles.fixsize,handles.rewardprob...
            ,handles.rewardduration,handles.manualrewardduration,handles.fixwin,handles.fixcol,handles.blocknum];
        
        set(all_handles,'Enable','off');
        set(on_handles,'Enable','on');
    case 'Eyelink Calib' % User selects Peaks.
        handles.metricdata.trainstep = 8;
        on_handles = [handles.rewardduration,handles.manualrewardduration,handles.fixcol];
        
        set(all_handles,'Enable','off');
        set(on_handles,'Enable','on');
end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function trainstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'-----','Set 1','Set 2','Set 3','Set 4','DST','Eye Calib','Auto Eye Calib','Eyelink Calib'});

% --- Executes on selection change in trainstep.
function monkeyname_Callback(hObject, eventdata, handles)
% hObject    handle to trainstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns trainstep contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trainstep
str = get(hObject, 'String');
val = get(hObject,'Value');

switch str{val};
    case 'Pancake' % User selects Peaks.
        handles.metricdata.monkeyname = 'P';
    case 'James' % User selects Peaks.
        handles.metricdata.monkeyname = 'J';

end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function monkeyname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'Pancake','James'});

% function loadfile_Callback(hObject, eventdata, handles)
% % hObject    handle to trainstep (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = get(hObject,'String') returns trainstep contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from trainstep
% str = get(hObject, 'String');
% val = get(hObject,'Value');
% 
% switch str{val};
%     case 'Pancake' % User selects Peaks.
%         handles.metricdata.loadfile = 'P';
%     case 'James' % User selects Peaks.
%         handles.metricdata.loadfile = 'J';
% 
% end
% guidata(hObject,handles)
% 
% 
% % --- Executes during object creation, after setting all properties.
% function loadfile_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to trainstep (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% set(hObject, 'String', {'Pancake','James'});


function fixation_Callback(hObject, eventdata, handles)
% hObject    handle to fixation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fixation as text
%        str2double(get(hObject,'String')) returns contents of fixation as a double
fixation = str2double(get(hObject, 'String'));
if isnan(fixation)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.fixation = fixation;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function fixation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function minfix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minfix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minfix_Callback(hObject, eventdata, handles)
% hObject    handle to minfix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minfix as text
%        str2double(get(hObject,'String')) returns contents of minfix as a double
minfix = str2double(get(hObject, 'String'));
if isnan(minfix)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.minfix = minfix;
guidata(hObject,handles)

function minprestim_Callback(hObject, eventdata, handles)
% hObject    handle to minprestim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minprestim as text
%        str2double(get(hObject,'String')) returns contents of minprestim as a double
minprestim = str2double(get(hObject, 'String'));
if isnan(minprestim)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.minprestim = minprestim;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function minprestim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minprestim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxprestim_Callback(hObject, eventdata, handles)
% hObject    handle to minprestim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minprestim as text
%        str2double(get(hObject,'String')) returns contents of minprestim as a double
maxprestim = str2double(get(hObject, 'String'));
if isnan(maxprestim)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.maxprestim = maxprestim;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function maxprestim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minprestim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mintarget_Callback(hObject, eventdata, handles)
% hObject    handle to mintarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minfgfgfgf as text
%        str2double(get(hObject,'String')) returns contents of mintarget as a double
mintarget = str2double(get(hObject, 'String'));
if isnan(mintarget)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.mintarget = mintarget;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function mintarget_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mintarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxtarget_Callback(hObject, eventdata, handles)
% hObject    handle to maxtarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxtarget as text
%        str2double(get(hObject,'String')) returns contents of maxtarget as a double
maxtarget = str2double(get(hObject, 'String'));
if isnan(maxtarget)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.maxtarget = maxtarget;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function maxtarget_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxtarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minblank_Callback(hObject, eventdata, handles)
% hObject    handle to minblank (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minblank as text
%        str2double(get(hObject,'String')) returns contents of minblank as a double
minblank = str2double(get(hObject, 'String'));
if isnan(minblank)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.minblank = minblank;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function minblank_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minblank (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxblank_Callback(hObject, eventdata, handles)
% hObject    handle to maxblank (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxblank as text
%        str2double(get(hObject,'String')) returns contents of maxblank as a double
maxblank = str2double(get(hObject, 'String'));
if isnan(maxblank)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.maxblank = maxblank;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function maxblank_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxblank (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mindelay_Callback(hObject, eventdata, handles)
% hObject    handle to mindelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mindelay as text
%        str2double(get(hObject,'String')) returns contents of mindelay as a double
mindelay = str2double(get(hObject, 'String'));
if isnan(mindelay)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.mindelay = mindelay;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function mindelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mindelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxdelay_Callback(hObject, eventdata, handles)
% hObject    handle to mindelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mindelay as text
%        str2double(get(hObject,'String')) returns contents of mindelay as a double
maxdelay = str2double(get(hObject, 'String'));
if isnan(maxdelay)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.maxdelay = maxdelay;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function maxdelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mindelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function response_Callback(hObject, eventdata, handles)
% hObject    handle to response (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of response as text
%        str2double(get(hObject,'String')) returns contents of response as a double
response = str2double(get(hObject, 'String'));
if isnan(response)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.response = response;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function response_CreateFcn(hObject, eventdata, handles)
% hObject    handle to response (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minresponse_Callback(hObject, eventdata, handles)
% hObject    handle to minresponse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minresponse as text
%        str2double(get(hObject,'String')) returns contents of minresponse as a double
minresponse = str2double(get(hObject, 'String'));
if isnan(minresponse)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.minresponse = minresponse;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function minresponse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minresponse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function feedback_Callback(hObject, eventdata, handles)
% hObject    handle to feedback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of feedback as text
%        str2double(get(hObject,'String')) returns contents of feedback as a double
feedback = str2double(get(hObject, 'String'));
if isnan(feedback)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.feedback = feedback;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function feedback_CreateFcn(hObject, eventdata, handles)
% hObject    handle to feedback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function penalty_Callback(hObject, eventdata, handles)
% hObject    handle to penalty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of penalty as text
%        str2double(get(hObject,'String')) returns contents of penalty as a double
penalty = str2double(get(hObject, 'String'));
if isnan(penalty)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.penalty = penalty;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function penalty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to penalty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function miniti_Callback(hObject, eventdata, handles)
% hObject    handle to miniti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of miniti as text
%        str2double(get(hObject,'String')) returns contents of miniti as a double
miniti = str2double(get(hObject, 'String'));
if isnan(miniti)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.miniti = miniti;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function miniti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to miniti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxiti_Callback(hObject, eventdata, handles)
% hObject    handle to miniti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of miniti as text
%        str2double(get(hObject,'String')) returns contents of miniti as a double
maxiti = str2double(get(hObject, 'String'));
if isnan(maxiti)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.maxiti = maxiti;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function maxiti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to miniti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function buffertime_Callback(hObject, eventdata, handles)
% hObject    handle to fixsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fixsize as text
%        str2double(get(hObject,'String')) returns contents of fixsize as a double
buffertime = str2double(get(hObject, 'String'));
if isnan(buffertime)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Save the new minfix value
handles.metricdata.buffertime = buffertime;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function buffertime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to miniti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fixsize_Callback(hObject, eventdata, handles)
% hObject    handle to fixwin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fixwin as text
%        str2double(get(hObject,'String')) returns contents of fixwin as a double
fixsize = str2double(get(hObject, 'String'));
if isnan(fixsize)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.fixsize = fixsize;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function fixsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function fixwin_Callback(hObject, eventdata, handles)
% hObject    handle to fixwin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fixwin as text
%        str2double(get(hObject,'String')) returns contents of fixwin as a double
fixwin = str2double(get(hObject, 'String'));
if isnan(fixwin)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.fixwin = fixwin;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function fixwin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixwin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in targetcol.
function fixcol_Callback(hObject, eventdata, handles)
% hObject    handle to targetcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns targetcol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from targetcol
str = get(hObject, 'String');
val = get(hObject,'Value');

switch str{val};
    case 'White' % User selects Membrane.
        handles.metricdata.fixcol = [255 255 255];
    case 'Yellow' % User selects Peaks.
        handles.metricdata.fixcol = [255 255 0];
    case 'Red' % User selects Peaks.
        handles.metricdata.fixcol = [255 0 0];
end
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function fixcol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'White','Yellow','Red'});

function mouse_Callback(hObject, eventdata, handles)
% hObject    handle to fixwin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fixwin as text
%        str2double(get(hObject,'String')) returns contents of fixwin as a double
if (get(hObject,'Value') == get(hObject,'Max'))
    % Checkbox is checked-take approriate action
    handles.metricdata.mouse = 1;
else
    handles.metricdata.mouse = 0;
end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function mouse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixwin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function respond_center_Callback(hObject, eventdata, handles)
% hObject    handle to fixwin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fixwin as text
%        str2double(get(hObject,'String')) returns contents of fixwin as a double
if (get(hObject,'Value') == get(hObject,'Max'))
    % Checkbox is checked-take approriate action
    handles.metricdata.respond_center = 1;
else
    handles.metricdata.respond_center = 0;
end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function respond_center_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixwin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fixtime_Callback(hObject, eventdata, handles)
% hObject    handle to fixwin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fixwin as text
%        str2double(get(hObject,'String')) returns contents of fixwin as a double
if (get(hObject,'Value') == get(hObject,'Max'))
    % Checkbox is checked-take approriate action
    handles.metricdata.fixtime = 1;
else
    handles.metricdata.fixtime = 0;
end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function fixtime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixwin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function horgnum_Callback(hObject, eventdata, handles)
% hObject    handle to horgnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of horgnum as text
%        str2double(get(hObject,'String')) returns contents of horgnum as a double
horgnum = str2double(get(hObject, 'String'));
if isnan(horgnum)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.horgnum = horgnum;
handles.metricdata.selected_target_locations = 0;
handles.metricdata.selected_distractor_locations = 0;
guidata(hObject,handles)
plot_stimulus(handles)


% --- Executes during object creation, after setting all properties.
function horgnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to horgnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vergnum_Callback(hObject, eventdata, handles)
% hObject    handle to vergnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vergnum as text
%        str2double(get(hObject,'String')) returns contents of vergnum as a double
vergnum = str2double(get(hObject, 'String'));
if isnan(vergnum)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new minfix value
handles.metricdata.vergnum = vergnum;
handles.metricdata.selected_target_locations = 0;
handles.metricdata.selected_distractor_locations = 0;
guidata(hObject,handles)
plot_stimulus(handles)


% --- Executes during object creation, after setting all properties.
function vergnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vergnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function gridcontrast_Callback(hObject, eventdata, handles)
% hObject    handle to mindistractor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mindistractor as text
%        str2double(get(hObject,'String')) returns contents of mindistractor as a double
gridcontrast = str2double(get(hObject, 'String'));
if isnan(gridcontrast)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.gridcontrast = gridcontrast;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function gridcontrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mindistractor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function respondsizeratio_Callback(hObject, eventdata, handles)
% hObject    handle to mindistractor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mindistractor as text
%        str2double(get(hObject,'String')) returns contents of mindistractor as a double
respondsizeratio = str2double(get(hObject, 'String'));
if isnan(respondsizeratio)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.respondsizeratio = respondsizeratio;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function respondsizeratio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mindistractor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in targetcol.
function targetcol_Callback(hObject, eventdata, handles)
% hObject    handle to targetcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns targetcol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from targetcol
str = get(hObject, 'String');
val = get(hObject,'Value');

switch str{val};
    case 'Red' % User selects Peaks.
        handles.metricdata.targetcol = [255 0 0];
    case 'Green' % User selects Membrane.
        handles.metricdata.targetcol = [0 255 0];
end
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function targetcol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Red', 'Green'});

% --- Executes on selection change in targetcol.
function distractorcol_Callback(hObject, eventdata, handles)
% hObject    handle to targetcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns targetcol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from targetcol
str = get(hObject, 'String');
val = get(hObject,'Value');

switch str{val};
    case 'Green' % User selects Peaks.
        handles.metricdata.distractorcol = [0 255 0];
    case 'Red' % User selects Membrane.
        handles.metricdata.distractorcol = [255 0 0];
end
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function distractorcol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Green','Red'});


function maxnumtarget_Callback(hObject, eventdata, handles)
% hObject    handle to mindistractor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mindistractor as text
%        str2double(get(hObject,'String')) returns contents of mindistractor as a double
maxnumtarget = str2double(get(hObject, 'String'));
if isnan(maxnumtarget)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.maxnumtarget = maxnumtarget;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function maxnumtarget_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mindistractor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mindistractor_Callback(hObject, eventdata, handles)
% hObject    handle to mindistractor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mindistractor as text
%        str2double(get(hObject,'String')) returns contents of mindistractor as a double
mindistractor = str2double(get(hObject, 'String'));
if isnan(mindistractor)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.mindistractor = mindistractor;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function mindistractor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mindistractor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxdistractor_Callback(hObject, eventdata, handles)
% hObject    handle to maxdistractor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxdistractor as text
%        str2double(get(hObject,'String')) returns contents of maxdistractor as a double
maxdistractor = str2double(get(hObject, 'String'));
if isnan(maxdistractor)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.maxdistractor = maxdistractor;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function maxdistractor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxdistractor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rewardprob_Callback(hObject, eventdata, handles)
% hObject    handle to rewardprob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rewardprob as text
%        str2double(get(hObject,'String')) returns contents of rewardprob as a double
rewardprob = str2double(get(hObject, 'String'));
if isnan(rewardprob)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.rewardprob = rewardprob;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function rewardprob_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rewardprob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rewardduration_Callback(hObject, eventdata, handles)
% hObject    handle to rewardprob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rewardprob as text
%        str2double(get(hObject,'String')) returns contents of rewardprob as a double
rewardduration = str2double(get(hObject, 'String'));
if isnan(rewardduration)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.rewardduration = rewardduration;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function rewardduration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rewardprob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function manualrewardduration_Callback(hObject, eventdata, handles)
% hObject    handle to rewardprob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rewardprob as text
%        str2double(get(hObject,'String')) returns contents of rewardprob as a double
manualrewardduration = str2double(get(hObject, 'String'));
if isnan(manualrewardduration)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.manualrewardduration = manualrewardduration;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function manualrewardduration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rewardprob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function prestimcontrast_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
prestimcontrast = str2double(get(hObject, 'String'));
if isnan(prestimcontrast)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.prestimcontrast = prestimcontrast;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function prestimcontrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function stimcontrast_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
stimcontrast = str2double(get(hObject, 'String'));
if isnan(stimcontrast)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.stimcontrast = stimcontrast;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function stimcontrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function responsecontrast_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
responsecontrast = str2double(get(hObject, 'String'));
if isnan(responsecontrast)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.responsecontrast = responsecontrast;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function responsecontrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function blocknum_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
blocknum = str2double(get(hObject, 'String'));
if isnan(blocknum)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.blocknum = blocknum;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function blocknum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function channel_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
channel = str2double(get(hObject, 'String'));
if isnan(channel)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.channel = channel;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function anode_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
anode = str2double(get(hObject, 'String'));
if isnan(anode)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.anode = anode;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function anode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function serialport_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
serialport = get(hObject, 'String');
if isnan(serialport)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.serialport = serialport;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function serialport_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rate_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
rate = str2double(get(hObject, 'String'));
if isnan(rate)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.rate = rate;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function first_pulseamp_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
first_pulseamp = str2double(get(hObject, 'String'));
if isnan(first_pulseamp)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.first_pulseamp = first_pulseamp;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function first_pulseamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function first_pulsedur_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
first_pulsedur = str2double(get(hObject, 'String'));
if isnan(first_pulsedur)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.first_pulsedur = first_pulsedur;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function first_pulsedur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function second_pulseamp_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
second_pulseamp = str2double(get(hObject, 'String'));
if isnan(second_pulseamp)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.second_pulseamp = second_pulseamp;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function second_pulseamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function second_pulsedur_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
second_pulsedur = str2double(get(hObject, 'String'));
if isnan(second_pulsedur)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.second_pulsedur = second_pulsedur;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function second_pulsedur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function numpulses_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
numpulses = str2double(get(hObject, 'String'));
if isnan(numpulses)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.numpulses = numpulses;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function numpulses_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function interdur_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
interdur = str2double(get(hObject, 'String'));
if isnan(interdur)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.interdur = interdur;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function interdur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function stimprob_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
stimprob = str2double(get(hObject, 'String'));
if isnan(stimprob)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.stimprob = stimprob;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function stimprob_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function stimref_Callback(hObject, eventdata, handles)
% hObject    handle to targetcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns targetcol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from targetcol
str = get(hObject, 'String');
val = get(hObject,'Value');

switch str{val};
    case 'PreStim'
        handles.metricdata.stimref = 1;
    case 'Target' 
        handles.metricdata.stimref = 2;
    case 'Delay'
        handles.metricdata.stimref = 3;
    case 'Response'
        handles.metricdata.stimref = 4;
end
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function stimref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targetcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'PreStim','Target','Delay','Response'});

function stimonset_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
stimonset = str2double(get(hObject, 'String'));
if isnan(stimonset)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.stimonset = stimonset;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function stimonset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxcorrecttrials_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
maxcorrecttrials = str2double(get(hObject, 'String'));
if isnan(maxcorrecttrials)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.maxcorrecttrials = maxcorrecttrials;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function maxcorrecttrials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function savefilename_ext_Callback(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocknum as text
%        str2double(get(hObject,'String')) returns contents of blocknum as a double
savefilename_ext = get(hObject, 'String');
if isnan(savefilename_ext)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new mintarget value
handles.metricdata.savefilename_ext = savefilename_ext;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function savefilename_ext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocknum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plot_stimulus(handles)

% draw grid
axes(handles.stimulus)
for x = 0:handles.metricdata.horgnum
    plot(x*ones(size(0:handles.metricdata.vergnum)),0:handles.metricdata.vergnum)
    hold on
end
for y = 0:handles.metricdata.vergnum
    plot(0:handles.metricdata.horgnum,y*ones(size(0:handles.metricdata.horgnum)))
    hold on
end
xlim([0 handles.metricdata.horgnum])
ylim([0 handles.metricdata.vergnum])
set(handles.stimulus,'xticklabel',[],'yticklabel',[]) 

%draw stimulus
if isfield(handles.metricdata, 'selected_locations')
    if handles.metricdata.selected_locations ~= 0
        sstim = handles.metricdata.selected_locations;
        for x = 1:size(sstim,1)
            fill([sstim(x,1)-1,sstim(x,1)-1,sstim(x,1),sstim(x,1)],handles.metricdata.horgnum - [sstim(x,2)-1 sstim(x,2) sstim(x,2) sstim(x,2)-1],'r')
            
            hold on
        end
    end
else
    if isfield(handles.metricdata, 'selected_target_locations')
    
        if handles.metricdata.selected_target_locations ~= 0
            sstim = handles.metricdata.selected_target_locations;
            for x = 1:size(sstim,1)
                fill([sstim(x,1)-1,sstim(x,1)-1,sstim(x,1),sstim(x,1)],handles.metricdata.horgnum - [sstim(x,2)-1 sstim(x,2) sstim(x,2) sstim(x,2)-1],'r')
                
                hold on
            end
        end

        if handles.metricdata.selected_distractor_locations ~= 0
            distractorstim = handles.metricdata.selected_distractor_locations;
            for x = 1:size(distractorstim,1)
                fill([distractorstim(x,1)-1,distractorstim(x,1)-1,distractorstim(x,1),distractorstim(x,1)],handles.metricdata.horgnum - [distractorstim(x,2)-1 distractorstim(x,2) distractorstim(x,2) distractorstim(x,2)-1],'g')
                
                hold on
            end
            
            if handles.metricdata.selected_target_locations ~= 0
                intersect_term_index = 0;
                targetstim = handles.metricdata.selected_target_locations;
                for x = 1:size(targetstim,1)
                    for y = 1:size(distractorstim,1)
                        temp = sum(targetstim(x,:) == distractorstim(y,:));
                        if temp == 2
                            intersect_term_index(x) = temp;
                            continue
                        end
                    end
                    
                end
                if sum(intersect_term_index ~= 0)
                    for x = 1:length(intersect_term_index)
                        if intersect_term_index(x) == 2
                            fill([targetstim(x,1)-1,targetstim(x,1)-1,targetstim(x,1),targetstim(x,1)],handles.metricdata.horgnum - [targetstim(x,2)-1 targetstim(x,2) targetstim(x,2) targetstim(x,2)-1],'b')
                            hold on
                        end
                    end
                end
                
            end
        end
    end
end

hold off

function updatepopupmenu(handles)

if handles.metricdata.trainstep == 1
    set(handles.trainstep,'Value',2);
elseif handles.metricdata.trainstep == 2
    set(handles.trainstep,'Value',3);
elseif handles.metricdata.trainstep == 3
    set(handles.trainstep,'Value',4);
elseif handles.metricdata.trainstep == 4
    set(handles.trainstep,'Value',5);
elseif handles.metricdata.trainstep == 5
    set(handles.trainstep,'Value',6);
elseif handles.metricdata.trainstep == 6
    set(handles.trainstep,'Value',7);
elseif handles.metricdata.trainstep == 7
    set(handles.trainstep,'Value',8);
end

if handles.metricdata.monkeyname == 1
    set(handles.monkeyname,'Value',1);
elseif handles.metricdata.monkeyname == 2
    set(handles.monkeyname,'Value',2);
end
    
if handles.metricdata.fixcol == [255 255 255]
    set(handles.fixcol,'Value',1);
elseif handles.metricdata.fixcol == [255 255 0]
    set(handles.fixcol,'Value',2);
elseif handles.metricdata.fixcol == [255 0 0]
    set(handles.fixcol,'Value',3);
end

if handles.metricdata.targetcol == [255 0 0]
    set(handles.targetcol,'Value',1);
elseif handles.metricdata.targetcol == [0 255 0]
    set(handles.targetcol,'Value',2);
end

if handles.metricdata.distractorcol == [0 255 0]
    set(handles.distractorcol,'Value',1);
elseif handles.metricdata.distractorcol == [255 0 0]
    set(handles.distractorcol,'Value',2);
end

if handles.metricdata.mouse == 0
    set(handles.mouse,'Value',0);
elseif handles.metricdata.mouse == 1
    set(handles.mouse,'Value',1);
end

if handles.metricdata.fixtime == 0
    set(handles.fixtime,'Value',0);
elseif handles.metricdata.fixtime == 1
    set(handles.fixtime,'Value',1);
end


% set(handles.eyedatafile,  'String', handles.metricdata.eyedatafile);


