function myDST5(homeDir,results)
global handle whichScreen
KbName('UnifyKeyNames');
%TODO: Allow smaller targets at the centre of the big targets
%TODO: Make we use the same axis handle for all plots
% + +   + +
%  *     *
% + +

% Trigger
% (11000000) Start of Session 
% (00000000) Start of Fixation period 
% (00000001) Start of Pre-Stimulus Period              
% (10000000) Start of Target Stimulus (34 locations)    
% (01000000) Start of Distractor Stimulus (34 locations) 
% the first 6 bins encode the information the 34 locations 
% 00 (000,000) (x,y)
% eg. (4,5) square is represented by (100,101), 
% so distractor stimulus at (4,5) will be represented by (01100101)

% (00000011) Start of Stimulus Blank period         
% (00000100) Start of Delay Period                                   
% (00000101) Start of Response Period                     
% (00000110) Start of Reward Feedback
% (00000111) Start of Failure Feedback 
% (00100000) End of Trial

% (00001111) Start of Microstimulation

%%% Save parameters in Results file

% squareSize = results.parameters.squareSize;

monkeyname = results.parameters.monkeyname;
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
rangeRT = results.parameters.rangeRT;
timeOnTarget = results.parameters.timeOnTarget;
rangeDistractors = results.parameters.rangeDistractors;
feedbackTime = results.parameters.feedbackTime;
fixSize = results.parameters.fixSize;
fixArea = results.parameters.fixArea;
fixcol = results.parameters.fixcol;
timeFixation = results.parameters.timeFixation;
rewardprob = results.parameters.rewardprob;
rewardduration = results.parameters.rewardduration;
manualrewardduration = results.parameters.manualrewardduration;
targetColor = results.parameters.targetcol;
distractorColor = results.parameters.distractorcol;
backgroundColor = results.parameters.backgroundColor;
blocknum = results.parameters.blocknum;
maxcorrecttrials = results.parameters.maxcorrecttrials;
selected_target_locations = results.parameters.selected_target_locations;
selected_distractor_locations = results.parameters.selected_distractor_locations;
mouse = results.parameters.mouse;
respond_center = results.parameters.respond_center;
fixtime = results.parameters.fixtime;
eyemvt = 0;
date = results.parameters.date;
time = results.parameters.time;
numDivisionsGrid = [results.parameters.horgnum results.parameters.vergnum]; % number of division of grid in [x,y] axis
gridcontrast = results.parameters.gridcontrast;
numdatapoints = 3; 
squareSize = 100;
respondsizeratio = results.parameters.respondsizeratio;
maxAddTargets = results.parameters.maxnumtarget;
% tarcontrastlevel = results.parameters.tarcontrastlevel;
% distContrastlevel = results.parameters.distcontrastlevel;
prestimcontrastlevel = results.parameters.prestimcontrast;
stimcontrastlevel = results.parameters.stimcontrast;
responsecontrastlevel = results.parameters.responsecontrast;
distContrastlevel = 0;
repeatederror_count_threshold = 3;
present_alllocations = 1;
savefilename_ext = results.parameters.savefilename_ext;
eyesquareSize = 10;
eyeRectOriginal = [0 0 eyesquareSize eyesquareSize];
targetColor_mod = targetColor/255;
distractorColor_mod = distractorColor/255;

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
prestimratio = results.parameters.prestimratio;
squareTimeONratio = results.parameters.squareTimeONratio;
interSquareTimeratio = results.parameters.interSquareTimeratio;
%should stimulaition change the length of the delay period
delayratio = results.parameters.delayratio;
RTratio = results.parameters.RTratio;
timeOnTargetratio = results.parameters.timeOnTargetratio;

rewardbeep = MakeBeep(2000,0.2);
failurebeep = MakeBeep(100,0.2);
Snd('Open')

%attempt to get the current commit
code_version = '';
if exist('getGitInfo')
    [pathstr,~,~] = fileparts((mfilename('fullpath')));
    gg = getGitInfo(pathstr);
    code_version = gg.hash;
end

if blocknum == 0
    blocknum = 1000;
end

if maxcorrecttrials == 0
    maxcorrecttrials = 10000;
end

%%% Define filename
a = clock; a(1:3); % a = [year month day]
if ~exist([homeDir '/results_DST/'])
    mkdir([homeDir '/results_DST/']);
end
if isempty(savefilename_ext)
    filename = [homeDir '/results_DST/results_DST_' monkeyname '_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '.mat'];
    trialcountfilename = [homeDir '/results_DST/trialcount_DST_' monkeyname '_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '.mat'];
    
    k = 1;
    while exist(filename) %#ok<*EXIST>
        k = k + 1;
        filename = [homeDir '/results_DST/results_DST_' monkeyname '_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '(' num2str(k) ').mat'];
    end
else
    filename = [homeDir '/results_DST/results_DST_' monkeyname '_' savefilename_ext '_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '.mat'];
    trialcountfilename = [homeDir '/results_DST/trialcount_DST_' monkeyname '_' savefilename_ext '_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '.mat'];
    
    k = 1;
    while exist(filename) %#ok<*EXIST>
        k = k + 1;
        filename = [homeDir '/results_DST/results_DST_' monkeyname '_' savefilename_ext '_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '(' num2str(k) ').mat'];
    end
    
end

if exist(trialcountfilename) %#ok<*EXIST>0
    load(trialcountfilename);
else
    totalcorrectTrial = 0;
    totalincorrectTrial = 0;
    totalincompleteTrial = 0;
    totalmanualreward_count = 0;
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

try
    % create a handle for reward system
    %[handle,errmsg] = IOPort('OpenSerialPort','com4','RTS=1');
    
    % Removes the blue screen flash and minimize extraneous warnings.
    Screen('Preference', 'VisualDebugLevel', 3);
    Screen('Preference', 'SuppressAllWarnings', 1);
    
    % Find out how many screens and use largest screen number.
    % whichScreen = max(Screen('Screens'));
    %whichScreen = 2;
    
    if mouse == 1
        whichScreen = 1;
    end
    % Open a new window.
    [ window, windowRect ] = Screen('OpenWindow', whichScreen,backgroundColor);
    
    % window = 10;
    % windowRect = [0 0 1680 1050];
    
    squareArea = floor((windowRect(4)-windowRect(4)/10)/numDivisionsGrid(2));
    buffersize = round(squareArea*(respondsizeratio - 1));
    % diffsize = round((squareArea - squareSize)/2);
    diffsize = round((squareArea - squareArea)/2);
    
    while squareArea*numDivisionsGrid(1) > windowRect(3)
        numDivisionsGrid(1) = numDivisionsGrid(1) - 2;
    end
    results.parameters.numDivisionsGrid = numDivisionsGrid;
    
    % Calculate grid size
    fromX = (windowRect(3) - numDivisionsGrid(1) * squareArea) / 2;
    toX   = windowRect(3) - fromX;
    
    fromY = (windowRect(4) - numDivisionsGrid(2) * squareArea) / 2;
    toY   = windowRect(4) - fromY;

    if selected_target_locations == 0
        locations = [];
        for i = 1:numDivisionsGrid(1)
            for j = 1:numDivisionsGrid(2)
                if mod(numDivisionsGrid(1),2) == 1 && mod(numDivisionsGrid(2),2) == 1
                    if i ~= ceil(numDivisionsGrid(1)/2) || j ~= ceil(numDivisionsGrid(2)/2)
                        locations = [locations; i,j]; %#ok<*AGROW>
                    end
                elseif mod(numDivisionsGrid(1),2) == 0 && mod(numDivisionsGrid(2),2) == 0
                    if (i ~= (numDivisionsGrid(1)/2) && i ~= (numDivisionsGrid(1)/2)+1) || (j ~= (numDivisionsGrid(2)/2) && j ~= (numDivisionsGrid(2)/2)+1)
                        locations = [locations; i,j]; %#ok<*AGROW>
                    end
                elseif mod(numDivisionsGrid(1),2) == 1 && mod(numDivisionsGrid(2),2) == 0
                    if i ~= ceil(numDivisionsGrid(1)/2) || (j ~= (numDivisionsGrid(2)/2) && j ~= (numDivisionsGrid(2)/2)+1)
                        locations = [locations; i,j]; %#ok<*AGROW>
                    end
                elseif mod(numDivisionsGrid(1),2) == 0 && mod(numDivisionsGrid(2),2) == 1
                    if (i ~= (numDivisionsGrid(1)/2) && i ~= (numDivisionsGrid(1)/2)+1) || j ~= ceil(numDivisionsGrid(2)/2)
                        locations = [locations; i,j]; %#ok<*AGROW>
                    end
                end
            end
        end
    else
        locations = selected_target_locations;
    end
    
    if selected_distractor_locations == 0
        distractor_locations = [];
        for i = 1:numDivisionsGrid(1)
            for j = 1:numDivisionsGrid(2)
                if mod(numDivisionsGrid(1),2) == 1 && mod(numDivisionsGrid(2),2) == 1
                    if i ~= ceil(numDivisionsGrid(1)/2) || j ~= ceil(numDivisionsGrid(2)/2)
                        distractor_locations = [distractor_locations; i,j]; %#ok<*AGROW>
                    end
                elseif mod(numDivisionsGrid(1),2) == 0 && mod(numDivisionsGrid(2),2) == 0
                    if (i ~= (numDivisionsGrid(1)/2) && i ~= (numDivisionsGrid(1)/2)+1) || (j ~= (numDivisionsGrid(2)/2) && j ~= (numDivisionsGrid(2)/2)+1)
                        distractor_locations = [distractor_locations; i,j]; %#ok<*AGROW>
                    end
                elseif mod(numDivisionsGrid(1),2) == 1 && mod(numDivisionsGrid(2),2) == 0
                    if i ~= ceil(numDivisionsGrid(1)/2) || (j ~= (numDivisionsGrid(2)/2) && j ~= (numDivisionsGrid(2)/2)+1)
                        distractor_locations = [distractor_locations; i,j]; %#ok<*AGROW>
                    end
                elseif mod(numDivisionsGrid(1),2) == 0 && mod(numDivisionsGrid(2),2) == 1
                    if (i ~= (numDivisionsGrid(1)/2) && i ~= (numDivisionsGrid(1)/2)+1) || j ~= ceil(numDivisionsGrid(2)/2)
                        distractor_locations = [distractor_locations; i,j]; %#ok<*AGROW>
                    end
                end
            end
        end
    else
        distractor_locations = selected_distractor_locations;
    end
    
    numLocations = size(locations,1);
    locationsIndex = 1:numLocations;
    
    distractor_numLocations = size(distractor_locations,1);
    distractor_locationsIndex = 1:distractor_numLocations;
    
    % Calculate locations
    % HideCursor(0);
    cueRectOriginal = [0 0 squareArea squareArea]; % rect for cue/target/distractors
    
    fixRect = [0 0 fixSize fixSize]; % rect for fixation spot
    fixRect = CenterRect(fixRect, windowRect); % Center the spot
    fix_X = [fixRect(1) fixRect(1) fixRect(3) fixRect(3)];
    fix_Y = [fixRect(2) fixRect(4) fixRect(4) fixRect(2)];
    
    fixAreaRect = [0 0 fixArea fixArea]; % rect for fixation area
    fixAreaRect = CenterRect(fixAreaRect, windowRect); % Center the area
    fixArea_X = [fixAreaRect(1) fixAreaRect(1) fixAreaRect(3) fixAreaRect(3)];
    fixArea_Y = [fixAreaRect(2) fixAreaRect(4) fixAreaRect(4) fixAreaRect(2)];
    fixAreaColor = [0.5 0.5 0.5];
    for linesX = 1:numDivisionsGrid(1)+1
        if respond_center == 1
            if linesX ~= numDivisionsGrid(2)+1
                Y_rect(linesX) = fromY+squareArea*(linesX-1);
            end
        end
    end
    for linesY = 1:numDivisionsGrid(1)+1
        if respond_center == 1
            if linesY ~= numDivisionsGrid(1)+1
                X_rect(linesY) = fromX+squareArea*(linesY-1);
            end
        end
    end
    
    if respond_center == 1
        oldTextSize = Screen('TextSize', window, fixSize);
        [normBoundsRect, offsetBoundsRect]= Screen('TextBounds', window, '+');
    end
    
    % Set keys.
    escapeKey = KbName('ESCAPE');
    spaceKey = KbName('SPACE');
    rKey = KbName('R');
    
    h = figure;
    set(gcf(),'outerposition',[0 430,560,470])
    
    continueTask = 1;
    trialsStarted = 0;
    % whichTrial = 0;
    whichTrial = 1;
    repeatederror_count = 0;
    sessionstarted = 0;
    timeSessionStarts = GetSecs;
    results.parameters.timeSessionStarts = timeSessionStarts;
    blTrial = [];
    blkcorrectTrial = 0;
    blkincorrectTrial = 0;
    blkincompleteTrial = 0;
    maxcorrecttrials_count = 0;
    % totalmanualreward_count = 0;
    
    % open stimulator object if stimprob ~= 0
    if stimprob ~= 0
        % initializing the stimulator object
        err = StimController(channel, Rate, first_pulseamp, second_pulseamp, first_pulseDur, second_pulseDur, interDur, numPulses);
    end
    %before we enter loop, set up reward and trigger objects
    %trigger object
    % Create a Digital I/O Object with the digitalio function
    dio.io.ioObj = io32();
    dio.io.status = io32(dio.io.ioObj);
    % dio=digitalio('parallel','lpt1');
    % Add lines to a Digital I/O Object
    % addline(dio,0,2,'out');
    % addline(dio,0:7,0,'out'); % add the hardware lines 0 until 7 from port 0 to the digital object dio
    %clear the lines
    % putvalue(dio,zeros(1,9));
    %reward object
    % AO = analogoutput('nidaq','Dev2');
    % Add channels  Add one channel to AO.
    % addchannel(AO,0);
    % Set the SampleRate
    % set(AO,'SampleRate',8000);
    
    SendEvent2([1 1 0 0 0 0 0 0],dio);
    ncols = bitget(numDivisionsGrid(1),1:6);
    nrows = bitget(numDivisionsGrid(2),1:6);
    SendEvent2([1 1 ncols],dio); %maximum column
    SendEvent2([1 1 nrows],dio); %maximum row
    if mouse == 0
        Eyelink('Message',sunm2str([1 1 0 0 0 0 0 0]));
        Eyelink('Message', num2str([1 1 ncols nrows]));
    end
    
    while continueTask == 1 && floor(whichTrial/numLocations) ~= blocknum && maxcorrecttrials_count < maxcorrecttrials
        
        %% WAIT FOR FIXATION
        inFixation = 0;
        startTask = 0;
        inTask = 1;
        % whichTrial = whichTrial + 1;
        results.totalNumberOfTrials = whichTrial;
        trialHasStarted = 0;
        breakFixation = 0;
        wrongTarget = 0;
        reward = 0;
        manualreward = 0;
        stimulation = 0;
        spacecount = 0;
        
        estarttrial = 0;
        eprestim = 0;
        etarget = 0;
        eblank = zeros(1,5);
        edistractor = zeros(1,5);
        edelay = 0;
        erespond = 0;
        ereward = 0;
        efail = 0;
        
        vblstarttrial = 0;
        vblprestim = 0;
        vbltarget = 0;
        vblblank = zeros(1,5);
        vbldistractor = zeros(1,5);
        vbldelay = 0;
        vblrespond = 0;
        vblreward = 0;
        vblfail = 0;
        
        timeTrialStarts = GetSecs;
        
        iteration = 0;
        
        if mod(whichTrial,numLocations) == 1 || numLocations == 1 
            if sessionstarted == 0
                blkcorrectTrial = 0;
                blkincorrectTrial = 0;
                blkincompleteTrial = 0;
                
                cuelocationsIndexShuffled = randperm(numLocations);
                sessionstarted = 1;
            end
        end
        
        if mod(whichTrial,numLocations) ~= 0
            blTrial = mod(whichTrial,numLocations);
        else
            blTrial = numLocations;
        end
        
        % Select number of distractors and locations
        numDistractors = rangeDistractors(1):rangeDistractors(2);
        numDistractors = numDistractors(ceil(rand*length(numDistractors)));
        numAddTargets = 0:maxAddTargets;
        numAddTargets = numAddTargets(ceil(rand*length(numAddTargets)));
        
        stim_sequence = [ones(1,numAddTargets),2*ones(1,numDistractors)];
        stim_sequence = stim_sequence(randperm(length(stim_sequence)));
        targetindex = find(stim_sequence == 1);
        
        if present_alllocations == 0
            locationIndexShuffled = Shuffle(setdiff(distractor_locationsIndex,cuelocationsIndexShuffled(blTrial)));
        elseif present_alllocations == 1
            locationIndexShuffled = Shuffle(distractor_locationsIndex);
        end
        % locationsTrial = [cuelocationsIndexShuffled(blTrial),locationIndexShuffled(1:numDistractors)];
        stim_sequence_locationindex = locationIndexShuffled(1:length(stim_sequence));
        for x = 1:length(targetindex)
            stim_sequence_locationindex(targetindex(x)) = cuelocationsIndexShuffled(randi(length(cuelocationsIndexShuffled),1,1));
        end
				%what targets and distractors will be presented in this trial
        locationsTrial = [cuelocationsIndexShuffled(blTrial),stim_sequence_locationindex];
        
				%get the actual position of the target on the screen
        xOffset = squareArea*(locations(locationsTrial(1),1)-1)+fromX;
        yOffset = squareArea*(locations(locationsTrial(1),2)-1)+fromY;
        cueRect = OffsetRect(cueRectOriginal, xOffset, yOffset);
        cueSizeRect = [cueRect(1)+diffsize cueRect(2)+diffsize cueRect(3)-diffsize cueRect(4)-diffsize];
				%for the experimenter screen
        cue_X = [cueSizeRect(1) cueSizeRect(1) cueSizeRect(3) cueSizeRect(3)];
        cue_Y = windowRect(4) - [cueSizeRect(2) cueSizeRect(4) cueSizeRect(4) cueSizeRect(2)];
        
        while startTask == 0
            
            iteration = iteration + 1;
            
            if mouse == 0
                
                sample = Eyelink('NewestFloatSample');
                posX = round(sample.gx(eye_used+1));
                posY = round(sample.gy(eye_used+1));
            elseif mouse == 1
                [posX,posY,buttons] = GetMouse(window);
            end
            
						%TODO: what if the monkey blinks?
						%is the eye poisition within the central fixation window
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

						%TODO: also check if we are in fixation
            if GetSecs - fixationIni > timeFixation
                startTask = 1;
                break;
            end
           	
					 dobreak = checkforkeys	;
					 if dobreak
						 break
					 end
					 %should the target appear with the fixation spot?	
            if prestimcontrastlevel ~= 0
                Screen('FillRect', window,[((255-100)*prestimcontrastlevel/100) + 100 ((0-100)*prestimcontrastlevel/100) + 100  ((0-100)*prestimcontrastlevel/100) + 100], cueSizeRect);
            end
            Screen('FillOval', window, fixcol, fixRect);
            
            if respond_center == 1
                ScreenGridCenters(window,numDivisionsGrid,locations,squareArea, X_rect, Y_rect,normBoundsRect,fixcol);
            else
                ScreenGridLines(window,numDivisionsGrid,squareArea,fromX,toX,fromY,toY,gridcontrast,backgroundColor)
            end
            % Screen('Flip', window);
            [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
            if iteration == 1
                vblstarttrial = VBLTimestamp;
                SendEvent2([0 0 0 0 0 0 0 0],dio);
                estarttrial = GetSecs;
                if mouse == 0
                    Eyelink('Message', num2str([0 0 0 0 0 0 0 0]));
                end
            end
            
            eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
            eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
            eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
            fill(fix_X,fix_Y,'k');
            hold on
            if prestimcontrastlevel ~= 0
                fill(cue_X,cue_Y,targetColor_mod);
                hold on
            end
            fill(eye_X,eye_Y,'b');
            hold off
            axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
            plotGridLines(numDivisionsGrid,squareArea,fromX,toX,fromY,toY)
            
            title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',...
                num2str(blkincorrectTrial),'/',num2str(blkincompleteTrial),'  Total: ',num2str(totalcorrectTrial),'/',...
                num2str(totalincorrectTrial),'/',num2str(totalincompleteTrial), '  (' num2str(100*totalcorrectTrial/(totalincorrectTrial+totalcorrectTrial)) '%)',...
                '    Manual Reward = ',num2str(totalmanualreward_count)])
            drawnow

        end

        %% PRE-STIMULUS PERIOD

        iteration = 0;

        prestim = rand*(maxprestim-minprestim) + minprestim;
        timefixationend = GetSecs;
        while GetSecs < (timefixationend + prestim+(prestim*(prestimratio-1)*stimulation)) && inTask == 1
            
            iteration = iteration +1;
            trialHasStarted = 1;
            
						%TODO: make this into a function since we keep doing the same thing
            % Check for escape command
						dobreak = checkforkeys
						if dobreak
							break;
						end

            % Check for fixation. If not, abort trial
            if mouse == 0
                
                sample = Eyelink('NewestFloatSample');
                posX = round(sample.gx(eye_used+1));
                posY = round(sample.gy(eye_used+1));
                
            elseif mouse == 1
                [posX,posY,buttons] = GetMouse(window);
            end
            
            if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)
                if prestimcontrastlevel ~= 0
                    Screen('FillRect', window,[((255-100)*prestimcontrastlevel/100) + 100 ((0-100)*prestimcontrastlevel/100) + 100  ((0-100)*prestimcontrastlevel/100) + 100], cueSizeRect);
                end
                Screen('FillOval', window, fixcol, fixRect);
                if respond_center == 0
                    ScreenGridLines(window,numDivisionsGrid,squareArea,fromX,toX,fromY,toY,gridcontrast,backgroundColor)
                else
                   ScreenGridCenters(window,numDivisionsGrid,locations,squareArea, X_rect, Y_rect,normBoundsRect,fixcol);
                end
                
                % Screen('Flip', window);
                [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                if iteration == 1
                    vblprestim = VBLTimestamp;
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
                if prestimcontrastlevel ~= 0
                    fill(cue_X,cue_Y,targetColor_mod);
                    hold on
                end
                fill(eye_X,eye_Y,'b');
                hold off
                axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                plotGridLines(numDivisionsGrid,squareArea,fromX,toX,fromY,toY)
                title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',...
                num2str(blkincorrectTrial),'/',num2str(blkincompleteTrial),'  Total: ',num2str(totalcorrectTrial),'/',...
                num2str(totalincorrectTrial),'/',num2str(totalincompleteTrial), '  (' num2str(100*totalcorrectTrial/(totalincorrectTrial+totalcorrectTrial)) '%)',...
                '    Manual Reward = ',num2str(totalmanualreward_count)])
                drawnow
            else
							%TODO: use buffer time here to allow the monkey to drift outside the fixation for a short period
                if breakFixation == 0
                    breakFixation = GetSecs - timeSessionStarts;
                    blkincompleteTrial = blkincompleteTrial + 1;
                    totalincompleteTrial = totalincompleteTrial + 1;
                    %TODO: why are we not incrementing the trial counter here?
                    whichTrial = whichTrial + 1;
                end
                inTask = 0;
                break;
            end
            
            if StimRef == 1 && stimprob ~= 0
                if GetSecs > timefixationend + Stimulation_onset && stimulation == 0
                    if rand < stimprob
                        SendEvent2([0 0 0 0 1 1 1 1],dio);
                        if mouse == 0
                            Eyelink('Message', num2str([0 0 0 0 1 1 1 1]));
                            Eyelink('Message', num2str([channel, Rate, first_pulseamp, second_pulseamp, first_pulseDur, second_pulseDur, interDur, numPulses]));
                        end
                        err = PS_StartStimAllChannels(1);
                    end
                    stimulation = 1;
                end
            end
        end
        
        %% PRESENT CUE AND DISTRACTORS
        
        % Select number of distractors and locations
%         numDistractors = rangeDistractors(1):rangeDistractors(2);
%         numDistractors = numDistractors(ceil(rand*length(numDistractors)));
%         numAddTargets = 0:maxAddTargets;
%         numAddTargets = numAddTargets(ceil(rand*length(numAddTargets)));
% 
%         stim_sequence = [ones(1,numAddTargets),2*ones(1,numDistractors)];
%         stim_sequence = stim_sequence(randperm(length(stim_sequence)));
%         targetindex = find(stim_sequence == 1);
%         
%         locationIndexShuffled = Shuffle(setdiff(locationsIndex,cuelocationsIndexShuffled(blTrial)));
%         % locationsTrial = [cuelocationsIndexShuffled(blTrial),locationIndexShuffled(1:numDistractors)];
%         locationsTrial = [cuelocationsIndexShuffled(blTrial),locationIndexShuffled(1:length(stim_sequence))];
        
        % FIRST PRESENT CUE
        timeStartCue = GetSecs;
        
%         xOffset = squareArea*(locations(locationsTrial(1),1)-1)+fromX;
%         yOffset = squareArea*(locations(locationsTrial(1),2)-1)+fromY;
%         cueRect = OffsetRect(cueRectOriginal, xOffset, yOffset);
%         cueSizeRect = [cueRect(1)+diffsize cueRect(2)+diffsize cueRect(3)-diffsize cueRect(4)-diffsize];
%         cue_X = [cueSizeRect(1) cueSizeRect(1) cueSizeRect(3) cueSizeRect(3)];
%         cue_Y = windowRect(4) - [cueSizeRect(2) cueSizeRect(4) cueSizeRect(4) cueSizeRect(2)];
        
        %         cueRectwithbuffer = [cueRect(1)-buffersize cueRect(2)-buffersize cueRect(3)+buffersize cueRect(4)+buffersize];
        %         cue_Xwithbuffer = [cueRectwithbuffer(1) cueRectwithbuffer(1) cueRectwithbuffer(3) cueRectwithbuffer(3)];
        %         cue_Ywithbuffer = windowRect(4) - [cueRectwithbuffer(2) cueRectwithbuffer(4) cueRectwithbuffer(4) cueRectwithbuffer(2)];
        
        if ~isempty(targetindex)
            xOffset1 = squareArea*(locations(locationsTrial(targetindex(end)+1),1)-1)+fromX;
            yOffset1 = squareArea*(locations(locationsTrial(targetindex(end)+1),2)-1)+fromY;
            cueRect1 = OffsetRect(cueRectOriginal, xOffset1, yOffset1);
            cueRectwithbuffer = [cueRect1(1)-buffersize cueRect1(2)-buffersize cueRect1(3)+buffersize cueRect1(4)+buffersize];
            cue_Xwithbuffer = [cueRectwithbuffer(1) cueRectwithbuffer(1) cueRectwithbuffer(3) cueRectwithbuffer(3)];
            cue_Ywithbuffer = windowRect(4) - [cueRectwithbuffer(2) cueRectwithbuffer(4) cueRectwithbuffer(4) cueRectwithbuffer(2)];
        else
            cueRectwithbuffer = [cueRect(1)-buffersize cueRect(2)-buffersize cueRect(3)+buffersize cueRect(4)+buffersize];
            cue_Xwithbuffer = [cueRectwithbuffer(1) cueRectwithbuffer(1) cueRectwithbuffer(3) cueRectwithbuffer(3)];
            cue_Ywithbuffer = windowRect(4) - [cueRectwithbuffer(2) cueRectwithbuffer(4) cueRectwithbuffer(4) cueRectwithbuffer(2)];
        end

        if startTask == 1
            trialsStarted = trialsStarted + 1;
        end
        
        if locationsTrial(1) ~= 0
            xbinmod = bitget(locations(locationsTrial(1),1),1:6);
            ybinmod = bitget(locations(locationsTrial(1),2),1:6);
            
            
            iteration = 0;
            squareTimeON = rand*(maxsquareTimeON-minsquareTimeON) + minsquareTimeON;

            while GetSecs < (timeStartCue + squareTimeON + (squareTimeON*(squareTimeONratio-1)*stimulation)) && inTask == 1

                iteration = iteration + 1;
                % trialHasStarted = 1;

                % Check for escape command
								dobreak = checkforkeys;
								if dobreak
									break;
								end

                % Check for fixation. If not, abort trial
                if mouse == 0
                    
                    sample = Eyelink('NewestFloatSample');
                    posX = round(sample.gx(eye_used+1));
                    posY = round(sample.gy(eye_used+1));
                    
                elseif mouse == 1
                    [posX,posY,buttons] = GetMouse(window);
                end
                
                if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)

                    % Present cue
                    % Screen('FillRect', window, targetColor, cueSizeRect);
                    if stimcontrastlevel ~= 0
                        Screen('FillRect', window,[((255-100)*stimcontrastlevel/100) + 100 ((0-100)*stimcontrastlevel/100) + 100  ((0-100)*stimcontrastlevel/100) + 100], cueSizeRect);
                    end
                    % Screen('FillRect', window, [255 255 255], [0 0 100 100]);
                    Screen('FillOval', window, fixcol, fixRect);
                    if respond_center == 0
                        ScreenGridLines(window,numDivisionsGrid,squareArea,fromX,toX,fromY,toY,gridcontrast,backgroundColor)
                    else
                       ScreenGridCenters(window,numDivisionsGrid,locations,squareArea, X_rect, Y_rect,normBoundsRect,fixcol);
                    end
                    % Screen('Flip', window);
                    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                    if iteration == 1
                        vbltarget = VBLTimestamp;
                        if targetColor == [0 255 0]
                            SendEvent2([1 0 xbinmod],dio);
                            SendEvent2([1 0 ybinmod],dio);
                            etarget = GetSecs;
                            if mouse == 0
                                Eyelink('Message', num2str([1 0 xbinmod ybinmod]));
                            end
                        elseif targetColor == [255 0 0]
                            SendEvent2([0 1 xbinmod],dio);
                            SendEvent2([0 1 ybinmod],dio);
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
                    plotGridLines(numDivisionsGrid,squareArea,fromX,toX,fromY,toY)

                    title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',...
                    num2str(blkincorrectTrial),'/',num2str(blkincompleteTrial),'  Total: ',num2str(totalcorrectTrial),'/',...
                    num2str(totalincorrectTrial),'/',num2str(totalincompleteTrial), '  (' num2str(100*totalcorrectTrial/(totalincorrectTrial+totalcorrectTrial)) '%)',...
                    '    Manual Reward = ',num2str(totalmanualreward_count)])
                    drawnow
                else
                    if breakFixation == 0
                        breakFixation = GetSecs - timeSessionStarts;
                        blkincompleteTrial = blkincompleteTrial + 1;
                        totalincompleteTrial = totalincompleteTrial + 1;
                        if locations(locationsTrial(1),1) == 4 && locations(locationsTrial(1),2) == 4
                            %TODO: which are we still doing this?
                        else
                            whichTrial = whichTrial + 1;
                        end
                    end
                    inTask = 0;
                    break;
                end

                if StimRef == 2 && stimprob ~= 0
                    if (GetSecs > (timeStartCue + Stimulation_onset)) && stimulation == 0
                        if rand < stimprob
                            SendEvent2([0 0 0 0 1 1 1 1],dio);
                            if mouse == 0
                                Eyelink('Message', num2str([0 0 0 0 1 1 1 1]));
                                Eyelink('Message', num2str([channel, Rate, first_pulseamp, second_pulseamp, first_pulseDur, second_pulseDur, interDur, numPulses]));
                            end
                            err = PS_StartStimAllChannels(1);
                        end
                        stimulation = 1;
                    end
                end
            end
        end
        % NOW PRESENT DISTRACTORS
        % if numDistractors > 0
        if ~isempty(stim_sequence)
            % for d = 1:numDistractors
            for d = 1:length(stim_sequence)
                
                if d == 1 &&  locationsTrial(1) == 0
                else
                    xOffset = squareArea*(distractor_locations(locationsTrial(d+1),1)-1)+fromX;
                    yOffset = squareArea*(distractor_locations(locationsTrial(d+1),2)-1)+fromY;
                    distRect = OffsetRect(cueRectOriginal, xOffset, yOffset);
                    distRect = [distRect(1)+diffsize distRect(2)+diffsize distRect(3)-diffsize distRect(4)-diffsize];

                    % INTER SQUARE INTERVAL
                    iteration = 0;
                    interSquareTime = rand*(maxinterSquareTime-mininterSquareTime) + mininterSquareTime;
                    
                    timeIniDistractor = GetSecs;
                    while GetSecs < (timeIniDistractor + interSquareTime + (interSquareTime*(interSquareTimeratio-1)*stimulation)) && inTask == 1

                        iteration = iteration + 1;

                        % Check for escape command
												dobreak = checkforkeys;
												if dobreak
													break
												end
                        % Check for fixation. If not, abort trial
                        if mouse == 0
                            
                            sample = Eyelink('NewestFloatSample');
                            posX = round(sample.gx(eye_used+1));
                            posY = round(sample.gy(eye_used+1));
                            
                        elseif mouse == 1
                            [posX,posY,buttons] = GetMouse(window);
                        end
                        
                        if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)
                            % Wait period
                            Screen('FillOval', window, fixcol, fixRect);
                            if respond_center == 0
                                ScreenGridLines(window,numDivisionsGrid,squareArea,fromX,toX,fromY,toY,gridcontrast,backgroundColor)
                            else
                                ScreenGridCenters(window,numDivisionsGrid,locations,squareArea, X_rect, Y_rect,normBoundsRect,fixcol);
                            end
                            % Screen('Flip', window);
                            [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                            
                            if iteration == 1
                                vblblank(1,d) = VBLTimestamp;
                                SendEvent2([0 0 0 0 0 0 1 1],dio);
                                eblank(1,d) = GetSecs;
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
                            plotGridLines(numDivisionsGrid,squareArea,fromX,toX,fromY,toY)

                             title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',...
                num2str(blkincorrectTrial),'/',num2str(blkincompleteTrial),'  Total: ',num2str(totalcorrectTrial),'/',...
                num2str(totalincorrectTrial),'/',num2str(totalincompleteTrial), '  (' num2str(100*totalcorrectTrial/(totalincorrectTrial+totalcorrectTrial)) '%)',...
                '    Manual Reward = ',num2str(totalmanualreward_count)])
                            drawnow
                        else
                            if breakFixation == 0
                                breakFixation = GetSecs - timeSessionStarts;
                                blkincompleteTrial = blkincompleteTrial + 1;
                                totalincompleteTrial = totalincompleteTrial + 1;
                                if locations(locationsTrial(1),1) == 4 && locations(locationsTrial(1),2) == 4
                                    %TODO: why are we still doing this?
                                else
                                    whichTrial = whichTrial + 1;
                                end
                            end
                            inTask = 0;
                            break;
                        end
                    end
                end
                
                % PRESENT NEXT DISTRACTOR
                
                xbinmod = bitget(distractor_locations(locationsTrial(d+1),1),1:6);
                ybinmod = bitget(distractor_locations(locationsTrial(d+1),2),1:6);
                iteration = 0;
                
                timeIniDistractor = GetSecs;
                while GetSecs < (timeIniDistractor + squareTimeON + (squareTimeON*(squareTimeONratio-1)*stimulation)) && inTask == 1
                    
                    iteration = iteration + 1;
                    
                    % Check for escape command
										dobreak = checkforkeys;
										if dobreak
											break
										end
                    % Check for fixation. If not, abort trial
                    if mouse == 0
                        
                        sample = Eyelink('NewestFloatSample');
                        posX = round(sample.gx(eye_used+1));
                        posY = round(sample.gy(eye_used+1));
                        
                    elseif mouse == 1
                        [posX,posY,buttons] = GetMouse(window);
                    end
                    
                    if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)
                        % Present Distractor
                        if distContrastlevel ~= 0
                            Screen('FillRect', window,[(distractorColor(1)-100)/distContrastlevel+100 (distractorColor(2)-100)/distContrastlevel+100 (distractorColor(3)-100)/distContrastlevel+100], distRect);
                        else
                            if stim_sequence(d) == 1
                                Screen('FillRect', window, targetColor, distRect);
                            elseif stim_sequence(d) == 2
                                Screen('FillRect', window, distractorColor, distRect);
                            end
                        end
                        Screen('FillOval', window, fixcol, fixRect);
                        if respond_center == 0
                            ScreenGridLines(window,numDivisionsGrid,squareArea,fromX,toX,fromY,toY,gridcontrast,backgroundColor)
                        else
                            ScreenGridCenters(window,numDivisionsGrid,locations,squareArea, X_rect, Y_rect,normBoundsRect,fixcol);
                        end
                        % Screen('Flip', window);
                        [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                        
                        if iteration == 1
                            vbldistractor(1,d) = VBLTimestamp;
                            if stim_sequence(d) == 1
                                if targetColor == [0 255 0]
                                    SendEvent2([1 0 xbinmod],dio);
                                    SendEvent2([1 0 ybinmod],dio);
                                    edistractor(1,d) = GetSecs;
                                    if mouse == 0
                                        Eyelink('Message', num2str([1 0 xbinmod ybinmod]));
                                    end
                                elseif targetColor == [255 0 0]
                                    SendEvent2([0 1 xbinmod],dio);
                                    SendEvent2([0 1 ybinmod],dio);
                                    edistractor(1,d) = GetSecs;
                                    if mouse == 0
                                        Eyelink('Message', num2str([0 1 xbinmod ybinmod]));
                                    end
                                end
                            elseif stim_sequence(d) == 2
                                if distractorColor == [0 255 0]
                                    SendEvent2([1 0 xbinmod],dio);
                                    SendEvent2([1 0 ybinmod],dio);
                                    edistractor(1,d) = GetSecs;
                                    if mouse == 0
                                        Eyelink('Message', num2str([1 0 xbinmod ybinmod]));
                                    end
                                elseif distractorColor == [255 0 0]
                                    SendEvent2([0 1 xbinmod],dio);
                                    SendEvent2([0 1 ybinmod],dio);
                                    edistractor(1,d) = GetSecs;
                                    if mouse == 0
                                        Eyelink('Message', num2str([0 1 xbinmod ybinmod]));
                                    end
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
                        if stim_sequence(d) == 1
                            fill(dist_X,dist_Y,targetColor_mod);
                        elseif stim_sequence(d) == 2
                            fill(dist_X,dist_Y,distractorColor_mod);
                        end
                        hold on
                        fill(eye_X,eye_Y,'b');
                        hold off
                        axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                        plotGridLines(numDivisionsGrid,squareArea,fromX,toX,fromY,toY)

                         title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',...
                num2str(blkincorrectTrial),'/',num2str(blkincompleteTrial),'  Total: ',num2str(totalcorrectTrial),'/',...
                num2str(totalincorrectTrial),'/',num2str(totalincompleteTrial), '  (' num2str(100*totalcorrectTrial/(totalincorrectTrial+totalcorrectTrial)) '%)',...
                '    Manual Reward = ',num2str(totalmanualreward_count)])
                        drawnow
                    else
                        if breakFixation == 0
                            breakFixation = GetSecs - timeSessionStarts;
                            blkincompleteTrial = blkincompleteTrial + 1;
                            totalincompleteTrial = totalincompleteTrial + 1;
                            if locations(locationsTrial(1),1) == 4 && locations(locationsTrial(1),2) == 4
                                %TODO: why are we still doing this?
                            else
                                whichTrial = whichTrial + 1;
                            end
                        end
                        inTask = 0;
                        break;
                    end
                end
            end
        end
        
        % PRE-RESPONSE PERIOD
        iteration = 0;
        
        if fixtime == 1
            diffnumDistractors = rangeDistractors(2) - numDistractors;
            distractor_stimblank_period = (maxinterSquareTime + mininterSquareTime)/2 + (maxsquareTimeON + minsquareTimeON)/2;
            delay = rand*(maxdelay-mindelay) + mindelay + diffnumDistractors * distractor_stimblank_period;
        elseif fixtime == 0
            delay = rand*(maxdelay-mindelay) + mindelay;
        end
        timeIniPreresponse = GetSecs;
        while GetSecs < (timeIniPreresponse + delay + (delay*(delayratio-1)*stimulation)) && inTask == 1

            iteration = iteration + 1;
            
            % Check for escape command
						dobreak = checkforkeys;
						if dobreak
							break
						end
            % Check for fixation. If not, abort trial
            if mouse == 0
                
                sample = Eyelink('NewestFloatSample');
                posX = round(sample.gx(eye_used+1));
                posY = round(sample.gy(eye_used+1));
                
            elseif mouse == 1
                [posX,posY,buttons] = GetMouse(window);
            end
            
            if posX > fixAreaRect(1) && posX < fixAreaRect(3) && posY > fixAreaRect(2) && posY < fixAreaRect(4)
                % Wait period
%                 if responsecontrastlevel ~= 0
%                     % Screen('FillRect', window,[(255-100)/(101-tarcontrastlevel)+100 (0-100)/(101-tarcontrastlevel)+100 (0-100)/(101-tarcontrastlevel)+100], cueSizeRect);
%                     Screen('FillRect', window,[((255-100)*responsecontrastlevel/100) + 100 ((0-100)*responsecontrastlevel/100) + 100  ((0-100)*responsecontrastlevel/100) + 100], cueSizeRect);
%                 end
                Screen('FillOval', window, fixcol, fixRect);
                if respond_center == 0
                    ScreenGridLines(window,numDivisionsGrid,squareArea,fromX,toX,fromY,toY,gridcontrast,backgroundColor)
                else
                    ScreenGridCenters(window,numDivisionsGrid,locations,squareArea, X_rect, Y_rect,normBoundsRect,fixcol);
                end
                % Screen('Flip', window);
                [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                
                if iteration == 1
                    vbldelay = VBLTimestamp;
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
                plotGridLines(numDivisionsGrid,squareArea,fromX,toX,fromY,toY)

                 title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',...
                num2str(blkincorrectTrial),'/',num2str(blkincompleteTrial),'  Total: ',num2str(totalcorrectTrial),'/',...
                num2str(totalincorrectTrial),'/',num2str(totalincompleteTrial), '  (' num2str(100*totalcorrectTrial/(totalincorrectTrial+totalcorrectTrial)) '%)',...
                '    Manual Reward = ',num2str(totalmanualreward_count)])
                drawnow
                
            else
                if breakFixation == 0
                    breakFixation = GetSecs - timeSessionStarts;
                    blkincompleteTrial = blkincompleteTrial + 1;
                    totalincompleteTrial = totalincompleteTrial + 1;
                    %FIXME:  this was only needed when the monkey refused to look down-right
                    if locations(locationsTrial(1),1) == 4 && locations(locationsTrial(1),2) == 4
                    else
                        whichTrial = whichTrial + 1;
                    end
                end
                inTask = 0;
                break;
            end
            
            if StimRef == 3 && stimprob ~= 0
                if GetSecs > timeIniPreresponse + Stimulation_onset && stimulation == 0
                    if rand < stimprob
                        SendEvent2([0 0 0 0 1 1 1 1],dio);
                        if mouse == 0
                            Eyelink('Message', num2str([0 0 0 0 1 1 1 1]));
                            Eyelink('Message', num2str([channel, Rate, first_pulseamp, second_pulseamp, first_pulseDur, second_pulseDur, interDur, numPulses]));
                        end
                        err = PS_StartStimAllChannels(1);
                    end
                    stimulation = 1;
                end
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
            
            % oldFontSize = Screen(window,'TextSize',300);                    
            iteration = iteration + 1;
            if GetSecs - timeIniResponse > (rangeRT(2)/1000 + (rangeRT(2)/1000*(RTratio-1)*stimulation))
                responded = 1;
                % continue;
            end
            
            % Check for escape command
						dobreak = checkforkeys;
						if dobreak
							break
						end
            % Check for correct response.
            if mouse == 0
                
                sample = Eyelink('NewestFloatSample');
                posX = round(sample.gx(eye_used+1));
                posY = round(sample.gy(eye_used+1));
                
            elseif mouse == 1
                [posX,posY,buttons] = GetMouse(window);
            end
            
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

                eyeRectOriginal = [0 0 eyesquareArea eyesquareArea];
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
            
            if posX > cueRectwithbuffer(1) && posX < cueRectwithbuffer(3) && posY > cueRectwithbuffer(2) && posY < cueRectwithbuffer(4)
                
                responded = 0;
                if timeReachTarget == inf
                    timeReachTarget = GetSecs;
                end
                
                if GetSecs - timeReachTarget > (timeOnTarget + (timeOnTarget*(timeOnTargetratio-1)*stimulation))
                    responded = 1;
                    reward = 1;
                    continue;

                    %%%%%%% reward %%%%%%%
                end
                % Wait period
                
                if responsecontrastlevel ~= 0
                    % Screen('FillRect', window, [(255-100)/(101-tarcontrastlevel)+100 (0-100)/(101-tarcontrastlevel)+100 (0-100)/(101-tarcontrastlevel)+100], cueSizeRect);
                    Screen('FillRect', window,[((255-100)*responsecontrastlevel/100) + 100 ((0-100)*responsecontrastlevel/100) + 100  ((0-100)*responsecontrastlevel/100) + 100], cueSizeRect);
                end
                
                if respond_center == 0
                    ScreenGridLines(window,numDivisionsGrid,squareArea,fromX,toX,fromY,toY,gridcontrast,backgroundColor)

                else
                    ScreenGridCenters(window,numDivisionsGrid,locations,squareArea, X_rect, Y_rect,normBoundsRect,fixcol);
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
                % Screen('Flip', window);
                [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                
                if iteration == 1
                    vblrespond = VBLTimestamp;
                    SendEvent2([0 0 0 0 0 1 0 1],dio);
                    erespond = GetSecs;
                    if mouse == 0
                        Eyelink('Message', num2str([0 0 0 0 0 1 0 1]));
                    end
                end

                eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
                
                fill(cue_Xwithbuffer,cue_Ywithbuffer,targetColor_mod);
                hold on
                fill(eye_X,eye_Y,'b');
                hold off
                axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                plotGridLines(numDivisionsGrid,squareArea,fromX,toX,fromY,toY)

                title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',...
                num2str(blkincorrectTrial),'/',num2str(blkincompleteTrial),'  Total: ',num2str(totalcorrectTrial),'/',...
                num2str(totalincorrectTrial),'/',num2str(totalincompleteTrial), '  (' num2str(100*totalcorrectTrial/(totalincorrectTrial+totalcorrectTrial)) '%)',...
                '    Manual Reward = ',num2str(totalmanualreward_count)])
                drawnow
            else
%                 if wrongTarget == 0 && startTask == 1 && timeReachTarget == inf
%                     wrongTarget = GetSecs - timeSessionStarts;
%                 end
                if responded == 0
                    wrongTarget = GetSecs - timeSessionStarts;
                end
                timeReachTarget = inf;
                % Wait period
                if responsecontrastlevel ~= 0
                    % Screen('FillRect', window, [(255-100)/(101-tarcontrastlevel)+100 (0-100)/(101-tarcontrastlevel)+100 (0-100)/(101-tarcontrastlevel)+100], cueSizeRect);
                    Screen('FillRect', window,[((255-100)*responsecontrastlevel/100) + 100 ((0-100)*responsecontrastlevel/100) + 100  ((0-100)*responsecontrastlevel/100) + 100], cueSizeRect);
                end
                
                if respond_center == 0
                    ScreenGridLines(window,numDivisionsGrid,squareArea,fromX,toX,fromY,toY,gridcontrast,backgroundColor)   
                else
                    ScreenGridCenters(window,numDivisionsGrid,locations,squareArea, X_rect, Y_rect,normBoundsRect,fixcol);
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
                % Screen('Flip', window);
                [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                
                if iteration == 1
                    vblrespond = VBLTimestamp;
                    SendEvent2([0 0 0 0 0 1 0 1],dio);
                    erespond = GetSecs;
                    if mouse == 0
                        Eyelink('Message', num2str([0 0 0 0 0 1 0 1]));
                    end
                end

                eyeRect = OffsetRect(eyeRectOriginal, posX, posY);
                eye_X = [eyeRect(1) eyeRect(1) eyeRect(3) eyeRect(3)];
                eye_Y = windowRect(4) - [eyeRect(2) eyeRect(4) eyeRect(4) eyeRect(2)];
                
                fill(cue_Xwithbuffer,cue_Ywithbuffer,targetColor_mod);
                hold on
                fill(eye_X,eye_Y,'b');
                hold off
                
                axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                plotGridLines(numDivisionsGrid,squareArea,fromX,toX,fromY,toY)

                title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',...
                num2str(blkincorrectTrial),'/',num2str(blkincompleteTrial),'  Total: ',num2str(totalcorrectTrial),'/',...
                num2str(totalincorrectTrial),'/',num2str(totalincompleteTrial), '  (' num2str(100*totalcorrectTrial/(totalincorrectTrial+totalcorrectTrial)) '%)',...
                '    Manual Reward = ',num2str(totalmanualreward_count)])
                drawnow
            end
            
            if StimRef == 4 && stimprob ~= 0
                if GetSecs > timeIniResponse + Stimulation_onset && stimulation == 0
                    if rand < stimprob
                        SendEvent2([0 0 0 0 1 1 1 1],dio);
                        if mouse == 0
                            Eyelink('Message', num2str([0 0 0 0 1 1 1 1]));
                            Eyelink('Message', num2str([channel, Rate, first_pulseamp, second_pulseamp, first_pulseDur, second_pulseDur, interDur, numPulses]));
                        end
                        err = PS_StartStimAllChannels(1);
                    end
                    stimulation = 1;
                end
            end
        end

%         %% PRESENT FEEDBACK FOR REWARDS
%         if inTask == 1
%             results.reward(trialsStarted,1) = reward;
%         end
        
        if manualreward == 0
            if reward == 1
                
                timeIniFeedback = GetSecs;
                
                iteration = 0;
                totalcorrectTrial = totalcorrectTrial + 1;
                maxcorrecttrials_count = maxcorrecttrials_count + 1;
                blkcorrectTrial = blkcorrectTrial + 1;
                whichTrial = whichTrial + 1;
                sessionstarted = 0;
                
                % Snd('Play',rewardbeep);
                % % SendEvent2([0 0 0 0 0 1 1 0]);
                
                while GetSecs - timeIniFeedback < feedbackTime
                    iteration = iteration + 1;
                    % Screen('FillOval', window, [0 0 255], fixRect);
                    if respond_center == 0
                        ScreenGridLines(window,numDivisionsGrid,squareArea,fromX,toX,fromY,toY,gridcontrast,backgroundColor)
                    else
                       ScreenGridCenters(window,numDivisionsGrid,locations,squareArea, X_rect, Y_rect,normBoundsRect,fixcol);
                    end
                    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                    
                    if iteration == 1
                        vblreward = VBLTimestamp;
                        SendEvent2([0 0 0 0 0 1 1 0],dio);
                        ereward = GetSecs;
                        if mouse == 0
                            Eyelink('Message', num2str([0 0 0 0 0 1 1 0]));
                        end
                        if rand<=rewardprob
                            usb_pulse(handle,rewardduration)
                            % DST_reward(rewardduration,AO)
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
                    fill(eye_X,eye_Y,'b');
                    hold off
                    axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                    plotGridLines(numDivisionsGrid,squareArea,fromX,toX,fromY,toY)

                     title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',...
                num2str(blkincorrectTrial),'/',num2str(blkincompleteTrial),'  Total: ',num2str(totalcorrectTrial),'/',...
                num2str(totalincorrectTrial),'/',num2str(totalincompleteTrial), '  (' num2str(100*totalcorrectTrial/(totalincorrectTrial+totalcorrectTrial)) '%)',...
                '    Manual Reward = ',num2str(totalmanualreward_count)])
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
                
                if breakFixation == 0 
                    totalincorrectTrial = totalincorrectTrial + 1;
                    blkincorrectTrial = blkincorrectTrial + 1;
                    
                    if locations(locationsTrial(1),1) == 4 && locations(locationsTrial(1),2) == 4
                        repeatederror_count = repeatederror_count +1;
                        if repeatederror_count == repeatederror_count_threshold
                            whichTrial = whichTrial + 1;
                            repeatederror_count = 0;
                        end
                    else
                        whichTrial = whichTrial + 1;
                        repeatederror_count = 0;
                    end
                    
                end
                % Snd('Play',failurebeep);
                % % SendEvent2([0 0 0 0 0 1 1 1]);
                
                timeIniFeedback = GetSecs;
                while GetSecs - timeIniFeedback < feedbackTime
                    iteration = iteration + 1;
                    % Screen('FillOval', window, fixcol, fixRect);
                    
                    if respond_center == 0
                        ScreenGridLines(window,numDivisionsGrid,squareArea,fromX,toX,fromY,toY,gridcontrast,backgroundColor)
                    else
                        ScreenGridCenters(window,numDivisionsGrid,locations,squareArea, X_rect, Y_rect,normBoundsRect,fixcol);
                    end
                    [X,Y] = RectCenter(windowRect);
                    % oldFontSize = Screen(window,'TextSize',800);
                    % Screen('DrawText', window, 'x', X-320, Y-650, [255 0 0]);
                    % Screen('FillOval', window, [255 0 0], fixRect);
                    [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                    
                    if iteration == 1
                        vblfail = VBLTimestamp;
                        SendEvent2([0 0 0 0 0 1 1 1],dio);
                        efail = GetSecs;
                        if mouse == 0
                            Eyelink('Message', num2str([0 0 0 0 0 1 1 1]));
                        end
                        Snd('Play',failurebeep);
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
                    
                    fill(fix_X,fix_Y,[1 0 0]);
                    hold on
                    fill(eye_X,eye_Y,'b');
                    hold off
                    axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                    plotGridLines(numDivisionsGrid,squareArea,fromX,toX,fromY,toY)

                     title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',...
                num2str(blkincorrectTrial),'/',num2str(blkincompleteTrial),'  Total: ',num2str(totalcorrectTrial),'/',...
                num2str(totalincorrectTrial),'/',num2str(totalincompleteTrial), '  (' num2str(100*totalcorrectTrial/(totalincorrectTrial+totalcorrectTrial)) '%)',...
                '    Manual Reward = ',num2str(totalmanualreward_count)])
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
            
            totalmanualreward_count = totalmanualreward_count + 1;
            
            while GetSecs - timeIniFeedback < feedbackTime
                iteration = iteration + 1;
                % Screen('FillOval', window, [0 0 255], fixRect);
                if respond_center == 0
                    ScreenGridLines(window,numDivisionsGrid,squareArea,fromX,toX,fromY,toY,gridcontrast,backgroundColor)
                else
                    ScreenGridCenters(window,numDivisionsGrid,locations,squareArea, X_rect, Y_rect,normBoundsRect,fixcol);
                end
                [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
                
                if iteration == 1
                    SendEvent2([0 0 0 0 1 0 0 0],dio);
                    if mouse == 0
                        Eyelink('Message', num2str([0 0 0 0 1 0 0 0]));
                    end
                    usb_pulse(handle,manualrewardduration)
                    Snd('Play',rewardbeep);
                    % DST_reward(manualrewardduration,AO)
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
                fill(eye_X,eye_Y,'b');
                hold off
                axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
                plotGridLines(numDivisionsGrid,squareArea,fromX,toX,fromY,toY)

                 title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',...
                num2str(blkincorrectTrial),'/',num2str(blkincompleteTrial),'  Total: ',num2str(totalcorrectTrial),'/',...
                num2str(totalincorrectTrial),'/',num2str(totalincompleteTrial), '  (' num2str(100*totalcorrectTrial/(totalincorrectTrial+totalcorrectTrial)) '%)',...
                '    Manual Reward = ',num2str(totalmanualreward_count)])
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
						dobreak = checkforkeys;
						if dobreak
							break
						end
            if respond_center == 0
                ScreenGridLines(window,numDivisionsGrid,squareArea,fromX,toX,fromY,toY,gridcontrast,backgroundColor)
            else
               ScreenGridCenters(window,numDivisionsGrid,locations,squareArea, X_rect, Y_rect,normBoundsRect,fixcol);
            end
            Screen('Flip', window);
            
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

            fill(eye_X,eye_Y,'b');
            axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
            plotGridLines(numDivisionsGrid,squareArea,fromX,toX,fromY,toY)

             title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',...
                num2str(blkincorrectTrial),'/',num2str(blkincompleteTrial),'  Total: ',num2str(totalcorrectTrial),'/',...
                num2str(totalincorrectTrial),'/',num2str(totalincompleteTrial), '  (' num2str(100*totalcorrectTrial/(totalincorrectTrial+totalcorrectTrial)) '%)',...
                '    Manual Reward = ',num2str(totalmanualreward_count)])
            drawnow
        end
        
%         if trialHasStarted == 1
%             results.breakFixation(trialsStarted) = breakFixation;
%             results.wrongTarget(trialsStarted) = wrongTarget;
%         end
        
        %% POST TRIAL INTERVAL
        ITI = rand*(maxITI-minITI) + minITI;
        timeIniPTI = GetSecs;
        while GetSecs - timeIniPTI < ITI

						dobreak = checkforkeys;
						if dobreak
							break;
						end
            
            if respond_center == 0
                ScreenGridLines(window,numDivisionsGrid,squareArea,fromX,toX,fromY,toY,gridcontrast,backgroundColor)
            else
               ScreenGridCenters(window,numDivisionsGrid,locations,squareArea, X_rect, Y_rect,normBoundsRect,fixcol);
            end
            Screen('Flip', window);
            
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
            
            fill(eye_X,eye_Y,'b');
            axis([windowRect(1),windowRect(3),windowRect(2),windowRect(4)])
            plotGridLines(numDivisionsGrid,squareArea,fromX,toX,fromY,toY)

             title(['Block ', num2str(ceil(whichTrial/numLocations)),'  Trial ', num2str(blTrial),'  Block: ',num2str(blkcorrectTrial),'/',...
                num2str(blkincorrectTrial),'/',num2str(blkincompleteTrial),'  Total: ',num2str(totalcorrectTrial),'/',...
                num2str(totalincorrectTrial),'/',num2str(totalincompleteTrial), '  (' num2str(100*totalcorrectTrial/(totalincorrectTrial+totalcorrectTrial)) '%)',...
                '    Manual Reward = ',num2str(totalmanualreward_count)])
            drawnow
        end
        SendEvent2([0 0 1 0 0 0 0 0],dio);
        if mouse == 0
            Eyelink('Message', num2str([0 0 1 0 0 0 0 0]));
        end
        
        if exist(trialcountfilename) %#ok<*EXIST>0
            old_result = load(trialcountfilename);
            correctTrial = totalcorrectTrial - old_result.totalcorrectTrial;
            incorrectTrial = totalincorrectTrial - old_result.totalincorrectTrial;
            incompleteTrial = totalincompleteTrial - old_result.totalincompleteTrial;
            manualreward_count = totalmanualreward_count - old_result.totalmanualreward_count;
        else
            correctTrial = totalcorrectTrial;
            incorrectTrial = totalincorrectTrial;
            incompleteTrial = totalincompleteTrial;
            manualreward_count = totalmanualreward_count;
        end
        save(filename,'results','correctTrial','incorrectTrial','incompleteTrial','manualreward_count')
        save(trialcountfilename,'totalcorrectTrial','totalincorrectTrial','totalincompleteTrial','totalmanualreward_count')
        if spacecount
            KbWait;
        end
        
        results.vblstarttrial(whichTrial) = vblstarttrial;
        results.vblprestim(whichTrial) = vblprestim;
        results.vbltarget(whichTrial) = vbltarget;
        results.vblblank(whichTrial,:) = vblblank;
        results.vbldistractor(whichTrial,:) = vbldistractor;
        results.vbldelay(whichTrial) = vbldelay;
        results.vblrespond(whichTrial) = vblrespond;
        results.vblreward(whichTrial) = vblreward;
        results.vblfail(whichTrial) = vblfail;

        results.estarttrial(whichTrial) = estarttrial;
        results.eprestim(whichTrial) = eprestim;
        results.etarget(whichTrial) = etarget;
        results.eblank(whichTrial,:) = eblank;
        results.edistractor(whichTrial,:) = edistractor;
        results.edelay(whichTrial) = edelay;
        results.erespond(whichTrial) = erespond;
        results.ereward(whichTrial) = ereward;
        results.efail(whichTrial) = efail;
        results.code_version = code_version;
        save(filename,'results')
    end
    
    Screen('CloseAll');
    %close the digital/analog objects
	clear dio
    %close stimulation object
    if stimprob ~= 0
        err = PS_StopStimAllChannels(1);
        err = PS_CloseStim(1);
    end
    %IOPort('CloseAll');
catch %#ok<CTCH>
    Screen('CloseAll');
    clear dio
    %close stimulation object
    if stimprob ~= 0
        err = PS_StopStimAllChannels(1);
        err = PS_CloseStim(1);
    end
    %IOPort('CloseAll');
    psychrethrow(psychlasterror);
end

close(h)
return

function ScreenGridLines(window,numDivisionsGrid,squareArea,fromX,toX,fromY,toY,gridcontrast,backgroundColor)

for linesX = 1:numDivisionsGrid(2)+1
    if mod(numDivisionsGrid(2),2) == 1
        Screen('DrawLine', window ,(-backgroundColor*(gridcontrast/100))+backgroundColor, fromX, fromY+squareArea*(linesX-1), toX, fromY+squareArea*(linesX-1) ,2);
    else
        if linesX ~= (numDivisionsGrid(2)+2)/2
            Screen('DrawLine', window ,(-backgroundColor*(gridcontrast/100))+backgroundColor, fromX, fromY+squareArea*(linesX-1), toX, fromY+squareArea*(linesX-1) ,2);
        else
            Screen('DrawLine', window ,(-backgroundColor*(gridcontrast/100))+backgroundColor, fromX, fromY+squareArea*(linesX-1), fromX+squareArea*(linesX-2), fromY+squareArea*(linesX-1) ,2);
            Screen('DrawLine', window ,(-backgroundColor*(gridcontrast/100))+backgroundColor, fromX+squareArea*(linesX), fromY+squareArea*(linesX-1), toX, fromY+squareArea*(linesX-1) ,2);
        end
    end
end
for linesY = 1:numDivisionsGrid(1)+1
    if mod(numDivisionsGrid(1),2) == 1
        Screen('DrawLine', window ,(-backgroundColor*(gridcontrast/100))+backgroundColor, fromX+squareArea*(linesY-1), fromY, fromX+squareArea*(linesY-1), toY ,2);
    else
        if linesY ~= (numDivisionsGrid(1)+2)/2
            Screen('DrawLine', window ,(-backgroundColor*(gridcontrast/100))+backgroundColor, fromX+squareArea*(linesY-1), fromY, fromX+squareArea*(linesY-1), toY ,2);
        else
            Screen('DrawLine', window ,(-backgroundColor*(gridcontrast/100))+backgroundColor, fromX+squareArea*(linesY-1), fromY, fromX+squareArea*(linesY-1), fromY+squareArea*(linesY-2) ,2);
            Screen('DrawLine', window ,(-backgroundColor*(gridcontrast/100))+backgroundColor, fromX+squareArea*(linesY-1), fromY+squareArea*(linesY), fromX+squareArea*(linesY-1), toY ,2);
        end
    end
end

function ScreenGridCenters(window,numDivisionsGrid,locations,squareArea,X_rect, Y_rect,normBoundsRect,fixcol)
    centerX = ceil(numDivisionsGrid(2)/2);
    centerY =  ceil(numDivisionsGrid(1)/2);
    for i = 1:size(locations,1)
        Xpos = locations(i,1);
        Ypos = locations(i,2);
        if ~((mod(numDivisionsGrid(2),2) == 0 && (Xpos == centerX || Xpos == centerX +1))&&( mod(numDivisionsGrid(1),2) == 0 && (Ypos == centerY || Ypos == centerY +1))) && ~((mod(numDivisionsGrid(2),2) == 1 && Xpos == centerX) && ( mod(numDivisionsGrid(1),2) == 1 && Ypos == centerY))
            XYRect = [X_rect(Xpos),Y_rect(Ypos),X_rect(Xpos)+squareArea,Y_rect(Ypos)+squareArea];
            [X,Y] = RectCenter(XYRect);
            Screen('DrawText', window, '+', X-round(normBoundsRect(3)/2), Y-round(normBoundsRect(4)/2), fixcol);
        end
    end

                
                
function plotGridLines(numDivisionsGrid,squareArea,fromX,toX,fromY,toY)

for linesX = 1:numDivisionsGrid(2)+1
    if mod(numDivisionsGrid(2),2) == 1
        line([fromX,toX],fromY+squareArea*(linesX-1)*[1,1],'Color','k')
    else
        if linesX ~= (numDivisionsGrid(2)+2)/2
            line([fromX,toX],fromY+squareArea*(linesX-1)*[1,1],'Color','k')
        else
            line([fromX,fromX*(linesX-2)],fromY+squareArea*(linesX-1)*[1,1],'Color','k')
            line([fromX*(linesX),toX],fromY+squareArea*(linesX-1)*[1,1],'Color','k')
        end
    end
end
for linesY = 1:numDivisionsGrid(1)+1
    if mod(numDivisionsGrid(1),2) == 1
        line(fromX+squareArea*(linesY-1)*[1,1],[fromY,toY],'Color','k')
    else
        if linesY ~= (numDivisionsGrid(1)+2)/2
            line(fromX+squareArea*(linesY-1)*[1,1],[fromY,toY],'Color','k')
        else
            line(fromX+squareArea*(linesY-1)*[1,1],[fromY,fromY+squareArea*(linesY-2)],'Color','k')
            line(fromX+squareArea*(linesY-1)*[1,1],[fromY+squareArea*(linesY),toY],'Color','k')
        end
    end
end

function dobreak = checkforkeys
	dobreak = 0;
	[ keyIsDown, seconds, keyCode ] = KbCheck;
	if keyIsDown
			if keyCode(escapeKey)
					save(filename,'results');
					continueTask = 0;
					inTask = 0;
					dobreak = 1;
			elseif keyCode(spaceKey)
					spacecount = spacecount + 1;
			elseif keyCode(rKey)
					manualreward = 1;
					dobreak = 1;
			end
	end
