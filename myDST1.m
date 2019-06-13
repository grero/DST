function myDST1(homeDir,results)
global handle whichScreen
% Trigger
% (00000000) Start of Fixation period, note: trigger changed to (10000000)
% on 2017/07/11
% (00000110) Start of Reward Feedback
% (00000111) Start of Failure Feedback
% (00001000) Start of manual Reward Feedback
% (00001111) Start of StimulationF
% (00100000) End of Trial
warning('off','daq:digitialio:adaptorobsolete');
KbName('UnifyKeyNames');

%%% Save parameters in Results file

minITI = results.parameters.minITI;
maxITI = results.parameters.maxITI;
fixationOn = results.parameters.fixationOn;
feedbackTime = results.parameters.feedbackTime;
fixSize = results.parameters.fixSize;
fixArea = results.parameters.fixArea;
timeFixation = results.parameters.timeFixation;
rewardprob = results.parameters.rewardprob;
% numreward = results.parameters.numreward;
rewardduration = results.parameters.rewardduration;
backgroundColor = results.parameters.backgroundColor;
anode = results.parameters.anode;
numdatapoints = 3;
% eyefile = results.parameters.eyedatafile;
GridCols = 3;
GridRows = 3;
displayImage = 0; %should we display an image instead of the square?
fixcol = results.parameters.fixcol;
mouse = results.parameters.mouse;

channel = results.parameters.channel;
Stimulation_onset = results.parameters.stimonset;
first_pulseamp = results.parameters.first_pulseamp; %mV
first_pulseDur = results.parameters.first_pulsedur; %uSec
second_pulseamp = results.parameters.second_pulseamp; %mV
second_pulseDur = results.parameters.second_pulsedur; %uSec
numPulses = results.parameters.numpulses; % if set to zero, means continuous 
interDur = results.parameters.interdur; %uSec
stimprob = results.parameters.stimprob;
Rate = results.parameters.rate; %Hz
StimRef = results.parameters.stimref; % 1= pre-stim, 2= target 3= delay, 4= response

savefilename_ext = results.parameters.savefilename_ext;

eyesquareSize = 10;
eyeRectOriginal = [0 0 eyesquareSize eyesquareSize];

rewardbeep = MakeBeep(2000,0.2);
failurebeep = MakeBeep(100,0.2);
Snd('Open')

a = clock; a(1:3); % a = [year month day]
if ~exist([homeDir '/results_DST/'])
    mkdir([homeDir '/results_DST/']);
end

if isempty(savefilename_ext)
    filename = [homeDir '/results_DST/results_Set1_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '.mat'];
    trialcountfilename = [homeDir '/results_DST/trialcount_Set1_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '.mat'];
    
    k = 1;
    while exist(filename) %#ok<*EXIST>
        k = k + 1;
        filename = [homeDir '/results_DST/results_Set1_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '(' num2str(k) ').mat'];
    end
else
    filename = [homeDir '/results_DST/results_Set1_' savefilename_ext '_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '.mat'];
    trialcountfilename = [homeDir '/results_DST/trialcount_Set1_' savefilename_ext '_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '.mat'];
    
    k = 1;
    while exist(filename) %#ok<*EXIST>
        k = k + 1;
        filename = [homeDir '/results_DST/results_Set1_' savefilename_ext '_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '(' num2str(k) ').mat'];
    end
end

% get eye that's tracked
if mouse == 0
    eye_used = Eyelink('EyeAvailable');
else
    eye_used = 1;
end
% returns 0 (Left_Eye), 1 (Right_Eye) or 2(binocular) depending on what
% data is
if eye_used == 2
    eye_used = 1; % use the right_eye data
end

if exist(trialcountfilename) %#ok<*EXIST>
    load(trialcountfilename);
else
    totalcorrectTrial = 0;
    totalincorrectTrial = 0;
end

try
    
    % Removes the blue screen flash and minimize extraneous warnings.
    Screen('Preference', 'VisualDebugLevel', 3);
    Screen('Preference', 'SuppressAllWarnings', 1);
    
    % Find out how many screens and use largest screen number.
    % whichScreen = max(Screen('Screens'));
    whichScreen = 1; %1 is primary screen
    % Open a new window.
    [ window, windowRect ] = Screen('OpenWindow', whichScreen,backgroundColor);
    
    % window = 10;
    % windowRect = [0 0 1680 1050];
    
    % textureIndex=Screen('MakeTexture', window, imageMatrix);
    
    CenterX = windowRect(3)/2;
    CenterY = windowRect(4)/2;
    
    Xsize = windowRect(3) - 400;
    Ysize = windowRect(4) - 400;
    
    starty = CenterY(1) - Ysize(1)/2;
    startx = CenterX(1) - Xsize(1)/2;
    xincrement = Xsize(1)/(GridCols(1) - 1);
    yincrement = Ysize(1)/(GridRows(1) - 1);
    
    locations = [];
    for i = 1:GridCols
        for j = 1:GridRows
            locations = [locations; startx + xincrement*(i-1), starty + yincrement*(j-1)]; %#ok<*AGROW>
        end
    end
    
    posX1 = CenterX;
    posY1 = CenterY;
    
    fixRectOriginal = [0 0 fixSize fixSize]; % rect for fixation spot
    fixRect = CenterRect(fixRectOriginal, windowRect); % Center the spot
    fix_X = [fixRect(1) fixRect(1) fixRect(3) fixRect(3)];
    fix_Y = [fixRect(2) fixRect(4) fixRect(4) fixRect(2)];
    
    fixAreaRectOriginal = [0 0 fixArea fixArea]; % rect for fixation area
    fixAreaRect = CenterRect(fixAreaRectOriginal, windowRect); % Center the area
    fixArea_X = [fixAreaRect(1) fixAreaRect(1) fixAreaRect(3) fixAreaRect(3)];
    fixArea_Y = [fixAreaRect(2) fixAreaRect(4) fixAreaRect(4) fixAreaRect(2)];
    fixAreaColor = [0.5 0.5 0.5];
    
    imageRectOriginal = [0 0 fixArea fixArea]; % rect for fixation spot
    imageRect = CenterRect(imageRectOriginal, windowRect);
    % Set keys.
    escapeKey = KbName('ESCAPE');
    spaceKey = KbName('SPACE');
    bKey = KbName('B');
    rKey = KbName('R');
    sKey = KbName('S');
    leftKey = KbName('LeftArrow');
    rightKey = KbName('RightArrow');
    upKey = KbName('UpArrow');
    downKey = KbName('DownArrow');
    
    h = figure;
    set(gcf(),'outerposition',[0 430,560,470])
    
    continueTask = 1;
    timeSessionStarts = GetSecs;
    results.parameters.timeSessionStarts = timeSessionStarts;
    
    if displayImage == 1
        imageindex = ceil(rand(1)*8);
        imagename = [num2str(imageindex),'.jpg'];
        imageMatrix = imread(imagename);
        textureIndex=Screen('MakeTexture', window, imageMatrix);
    end
    
    Trial = 0;
    correctTrial = 0;
    incorrectTrial = 0;
    manualreward_count = 0;
    %before we enter loop, set up reward and trigger objects
	%trigger object
	% Create a Digital I/O Object with the digitalio function
    dio.io.ioObj = io64();
    dio.io.status = io64(dio.io.ioObj);
    %
    if dio.io.status == 0
        parallel_ok = 1;
    else 
        warning('No parallel port found. Events will only be sent to Eyelink');
        parallel_ok = 0;
    end
    %
% 	dio=digitalio('parallel','lpt1');
% 	Add lines to a Digital I/O Object
% 	addline(dio,0,2,'out');
% 	addline(dio,0:7,0,'out'); % add the hardware lines 0 until 7 from port 0 to the digital object dio
% 	clear the lines
% 	putvalue(dio,zeros(1,9)); 
% 	reward object	
% 	AO = analogoutput('nidaq','Dev2');
% 	Add channels  Add one channel to AO.
% 	addchannel(AO,0); 
% 	Set the SampleRate
% 	set(AO,'SampleRate',8000);

    % open stimulator object if stimprob ~= 0
    if stimprob ~= 0
        % initializing the stimulator object
        err = StimController(channel, Rate, first_pulseamp, second_pulseamp, first_pulseDur, second_pulseDur, interDur, numPulses);
    end
    
    while continueTask == 1
        
        %% WAIT FOR FIXATION
        inFixation = 0;
        startTask = 0;
        reward = 0;
        inTask = 1;
        spacecount = 0;
        manualreward = 0;
        stimulation = 0;
        update = 0;
        Trial = Trial + 1;
        
        vblstarttrial = 0;
        vblreward = 0;
        vblmanualreward = 0;
        vblfail = 0;
        
        iteration = 0;
        timeTrialStarts = GetSecs;
        
        while startTask == 0
            change_ind = 0;
            iteration = iteration + 1;
            
            if mouse == 0

                sample = Eyelink('NewestFloatSample');
                posX = round(sample.gx(eye_used+1));
                posY = round(sample.gy(eye_used+1));
                
            elseif mouse == 1
                [posX,posY,buttons] = GetMouse(window);
            end
            
            if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)
                if inFixation == 0
                    fixationIni = GetSecs;
                end
                inFixation = 1;
            else
                inFixation = 0;
                fixationIni = GetSecs;
                if GetSecs - timeTrialStarts > fixationOn
                    inTask = 0;
                    break;
                end
            end
            
            if stimprob ~= 0 && inFixation == 1
                if GetSecs > fixationIni + Stimulation_onset && stimulation == 0
                    if rand < stimprob
                        if mouse == 0
                            Eyelink('Message', num2str([0 0 0 0 1 1 1 1]));
                            Eyelink('Message', num2str([channel, Rate, first_pulseamp, second_pulseamp, first_pulseDur, second_pulseDur, interDur, numPulses]));
                        end
                        err = PS_StartStimAllChannels(1);
                    end
                    stimulation = 1;
                end
            end
            
            if GetSecs - fixationIni > timeFixation
                reward = 1;
                startTask = 1;
                break;
            end
            
            [ keyIsDown, seconds, keyCode ] = KbCheck; %#ok<*ASGLU>
            if keyIsDown
                if keyCode(escapeKey)
                    continueTask = 0;
                    startTask = 1;
                    break;
                elseif keyCode(spaceKey)
                    spacecount = spacecount + 1;
                elseif keyCode(bKey)
                    Screen('Flip', window);
                    WaitSecs(0.2)
                elseif keyCode(rKey)
                    manualreward = 1;
                    % update = 1;
                    break;
                elseif keyCode(sKey)
                    SendEvent2([0 0 0 0 1 1 1 1],dio);
                    if mouse == 0
                        Eyelink('Message', num2str([anode channel]));
                    end
                elseif keyCode(leftKey)
                    change_ind = 1;
                    leftmove = 1;
                    rightmove = 0;
                    upmove = 0;
                    downmove = 0;
                    WaitSecs(0.1)
                elseif keyCode(rightKey)
                    change_ind = 1;
                    leftmove = 0;
                    rightmove = 1;
                    upmove = 0;
                    downmove = 0;
                    WaitSecs(0.1)
                elseif keyCode(upKey)
                    change_ind = 1;
                    leftmove = 0;
                    rightmove = 0;
                    upmove = 1;
                    downmove = 0;
                    WaitSecs(0.1)
                elseif keyCode(downKey)
                    change_ind = 1;
                    leftmove = 0;
                    rightmove = 0;
                    upmove = 0;
                    downmove = 1;
                    WaitSecs(0.1)
                end
            end
            
            if change_ind
                posX1 = posX1 - leftmove*xincrement + rightmove*xincrement;
                posY1 = posY1 - upmove*yincrement + downmove*yincrement;
                fixRect = OffsetRect(fixRectOriginal, posX1-fixSize/2, posY1-fixSize/2);
                fix_X = [fixRect(1) fixRect(1) fixRect(3) fixRect(3)];
                fix_Y = windowRect(4) - [fixRect(2) fixRect(4) fixRect(4) fixRect(2)];
                
                fixAreaRect = OffsetRect(fixAreaRectOriginal, posX1-fixArea/2, posY1-fixArea/2); % Center the area
                fixArea_X = [fixAreaRect(1) fixAreaRect(1) fixAreaRect(3) fixAreaRect(3)];
                fixArea_Y = windowRect(4) - [fixAreaRect(2) fixAreaRect(4) fixAreaRect(4) fixAreaRect(2)];
                
                imageRect = OffsetRect(imageRectOriginal, posX1-fixArea/2, posY1-fixArea/2); % Center the area
                
            end
            
            if displayImage == 0
                Screen('FillOval', window, fixcol, fixRect);
            elseif displayImage == 1
                Screen('DrawTexture',window,textureIndex,[],imageRect);
            end
            
            [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
            if iteration == 1
                vblstarttrial = VBLTimestamp;
                SendEvent2([1 0 0 0 0 0 0 0],dio); %uncomment to send
                %events through parallel port
                if mouse == 0
                    Eyelink('Message', num2str([1 0 0 0 0 0 0 0]));
                end
            end
            
            eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
            eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
            eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
            fill(fixArea_X,fixArea_Y,fixAreaColor);
            hold on
            fill(fix_X,fix_Y,'k');
            hold on
            fill(eye_X,eye_Y,'r');
            hold off
            axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
            
            title(['Trial ', num2str(Trial),'    Correct ', num2str(correctTrial),'    Wrong ', num2str(incorrectTrial)]);
            
            drawnow
        end
        
        %% PRESENT FEEDBACK FOR REWARDS
        if manualreward == 0
            if reward == 1
                
                if displayImage == 1
                    imageindex = ceil(rand(1)*8);
                    imagename = [num2str(imageindex),'.jpg'];
                    imageMatrix = imread(imagename);
                    textureIndex=Screen('MakeTexture', window, imageMatrix);
                end
                
                correctTrial = correctTrial + 1;
                
                if update == 1
                    
                    setX = find(locations(:,1) == posX1);
                    setY = find(locations(:,2) == posY1);
                    locationindex = intersect(setX,setY);
                    ec.eyevol(locationindex,:) = eyefilt;
                    update = 0;
                    
                end
                % make a beep sound
                timeIniFeedback = GetSecs;
                
%                 Snd('Play',rewardbeep);
%                  SendEvent2([0 0 0 0 0 1 1 0], dio);
%                 Eyelink('Message', num2str([0 0 0 0 0 1 1 0]));
%                 
%                 if rand<=rewardprob
%                     usb_pulse(numreward,rewardduration)
%                 end
                
                iteration = 0;
                
                while GetSecs - timeIniFeedback < feedbackTime
                    iteration = iteration + 1;
                    
                    Screen('FillOval', window, [0 0 255], fixRect);
                    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                    
                    if iteration == 1
                        
                        vblreward = VBLTimestamp;
                        SendEvent2([0 0 0 0 0 1 1 0],dio);
                        if mouse == 0
                            Eyelink('Message', num2str([0 0 0 0 0 1 1 0]));
                        end
                        if rand<=rewardprob
                            usb_pulse(handle,rewardduration)
                        end
                        Snd('Play',rewardbeep);
                    end
                    
                    if mouse == 0
                        
                        sample = Eyelink('NewestFloatSample');
                        posX = round(sample.gx(eye_used+1));
                        posY = round(sample.gy(eye_used+1));
                        
                    elseif mouse == 1
                        [posX,posY,buttons] = GetMouse(window);
                    end
                    
                    eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                    eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                    eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
                    
                    fill(fix_X,fix_Y,[0 0 1]);
                    hold on
                    fill(eye_X,eye_Y,'r');
                    hold off
                    axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                    
                    title(['Trial ', num2str(Trial),'    Correct ', num2str(correctTrial),'    Wrong ', num2str(incorrectTrial)]);
                    drawnow
                    [ keyIsDown, seconds, keyCode ] = KbCheck;
                    if keyIsDown
                        if keyCode(spaceKey)
                            spacecount = spacecount + 1;
                        end
                    end
                    
                end
            elseif reward == 0 && continueTask == 1
                timeIniFeedback = GetSecs;
                iteration = 0;
                
                incorrectTrial = incorrectTrial + 1;
                
                Snd('Play',failurebeep);
                SendEvent2([0 0 0 0 0 1 1 1], dio);
                Eyelink('Message', num2str([0 0 0 0 0 1 1 1]));
                
                while GetSecs - timeIniFeedback < feedbackTime
                    iteration = iteration + 1;
                    
                    if mouse == 0
                        
                        sample = Eyelink('NewestFloatSample');
                        posX = round(sample.gx(eye_used+1));
                        posY = round(sample.gy(eye_used+1));
                        
                    elseif mouse == 1
                        [posX,posY,buttons] = GetMouse(window);
                    end
                    
                    [X,Y] = RectCenter(windowRect);
                    oldFontSize = Screen(window,'TextSize',800);
                    Screen('DrawText', window, 'x', X-320, Y-650, [255 0 0]);
                    % Screen('FillOval', window, [255 0 0], fixRect);
                    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                    
                    if iteration == 1
                        vblfail = VBLTimestamp;
                        SendEvent2([0 0 0 0 0 1 1 1],dio);
                        if mouse == 0
                            Eyelink('Message', num2str([0 0 0 0 0 1 1 1]));
                        end
                        Snd('Play',failurebeep);
                    end
                    
                    eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                    eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                    eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
                    
                    fill(fix_X,fix_Y,[1 0 0]);
                    %                 uicontrol('Style', 'text',...
                    %                     'String', 'X',...
                    %                     'Units','normalized',...
                    %                     'Position', [0.9 0.2 0.1 0.1]);
                    
                    hold on
                    fill(eye_X,eye_Y,'r');
                    hold off
                    axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                    
                    title(['Trial ', num2str(Trial),'    Correct ', num2str(correctTrial),'    Wrong ', num2str(incorrectTrial)]);
                    
                    drawnow
                    [ keyIsDown, seconds, keyCode ] = KbCheck; %#ok<*ASGLU>
                    if keyIsDown
                        if keyCode(spaceKey)
                            spacecount = spacecount + 1;
                        end
                    end
                end
            end
        else
            
            if displayImage == 1
                imageindex = ceil(rand(1)*8);
                imagename = [num2str(imageindex),'.jpg'];
                imageMatrix = imread(imagename);
                textureIndex=Screen('MakeTexture', window, imageMatrix);
            end
            
            manualreward_count = manualreward_count + 1;

            % make a beep sound
            timeIniFeedback = GetSecs;
            
%             Snd('Play',rewardbeep);
%             SendEvent2([0 0 0 0 1 0 0 0], dio);
%             Eyelink('Message', num2str([0 0 0 0 1 0 0 0]));

            %usb_pulse(numreward,rewardduration)
            
            iteration = 0;
            
            while GetSecs - timeIniFeedback < feedbackTime
                iteration = iteration + 1;
                
                Screen('FillOval', window, [0 0 255], fixRect);
                [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                
                if iteration == 1
                    vblmanualreward = VBLTimestamp;
                    SendEvent2([0 0 0 0 1 0 0 0],dio);
                    if mouse == 0
                        Eyelink('Message', num2str([0 0 0 0 1 0 0 0]));
                    end
                    Snd('Play',rewardbeep);
                    usb_pulse(handle,rewardduration)
                end
                
                if mouse == 0
                    
                    sample = Eyelink('NewestFloatSample');
                    posX = round(sample.gx(eye_used+1));
                    posY = round(sample.gy(eye_used+1));
                    
                elseif mouse == 1
                    [posX,posY,buttons] = GetMouse(window);
                end
                
                eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
                
                fill(fix_X,fix_Y,[0 0 1]);
                hold on
                fill(eye_X,eye_Y,'r');
                hold off
                axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                
                title(['Trial ', num2str(Trial),'    Correct ', num2str(correctTrial),'    Wrong ', num2str(incorrectTrial)]);
                drawnow
                [ keyIsDown, seconds, keyCode ] = KbCheck; 
                if keyIsDown
                    if keyCode(spaceKey)
                        spacecount = spacecount + 1;
                    end
                end
            end
        end
        
        %% POST TRIAL INTERVAL
        ITI = rand*(maxITI-minITI) + minITI;
        timeIniPTI = GetSecs;
        while GetSecs - timeIniPTI < ITI
            if mouse == 0
                
                sample = Eyelink('NewestFloatSample');
                posX = round(sample.gx(eye_used+1));
                posY = round(sample.gy(eye_used+1));
                
            elseif mouse == 1
                [posX,posY,buttons] = GetMouse(window);
            end
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(escapeKey)
                    continueTask = 0;
                    startTask = 1;
                    break;
                elseif keyCode(spaceKey)
                    spacecount = spacecount + 1;
                end
            end
            
            Screen('Flip', window);
            eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
            eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
            eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
            
            fill(eye_X,eye_Y,'r');
            axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
            drawnow
        end
        
        if spacecount
            KbWait;
        end
        SendEvent2([0 0 1 0 0 0 0 0],dio);
        if mouse == 0
            Eyelink('Message', num2str([0 0 1 0 0 0 0 0]));
        end
        
        results.vblstarttrial(Trial) = vblstarttrial;
        results.vblreward(Trial) = vblreward;
        results.vblmanualreward(Trial) = vblmanualreward;
        results.vblfail(Trial) = vblfail;

        
        save(filename,'results')
    end
    
    Screen('CloseAll');
    %delete(dio)
    clear dio
    %delete(AO)
    %clear AO
    if stimprob ~= 0
        err = PS_StopStimAllChannels(1);
        err = PS_CloseStim(1);
    end
catch
    Screen('CloseAll');
    if stimprob ~= 0
        err = PS_StopStimAllChannels(1);
        err = PS_CloseStim(1);
    end
    psychrethrow(psychlasterror);
end

close(h)
return
