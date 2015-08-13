function errorCode = StimSerialController(serialPort, channel, pulseMag, pulseDur, numPulses, interDur)
    % Parameters:
    % channel = 0,1,2,3
    % pulseMag = 0 - 20 (mA)
    % pulseDur = 0 - 2.2 (ms)
    % numPulses = 0 - 1023
    % interDur = 1.3 - 4.2 (ms)
    %
    % Return:
    % -1, -2 : failed to open serial port
    % 1      : success

    global s;
    
    % create serial port for the first time
    if(isempty(s))
        OpenSerial(serialPort, 9600);
    else
        % change serial port if it is different from existing
        if(strcmp(s.Name, serialPort) == 0)
            EndSerial();
            OpenSerial(serialPort, 2400);
        end
    end
    
    % check status of port, if closed, return failed
    if(strcmp(s.Status,'closed') == 1)
        EndSerial();
        errorCode = -1;
    else
        % port is open, send
        ConvertAndSendPacket(channel, pulseMag, pulseDur, numPulses, interDur);
        errorCode = 1;
    end
end

function OpenSerial(port, baud)
    global s;
    s = serial(port);
    s.BaudRate = baud;
    fopen(s);
end

function EndSerial
    global s;
    if(~isempty(s))
        fclose(s);
        delete(s);
        s = []; 
    end
end

function ConvertAndSendPacket(channel, pulseMag, pulseDur, numPulses, interDur)
    global s;
    channel = channel * 8; %left shift by 4 bits
    pulseMag = mapToRange(pulseMag,[0,20],[0,255]);
    pulseDur = mapToRange(pulseDur,[0,2.2],[0,255]);
    numPulses = mapToRange(numPulses,[0,1023],[0,255]);
    interDur = mapToRange(interDur,[1.3,4.2],[0,255]);
    fwrite(s, [uint8(170),uint8(85),uint8(channel),uint8(pulseMag),uint8(pulseDur),uint8(numPulses),uint8(interDur),uint8(0),uint8(0),uint8(0),uint8(0)]);
end

function b = mapToRange(a, fromRange, toRange)
    if(a < fromRange(1)); a = fromRange(1); end
    if(a > fromRange(2)); a = fromRange(2); end
    b = toRange(1) + a * (toRange(2) - toRange(1)) / (fromRange(2)-fromRange(1));
end




