function rect=EyelinkDrawCalTarget_DST(el, x, y)

% draw simple calibration target
%
% USAGE: rect=EyelinkDrawCalTarget(el, x, y)
%
%		el: eyelink default values
%		x,y: position at which it should be drawn
%		rect: 

% simple, standard eyelink version
%   22-06-06    fwc OSX-ed

fixcol = [255 255 255];
[width, height]=Screen('WindowSize', el.window);
size=round(el.calibrationtargetsize/100*width);

rect=CenterRectOnPoint([0 0 size size], x, y);
Screen( 'FillOval', el.window, fixcol,  rect );
Screen( 'Flip',  el.window);
