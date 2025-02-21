function mdl = setportmapping(mode,ReferenceDesignName,board_name)

mdl = 'testModel';
numChannels = 2;
portWidthRX = 16;
portWidthTX = 16;

if mod(numChannels,2)~=0
    error('Channels must be multiple of 2');
end

if contains(lower(ReferenceDesignName),'936')
    dev = 'AD9361';
elseif contains(lower(ReferenceDesignName),'9002')
    dev = 'ADRV9002';
elseif contains(lower(ReferenceDesignName),'pluto')
    dev = 'AD9361';
    numChannels = 1;
elseif contains(lower(ReferenceDesignName),'fmcomms')
    dev = 'AD9361';
    if contains(lower(ReferenceDesignName),'fmcomms5')
        numChannels = 4;
    end
elseif contains(lower(ReferenceDesignName),'937')
    dev = 'AD9371';
    if contains(lower(board_name),'tx') || contains(lower(ReferenceDesignName),'tx')
        mdl = 'testModel_Tx32';
        portWidthTX = 32;
    end
    if contains(lower(board_name),'rx & tx') || contains(lower(ReferenceDesignName),'rx & tx')
        mdl = 'testModel_Rx16Tx32';
        portWidthTX = 32;
    end
elseif contains(lower(ReferenceDesignName),'9009')
    dev = 'ADRV9009';
    if contains(lower(board_name),'tx') || contains(lower(ReferenceDesignName),'tx')
        mdl = 'testModel_Tx32';
        portWidthTX = 32;
    end
    if contains(lower(board_name),'rx & tx') || contains(lower(ReferenceDesignName),'rx & tx')
        mdl = 'testModel_Rx16Tx32';
        portWidthTX = 32;
    end
else
    error('Unknown device');
end

load_system(mdl);


% First set all ports to NIS
for k=1:8
    hdlset_param([mdl,'/HDL_DUT/in',num2str(k)], 'IOInterface', 'No Interface Specified');
    hdlset_param([mdl,'/HDL_DUT/in',num2str(k)], 'IOInterfaceMapping', '');
    hdlset_param([mdl,'/HDL_DUT/out',num2str(k)], 'IOInterface', 'No Interface Specified');
    hdlset_param([mdl,'/HDL_DUT/out',num2str(k)], 'IOInterfaceMapping', '');
end

hdlset_param([mdl,'/HDL_DUT/validOut1'], 'IOInterface', 'No Interface Specified');
hdlset_param([mdl,'/HDL_DUT/validOut1'], 'IOInterfaceMapping', '');
hdlset_param([mdl,'/HDL_DUT/validIn1'], 'IOInterface', 'No Interface Specified');
hdlset_param([mdl,'/HDL_DUT/validIn1'], 'IOInterfaceMapping', '');
hdlset_param([mdl,'/HDL_DUT/validOut2'], 'IOInterface', 'No Interface Specified');
hdlset_param([mdl,'/HDL_DUT/validOut2'], 'IOInterfaceMapping', '');
hdlset_param([mdl,'/HDL_DUT/validIn2'], 'IOInterface', 'No Interface Specified');
hdlset_param([mdl,'/HDL_DUT/validIn2'], 'IOInterfaceMapping', '');

switch mode
    case 'tx'
        % Connect enables
        if ~strcmp(dev,'ADRV9002')
            hdlset_param([mdl,'/HDL_DUT/validOut1'], 'IOInterface', 'IP Load Tx Data OUT');
            hdlset_param([mdl,'/HDL_DUT/validOut1'], 'IOInterfaceMapping', '[0]');
        end
        hdlset_param([mdl,'/HDL_DUT/validIn1'], 'IOInterface', 'IP Valid Tx Data IN');
        hdlset_param([mdl,'/HDL_DUT/validIn1'], 'IOInterfaceMapping', '[0]');
        
        hdlset_param([mdl,'/HDL_DUT/in1'], 'IOInterface', ['IP Data 0 IN [0:',num2str(portWidthTX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in1'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in2'], 'IOInterface', ['IP Data 1 IN [0:',num2str(portWidthTX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in2'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out1'], 'IOInterface', [dev,' DAC Data I0 [0:',num2str(portWidthTX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out1'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out2'], 'IOInterface', [dev,' DAC Data Q0 [0:',num2str(portWidthTX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out2'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
        
        if numChannels==4
            hdlset_param([mdl,'/HDL_DUT/in3'], 'IOInterface', ['IP Data 2 IN [0:',num2str(portWidthTX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in3'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in4'], 'IOInterface', ['IP Data 3 IN [0:',num2str(portWidthTX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in4'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out3'], 'IOInterface', [dev,' DAC Data I1 [0:',num2str(portWidthTX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out3'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out4'], 'IOInterface', [dev,' DAC Data Q1 [0:',num2str(portWidthTX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out4'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
        end
        
    case 'rx'
        % Connect enables
        hdlset_param([mdl,'/HDL_DUT/validOut1'], 'IOInterface', 'IP Data Valid OUT');
        hdlset_param([mdl,'/HDL_DUT/validOut1'], 'IOInterfaceMapping', '[0]');
        hdlset_param([mdl,'/HDL_DUT/validIn1'], 'IOInterface', 'IP Valid Rx Data IN');
        hdlset_param([mdl,'/HDL_DUT/validIn1'], 'IOInterfaceMapping', '[0]');
        
        hdlset_param([mdl,'/HDL_DUT/in1'], 'IOInterface', [dev,' ADC Data I0 [0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in1'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in2'], 'IOInterface', [dev,' ADC Data Q0 [0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in2'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out1'], 'IOInterface', ['IP Data 0 OUT [0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out1'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out2'], 'IOInterface', ['IP Data 1 OUT [0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out2'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
        
        hdlset_param([mdl,'/HDL_DUT/in3'], 'IOInterface', [dev,' ADC Data I1 [0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in3'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in4'], 'IOInterface', [dev,' ADC Data Q1 [0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in4'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out3'], 'IOInterface', ['IP Data 2 OUT [0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out3'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out4'], 'IOInterface', ['IP Data 3 OUT [0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out4'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
        
        if numChannels==4
            hdlset_param([mdl,'/HDL_DUT/in5'], 'IOInterface', [dev,' ADC Data I2 [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in5'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in6'], 'IOInterface', [dev,' ADC Data Q2 [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in6'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out5'], 'IOInterface', ['IP Data 4 OUT [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out5'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out6'], 'IOInterface', ['IP Data 5 OUT [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out6'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            
            hdlset_param([mdl,'/HDL_DUT/in7'], 'IOInterface', [dev,' ADC Data I3 [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in7'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in8'], 'IOInterface', [dev,' ADC Data Q3 [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in8'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out7'], 'IOInterface', ['IP Data 6 OUT [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out7'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out8'], 'IOInterface', ['IP Data 7 OUT [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out8'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            
        end
    case 'rxtx'
        % Connect enables
        if ~strcmp(dev,'ADRV9002')
            hdlset_param([mdl,'/HDL_DUT/validOut1'], 'IOInterface', 'IP Load Tx Data OUT');
            hdlset_param([mdl,'/HDL_DUT/validOut1'], 'IOInterfaceMapping', '[0]');
        end
%         hdlset_param([mdl,'/HDL_DUT/validOut1'], 'IOInterface', 'IP Load Tx Data OUT');
%         hdlset_param([mdl,'/HDL_DUT/validOut1'], 'IOInterfaceMapping', '[0]');
        hdlset_param([mdl,'/HDL_DUT/validIn1'], 'IOInterface', 'IP Valid Tx Data IN');
        hdlset_param([mdl,'/HDL_DUT/validIn1'], 'IOInterfaceMapping', '[0]');
        hdlset_param([mdl,'/HDL_DUT/validOut2'], 'IOInterface', 'IP Data Valid OUT');
        hdlset_param([mdl,'/HDL_DUT/validOut2'], 'IOInterfaceMapping', '[0]');
        hdlset_param([mdl,'/HDL_DUT/validIn2'], 'IOInterface', 'IP Valid Rx Data IN');
        hdlset_param([mdl,'/HDL_DUT/validIn2'], 'IOInterfaceMapping', '[0]');
        
        % RX
        hdlset_param([mdl,'/HDL_DUT/in1'], 'IOInterface', [dev,' ADC Data I0 [0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in1'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in2'], 'IOInterface', [dev,' ADC Data Q0 [0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in2'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out1'], 'IOInterface', ['IP Data 0 OUT [0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out1'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out2'], 'IOInterface', ['IP Data 1 OUT [0:',num2str(portWidthRX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out2'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
        % TX
        hdlset_param([mdl,'/HDL_DUT/in3'], 'IOInterface', ['IP Data 0 IN [0:',num2str(portWidthTX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in3'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in4'], 'IOInterface', ['IP Data 1 IN [0:',num2str(portWidthTX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/in4'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out3'], 'IOInterface', [dev,' DAC Data I0 [0:',num2str(portWidthTX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out3'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out4'], 'IOInterface', [dev,' DAC Data Q0 [0:',num2str(portWidthTX-1),']']);
        hdlset_param([mdl,'/HDL_DUT/out4'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
        
        
        if numChannels==4
            hdlset_param([mdl,'/HDL_DUT/in5'], 'IOInterface', [dev,' ADC Data I1 [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in5'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in6'], 'IOInterface', [dev,' ADC Data Q1 [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in6'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out5'], 'IOInterface', ['IP Data 2 OUT [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out5'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out6'], 'IOInterface', ['IP Data 3 OUT [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out6'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            
            hdlset_param([mdl,'/HDL_DUT/in7'], 'IOInterface', ['IP Data 2 IN [0:',num2str(portWidthTX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in7'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in8'], 'IOInterface', ['IP Data 3 IN [0:',num2str(portWidthTX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in8'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out7'], 'IOInterface', [dev,' DAC Data I1 [0:',num2str(portWidthTX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out7'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out8'], 'IOInterface', [dev,' DAC Data Q1 [0:',num2str(portWidthTX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out8'], 'IOInterfaceMapping', ['[0:',num2str(portWidthTX-1),']']);
            
            hdlset_param([mdl,'/HDL_DUT/in5'], 'IOInterface', [dev,' ADC Data I2 [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in5'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in6'], 'IOInterface', [dev,' ADC Data Q2 [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in6'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out5'], 'IOInterface', ['IP Data 4 OUT [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out5'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out6'], 'IOInterface', ['IP Data 5 OUT [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out6'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            
            hdlset_param([mdl,'/HDL_DUT/in7'], 'IOInterface', [dev,' ADC Data I3 [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in7'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in8'], 'IOInterface', [dev,' ADC Data Q3 [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/in8'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out7'], 'IOInterface', ['IP Data 6 OUT [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out7'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out8'], 'IOInterface', ['IP Data 7 OUT [0:',num2str(portWidthRX-1),']']);
            hdlset_param([mdl,'/HDL_DUT/out8'], 'IOInterfaceMapping', ['[0:',num2str(portWidthRX-1),']']);
            
        end
        
    otherwise
        error('Unknown mode');
end
