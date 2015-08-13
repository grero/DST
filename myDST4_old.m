function myDST4(homeDir,results)

KbName('UnifyKeyNames');

% Trigger
% (00000000) Start of Fixation period 
% (00000001) Start of Pre-Stimulus Period              
% (10000000) Start of Target Stimulus (34 locations)    
% (01000000) Start of Distractor Stimulus (34 locations) 
% the first 6 bins encode the information the 34 locations 
% 00 (000,000) (x,y)
% eg. (4,5) square is represented by (100,101), 
% so distractor stimulus at (4,5) will be represented by (01100101)

% (00000010) Start of Stimulus Blank period         
% (00000100) Start of Delay Period                                   
% (00001000) Start of Response Period                     
% (00010000) Start of Feedback 
% (00100000) End of Trial

%%% Save parameters in Results file

% squareSize = results.parameters.squareSize;

ITI = results.parameters.ITI;
penalty = results.parameters.penalty;
fixationOn = results.parameters.fixationOn;
prestim = results.parameters.prestim;
delay = results.parameters.delay;
squareTimeON = results.parameters.squareTimeON;
interSquareTime = results.parameters.interSquareTime;
rangeRT = results.parameters.rangeRT;
timeOnTarget = results.parameters.timeOnTarget;
rangeDistractors = results.parameters.rangeDistractors;
feedbackTime = results.parameters.feedbackTime;
fixSize = results.parameters.fixSize;
fixArea = results.parameters.fixArea;
timeFixation = results.parameters.timeFixation;
targetColor = results.parameters.targetcol;
distractorColor = results.parameters.distractorcol;
backgroundColor = results.parameters.backgroundColor;
eyemvt = results.parameters.eyemvt;
date = results.parameters.date;
time = results.parameters.time;
numDivisionsGrid = [results.parameters.horgnum results.parameters.vergnum]; % number of division of grid in [x,y] axis

eyesquareSize = 10;

beep = MakeBeep(100,0.2);
Snd('Open')


% Initialize variables.
% daqreset;
% adaptor = 'nidaq';
% id = 'Dev2';
% chanID = 1;
% chanID2 = 2;
% sampleRate = 8000; 
% initialPosX = 0;
% 
% % Create and configure analog input object.
% ai = analoginput(adaptor,id);
% addchannel(ai,chanID);
% addchannel(ai,chanID2);
% set(ai, 'SampleRate', sampleRate);
% set(ai, 'SamplesPerTrigger', Inf);
% 
% start(ai);
% initialPosX = getdata(ai,1);
% stop(ai);
% 
% % Stop DAQ
% delete(ai);
% daqreset;

%%% Define filename
a = clock; a(1:3); % a = [year month day]
if ~exist([homeDir '/results_DST/'])
    mkdir([homeDir '/results_DST/']);
end
filename = [homeDir '/results_DST/results_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '.mat'];
k = 1;
while exist(filename) %#ok<*EXIST>
    k = k + 1;
    filename = [homeDir '/results_DST/results_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '(' num2str(k) ').mat'];
end

try
    
    % Removes the blue screen flash and minimize extraneous warnings.
    Screen('Preference', 'VisualDebugLevel', 3);
    Screen('Preference', 'SuppressAllWarnings', 1);
    
    % Find out how many screens and use largest screen number.
    % whichScreen = max(Screen('Screens'));
    whichScreen = 1;
    
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
    
    locations = [];
    for i = 1:numDivisionsGrid(1)
        for j = 1:numDivisionsGrid(2)
            if i ~= ceil(numDivisionsGrid(1)/2) && j ~= ceil(numDivisionsGrid(2)/2)
                locations = [locations; i,j]; %#ok<*AGROW>
            end
        end
    end
    numLocations = length(locations);
    locationsIndex = 1:numLocations;
    
    % Calculate locations
    %     HideCursor(0);
    cueRectOriginal = [0 0 squareSize squareSize]; % rect for cue/target/distractors
    
    fixRect = [0 0 fixSize fixSize]; % rect for fixation spot
    fixRect = CenterRect(fixRect, windowRect); % Center the spot
    
    fixAreaRect = [0 0 fixArea fixArea]; % rect for fixation area
    fixAreaRect = CenterRect(fixAreaRect, windowRect); % Center the area
    
    % Set keys.
    escapeKey = KbName('ESCAPE');
    
    continueTask = 1;
    trialsStarted = 0;
    whichTrial = 0;
    timeSessionStarts = GetSecs;
    results.parameters.timeSessionStarts = timeSessionStarts;
    while continueTask == 1
        
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
        
        timeTrialStarts = GetSecs;
        
        iteration = 0;
        while startTask == 0
            
            iteration = iteration + 1;
            
            [posX,posY,buttons] = GetMouse(window); %#ok<*NASGU>
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
                end
            end
            
            Screen('FillOval', window, [255 255 255], fixRect);
            for linesX = 1:numDivisionsGrid(2)+1
                Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
            end
            for linesY = 1:numDivisionsGrid(1)+1
                Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
            end
            Screen('Flip', window);
            if iteration == 1
                SendEvent([0 0 0 0 0 0 0 0]);
            end
        end

        %% PRE-STIMULUS PERIOD

        iteration = 0;
        
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
                end
            end

            % Check for fixation. If not, abort trial
            [posX,posY,buttons] = GetMouse(window);
            if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)

                Screen('FillOval', window, [255 255 255], fixRect);
                for linesX = 1:numDivisionsGrid(2)+1
                    Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                end
                Screen('Flip', window);
                if iteration == 1
                    SendEvent([0 0 0 0 0 0 0 0]);
                end

            else
                if breakFixation == 0
                    breakFixation = GetSecs - timeSessionStarts;
                end
                inTask = 0;
                break;
            end

        end

        
        %% PRESENT CUE AND DISTRACTORS
        
        % Select number of distractors and locations
        numDistractors = rangeDistractors(1):rangeDistractors(2);
        numDistractors = numDistractors(ceil(rand*length(numDistractors)));
        
        
        locationIndexShuffled = shuffle(locationsIndex);
        locationsTrial = locationIndexShuffled(1:numDistractors+1);
        
        % FIRST PRESENT CUE
        timeStartCue = GetSecs;
        
        xOffset = squareSize*(locations(locationsTrial(1),1)-1)+fromX;
        yOffset = squareSize*(locations(locationsTrial(1),2)-1)+fromY;
        cueRect = OffsetRect(cueRectOriginal, xOffset, yOffset);
        
        if startTask == 1
            trialsStarted = trialsStarted + 1;
            results.trialsStarted = trialsStarted;
            results.numDistractors(trialsStarted) = numDistractors;
            results.locationsTrial{trialsStarted} = locationsTrial;
            results.timeStartCue(trialsStarted,1) = timeStartCue - timeSessionStarts;
        end
        
        xbin = str2num(dec2bin(locations(locationsTrial(1),1),3));
        ybin = str2num(dec2bin(locations(locationsTrial(1),2),3));

        for x = 1:3
            xbinmod(1,x) = bitget(xbin,x);
            ybinmod(1,x) = bitget(ybin,x);
        end

        iteration = 0;
        
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
                end
            end
            
            % Check for fixation. If not, abort trial
            [posX,posY,buttons] = GetMouse(window);
            if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)
                
                % Present cue
                Screen('FillRect', window, targetColor, cueRect);
                Screen('FillOval', window, [255 255 255], fixRect);
                for linesX = 1:numDivisionsGrid(2)+1
                    Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                end
                Screen('Flip', window);
                
                if iteration == 1
                    SendEvent([1 0 xbinmod ybinmod]);
                end
                
            else
                if breakFixation == 0
                    breakFixation = GetSecs - timeSessionStarts;
                end
                inTask = 0;
                break;
            end
            
        end
        
        % NOW PRESENT DISTRACTORS
        if numDistractors > 0
            for d = 1:numDistractors
                
                xOffset = squareSize*(locations(locationsTrial(d+1),1)-1)+fromX;
                yOffset = squareSize*(locations(locationsTrial(d+1),2)-1)+fromY;
                distRect = OffsetRect(cueRectOriginal, xOffset, yOffset);
                
                % INTER SQUARE INTERVAL
                iteration = 0;

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
                        end
                    end
                    
                    % Check for fixation. If not, abort trial
                    [posX,posY,buttons] = GetMouse(window);
                    if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)
                        % Wait period
                        Screen('FillOval', window, [255 255 255], fixRect);
                        for linesX = 1:numDivisionsGrid(2)+1
                            Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                        end
                        for linesY = 1:numDivisionsGrid(1)+1
                            Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                        end
                        Screen('Flip', window);
                        
                        if iteration == 1;
                            SendEvent([0 0 0 0 0 0 1 0]);
                        end
                    else
                        if breakFixation == 0
                            breakFixation = GetSecs - timeSessionStarts;
                        end
                        inTask = 0;
                        break;
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
                        end
                    end
                    
                    % Check for fixation. If not, abort trial
                    [posX,posY,buttons] = GetMouse(window);
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
                        Screen('Flip', window);
                        
                        if iteration == 1
                            SendEvent([0 1 xbinmod ybinmod]);
                        end
                    else
                        if breakFixation == 0
                            breakFixation = GetSecs - timeSessionStarts;
                        end
                        inTask = 0;
                        break;
                    end
                end
            end
        end
        
        % PRE-RESPONSE PERIOD
        iteration = 0;

        timeIniPreresponse = GetSecs;
        while GetSecs < timeIniPreresponse + delay && inTask == 1

            iteration = iteration + 1;
            
            % Check for escape command
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(escapeKey)
                    save(filename,'results');
                    continueTask = 0;
                    inTask = 0;
                    break;
                end
            end
            
            % Check for fixation. If not, abort trial
            [posX,posY,buttons] = GetMouse(window);
            if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)
                % Wait period
                Screen('FillOval', window, [255 255 255], fixRect);
                for linesX = 1:numDivisionsGrid(2)+1
                    Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                end
                Screen('Flip', window);
                
                if iteration == 1;
                    SendEvent([0 0 0 0 0 1 0 0]);
                end
            else
                if breakFixation == 0
                    breakFixation = GetSecs - timeSessionStarts;
                end
                inTask = 0;
                break;
            end
        end
        
        % RESPONSE PERIOD
        timeIniResponse = GetSecs;
        timeReachTarget = inf;
        responded = 0;
        eyeRect = [];
        new_pos = inf;
        new_vel = inf;
        vel = [];
        acc = [];
        sac_threshold = 1000;
        j = 0;

        % jit hon edited (check if intask == 1)
        iteration = 0;
        
        while responded == 0  && inTask == 1
            
            iteration = iteration + 1;
            if GetSecs - timeIniResponse > rangeRT(2)/1000
                responded = 1;
            end
            
            % Check for escape command
            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(escapeKey)
                    save(filename,'results');
                    continueTask = 0;
                    responded = 1;
                    break;
                end
            end
            
            % Check for correct response.
            [posX,posY,buttons] = GetMouse(window);
            
            if eyemvt == 1
                pos = sqrt(posX^2+posY^2);
                if isinf(new_pos)
                    old_pos = pos;
                    old_GetSecs = GetSecs;
                else
                    old_pos = new_pos;
                    old_GetSecs = new_GetSecs;
                end
                new_pos = pos;
                new_GetSecs = GetSecs;

                vel = [vel abs(new_pos - old_pos)/(new_GetSecs-old_GetSecs)];

                if isinf(new_vel)
                    old_vel = vel(end);
                else
                    old_vel = new_vel;
                end
                new_vel = vel(end);

                acc = [acc (new_vel - old_vel)/(new_GetSecs-old_GetSecs)];

                % saccade colour (red)
                saccol = [255 0 0];
                % fixation colour (blue)
                fixcol = [0 0 255];

                eyeRectOriginal = [0 0 eyesquareSize eyesquareSize];
                eye_xOffset = posX;
                eye_yOffset = posY;
                eyeRect = [eyeRect; OffsetRect(eyeRectOriginal, eye_xOffset, eye_yOffset)];

                % need to compute saccade and fixation (using velocity and
                % acceleration)

                if vel(end)<sac_threshold && length(vel) == 1
                    j = j+1;
                    fix_pos{j} = [];
                    fix_pos{j} = [fix_pos{j} new_pos];
                elseif vel(end)>=sac_threshold && length(vel) == 1
                elseif vel(end)<sac_threshold && vel(end-1)<sac_threshold
                    fix_pos{j} = [fix_pos{j} new_pos];
                elseif vel(end)<sac_threshold && vel(end-1)>=sac_threshold
                    j = j+1;
                    fix_pos{j} = [];
                    fix_pos{j} = [fix_pos{j} new_pos];
                end
            end
            
            if posX > cueRect(1) && posX < cueRect(3) && posY > cueRect(2) && posY < cueRect(4)
                
                if timeReachTarget == inf
                    timeReachTarget = GetSecs;
                end
                
                if GetSecs - timeReachTarget > timeOnTarget
                    responded = 1;
                    reward = 1;
                    
                    %%%%%%% reward %%%%%%%
                end
                
                % Wait period
                
                for linesX = 1:numDivisionsGrid(2)+1
                    Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                end
                
                if eyemvt == 1
                    i = 0;
                    mvcol = [];
                    while i<size(eyeRect,1)
                        i = i+1;
                        if vel(i)>=sac_threshold
                            mvcol = [mvcol; saccol];
                        else
                            mvcol = [mvcol; fixcol];
                        end
                        Screen('FillOval', window, mvcol(i,:), eyeRect(i,:));
                    end
                end
                Screen('Flip', window);
                
                if iteration == 1
                    SendEvent([0 0 0 0 1 0 0 0]);
                end
            else
%                 if wrongTarget == 0 && startTask == 1 && timeReachTarget == inf
%                     wrongTarget = GetSecs - timeSessionStarts;
%                 end
                if responded == 0
                    wrongTarget = GetSecs - timeSessionStarts;
                end
                timeReachTarget = inf;
                % Wait period
                for linesX = 1:numDivisionsGrid(2)+1
                    Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                end
                
                if eyemvt == 1
                    i = 0;
                    mvcol = [];
                    while i<size(eyeRect,1)
                        i = i+1;
                        if vel(i)>=sac_threshold
                            mvcol = [mvcol; saccol];
                        else
                            mvcol = [mvcol; fixcol];
                        end
                        Screen('FillOval', window, mvcol(i,:), eyeRect(i,:));
                    end
                end
                Screen('Flip', window);
                
                if iteration == 1
                    SendEvent([0 0 0 0 1 0 0 0]);
                end
            end
            
        end
        
        %% PRESENT FEEDBACK FOR REWARDS
        if inTask == 1
            results.reward(trialsStarted,1) = reward;
        end
        
        if reward == 1
            
            % make a beep sound
            Snd('Play',beep);
            
            timeIniFeedback = GetSecs;

            iteration = 0;
            
            while GetSecs - timeIniFeedback < feedbackTime
                iteration = iteration + 1;
                Screen('FillOval', window, [0 255 0], fixRect);
                for linesX = 1:numDivisionsGrid(2)+1
                    Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                end
                Screen('Flip', window);
                if iteration == 1
                    SendEvent([0 0 0 1 0 0 0 0]);
                end
            end
        else
            iteration = 0;
            timeIniFeedback = GetSecs;
            while GetSecs - timeIniFeedback < feedbackTime
                iteration = iteration + 1;
                Screen('FillOval', window, [255 0 0], fixRect);
                for linesX = 1:numDivisionsGrid(2)+1
                    Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                end
                Screen('Flip', window);
                if iteration == 1
                    SendEvent([0 0 0 1 0 0 0 0]);
                end
            end
        end
        
        %% PENALTY IF ANIMAL MOVE OUTSIDE THE FIXATION WINDOW
        timeIniPen = GetSecs;
        while GetSecs - timeIniPen < penalty && inTask == 0
            for linesX = 1:numDivisionsGrid(2)+1
                Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
            end
            for linesY = 1:numDivisionsGrid(1)+1
                Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
            end
            Screen('Flip', window);
        end
        
        if trialHasStarted == 1
            results.breakFixation(trialsStarted) = breakFixation;
            results.wrongTarget(trialsStarted) = wrongTarget;
        end
        
        %% POST TRIAL INTERVAL
        timeIniPTI = GetSecs;
        while GetSecs - timeIniPTI < ITI
            for linesX = 1:numDivisionsGrid(2)+1
                Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
            end
            for linesY = 1:numDivisionsGrid(1)+1
                Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
            end
            Screen('Flip', window);
        end
        SendEvent([0 0 1 0 0 0 0 0]);
        
    end
    
    
    Screen('CloseAll');
    
catch %#ok<CTCH>
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end
return
