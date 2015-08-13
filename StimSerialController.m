function errorCode = StimSerialController(serialPort, baudRate, enableStim, channel, pulseMag, pulseDur, numPulses, interDur)
    % Parameters:
    % serialPort = 'COM..'
    % baudRate = 2400
    % enableStim = 1(stimulate), 0(open port only)
    % channel = 0,1,2,3
    % pulseMag = 0 - 20 (mA)
    % pulseDur = 0 - 2.2 (ms)
    % numPulses = 0 - 1023
    % interDur = 1.3 - 4.2 (ms)
    %
    % Return:
    % -1, -2 : failed to open serial port
    % 1      : success

    persistent s;
    
    % create serial port for the first time
    if(isempty(s))
        fprintf('opening serial port for first time\n');
        OpenSerial(serialPort, baudRate);
    else
        % change serial port if it is different from existing
        if(strcmp(s.Port, serialPort) == 0)
            fprintf('%s != %s', s.Name, serialPort);
            EndSerial();
            fprintf('opening serial port: port changed\n');
            OpenSerial(serialPort, baudRate);
        end
    end
    
    % check status of port, if closed, return failed
    if(strcmp(s.Status,'closed') == 1)
        EndSerial();
        errorCode = -1;
    else
        errorCode = 1;
        % port is open, send
        % errorCode = 1 - success
        % errorCode = -1 - failed
        if(enableStim == 1)
            ConvertAndSendPacket(channel, pulseMag, pulseDur, numPulses, interDur);
        end
    end
    
    function OpenSerial(port, baud)
%         instrreset;
        s = serial(port);
        s.BaudRate = baud;
        s.TimeOut = 1;
        try
            fopen(s);
        catch
            errorCode = -1
        end
            
    end

    function EndSerial
        if(~isempty(s))
            fprintf('closing serial port\n');
            fclose(s);
            delete(s);
            s = [];
        end
    end

    function ConvertAndSendPacket(channel, pulseMag, pulseDur, numPulses, interDur)

        channel = channel * 16 + 8; %left shift by 4 bits
        pulseMag = mapToRange(pulseMag,[0,20],[0,255]);
        pulseDur = mapToRange(pulseDur,[0,2.2],[0,255]);
        numPulses = mapToRange(numPulses,[0,1023],[0,255]);
        interDur = mapToRange(interDur,[1.3,4.2],[0,255]);
        
        try
           fwrite(s, [uint8(170),uint8(85),uint8(channel),uint8(pulseMag),uint8(pulseDur),uint8(numPulses),uint8(interDur),uint8(0),uint8(0),uint8(0),uint8(0)]);   
            errorCode = 1;
        catch
           EndSerial();
           errorCode = -1;
        end
    end

end

function b = mapToRange(a, fromRange, toRange)
    if(a < fromRange(1)); a = fromRange(1); end
    if(a > fromRange(2)); a = fromRange(2); end
    b = toRange(1) + a * (toRange(2) - toRange(1)) / (fromRange(2)-fromRange(1));
end




