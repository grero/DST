function DST_reward(varargin)

if nargin == 1
    duration = 0.15;
    AO = varargin{1};
elseif nargin == 2
    duration = varargin{1};
    AO = varargin{2};
end

% Obtain the actual rate set in case hardware limitations  
% prevent using the requested rate
ActualRate = get(AO,'SampleRate');

% Specify one second as the output time. 
% Use that to calculate the length of data

len = ActualRate*duration;

% Calculate the output signal based on the length of the data
data = 5*ones(len,1); data(1)=0; data(end)=0;
% data = sin(linspace(0,2*pi*500,80))';
% plot(data)
% All queued data is output once then repeated 4 times, 
% for a total of 5 times
% set(AO,'RepeatOutput',numPulses-1);
set(AO, 'TriggerType', 'Immediate');

% Queue the output data twice
putdata(AO,data)

%%% Output data ? Start AO and wait for the device object to stop running.
waitTime = duration+1.5;%numPulses*0.001 + 1;
start(AO)
wait(AO,waitTime)


