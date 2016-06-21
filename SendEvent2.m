function SendEvent2(event,dio)
    %This function uses the dio object to send digitial events
    %dio should be created thusly:
    %cogent.io.ioObj = io32();
    %assumes that lpt3 is on address D010
    %address = hex2dec('D010')
    %first write the bits, i.e. the first 8 bit from the base address
    io32(dio.io.ioObj,53264,(2.^(7:-1:0))*event');
    %then write to the strobe, i.e. the first bit of the 3rd byte,
    WaitSecs(0.001);
    %note that this assumes low = true
    io32(dio.io.ioObj,53264+2,255);
   
    %wait for 5 ms
    WaitSecs(0.005);
    %set to zero
    io32(dio.io.ioObj,53264+2,0)
    io32(dio.io.ioObj,53264,0);
    
end
    