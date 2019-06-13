function eyeAutoCalib(homeDir,results)

% Trigger
% (00000000) Start of Fixation period                 
% (00000110) Start of Reward Feedback
% (00000111) Start of Failure Feedback
% (00100000) End of Trial

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
numreward = results.parameters.numreward;
rewardduration = results.parameters.rewardduration;
backgroundColor = results.parameters.backgroundColor;
numdatapoints = 3; 
eyefile = 'new6ec';
reward_pos = [];
reward_XY = [];
GridCols = 3;
GridRows = 3;
displayImage = 0;
fixcol = results.parameters.fixcol;
mouse = 0;
blocknum = results.parameters.blocknum;

if blocknum == 0
    blocknum = 1000;
end

eyesquareSize = 10;
eyeRectOriginal = [0 0 eyesquareSize eyesquareSize];

rewardbeep = MakeBeep(2000,0.2);
failurebeep = MakeBeep(100,0.2);
Snd('Open')

if mouse == 0
    % Initialize variables.
    daqreset;
    adaptor = 'nidaq';
    id = 'Dev2';
    chanID = 1;
    chanID2 = 3;
    sampleRate = 240;

    % Create and configure analog input object.
    ai = analoginput(adaptor,id);
    addchannel(ai,chanID);
    addchannel(ai,chanID2);
    set(ai, 'SampleRate', sampleRate);
    set(ai, 'SamplesPerTrigger', Inf);

    start(ai);
end

try
    if mouse == 0
        cwd = pwd;
        cd(homeDir)
        cd results_DST
        load(eyefile)
        cd(cwd)
    end
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

    numLocations = size(locations,1);
    
    posX1 = CenterX;
    posY1 = CenterY;
    
    fixRectOriginal = [0 0 fixSize fixSize]; % rect for fixation spot
    fixAreaRectOriginal = [0 0 fixArea fixArea]; % rect for fixation area
    fixAreaColor = [0.5 0.5 0.5];
    
    imageRectOriginal = [0 0 fixArea fixArea]; % rect for fixation spot
    imageRect = CenterRect(imageRectOriginal, windowRect);
    % Set keys.
    escapeKey = KbName('ESCAPE');
    spaceKey = KbName('SPACE');
    bKey = KbName('B');
    rKey = KbName('R');
    
    h = figure;
    set(gcf(),'outerposition',[0 430,560,470])
    
    continueTask = 1;
    timeSessionStarts = GetSecs;
    results.parameters.timeSessionStarts = timeSessionStarts;
    Trial = 1;
    correctTrial = 0;
    incorrectTrial = 0;
    whichTrial = 0;
    
    if displayImage == 1
        imageindex = ceil(rand(1)*8);
        imagename = [num2str(imageindex),'.jpg'];
        imageMatrix = imread(imagename);
        textureIndex=Screen('MakeTexture', window, imageMatrix);
    end

    while continueTask == 1 && floor(whichTrial/numLocations) ~= blocknum

        %% WAIT FOR FIXATION
        inFixation = 0;
        startTask = 0;
        whichTrial = whichTrial + 1;
        reward = 0;
        inTask = 1;
        spacecount = 0;
        update = 0;
        
        timeTrialStarts = GetSecs;
        
        iteration = 0;
        
        if mod(whichTrial,numLocations) == 1
            cuelocationsIndexShuffled = randperm(numLocations);
        end
        
        if mod(whichTrial,numLocations) ~= 0
            blTrial = mod(whichTrial,numLocations);
        else
            blTrial = numLocations;
        end
        
        while startTask == 0
            iteration = iteration + 1;

            if mouse == 0
                XY_vol = peekdata(ai,numdatapoints);
                X_vol = mean(XY_vol(:,1));
                Y_vol = mean(XY_vol(:,2));

                eyefilt = [X_vol,Y_vol];
                screencoords = Eyevol2Screen(eyefilt',ec.eyevol',ec.GridCols,ec.GridRows,...
                    ec.CenterX,ec.CenterY,ec.Xsize,ec.Ysize);
                posX = screencoords(1);
                posY = screencoords(2);

            elseif mouse == 1
                [posX,posY,buttons] = GetMouse(window);
            end
            
            posX1 = locations(cuelocationsIndexShuffled(blTrial),1);
            posY1 = locations(cuelocationsIndexShuffled(blTrial),2);
            fixRect = OffsetRect(fixRectOriginal, posX1-fixSize/2, posY1-fixSize/2);
            fix_X = [fixRect(1) fixRect(1) fixRect(3) fixRect(3)];
            fix_Y = windowRect(4) - [fixRect(2) fixRect(4) fixRect(4) fixRect(2)];
            
            fixAreaRect = OffsetRect(fixAreaRectOriginal, posX1-fixArea/2, posY1-fixArea/2); % Center the area
            fixArea_X = [fixAreaRect(1) fixAreaRect(1) fixAreaRect(3) fixAreaRect(3)];
            fixArea_Y = windowRect(4) - [fixAreaRect(2) fixAreaRect(4) fixAreaRect(4) fixAreaRect(2)];
            
            imageRect = OffsetRect(imageRectOriginal, posX1-fixArea/2, posY1-fixArea/2); % Center the area
            
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
                    reward = 1;
                    % update = 1;
                    break;
                end
            end
            
            if displayImage == 0
                Screen('FillOval', window, fixcol, fixRect);
            elseif displayImage == 1
                Screen('DrawTexture',window,textureIndex,[],imageRect);
            end
            
            Screen('Flip', window);
            if iteration == 1
                SendEvent([0 0 0 0 0 0 0 0]);
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
        if reward == 1

            if displayImage == 1
                imageindex = ceil(rand(1)*8);
                imagename = [num2str(imageindex),'.jpg'];
                imageMatrix = imread(imagename);
                textureIndex=Screen('MakeTexture', window, imageMatrix);
            end

            Trial = Trial + 1;
            correctTrial = correctTrial + 1;
            
            if mouse == 0
                % locationindex = cuelocationsIndexShuffled(blTrial);
                % ec.eyevol(locationindex,:) = (ec.eyevol(locationindex,:) + eyefilt)/2;
            end
            
            % make a beep sound
            timeIniFeedback = GetSecs;
            iteration = 1;

            if iteration == 1
                Snd('Play',rewardbeep);
                SendEvent([0 0 0 0 0 1 1 0]);

                if mouse == 0
                    reward_pos = [reward_pos; repmat([posX1 posY1],3,1)];
                    % reward_XY = [reward_XY; repmat([posX posY],3,1)];
                    reward_XY = [reward_XY ; XY_vol];
                end
                if rand<=rewardprob
                    DST_reward(numreward,rewardduration)
                    % SendEvent([0 0 0 0 0 1 1 0]);
                end
            end

            while GetSecs - timeIniFeedback < feedbackTime
                
                Screen('FillOval', window, [0 0 255], fixRect);
                Screen('Flip', window);

                if mouse == 0
                    XY_vol = peekdata(ai,numdatapoints);
                    X_vol = mean(XY_vol(:,1));
                    Y_vol = mean(XY_vol(:,2));

                    eyefilt = [X_vol,Y_vol];
                    screencoords = Eyevol2Screen(eyefilt',ec.eyevol',ec.GridCols,ec.GridRows,...
                        ec.CenterX,ec.CenterY,ec.Xsize,ec.Ysize);
                    posX = screencoords(1);
                    posY = screencoords(2);

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
            iteration = 1;
            
            Trial = Trial + 1;
            incorrectTrial = incorrectTrial + 1;

            if iteration == 1
                Snd('Play',failurebeep);
                SendEvent([0 0 0 0 0 1 1 1]);
            end

            while GetSecs - timeIniFeedback < feedbackTime
                
                if mouse == 0
                    XY_vol = peekdata(ai,numdatapoints);
                    X_vol = mean(XY_vol(:,1));
                    Y_vol = mean(XY_vol(:,2));

                    eyefilt = [X_vol,Y_vol];
                    screencoords = Eyevol2Screen(eyefilt',ec.eyevol',ec.GridCols,ec.GridRows,...
                        ec.CenterX,ec.CenterY,ec.Xsize,ec.Ysize);
                    posX = screencoords(1);
                    posY = screencoords(2);

                elseif mouse == 1
                    [posX,posY,buttons] = GetMouse(window);
                end
                
                [X,Y] = RectCenter(windowRect);
                oldFontSize = Screen(window,'TextSize',800);
                Screen('DrawText', window, 'x', X-320, Y-650, [255 0 0]);
                % Screen('FillOval', window, [255 0 0], fixRect);
                Screen('Flip', window);

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
        
        %% POST TRIAL INTERVAL
        ITI = rand*(maxITI-minITI) + minITI;
        timeIniPTI = GetSecs;
        while GetSecs - timeIniPTI < ITI
            
            if mouse == 0
                XY_vol = peekdata(ai,numdatapoints);
                X_vol = mean(XY_vol(:,1));
                Y_vol = mean(XY_vol(:,2));

                eyefilt = [X_vol,Y_vol];
                screencoords = Eyevol2Screen(eyefilt',ec.eyevol',ec.GridCols,ec.GridRows,...
                    ec.CenterX,ec.CenterY,ec.Xsize,ec.Ysize);
                posX = screencoords(1);
                posY = screencoords(2);

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
        SendEvent([0 0 1 0 0 0 0 0]);

    end

    Screen('CloseAll');
    
catch 
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end

if mouse == 0
    % Stop DAQ
    stop(ai);
    
    delete(ai);
    daqreset;
    save('reward','reward_pos','reward_XY');
    save ec ec
end

close(h)
return
