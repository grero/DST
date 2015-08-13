function DST
%% Delay Sample Task

% Camilo Libedinsky, June, 2012

% homeDir = 'C:\Users\neuro\Desktop\Camilo Matlab';
homeDir = '/Users/elebjh/Desktop';
cd(homeDir)
KbName('UnifyKeyNames');
DST_task(homeDir);

% position eyes (mean, stdv) after fixation off
% time off fixation (to analyze predistraction period
% need to add where breakFixation was broken to... i.e. towards distractor? towards target?

return

function DST_task(homeDir)

% parameters.
ITI = 1; % time between end of previous trial and begin of new trial (s)
squareSize = 150; % size of cue, target and distractors (px)
numDivisionsGrid = [9 5]; % number of division of grid in [x,y] axis
squareTimeON = 1; % time cue, target and distractors are ON (s)
interSquareTime = 2; % time between cue and distractors and targets (s)
rangeRT = [100 2000]; % range of allowed RT
timeOnTarget = 1; % time required to stay on target (s)
rangeDistractors = [3 3];
feedbackTime = 0.5;

fixSize = 15; % size fixation spot (px)
fixArea = 100; % area where it is considered fixation (px)
timeFixation = 3; % time after fixation when trial begins (s)

backgroundColor = [100 100 100];

%%% Save parameters in Results file
results.parameters.ITI = ITI;
results.parameters.squareSize = squareSize;
results.parameters.squareTimeON = squareTimeON;
results.parameters.interSquareTime = interSquareTime;
results.parameters.rangeRT = rangeRT;
results.parameters.timeOnTarget = timeOnTarget;
results.parameters.rangeDistractors = rangeDistractors;
results.parameters.feedbackTime = feedbackTime;
results.parameters.fixSize = fixSize;
results.parameters.fixArea = fixArea;
results.parameters.timeFixation = timeFixation;
results.parameters.backgroundColor = [100 100 100];
results.parameters.date = date;
a = clock; time = [num2str( a(4),'%02i') ':' num2str( a(5),'%02i')];
results.parameters.time = time;
results.breakFixation = [];



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
    whichScreen = max(Screen('Screens'));
    
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
        
        while startTask == 0
            
            [posX,posY,buttons] = GetMouse(window); %#ok<*NASGU>
            if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)
                if inFixation == 0
                    fixationIni = GetSecs;
                end
                inFixation = 1;
            else
                inFixation = 0;
                fixationIni = GetSecs;
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
        
        while GetSecs < timeStartCue + squareTimeON && inTask == 1
            
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
                
                % Present cue
                Screen('FillRect', window, [255 0 0], cueRect);
                Screen('FillOval', window, [255 255 255], fixRect);
                for linesX = 1:numDivisionsGrid(2)+1
                    Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                end
                Screen('Flip', window);
                
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
                timeIniDistractor = GetSecs;
                while GetSecs < timeIniDistractor + interSquareTime && inTask == 1
                    
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
                    else
                        if breakFixation == 0
                            breakFixation = GetSecs - timeSessionStarts;
                        end
                        inTask = 0;
                        break;
                    end
                end
                
                % PRESENT NEXT DISTRACTOR
                timeIniDistractor = GetSecs;
                while GetSecs < timeIniDistractor + squareTimeON && inTask == 1
                    
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
                        Screen('FillRect', window, [0 255 0], distRect);
                        Screen('FillOval', window, [255 255 255], fixRect);
                        for linesX = 1:numDivisionsGrid(2)+1
                            Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                        end
                        for linesY = 1:numDivisionsGrid(1)+1
                            Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                        end
                        Screen('Flip', window);
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
        timeIniPreresponse = GetSecs;
        while GetSecs < timeIniPreresponse + interSquareTime && inTask == 1
            
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
        while responded == 0
            
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
                Screen('Flip', window);
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
                Screen('Flip', window);
            end
            
        end
        
        %% PRESENT FEEDBACK FOR REWARDS
        results.reward(trialsStarted,1) = reward;
        if reward == 1
            timeIniFeedback = GetSecs;
            while GetSecs - timeIniFeedback < feedbackTime
                Screen('FillOval', window, [0 255 0], fixRect);
                for linesX = 1:numDivisionsGrid(2)+1
                    Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                end
                Screen('Flip', window);
            end
        else
            timeIniFeedback = GetSecs;
            while GetSecs - timeIniFeedback < feedbackTime
                Screen('FillOval', window, [255 0 0], fixRect);
                for linesX = 1:numDivisionsGrid(2)+1
                    Screen('DrawLine', window ,[0 0 0], fromX, fromY+squareSize*(linesX-1), toX, fromY+squareSize*(linesX-1) ,2);
                end
                for linesY = 1:numDivisionsGrid(1)+1
                    Screen('DrawLine', window ,[0 0 0], fromX+squareSize*(linesY-1), fromY, fromX+squareSize*(linesY-1), toY ,2);
                end
                Screen('Flip', window);
            end
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
        
        if trialHasStarted == 1
            results.breakFixation(trialsStarted) = breakFixation;
            results.wrongTarget(trialsStarted) = wrongTarget;
        end
    end
    
    
    Screen('CloseAll');
    
catch %#ok<CTCH>
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end
return
