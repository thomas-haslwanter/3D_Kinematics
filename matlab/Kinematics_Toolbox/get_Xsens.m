%% get_Xsens
% Read data from Xsens motion trackers.
%
% Read in orientation data from measurement files (*.txt) with recorded
% data of Xsens MTx motion trackers.
%
%% Syntax
%    data = get_Xsens(inFile, rate);
%
%% Input Arguments
% * inFile -- Path and name of data file
% * rate -- Sample rate of recorded measurements
% 
%% Output Arguments
% * data-- raw and processed data [MATLAB-structure]
% 

% ----------------------
% ver:      0.3
% date:     Aug-2017
% authors:  ThH, Robert Kiechl

function data = get_Xsens(inFile, rate)

curr_dir = pwd;
% Check input arguments
% Check input file with measurement data
if (nargin==0) || (~ischar(inFile)) || (exist(inFile,'file')~=2)
	[filename,pathname] = uigetfile('*.txt','Select text-file with measurement data of Xsens motion trackers');
    if filename == 0
        disp('No input file selected');
        data = [];
        return;
    end
    inFile = fullfile(pathname,filename);
end
% Set sample rate if not defined
if (nargin<2) || (~isnumeric(rate))
    rate = input('Specify sample rate of recorded measurements: ');
end
if (isempty(rate)) || (rate==0) || (~isnumeric(rate))
	rate = 50;
	disp(['Sample rate set to ', num2str(rate),' Hz']);
end

% info_file = which('mat_inf');
% raw_dir = extract(info_file, 'raw_data_dir', '=');
% data_dir = extract(info_file, 'data_dir', '=');
% cd(raw_dir);

% Read in file with recorded measurement data
inData = importdata(inFile);
column_info = inData.textdata(end,:);
inData.colheaders = strsplit(column_info{1});
data.info = inData.colheaders;
data.rate = rate;
for read_idx = 1:length(inData.data(1,:))
	column = data.info{1,read_idx};
	switch column
        case 'Counter'
            time = inData.data(:,read_idx);
            data.time = (time - time(1))/rate;
        case 'Acc_X'
            data.acc(:,1) = inData.data(:,read_idx);
        case 'Acc_Y'
            data.acc(:,2) = inData.data(:,read_idx);
        case 'Acc_Z'
            data.acc(:,3) = inData.data(:,read_idx);
        case 'Gyr_X'
            data.omega(:,1) = inData.data(:,read_idx);
        case 'Gyr_Y'
            data.omega(:,2) = inData.data(:,read_idx);
        case 'Gyr_Z'
            data.omega(:,3) = inData.data(:,read_idx);
        case 'Mag_X'
            data.mag(:,1) = inData.data(:,read_idx);
        case 'Mag_Y'
            data.mag(:,2) = inData.data(:,read_idx);
        case 'Mag_Z'
            data.mag(:,3) = inData.data(:,read_idx);
        case 'Roll'
            data.angles(:,1) = inData.data(:,read_idx);
        case 'Pitch'
            data.angles(:,2) = inData.data(:,read_idx);
        case 'Yaw'
            data.angles(:,3) = inData.data(:,read_idx);
        case 'Quat_w'
            data.quats(:,1) = inData.data(:,read_idx);            
        case 'Quat_x'
            data.quats(:,2) = inData.data(:,read_idx);            
        case 'Quat_y'
            data.quats(:,3) = inData.data(:,read_idx);            
        case 'Quat_z'
            data.quats(:,4) = inData.data(:,read_idx);
	end
end
data.totalSamples = size(data.omega, 1);

cd(curr_dir);
end
