function eyeCalib(homeDir,results)
global handle
% Trigger
% (00000000) Start of Fixation period                 
% (00000110) Start of Reward Feedback
% (00000111) Start of Failure Feedback
% (00100000) End of Trial

KbName('UnifyKeyNames');

%%% Save parameters in Results file

GridCols = 3;
GridRows = 3;
waitsec = 2;
fixSize = results.parameters.fixSize;
eyeSize = 15;
imagesize = 100;
backgroundColor = [0 0 0];
blocknum = 1;
fix_threshold = 500;
numdatapoints = 3; % 240/75
order = 5;
displayImage = 0;
sampleRate = 240;
starteye = (800/1000)*sampleRate;
endeye = (400/1000)*sampleRate;
fixcol = results.parameters.fixcol;

imageMatrix = imread('banana.jpg');

eyesquareSize = 20;
eyeRectOriginal = [0 0 eyesquareSize eyesquareSize];

% Initialize variables.
daqreset;
adaptor = 'nidaq';
id = 'Dev2';
chanID = 1;
chanID2 = 3;

% Create and configure analog input object.
ai = analoginput(adaptor,id);
addchannel(ai,chanID);
addchannel(ai,chanID2);
set(ai, 'SampleRate', sampleRate);
set(ai, 'SamplesPerTrigger', Inf);

%%% Define filename
a = clock; a(1:3); % a = [year month day]
if ~exist([homeDir '/results_DST/'])
    mkdir([homeDir '/results_DST/']);
end
filename = [homeDir '/results_DST/ec_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '.mat'];
k = 1;
while exist(filename) %#ok<*EXIST>
    k = k + 1;
    filename = [homeDir '/results_DST/ec_' num2str(a(1)) '_' num2str(a(2)) '_' num2str(a(3)) '(' num2str(k) ').mat'];
end

start(ai)

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
    
    textureIndex=Screen('MakeTexture', window, imageMatrix);
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
    
    locations = round(locations);
    numLocations = size(locations,1);
    
    CenterOffset = [CenterX CenterY] - locations(ceil(numLocations/2),:);
    locations = locations + repmat(CenterOffset,numLocations,1);

    fixRectOriginal = [0 0 fixSize fixSize]; % rect for fixation spot
    eyeRectOriginal = [0 0 eyeSize eyeSize]; % rect for fixation spot
    imageRectOriginal = [0 0 imagesize imagesize]; % rect for fixation spot
    
    % Set keys.
    escapeKey = KbName('ESCAPE');
    enterKey1 = KbName('Return');
    bKey = KbName('B');
    leftKey = KbName('LeftArrow');

    enterKey = enterKey1(1);
    
    continueTask = 1;
    whichTrial = 1;
    eyevol = zeros(numLocations,2);
    newcoord = inf;
    newvel = inf;
    i = 0;
    vel = [];
    acc = [];
    mvcol = [];
    eyeRect = [];
    fixation = [];
    allcoord = [];
    fixationhorvol = [];
    fixationvervol = [];
    coords = [];
        
    iteration = 0;
    while continueTask == 1 && (whichTrial/numLocations) <= blocknum
        iteration = iteration + 1;
        currentblock = ceil(whichTrial/numLocations);
        spacecount = 0;

%         if mod(whichTrial,numLocations) == 1
%             fixlocationsIndexShuffled = randperm(numLocations);
%         end
        
        if mod(whichTrial,numLocations) ~= 0
            blTrial = mod(whichTrial,numLocations);
        else
            blTrial = numLocations;
        end
        
        posX = locations(blTrial,1);
        posY = locations(blTrial,2);

        if displayImage == 0
            fixRect = OffsetRect(fixRectOriginal, posX-fixSize/2, posY-fixSize/2);
            Screen('FillOval', window, fixcol, fixRect);
        elseif displayImage == 1
            imageRect = OffsetRect(imageRectOriginal, posX-imagesize/2, posY-imagesize/2);
            Screen('DrawTexture',window,textureIndex,[],imageRect);
        end
        
        if iteration == 1
            SendEvent([0 0 0 0 0 0 0 0]);
        end
        % determine saccade or fixation
        XY_vol = peekdata(ai,numdatapoints);
        X_vol = mean(XY_vol(:,1));
        Y_vol = mean(XY_vol(:,2));
        
        % [X_vol,Y_vol,buttons] = GetMouse(window); %#ok<*NASGU>

        coord = XY_vol;
        
        if size(coords,1) >= starteye
            coords = coords(end-(starteye-numdatapoints-1):end,:);
        end
        coords = [coords; coord];
        size(coords,1)

        if isinf(newcoord)
            oldcoord = coord;
            old_GetSecs = GetSecs;
        else
            oldcoord = newcoord;
            old_GetSecs = new_GetSecs;
        end
        newcoord = coord;
        new_GetSecs = GetSecs;
        allcoord = [allcoord; coord];
        
        dist = sqrt(sum((newcoord - oldcoord).^2));

        vel = [vel dist/(new_GetSecs-old_GetSecs)];
        
        if isinf(newvel)
            oldvel = vel(end);
        else
            oldvel = newvel;
        end
        newvel = vel(end);

        if length(vel) >= order
            if sum(vel(end-order+1:end) <= fix_threshold) == order
                fixation = [fixation 1];
                fixationhorvol = [fixationhorvol allcoord(end,1)];
                fixationvervol = [fixationvervol allcoord(end,2)];
            else
                fixation = [fixation 0];
            end
            vel = vel(end-order+2:end);
            allcoord = allcoord(end-order+1:end,:);
        else
            fixation = [fixation 0];
        end

        % acc = [acc (newvel - oldvel)/(new_GetSecs-old_GetSecs)];

        % saccade colour (red)
        saccol1 = [255 0 0];
        % fixation colour (blue)
        fixcol1 = [0 0 255];

        eyeRectOriginal = [0 0 eyesquareSize eyesquareSize];
        eye_xOffset = X_vol;
        eye_yOffset = Y_vol;
        eyeRect = [eyeRect; OffsetRect(eyeRectOriginal, eye_xOffset, eye_yOffset)];

        while i<size(eyeRect,1)
            i = i+1;
            if fixation(i) == 0
                mvcol = [mvcol; saccol1];
            else
                mvcol = [mvcol; fixcol1];
            end
            % Screen('FillOval', window, mvcol(i,:), eyeRect(i,:));
        end
        
        Screen('Flip', window);
        
        % need to compute saccade and fixation (using velocity and
        % acceleration)

%         if vel(end)<sac_threshold && length(vel) == 1
%             j = j+1;
%             fix_pos{j} = [];
%             fix_pos{j} = [fix_pos{j} newdist];
%         elseif vel(end)>=sac_threshold && length(vel) == 1
%         elseif vel(end)<sac_threshold && vel(end-1)<sac_threshold
%             fix_pos{j} = [fix_pos{j} newdist];
%         elseif vel(end)<sac_threshold && vel(end-1)>=sac_threshold
%             j = j+1;
%             fix_pos{j} = [];
%             fix_pos{j} = [fix_pos{j} newdist];
%         end

        [ keyIsDown, seconds, keyCode ] = KbCheck; %#ok<*ASGLU>
        if keyIsDown
            WaitSecs(0.2)
            if keyCode(escapeKey)
                continueTask = 0;
                break;
            elseif keyCode(enterKey)
%                 [clicks,x1,y1,whichButton] = GetClicks(window);
%                 if clicks
%                     spacecount = 1;
%                     reward = 1;
%                     save(['coords',num2str(whichTrial)],'coords');
%                 end
            elseif keyCode(bKey)
                Screen('Flip', window);
                WaitSecs(waitsec)
            elseif keyCode(leftKey)
                whichTrial = whichTrial - 1;
            end
        end
        
        [xx,yy,buttons,focus,valuators,valinfo] = GetMouse(window);
        if sum(buttons)
            spacecount = 1;
            reward = 1;
        end
        if spacecount

            % eyevol_temp{currentblock}(blTrial,:) = [X_vol Y_vol];
            eyevol_temp{currentblock}(blTrial,:) = mean(coords(1:endeye,:));
            save(['coords',num2str(whichTrial)],'coords');
            coords = [];
            
            eyeraw{blTrial} = XY_vol;
            whichTrial = whichTrial + 1;
            
            newdist = inf;
            newvel = inf;
            i = 0;
            vel = [];
            acc = [];
            mvcol = [];
            eyeRect = [];
            
            % Reward monkey
            DST_reward(2)
            SendEvent([0 0 0 0 0 1 1 0]);

        end
        
    end

    for x = 1:currentblock
        eyevol = eyevol + eyevol_temp{x};
    end
    eyevol = eyevol/currentblock;

    ec.eyevol = eyevol;
    ec.eyeraw = eyeraw;
    ec.GridCols = GridCols;
    ec.GridRows = GridRows;
    ec.CenterX = CenterX;
    ec.CenterY = CenterY;
    ec.Xsize = Xsize;
    ec.Ysize = Ysize;
    ec.fixhorvol = fixationhorvol;
    ec.fixvervol = fixationvervol;
    
    save(filename,'ec')

    max_xvol = max(eyevol(:,1));
    min_xvol = min(eyevol(:,1));
    range_xvol = max_xvol - min_xvol;
    max_yvol = max(eyevol(:,2));
    min_yvol = min(eyevol(:,2));
    range_yvol = max_yvol - min_yvol;
    
    continueTask = 1;
    while continueTask == 1
        
        for x = 1:length(fixationhorvol)
            
            posX = (fixationhorvol(x)-min_xvol) * (Xsize/range_xvol) + startx;
            posY = (fixationvervol(x)-min_yvol) * (Ysize/range_yvol) + starty;

            fixRect = OffsetRect(fixRectOriginal, round(posX), round(posY));
            % Screen('FillOval', window, [255 255 0], fixRect);
        end

        for x = 1:numLocations
            
            posX = (eyevol(x,1)-min_xvol) * (Xsize/range_xvol) + startx;
            posY = (eyevol(x,2)-min_yvol)* (Ysize/range_yvol) + starty;

            fixRect = OffsetRect(fixRectOriginal, posX, posY);
            Screen('FillOval', window, [255 0 0], fixRect);
        end
        
        Screen('Flip', window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck; %#ok<*ASGLU>
        if keyIsDown
            WaitSecs(0.2)
            if keyCode(escapeKey)
                continueTask = 0;
                break;
            end
        end 
    end

    continueTask = 1;
    index = 1;
    while continueTask == 1
        
%         for x = 1:numLocations
%             posX = locations(x,1);
%             posY = locations(x,2);
% 
%             fixRect = OffsetRect(fixRectOriginal, posX, posY);
%             Screen('FillOval', window, [255 255 0], fixRect);
%         end

            posX = locations(index,1);
            posY = locations(index,2);

            fixRect = OffsetRect(fixRectOriginal, posX, posY);
            Screen('FillOval', window, [255 255 0], fixRect);
        
        XY_vol = peekdata(ai,numdatapoints);
        X_vol = mean(XY_vol(:,1));
        Y_vol = mean(XY_vol(:,2));
        % [X_vol,Y_vol,buttons] = GetMouse(window); %#ok<*NASGU>
                 
        eyefilt = [X_vol,Y_vol];
        screencoords = Eyevol2Screen(eyefilt',ec.eyevol',ec.GridCols,ec.GridRows,...
					ec.CenterX,ec.CenterY,ec.Xsize,ec.Ysize);

        eyeRect = OffsetRect(eyeRectOriginal, screencoords(1), screencoords(2));
        Screen('FillOval', window, [255 0 0], eyeRect);

        Screen('Flip', window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck; %#ok<*ASGLU>
        if keyIsDown
            WaitSecs(0.2)
            if keyCode(escapeKey)
                continueTask = 0;
                break;
            elseif keyCode(enterKey)
                if index <9
                    index = index + 1;
                else
                    index = index + 1;                    
                    index = mod(index,9);
                end
            elseif keyCode(bKey)
                Screen('Flip', window);
                WaitSecs(waitsec)
            end
        end
        
    end

    Screen('CloseAll');
    
catch %#ok<CTCH>
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end
% Stop DAQ
stop(ai);

delete(ai);
daqreset;

return