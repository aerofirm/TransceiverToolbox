function hRD = plugin_rd_rx
% Reference design definition

% Call the common reference design definition function
hRD = AnalogDevices.adrv9002.common.plugin_rd('ZCU102', 'Rx');
AnalogDevices.adrv9002.zcu102.add_io(hRD, 'Rx');
