function [posX,posY] = vol2pix(X_vol,Y_vol,vol_range,windowRect)

posX = round((windowRect(3)/(vol_range(2)-vol_range(1)))*X_vol + windowRect(3)/2);
posY = round((windowRect(4)/(vol_range(2)-vol_range(1)))*Y_vol + windowRect(4)/2);
