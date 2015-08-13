function SendEvent(event,dio)

% Trigger
% (00000000) Start of Fixation period 
% (00000001) Start of Pre-Stimulus Period              
% (10000000) Start of Target Stimulus (24 locations)    
% (01000000) Start of Distractor Stimulus (24 locations) 
% the first 6 bins encode the information the 24 locations 
% 00 (000,000) (x,y)
% eg. (4,5) square is represented by (100,101), 
% so distractor stimulus at (4,5) will be represented by (01100101)

% (00000010) Start of Stimulus Blank period         
% (00000100) Start of Delay Period                                   
% (00001000) Start of Response Period                     
% (00010000) Start of Monkey Reaction 
% (00100000) Start of Reward (after the animal satisfy the response criteria) 

% in total 55 triggers, so only need 6 bits

rev_event = wrev(event);
% To check the support of your system, type
%daq = daqhwinfo('parallel');

% Create a Digital I/O Object with the digitalio function
%dio=digitalio('parallel','lpt1');

% Add lines to a Digital I/O Object

%jaddline(dio,0,2,'out');
%addline(dio,0:7,0,'out'); % add the hardware lines 0 until 7 from port 0 to the digital object dio

putvalue(dio,zeros(1,9)) 
putvalue(dio,[1 rev_event])

% Send data to the lines
%putvalue(dio,event) % send data '1' to line 1

%putvalue(dio,1) % send data '1' to line 1
