function myDST1(homeDir,results)

% Trigger
% (00000000) Start of Fixation period                 
% (00010000) Start of Feedback 
% (00100000) End of Trial

KbName('UnifyKeyNames');

%%% Save parameters in Results file

penalty = results.parameters.penalty;
fixationOn = results.parameters.fixationOn;
feedbackTime = results.parameters.feedbackTime;
fixSize = results.parameters.fixSize;
fixArea = results.parameters.fixArea;
timeFixation = results.parameters.timeFixation;
rewardprob = results.parameters.rewardprob;
backgroundColor = results.parameters.backgroundColor;

eyesquareSize = 10;
eyeRectOriginal = [0 0 eyesquareSize eyesquareSize];

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

try
    
    % Removes the blue screen flash and minimize extraneous warnings.
    Screen('Preference', 'VisualDebugLevel', 3);
    Screen('Preference', 'SuppressAllWarnings', 1);
    
    % Find out how many screens and use largest screen number.
    % whichScreen = max(Screen('Screens'));
    whichScreen = 0;
    % Open a new window.
    [ window, windowRect ] = Screen('OpenWindow', whichScreen,backgroundColor);
    
    % window = 10;
    % windowRect = [0 0 1680 1050];
    
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
    
    figure
    set(gcf(),'outerposition',[0 430,560,470])
    
    continueTask = 1;
    timeSessionStarts = GetSecs;
    results.parameters.timeSessionStarts = timeSessionStarts;

    while continueTask == 1
        
        %% WAIT FOR FIXATION
        inFixation = 0;
        startTask = 0;
        reward = 0;
        inTask = 1;
        
        timeTrialStarts = GetSecs;
        
        iteration = 0;
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
                end
            end

            Screen('FillOval', window, [255 255 255], fixRect);
            Screen('Flip', window);
            if iteration == 1
                % SendEvent([0 0 0 0 0 0 0 0]);
            end
            
            eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
            eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
            eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
            fill(fix_X,fix_Y,'k');
            hold on
            fill(eye_X,eye_Y,'b');
            hold off
            axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
            
            drawnow
        end


        
        %% PRESENT FEEDBACK FOR REWARDS
        if reward == 1 
            
            % make a beep sound
            Snd('Play',beep);
            timeIniFeedback = GetSecs;

            while GetSecs - timeIniFeedback < feedbackTime
                [posX,posY,buttons] = GetMouse(window);
                Screen('FillOval', window, [0 255 0], fixRect);
                Screen('Flip', window);
                if iteration == 1
                    if rand<=rewardprob
                        % SendEvent([0 0 0 1 0 0 0 0]);
                    end
                end
                eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];

                fill(fix_X,fix_Y,[0 1 0]);
                hold on
                fill(eye_X,eye_Y,'b');
                hold off
                axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                drawnow

            end
        else
            timeIniFeedback = GetSecs;
            while GetSecs - timeIniFeedback < feedbackTime
                [posX,posY,buttons] = GetMouse(window);
                Screen('FillOval', window, [255 0 0], fixRect);
                Screen('Flip', window);
                if iteration == 1
                    % SendEvent([0 0 0 1 0 0 0 0]);
                end
                eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];

                fill(fix_X,fix_Y,[1 0 0]);
                hold on
                fill(eye_X,eye_Y,'b');
                hold off
                axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])

                drawnow
            end
        end
        
        %% PENALTY IF ANIMAL MOVE OUTSIDE THE FIXATION WINDOW
        timeIniPen = GetSecs;
        while GetSecs - timeIniPen < penalty && inTask == 0
            [posX,posY,buttons] = GetMouse(window);

            [ keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                if keyCode(escapeKey)
                    save(filename,'results');
                    continueTask = 0;
                    inTask = 0;
                    break;
                end
            end
            
            Screen('Flip', window);
            eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
            eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
            eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];

            fill(eye_X,eye_Y,'b');
            axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])

            drawnow
        end
        
        
%         %% POST TRIAL INTERVAL
%         timeIniPTI = GetSecs;
%         while GetSecs - timeIniPTI < ITI
%             [posX,posY,buttons] = GetMouse(window);
%             [ keyIsDown, seconds, keyCode ] = KbCheck; %#ok<*ASGLU>
%             if keyIsDown
%                 if keyCode(escapeKey)
%                     continueTask = 0;
%                     startTask = 1;
%                     break;
%                 end
%             end
%             
%             Screen('Flip', window);
%             eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
%             eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
%             eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
%             
%             fill(eye_X,eye_Y,'b');
%             axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
% 
%             drawnow
%         end
         % SendEvent([0 0 1 0 0 0 0 0]);

    end
    
    
    Screen('CloseAll');
    
catch %#ok<CTCH>
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end
return
