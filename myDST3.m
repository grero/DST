function myDST3(homeDir,results)
global handle whichScreen
%turn off all warnings
warning('off','daq:digitialio:adaptorobsolete');
KbName('UnifyKeyNames');

% Trigger
% (00000000) Start of Fixation period 
% (00000001) Start of Pre-Stimulus Period              
% (10000000) Start of Green Stimulus (34 locations)    
% the first 6 bins encode the information the 34 locations 
% 00 (000,000) (x,y)
% eg. (4,5) square is represented by (100,101), 
% so Red stimulus at (4,5) will be represented by (01100101)

% (00000011) Start of Stimulus Blank period 
% (00000100) Start of Delay Period                                   
% (00000110) Start of Reward Feedback
% (00001000) Start of manual Reward Feedback
% (00000111) Start of Failure Feedback
% (00100000) End of Trial

%%% Save parameters in Results file

% squareSize = results.parameters.squareSize;

minITI = results.parameters.minITI;
maxITI = results.parameters.maxITI;
penalty = results.parameters.penalty;
fixationOn = results.parameters.fixationOn;
minprestim = results.parameters.minprestim;
maxprestim = results.parameters.maxprestim;
mindelay = results.parameters.mindelay;
maxdelay = results.parameters.maxdelay;
minsquareTimeON = results.parameters.minsquareTimeON;
maxsquareTimeON = results.parameters.maxsquareTimeON;
mininterSquareTime = results.parameters.mininterSquareTime;
maxinterSquareTime = results.parameters.maxinterSquareTime;
% rangeRT = results.parameters.rangeRT;
% timeOnTarget = results.parameters.timeOnTarget;
rangeDistractors = results.parameters.rangeDistractors;
feedbackTime = results.parameters.feedbackTime;
fixSize = results.parameters.fixSize;
fixArea = results.parameters.fixArea;
timeFixation = results.parameters.timeFixation;
targetColor = results.parameters.targetcol;
rewardprob = results.parameters.rewardprob;
distractorColor = results.parameters.distractorcol;
%numreward = results.parameters.numreward;
rewardduration = results.parameters.rewardduration;
backgroundColor = results.parameters.backgroundColor;
blocknum = results.parameters.blocknum;
selected_locations = results.parameters.selected_locations;
% eyemvt = results.parameters.eyemvt;
% date = results.parameters.date;
% time = results.parameters.time;
numDivisionsGrid = [results.parameters.horgnum results.parameters.vergnum]; % number of division of grid in [x,y] axis
numdatapoints = 3; 
mouse = results.parameters.mouse;
fixcol = results.parameters.fixcol;
timeBuffer = results.parameters.buffertime;

eyesquareSize = 10;
eyeRectOriginal = [0 0 eyesquareSize eyesquareSize];
targetColor_mod = targetColor/255;
distractorColor_mod = distractorColor/255;

rewardbeep = MakeBeep(2000,0.2);
failurebeep = MakeBeep(100,0.2);
Snd('Open')

if blocknum == 0
    blocknum = 1000;
end

% if mouse == 0
%                 
%     % Get eye that's tracked. Only available when samples/events are read
%     eye_used = -1; %init
%     while eye_used==-1
%         eye_used = Eyelink('eyeavailable');
%     end
% end

%%% Define filename
a = clock; a(1:3); % a = [year month day]
if ~exist([homeDir '/results_DST/'])
    mkdir([homeDir '/results_DST/']);
end
filename = [homeDir '/results_DST/results_Set2_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '.mat'];
trialcountfilename = [homeDir '/results_DST/trialcount_Set2' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '.mat'];

k = 1;
while exist(filename) %#ok<*EXIST>
    k = k + 1;
    filename = [homeDir '/results_DST/results_Set2_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '(' num2str(k) ').mat'];
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
    %whichScreen = 1;
    
    % Open a new window.
    [ window, windowRect ] = Screen('OpenWindow', whichScreen,backgroundColor);
    
    % window = 10;
    % windowRect = [0 0 1680 1050];
    
    squareSize = floor((windowRect(4)-windowRect(4)/10)/numDivisionsGrid(2));
    
    while squareSize*numDivisionsGrid(1) > windowRect(3)
        numDivisionsGrid(1) = numDivisionsGrid(1) - 2;
    end
    results.parameters.numDivisionsGrid = numDivisionsGrid;
    
    % Calculate grid size
    fromX = (windowRect(3) - numDivisionsGrid(1) * squareSize) / 2;
    toX   = windowRect(3) - fromX;
    
    fromY = (windowRect(4) - floor(windowRect(4)/squareSize) * squareSize) / 2;
    toY   = windowRect(4) - fromY;
    
    if selected_locations == 0
        locations = [];
        for i = 1:numDivisionsGrid(1)
            for j = 1:numDivisionsGrid(2)
                if i ~= ceil(numDivisionsGrid(1)/2) || j ~= ceil(numDivisionsGrid(2)/2)
                    locations = [locations; i,j]; %#ok<*AGROW>
                end
            end
        end
    else
        locations = selected_locations;
    end
    
    numLocations = size(locations,1);
    locationsIndex = 1:numLocations;
    % locationsIndex = 1:((numDivisionsGrid(1) * numDivisionsGrid(2)) - 1);
    
    % Calculate locations
    % HideCursor(0);
    cueRectOriginal = [0 0 squareSize squareSize]; % rect for cue/target/distractors
    
    fixRect = [0 0 fixSize fixSize]; % rect for fixation spot
    fixRect = CenterRect(fixRect, windowRect); % Center the spot
    fix_X = [fixRect(1) fixRect(1) fixRect(3) fixRect(3)];
    fix_Y = [fixRect(2) fixRect(4) fixRect(4) fixRect(2)];
    
    fixAreaRect = [0 0 fixArea fixArea]; % rect for fixation area
    fixAreaRect = CenterRect(fixAreaRect, windowRect); % Center the area
    fixArea_X = [fixAreaRect(1) fixAreaRect(1) fixAreaRect(3) fixAreaRect(3)];
    fixArea_Y = [fixAreaRect(2) fixAreaRect(4) fixAreaRect(4) fixAreaRect(2)];
    fixAreaColor = [0.5 0.5 0.5];
    
    % Set keys.
    escapeKey = KbName('ESCAPE');
    spaceKey = KbName('SPACE');
    rKey = KbName('R');
    
    h = figure;
    set(gcf(),'outerposition',[0 430,560,470])
    
    continueTask = 1;
    trialsStarted = 0;
    whichTrial = 0;
    timeSessionStarts = GetSecs;
    results.parameters.timeSessionStarts = timeSessionStarts;
    blkcorrectTrial = 0;
    blkincorrectTrial = 0;
    manualreward_count = 0;

	%before we enter loop, set up reward and trigger objects
	%trigger object
	% Create a Digital I/O Object with the digitalio function
% 	dio=digitalio('parallel','lpt1');
% 	% Add lines to a Digital I/O Object
% 	addline(dio,0,2,'out');
% 	addline(dio,0:7,0,'out'); % add the hardware lines 0 until 7 from port 0 to the digital object dio
% 	%clear the lines
% 	% putvalue(dio,zeros(1,9)); 
% 	%reward object	
% 	AO = analogoutput('nidaq','Dev2');
% 	% Add channels  Add one channel to AO.
% 	addchannel(AO,0); 
% 	% Set the SampleRate
% 	set(AO,'SampleRate',8000);
    %create dio object to communicate with the parallel port
    dio.io.ioObj = io32();
    dio.io.status = io32(dio.io.ioObj);
    
    while continueTask == 1 && floor(whichTrial/numLocations) ~= blocknum
        
        %% WAIT FOR FIXATION
        inFixation = 0;
        startTask = 0;
        inTask = 1;
        whichTrial = whichTrial + 1;
        results.totalNumberOfTrials = whichTrial;
        trialHasStarted = 0;
        breakFixation = 0;
        wrongTarget = 0;
        reward = 0;
        manualreward = 0;
        spacecount = 0;
        
        sstarttrial = 0;
        estarttrial = 0;
        sprestim = 0;
        eprestim = 0;
        starget = 0;
        etarget = 0;
        sblank = zeros(1,max(1,rangeDistractors(2)));
        eblank = zeros(1,max(1,rangeDistractors(2)));
        sdistractor = zeros(1,max(1,rangeDistractors(2)));
        edistractor = zeros(1,max(1,rangeDistractors(2)));
        sdelay = 0;
        edelay = 0;
        sreward = 0;
        ereward = 0;
        sfail = 0;
        efail = 0;
        sendtrial = 0;
        eendtrial = 0;
        
        vblstarttrial = 0;
        vblprestim = 0;
        vbltarget = 0;
        vblblank = zeros(1,max(1,rangeDistractors(2)));
        vbldistractor = zeros(1,max(1,rangeDistractors(2)));
        vbldelay = 0;
        vblreward = 0;
        vblmanualreward = 0;
        vblfail = 0;
        
        iteration = 0;
        timeTrialStarts = GetSecs;

        if mod(whichTrial,numLocations) == 1 || numLocations == 1
            blkcorrectTrial = 0;
            blkincorrectTrial = 0;

            cuelocationsIndexShuffled = randperm(numLocations);
        end
        
        if mod(whichTrial,numLocations) ~= 0
            blTrial = mod(whichTrial,numLocations);
        else
            blTrial = numLocations;
        end
        
        bufferstart = -timeBuffer;
        while startTask == 0
            
            iteration = iteration + 1;
            
            if mouse == 0

                sample = Eyelink('NewestFloatSample');
                posX = round(sample.gx(1));
                posY = round(sample.gy(1));
            
            elseif mouse == 1
                [posX,posY,buttons] = GetMouse(window);
            end
            
            if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)
                if inFixation == 0
                    fixationIni = GetSecs;
                end
                inFixation = 1;
                bufferstart = GetSecs;
                usb_pulse(handle,rewardduration)
            else
                if GetSecs - bufferstart > timeBuffer
                    inFixation = 0;
                    fixationIni = GetSecs;
                    if GetSecs - timeTrialStarts > fixationOn
                        inTask = 0;
                        break;
                    end
                end
            end

            if GetSecs - fixationIni > timeFixation
                startTask = 1;
                break;
            end
            
            [ keyIsDown, seconds, keyCode ] = KbCheck; %#ok<*ASGLU>
            if keyIsDown
                if keyCode(escapeKey)
                    save(filename,'results');
                    continueTask = 0;
                    startTask = 1;
                    break;
                elseif keyCode(spaceKey)
                    spacecount = spacecount + 1;
                elseif keyCode(rKey)
                    manualreward = 1;
                    break;
                end
            end
            
            Screen('FillOval', window, fixcol, fixRect);
            for linesX = 1:numDivisionsGrid(2)+1
                Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
            end
            for linesY = 1:numDivisionsGrid(1)+1
                Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
            end
            [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
            if iteration == 1
                vblstarttrial = VBLTimestamp;
                sstarttrial = GetSecs;
                SendEvent2([0 0 0 0 0 0 0 0],dio);
                estarttrial = GetSecs;
                if mouse == 0
                    Eyelink('Message', num2str([0 0 0 0 0 0 0 0]));
                end
            end
            
            eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
            eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
            eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
            fill(fixArea_X,fixArea_Y,fixAreaColor);
            hold on
            fill(fix_X,fix_Y,'k');
            hold on
            fill(eye_X,eye_Y,'b');
            hold off
            axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
            for linesX = 1:numDivisionsGrid(2)+1
                line([fromX,toX],fromY+squareSize*(linesX-1)*[1,1],'Color','k')
            end
            for linesY = 1:numDivisionsGrid(1)+1
                line(fromX+squareSize*(linesY-1)*[1,1],[fromY,toY],'Color','k')
            end
            title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',num2str(blkincorrectTrial),'  Total: ',num2str(totalcorrectTrial),'/',num2str(totalincorrectTrial),'    Manual Reward = ',num2str(manualreward_count)])
            drawnow

        end

        %% PRE-STIMULUS PERIOD

        iteration = 0;

        prestim = rand*(maxprestim-minprestim) + minprestim;
        timefixationend = GetSecs;

        while GetSecs < timefixationend + prestim && inTask == 1
            
            iteration = iteration +1;
            trialHasStarted = 1;
            
            % Check for escape command
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(escapeKey)
                    save(filename,'results');
                    continueTask = 0;
                    inTask = 0;
                    break;
                elseif keyCode(spaceKey)
                    spacecount = spacecount + 1;
                elseif keyCode(rKey)
                    manualreward = 1;
                    break;
                end
            end

            % Check for fixation. If not, abort trial            
            if mouse == 0

                sample = Eyelink('NewestFloatSample');
                posX = round(sample.gx(1));
                posY = round(sample.gy(1));

            elseif mouse == 1
                [posX,posY,buttons] = GetMouse(window);
            end
            
            if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)

                Screen('FillOval', window, fixcol, fixRect);
                for linesX = 1:numDivisionsGrid(2)+1
                    Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                end
                [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                if iteration == 1
                    vblprestim = VBLTimestamp;
                    sprestim = GetSecs;
                    SendEvent2([0 0 0 0 0 0 0 1],dio);
                    eprestim = GetSecs;
                    if mouse == 0
                        Eyelink('Message', num2str([0 0 0 0 0 0 0 1]));
                    end
                end
                
                eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
                fill(fixArea_X,fixArea_Y,fixAreaColor);
                hold on
                fill(fix_X,fix_Y,'k');
                hold on
                fill(eye_X,eye_Y,'b');
                hold off
                axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                for linesX = 1:numDivisionsGrid(2)+1
                    line([fromX,toX],fromY+squareSize*(linesX-1)*[1,1],'Color','k')
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    line(fromX+squareSize*(linesY-1)*[1,1],[fromY,toY],'Color','k')
                end
                title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',num2str(blkincorrectTrial),'  Total: ',num2str(totalcorrectTrial),'/',num2str(totalincorrectTrial),'    Manual Reward = ',num2str(manualreward_count)])
                drawnow
                bufferstart = GetSecs;
            else
                
                if GetSecs - bufferstart > timeBuffer
                    if breakFixation == 0
                        breakFixation = GetSecs - timeSessionStarts;
                    end
                    inTask = 0;
                    break;
                end
            end

        end
        
        %% PRESENT CUE
        
        numDistractors = rangeDistractors(1):rangeDistractors(2);
        numDistractors = numDistractors(ceil(rand*length(numDistractors)));
        
        if numLocations ~= 1
            locationIndexShuffled = Shuffle(setdiff(locationsIndex,cuelocationsIndexShuffled(blTrial)));
            locationsTrial = [cuelocationsIndexShuffled(blTrial),locationIndexShuffled(1:numDistractors)];
        elseif numLocations == 1
            locationsTrial = [cuelocationsIndexShuffled(blTrial),cuelocationsIndexShuffled(blTrial)*ones(size(1:numDistractors))];
        end
        
        % FIRST PRESENT CUE
        timeStartCue = GetSecs;
        
        xOffset = squareSize*(locations(locationsTrial(1),1)-1)+fromX;
        yOffset = squareSize*(locations(locationsTrial(1),2)-1)+fromY;
        cueRect = OffsetRect(cueRectOriginal, xOffset, yOffset);
        
        cue_X = [cueRect(1) cueRect(1) cueRect(3) cueRect(3)];
        cue_Y = windowRect(4) - [cueRect(2) cueRect(4) cueRect(4) cueRect(2)];

        if startTask == 1
            trialsStarted = trialsStarted + 1;
        end
        
        xbin = str2num(dec2bin(locations(locationsTrial(1),1),3));
        ybin = str2num(dec2bin(locations(locationsTrial(1),2),3));

        for x = 1:3
            xbinmod(1,x) = bitget(xbin,x);
            ybinmod(1,x) = bitget(ybin,x);
        end

        iteration = 0;
        squareTimeON = rand*(maxsquareTimeON-minsquareTimeON) + minsquareTimeON;
        
        while GetSecs < timeStartCue + squareTimeON && inTask == 1

            iteration = iteration + 1;
            % trialHasStarted = 1;

            % Check for escape command
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(escapeKey)
                    save(filename,'results');
                    continueTask = 0;
                    inTask = 0;
                    break;
                elseif keyCode(spaceKey)
                    spacecount = spacecount + 1;
                elseif keyCode(rKey)
                    manualreward = 1;
                    break;
                end
            end

            % Check for fixation. If not, abort trial
            if mouse == 0

                sample = Eyelink('NewestFloatSample');
                posX = round(sample.gx(1));
                posY = round(sample.gy(1));
                
            elseif mouse == 1
                [posX,posY,buttons] = GetMouse(window);
            end
            
            if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)

                % Present cue
                Screen('FillRect', window, targetColor, cueRect);
                % Screen('FillRect', window, [255 255 255], [0 0 100 100]);
                Screen('FillOval', window, fixcol, fixRect);
                for linesX = 1:numDivisionsGrid(2)+1
                    Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                end
                [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                %debug
                %flipTime = FlipTimestamp-VBLTimestamp
                %
                if iteration == 1
                    vbltarget = VBLTimestamp;
                    if targetColor == [0 255 0]
                        starget = GetSecs;
                        SendEvent2([1 0 xbinmod ybinmod],dio);
                        etarget = GetSecs;
                        %debug
                        %pulseTime = etarget - VBLTimestamp
                        %
                        if mouse == 0
                            Eyelink('Message', num2str([1 0 xbinmod ybinmod]));
                        end
                    elseif targetColor == [255 0 0]
                        starget = GetSecs;
                        SendEvent2([0 1 xbinmod ybinmod],dio);
                        etarget = GetSecs;
                        if mouse == 0
                            Eyelink('Message', num2str([0 1 xbinmod ybinmod]));
                        end
                    end
                end
                eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];

                fill(fixArea_X,fixArea_Y,fixAreaColor);
                hold on
                fill(fix_X,fix_Y,'k');
                hold on
                fill(cue_X,cue_Y,targetColor_mod);
                hold on
                fill(eye_X,eye_Y,'b');
                hold off
                axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                for linesX = 1:numDivisionsGrid(2)+1
                    line([fromX,toX],fromY+squareSize*(linesX-1)*[1,1],'Color','k')
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    line(fromX+squareSize*(linesY-1)*[1,1],[fromY,toY],'Color','k')
                end
                title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',num2str(blkincorrectTrial),'  Total: ',num2str(totalcorrectTrial),'/',num2str(totalincorrectTrial),'    Manual Reward = ',num2str(manualreward_count)])
                drawnow
                bufferstart = GetSecs;
            else
                if GetSecs - bufferstart > timeBuffer
                    if breakFixation == 0
                        breakFixation = GetSecs - timeSessionStarts;
                    end
                    inTask = 0;
                    break;
                end
            end
        end

        % NOW PRESENT DISTRACTORS
        if numDistractors > 0
            for d = 1:numDistractors
                
                if d == 1 &&  locationsTrial(1) == 0
                else
                    xOffset = squareSize*(locations(locationsTrial(d+1),1)-1)+fromX;
                    yOffset = squareSize*(locations(locationsTrial(d+1),2)-1)+fromY;
                    distRect = OffsetRect(cueRectOriginal, xOffset, yOffset);

                    % INTER SQUARE INTERVAL
                    iteration = 0;
                    interSquareTime = rand*(maxinterSquareTime-mininterSquareTime) + mininterSquareTime;
                    
                    timeIniDistractor = GetSecs;
                    
                    while GetSecs < timeIniDistractor + interSquareTime && inTask == 1

                        iteration = iteration + 1;

                        % Check for escape command
                        [ keyIsDown, seconds, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(escapeKey)
                                save(filename,'results');
                                continueTask = 0;
                                inTask = 0;
                                break;
                            elseif keyCode(spaceKey)
                                spacecount = spacecount + 1;
                            elseif keyCode(rKey)
                                manualreward = 1;
                                break;
                            end
                        end
                        
                        % Check for fixation. If not, abort trial
                        if mouse == 0
                            
                            sample = Eyelink('NewestFloatSample');
                            posX = round(sample.gx(1));
                            posY = round(sample.gy(1));
                            
                        elseif mouse == 1
                            [posX,posY,buttons] = GetMouse(window);
                        end
                        
                        if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)
                            % Wait period
                            Screen('FillOval', window, [255 255 255], fixRect);
                            for linesX = 1:numDivisionsGrid(2)+1
                                Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                            end
                            for linesY = 1:numDivisionsGrid(1)+1
                                Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                            end
                            [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                            
                            if iteration == 1;
                                vblblank(d) = VBLTimestamp;
                                sblank(d) = GetSecs;
                                SendEvent2([0 0 0 0 0 0 1 1],dio);
                                eblank(d) = GetSecs;
                                if mouse == 0
                                    Eyelink('Message', num2str([0 0 0 0 0 0 1 1]));
                                end
                            end
                            eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                            eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                            eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];

                            fill(fixArea_X,fixArea_Y,fixAreaColor);
                            hold on
                            fill(fix_X,fix_Y,'k');
                            hold on
                            fill(eye_X,eye_Y,'b');
                            hold off
                            axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                            for linesX = 1:numDivisionsGrid(2)+1
                                line([fromX,toX],fromY+squareSize*(linesX-1)*[1,1],'Color','k')
                            end
                            for linesY = 1:numDivisionsGrid(1)+1
                                line(fromX+squareSize*(linesY-1)*[1,1],[fromY,toY],'Color','k')
                            end
                            title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',num2str(blkincorrectTrial),'  Total: ',num2str(totalcorrectTrial),'/',num2str(totalincorrectTrial),'    Manual Reward = ',num2str(manualreward_count)])
                            drawnow
                            bufferstart = GetSecs;
                        else
                            if GetSecs - bufferstart > timeBuffer
                                if breakFixation == 0
                                    breakFixation = GetSecs - timeSessionStarts;
                                end
                                inTask = 0;
                                break;
                            end
                        end
                    end
                end
                
                % PRESENT NEXT DISTRACTOR
                
                xbin = str2num(dec2bin(locations(locationsTrial(d+1),1),3));
                ybin = str2num(dec2bin(locations(locationsTrial(d+1),2),3));
                
                for x = 1:3
                    xbinmod(1,x) = bitget(xbin,x);
                    ybinmod(1,x) = bitget(ybin,x);
                end

                iteration = 0;
                
                timeIniDistractor = GetSecs;
                
                while GetSecs < timeIniDistractor + squareTimeON && inTask == 1
                    
                    iteration = iteration + 1;
                    
                    % Check for escape command
                    [ keyIsDown, seconds, keyCode ] = KbCheck;
                    if keyIsDown
                        if keyCode(escapeKey)
                            save(filename,'results');
                            continueTask = 0;
                            break;
                        elseif keyCode(spaceKey)
                            spacecount = spacecount + 1;
                        elseif keyCode(rKey)
                            manualreward = 1;
                            break;
                        end
                    end

                    % Check for fixation. If not, abort trial
                    if mouse == 0
                        
                        sample = Eyelink('NewestFloatSample');
                        posX = round(sample.gx(1));
                        posY = round(sample.gy(1));
                        
                    elseif mouse == 1
                        [posX,posY,buttons] = GetMouse(window);
                    end
                    
                    if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)
                        % Present Distractor
                        Screen('FillRect', window, distractorColor, distRect);
                        Screen('FillOval', window, [255 255 255], fixRect);
                        for linesX = 1:numDivisionsGrid(2)+1
                            Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                        end
                        for linesY = 1:numDivisionsGrid(1)+1
                            Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                        end
                        [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                        
                        if iteration == 1
                            vbldistractor(d) = VBLTimestamp;
                            if distractorColor == [0 255 0]
                                sdistractor(d) = GetSecs;
                                SendEvent2([1 0 xbinmod ybinmod],dio);
                                edistractor(d) = GetSecs;
                                if mouse == 0
                                    Eyelink('Message', num2str([1 0 xbinmod ybinmod]));
                                end
                            elseif distractorColor == [255 0 0]
                                sdistractor(d) = GetSecs;
                                SendEvent2([0 1 xbinmod ybinmod],dio);
                                edistractor(d) = GetSecs;
                                if mouse == 0
                                    Eyelink('Message', num2str([0 1 xbinmod ybinmod]));
                                end
                            end
                        end
                        eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                        eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                        eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];

                        dist_X = [distRect(1) distRect(1) distRect(3) distRect(3)];
                        dist_Y = windowRect(4) - [distRect(2) distRect(4) distRect(4) distRect(2)];

                        fill(fixArea_X,fixArea_Y,fixAreaColor);
                        hold on
                        fill(fix_X,fix_Y,'k');
                        hold on
                        fill(dist_X,dist_Y,distractorColor_mod);
                        hold on
                        fill(eye_X,eye_Y,'b');
                        hold off
                        axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                        for linesX = 1:numDivisionsGrid(2)+1
                            line([fromX,toX],fromY+squareSize*(linesX-1)*[1,1],'Color','k')
                        end
                        for linesY = 1:numDivisionsGrid(1)+1
                            line(fromX+squareSize*(linesY-1)*[1,1],[fromY,toY],'Color','k')
                        end
                        title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',num2str(blkincorrectTrial),'  Total: ',num2str(totalcorrectTrial),'/',num2str(totalincorrectTrial),'    Manual Reward = ',num2str(manualreward_count)])
                        drawnow
                        bufferstart = GetSecs;
                    else
                        if GetSecs - bufferstart > timeBuffer
                            if breakFixation == 0
                                breakFixation = GetSecs - timeSessionStarts;
                            end
                            inTask = 0;
                            break;
                        end
                    end
                end
            end
        end
        
        %% Delay PERIOD

        iteration = 0;

        delay = rand*(maxdelay-mindelay) + mindelay;
        timedelaystart = GetSecs;
        
        while GetSecs < timedelaystart + delay && inTask == 1
            
            iteration = iteration +1;
            
            % Check for escape command
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(escapeKey)
                    save(filename,'results');
                    continueTask = 0;
                    inTask = 0;
                    break;
                elseif keyCode(spaceKey)
                    spacecount = spacecount + 1;
                elseif keyCode(rKey)
                    manualreward = 1;
                    break;
                end
            end

            % Check for fixation. If not, abort trial            
            if mouse == 0

                sample = Eyelink('NewestFloatSample');
                posX = round(sample.gx(1));
                posY = round(sample.gy(1));
                
            elseif mouse == 1
                [posX,posY,buttons] = GetMouse(window);
            end
            
            if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)

                Screen('FillOval', window, fixcol, fixRect);
                for linesX = 1:numDivisionsGrid(2)+1
                    Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                end
                [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                
                if iteration == 1
                    vbldelay = VBLTimestamp;
                    sdelay = GetSecs;
                    SendEvent2([0 0 0 0 0 1 0 0],dio);
                    edelay = GetSecs;
                    if mouse == 0
                        Eyelink('Message', num2str([0 0 0 0 0 1 0 0]));
                    end
                end
                
                eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
                fill(fixArea_X,fixArea_Y,fixAreaColor);
                hold on
                fill(fix_X,fix_Y,'k');
                hold on
                fill(eye_X,eye_Y,'b');
                hold off
                axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                for linesX = 1:numDivisionsGrid(2)+1
                    line([fromX,toX],fromY+squareSize*(linesX-1)*[1,1],'Color','k')
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    line(fromX+squareSize*(linesY-1)*[1,1],[fromY,toY],'Color','k')
                end
                title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',num2str(blkincorrectTrial),'  Total: ',num2str(totalcorrectTrial),'/',num2str(totalincorrectTrial),'    Manual Reward = ',num2str(manualreward_count)])
                drawnow
                bufferstart = GetSecs;
            else
                if GetSecs - bufferstart > timeBuffer
                    if breakFixation == 0
                        breakFixation = GetSecs - timeSessionStarts;
                    end
                    inTask = 0;
                    break;
                end
            end
        end
        
        
        %% PRESENT FEEDBACK FOR REWARDS
        if inTask == 1
            reward = 1;
        end
        
        if manualreward == 0
            if reward == 1
                
                timeIniFeedback = GetSecs;
                
                iteration = 0;
                totalcorrectTrial = totalcorrectTrial + 1;
                blkcorrectTrial = blkcorrectTrial + 1;
                
                % Snd('Play',rewardbeep);
                % SendEvent2([0 0 0 0 0 1 1 0]);
                
                while GetSecs - timeIniFeedback < feedbackTime
                    iteration = iteration + 1;
                    Screen('FillOval', window, [0 0 255], fixRect);
                    for linesX = 1:numDivisionsGrid(2)+1
                        Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                    end
                    for linesY = 1:numDivisionsGrid(1)+1
                        Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                    end
                    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                    
                    if iteration == 1
                        vblreward = VBLTimestamp;
                        Snd('Play',rewardbeep);
                        sreward = GetSecs;
                        SendEvent2([0 0 0 0 0 1 1 0],dio);
                        ereward = GetSecs;
                        if mouse == 0
                            Eyelink('Message', num2str([0 0 0 0 0 1 1 0]));
                        end
                        if rand<=rewardprob
                            usb_pulse(handle,rewardduration)
                        end
                    end
                    
                    if mouse == 0
                        
                        sample = Eyelink('NewestFloatSample');
                        posX = round(sample.gx(1));
                        posY = round(sample.gy(1));
                        
                    elseif mouse == 1
                        [posX,posY,buttons] = GetMouse(window);
                    end
                    eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                    eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                    eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
                    
                    fill(fix_X,fix_Y,[0 0 1]);
                    hold on
                    fill(eye_X,eye_Y,'b');
                    hold off
                    axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                    for linesX = 1:numDivisionsGrid(2)+1
                        line([fromX,toX],fromY+squareSize*(linesX-1)*[1,1],'Color','k')
                    end
                    for linesY = 1:numDivisionsGrid(1)+1
                        line(fromX+squareSize*(linesY-1)*[1,1],[fromY,toY],'Color','k')
                    end
                    title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',num2str(blkincorrectTrial),'  Total: ',num2str(totalcorrectTrial),'/',num2str(totalincorrectTrial),'    Manual Reward = ',num2str(manualreward_count)])
                    drawnow
                    [ keyIsDown, seconds, keyCode ] = KbCheck;
                    if keyIsDown
                        if keyCode(spaceKey)
                            spacecount = spacecount + 1;
                        end
                    end
                end
            elseif reward == 0 && continueTask == 1
                iteration = 0;
                
                totalincorrectTrial = totalincorrectTrial + 1;
                blkincorrectTrial = blkincorrectTrial + 1;
                % Snd('Play',failurebeep);
                % SendEvent2([0 0 0 0 0 1 1 1]);
                
                timeIniFeedback = GetSecs;
                while GetSecs - timeIniFeedback < feedbackTime
                    iteration = iteration + 1;
                    Screen('FillOval', window, fixcol, fixRect);
                    
                    for linesX = 1:numDivisionsGrid(2)+1
                        Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                    end
                    for linesY = 1:numDivisionsGrid(1)+1
                        Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                    end
                    [X,Y] = RectCenter(windowRect);
                    oldFontSize = Screen(window,'TextSize',800);
                    Screen('DrawText', window, 'x', X-320, Y-650, [255 0 0]);
                    % Screen('FillOval', window, [255 0 0], fixRect);
                    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                    
                    if iteration == 1
                        vblfail = VBLTimestamp;
                        Snd('Play',failurebeep);
                        sfail = GetSecs;
                        SendEvent2([0 0 0 0 0 1 1 1],dio);
                        efail = GetSecs;
                        if mouse == 0
                            Eyelink('Message', num2str([0 0 0 0 0 1 1 1]));
                        end
                    end
                    if mouse == 0
                        
                        sample = Eyelink('NewestFloatSample');
                        posX = round(sample.gx(1));
                        posY = round(sample.gy(1));
                        
                    elseif mouse == 1
                        [posX,posY,buttons] = GetMouse(window);
                    end
                    
                    eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                    eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                    eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
                    
                    fill(fix_X,fix_Y,[1 0 0]);
                    hold on
                    fill(eye_X,eye_Y,'b');
                    hold off
                    axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                    for linesX = 1:numDivisionsGrid(2)+1
                        line([fromX,toX],fromY+squareSize*(linesX-1)*[1,1],'Color','k')
                    end
                    for linesY = 1:numDivisionsGrid(1)+1
                        line(fromX+squareSize*(linesY-1)*[1,1],[fromY,toY],'Color','k')
                    end
                    title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',num2str(blkincorrectTrial),'  Total: ',num2str(totalcorrectTrial),'/',num2str(totalincorrectTrial),'    Manual Reward = ',num2str(manualreward_count)])
                    drawnow
                    [ keyIsDown, seconds, keyCode ] = KbCheck;
                    if keyIsDown
                        if keyCode(spaceKey)
                            spacecount = spacecount + 1;
                        end
                    end
                end
            end
            
        else
            
            timeIniFeedback = GetSecs;

            iteration = 0;          
            
            manualreward_count = manualreward_count + 1;
            
            while GetSecs - timeIniFeedback < feedbackTime
                iteration = iteration + 1;
                Screen('FillOval', window, [0 0 255], fixRect);
                for linesX = 1:numDivisionsGrid(2)+1
                    Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                end
                [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                
                if iteration == 1
                    vblmanualreward = VBLTimestamp;
                    Snd('Play',rewardbeep);
                    SendEvent2([0 0 0 0 1 0 0 0],dio);
                    if mouse == 0
                        Eyelink('Message', num2str([0 0 0 0 1 0 0 0]));
                    end
                    usb_pulse(handle,rewardduration)
                end
                
                if mouse == 0
                    
                    sample = Eyelink('NewestFloatSample');
                    posX = round(sample.gx(1));
                    posY = round(sample.gy(1));              
                    
                elseif mouse == 1
                    [posX,posY,buttons] = GetMouse(window);
                end
                eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];

                fill(fix_X,fix_Y,[0 0 1]);
                hold on
                fill(eye_X,eye_Y,'b');
                hold off
                axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                for linesX = 1:numDivisionsGrid(2)+1
                    line([fromX,toX],fromY+squareSize*(linesX-1)*[1,1],'Color','k')
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    line(fromX+squareSize*(linesY-1)*[1,1],[fromY,toY],'Color','k')
                end
                title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',num2str(blkincorrectTrial),'  Total: ',num2str(totalcorrectTrial),'/',num2str(totalincorrectTrial),'    Manual Reward = ',num2str(manualreward_count)])
                drawnow
                [ keyIsDown, seconds, keyCode ] = KbCheck;
                if keyIsDown
                    if keyCode(spaceKey)
                        spacecount = spacecount + 1;
                    end
                end
            end
        end
        
        %% PENALTY IF ANIMAL MOVE OUTSIDE THE FIXATION WINDOW
        timeIniPen = GetSecs;
        while GetSecs - timeIniPen < penalty && inTask == 0
            if mouse == 0
                
                sample = Eyelink('NewestFloatSample');
                posX = round(sample.gx(1));
                posY = round(sample.gy(1));
                
            elseif mouse == 1
                [posX,posY,buttons] = GetMouse(window);
            end
            
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(escapeKey)
                    save(filename,'results');
                    continueTask = 0;
                    inTask = 0;
                    break;
                end
            end

            for linesX = 1:numDivisionsGrid(2)+1
                Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
            end
            for linesY = 1:numDivisionsGrid(1)+1
                Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
            end
            [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
            eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
            eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
            eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];

            fill(eye_X,eye_Y,'b');
            axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
            for linesX = 1:numDivisionsGrid(2)+1
                line([fromX,toX],fromY+squareSize*(linesX-1)*[1,1],'Color','k')
            end
            for linesY = 1:numDivisionsGrid(1)+1
                line(fromX+squareSize*(linesY-1)*[1,1],[fromY,toY],'Color','k')
            end
            title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',num2str(blkincorrectTrial),'  Total: ',num2str(totalcorrectTrial),'/',num2str(totalincorrectTrial),'    Manual Reward = ',num2str(manualreward_count)])
            drawnow
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(spaceKey)
                    spacecount = spacecount + 1;
                end
            end
        end
        
%         if trialHasStarted == 1
%             results.breakFixation(trialsStarted) = breakFixation;
%             results.wrongTarget(trialsStarted) = wrongTarget;
%         end
        for linesX = 1:numDivisionsGrid(2)+1
            Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
        end
        for linesY = 1:numDivisionsGrid(1)+1
            Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
        end

%         %% POST TRIAL INTERVAL
        ITI = rand*(maxITI-minITI) + minITI;
        timeIniPTI = GetSecs;
        while GetSecs - timeIniPTI < ITI

            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(escapeKey)
                    save(filename,'results');
                    continueTask = 0;
                    inTask = 0;
                    break;
                end
            end

            for linesX = 1:numDivisionsGrid(2)+1
                Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
            end
            for linesY = 1:numDivisionsGrid(1)+1
                Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
            end
            [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
            if mouse == 0

                sample = Eyelink('NewestFloatSample');
                posX = round(sample.gx(1));
                posY = round(sample.gy(1));
                
            elseif mouse == 1
                [posX,posY,buttons] = GetMouse(window);
            end
            
            eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
            eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
            eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
            
            fill(eye_X,eye_Y,'b');
            axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
            for linesX = 1:numDivisionsGrid(2)+1
                line([fromX,toX],fromY+squareSize*(linesX-1)*[1,1],'Color','k')
            end
            for linesY = 1:numDivisionsGrid(1)+1
                line(fromX+squareSize*(linesY-1)*[1,1],[fromY,toY],'Color','k')
            end
            title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',num2str(blkincorrectTrial),'  Total: ',num2str(totalcorrectTrial),'/',num2str(totalincorrectTrial),'    Manual Reward = ',num2str(manualreward_count)])
            drawnow
        end
        
        if spacecount
            KbWait;
        end
        sendtrial = GetSecs;
        SendEvent2([0 0 1 0 0 0 0 0],dio);
        eendtrial = GetSecs;
        if mouse == 0
            Eyelink('Message', num2str([0 0 1 0 0 0 0 0]));
        end
        save(trialcountfilename,'totalcorrectTrial','totalincorrectTrial')

        if manualreward == 1
            whichTrial = whichTrial - 1;
        end
        
        results.sstarttrial(whichTrial) = sstarttrial;
        results.estarttrial(whichTrial) = estarttrial;
        results.sprestim(whichTrial) = sprestim;
        results.eprestim(whichTrial) = eprestim;
        results.starget(whichTrial) = starget;
        results.etarget(whichTrial) = etarget;
        results.sblank(whichTrial,:) = sblank;
        results.eblank(whichTrial,:) = eblank;
        results.sdistractor(whichTrial,:) = sdistractor;
        results.edistractor(whichTrial,:) = edistractor;
        results.sdelay(whichTrial) = sdelay;
        results.edelay(whichTrial) = edelay;
        results.sreward(whichTrial) = sreward;
        results.ereward(whichTrial) = ereward;
        results.sfail(whichTrial) = sfail;
        results.efail(whichTrial) = efail;
        results.sendtrial(whichTrial) = sendtrial;
        results.eendtrial(whichTrial) = eendtrial;
        
        results.vblstarttrial(whichTrial) = vblstarttrial;
        results.vblprestim(whichTrial) = vblprestim;
        results.vbltarget(whichTrial) = vbltarget;
        results.vblblank(whichTrial,:) = vblblank;
        results.vbldistractor(whichTrial,:) = vbldistractor;
        results.vbldelay(whichTrial) = vbldelay;
        results.vblreward(whichTrial) = vblreward;
        results.vblmanualreward(whichTrial) = vblmanualreward;
        results.vblfail(whichTrial) = vblfail;

        
        save(filename,'results')
    end

    Screen('CloseAll');
    %close the digital/analog objects
     clear dio
catch %#ok<CTCH>
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end


close(h)
return
