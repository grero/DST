function initAndCal_DST(monkeyname,rewardduration,fixcol)
global whichScreen

%% Initialize connection with EyeLink
initializedummy=0;
if initializedummy~=1
    if Eyelink('initialize') ~= 0
        fprintf('error in connecting to the eye tracker');
        return;
    end
else
    Eyelink('initializedummy');
end

%% setup PTB
%screenNumber=max(Screen('Screens')); % secondary monitor
screenNumber=whichScreen;
[window, wRect]=Screen('OpenWindow', screenNumber, 0,[],32,2);
Screen(window,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%% Eyelink dependencies on PTB
el=EyelinkInitDefaults(window);
[v vs]=Eyelink('GetTrackerVersion');
fprintf('Running experiment on a ''%s'' tracker.\n', vs );

el.callback =[]; %EW: disable callback
%% Results file open
a = clock; a(1:3);
% edfFile = ['eyedata_',num2str(a(1)),'_',num2str(a(2)),'_',num2str(a(3)),'.edf'];
edfFile = [monkeyname,num2str(a(2)),'_',num2str(a(3)),'.edf'];

if (Eyelink('Openfile', edfFile))~=0
    printf('Cannot create EDF file ''%s'' ', edffilename);
    Eyelink( 'Shutdown');
    return;
end

%% writing preamble message
Eyelink('command', 'add_file_preamble_text ''Recorded by EyelinkToolbox Group ''');


%% Eyelink Configration
[width, height]=Screen('WindowSize', screenNumber);
Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, width-1, height-1);
Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, width-1, height-1);                
% set calibration type.
Eyelink('command', 'calibration_type = HV9');
% set parser (conservative saccade thresholds)
Eyelink('command', 'saccade_velocity_threshold = 35');
Eyelink('command', 'saccade_acceleration_threshold = 9500');
% set EDF file and link contents
Eyelink('command', 'file_event_filter = LEFT,RIGHT,GAZE,AREA,GAZERES,HREF,PUPIL,STATUS,INPUT,HMARKER');
Eyelink('command', 'file_sample_data = LEFT,RIGHT,GAZE,AREA,GAZERES,HREF,PUPIL,STATUS,INPUT,HMARKER');
Eyelink('command','link_sample_data = LEFT,RIGHT,GAZE,AREA,GAZERES,HREF,PUPIL,STATUS,INPUT,HMARKER');
Eyelink('command','inputword_is_window = ON');


%% Callibration
 if Eyelink('IsConnected')~=1 return; end; % check if the link is still open
% setup the proper calibration foreground and background colors
el.backgroundcolour = 127;
%el.foregroundcolour = 255;
% el.calibrationtargetcolour = [1,0,0];
% Hide the mouse cursor;
% Screen('HideCursorHelper', window);
EyelinkDoTrackerSetup_DST(el,rewardduration,fixcol);


