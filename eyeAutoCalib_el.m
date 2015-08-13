function eyeAutoCalib_el(homeDir,results)

% Trigger
% (00000000) Start of Fixation period
% (00000110) Start of Reward Feedback
% (00000111) Start of Failure Feedback
% (00001000) Start of manual Reward Feedback
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
rewardduration = results.parameters.rewardduration;
backgroundColor = results.parameters.backgroundColor;
numdatapoints = 3;
% eyefile = results.parameters.eyedatafile;
reward_pos = [];
reward_XY = [];
GridCols = 3;
GridRows = 3;
displayImage = 0;
fixcol = results.parameters.fixcol;
mouse = results.parameters.mouse;
monkeyname = results.parameters.monkeyname;
blocknum = results.parameters.blocknum;

eyesquareSize = 10;
eyeRectOriginal = [0 0 eyesquareSize eyesquareSize];


if mouse == 0
    %run eyelink calibration
    initAndCal_DST(monkeyname,rewardduration,fixcol);
    Screen('CloseAll');
    
    %Start Recording
%     Eyelink('Command', 'set_idle_mode');
%     WaitSecs(0.05);
%     Eyelink('StartRecording', 1, 1, 1, 1);
                
end