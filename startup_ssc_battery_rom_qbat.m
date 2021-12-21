% Startup file for ssc_battery_rom_qbat

% Move to folder where this file is saved
cd(fileparts(which(mfilename)))

% Set up path
addpath(pwd)
addpath(genpath([pwd filesep 'ROM']));
addpath(genpath([pwd filesep 'Images']));
addpath([pwd filesep 'Scripts_Data']);

% Load parameters
ssc_battery_rom_qbat_param;

% Open model
open_system('ssc_battery_rom_qbat');
    