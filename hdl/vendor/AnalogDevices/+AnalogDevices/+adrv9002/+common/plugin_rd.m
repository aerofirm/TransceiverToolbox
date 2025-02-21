function hRD = plugin_rd(board, design)
% Reference design definition

% Construct reference design object
hRD = hdlcoder.ReferenceDesign('SynthesisTool', 'Xilinx Vivado');

% This is the base reference design that other RDs can build upon
hRD.ReferenceDesignName = sprintf('ADRV9002 %s (%s)', upper(board), upper(design));

% Determine the board name based on the design
hRD.BoardName = sprintf('AnalogDevices ADRV9002 %s', upper(board));

% Tool information
hRD.SupportedToolVersion = {'2019.1'};

% Get the root directory
rootDir = fileparts(strtok(mfilename('fullpath'), '+'));

% Design files are shared
hRD.SharedRD = true;
hRD.SharedRDFolder = fullfile(rootDir, 'vivado');

%% Add custom design files
% add custom Vivado design
hRD.addCustomVivadoDesign( ...
	'CustomBlockDesignTcl', fullfile('projects', 'adrv9001', lower(board), 'system_project_rxtx.tcl'), ...
	'CustomTopLevelHDL',    fullfile('projects', 'adrv9001', lower(board), 'system_top.v'));

hRD.BlockDesignName = 'system';	
	
% custom constraint files
hRD.CustomConstraints = {...
    fullfile('projects', 'adrv9001', lower(board), 'system_constr.xdc'), ...
    fullfile('projects', 'common', lower(board), sprintf('%s_system_constr.xdc', lower(board))), ...
    };

% custom source files
hRD.CustomFiles = {...
    fullfile('projects')...,
	fullfile('library')...,
    };

hRD.addParameter( ...
    'ParameterID',   'ref_design', ...
    'DisplayName',   'Reference Type', ...
    'DefaultValue',  design);

hRD.addParameter( ...
    'ParameterID',   'fpga_board', ...
    'DisplayName',   'FPGA Boad', ...
    'DefaultValue',  upper(board));

	
%% Add interfaces
% add clock interface
% hRD.addClockInterface( ...
%     'ClockConnection',   'axi_adrv9001/dac_1_clk', ...
%     'ResetConnection',   'axi_adrv9001/dac_1_rst');

hRD.addClockInterface( ...
    'ClockConnection',   'sys_ps8/pl_clk0', ...
    'ResetConnection',   'sys_rstgen/peripheral_aresetn');
	
