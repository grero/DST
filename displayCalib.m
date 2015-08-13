function displayCalib(eyecoilcoords,GridCols,GridRows,CenterX,CenterY,Xsize,Ysize)
%function X_adj  = nptEyecoil2Screen(data,eyecoilcoords,GridCols,GridRows,CenterY,CenterX,Xsize,Ysize)
%
%This program translates filtered and subsampled eyecoil data files into 
%screen coordinates.  eyecoilcoords are the average pixel locations of the eye 
%calibration grid obtained from possibly multiple .dxy files with the same 
%parameters.  2d interpolation is used to transform the coordinate systems.
%
%vertical data is channel 1
%horizontal data is channel 2
%
%revised 8/6/01


eyex=reshape(eyecoilcoords(1,:),GridCols(1),GridRows(1));
eyey=reshape(eyecoilcoords(2,:),GridCols(1),GridRows(1));

starty = CenterY(1) - Ysize(1)/2;
startx = CenterX(1) - Xsize(1)/2;
xincrement = Xsize(1)/(GridCols(1) - 1);
yincrement = Ysize(1)/(GridRows(1) - 1);

[screenx screeny] = meshgrid(startx+xincrement*[0:(GridCols(1)-1)],starty+yincrement*[0:(GridRows(1)-1)]);

%we should throw away all channels that are not eye data
hchan=1;
vchan=2;

% show mapping
figure
clf
plot(screenx(:),screeny(:),'+');
hold on
plot(griddata(eyex, eyey, screenx, eyecoilcoords(hchan,:), eyecoilcoords(vchan,:),'linear'),...
    griddata(eyex, eyey, screeny, eyecoilcoords(hchan,:), eyecoilcoords(vchan,:),'linear'),'ro');
max_eye=max(eyecoilcoords,[],2);
min_eye=min(eyecoilcoords,[],2);
eyerange=max_eye-min_eye;
[eyegridx eyegridy]=meshgrid(min_eye(hchan):eyerange(hchan)/25:max_eye(hchan),...
    min_eye(vchan):eyerange(vchan)/25:max_eye(vchan));
plot(griddata(eyex, eyey, screenx, eyegridx, eyegridy,'linear'),...
    griddata(eyex, eyey, screeny, eyegridx, eyegridy,'linear'),'r');
plot(griddata(eyex, eyey, screenx, eyegridx, eyegridy,'linear')',...
    griddata(eyex, eyey, screeny, eyegridx, eyegridy,'linear')','r');
drawnow
hold off

