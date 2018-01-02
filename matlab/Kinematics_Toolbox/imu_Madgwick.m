%% Madgwick
%  Calculation of quaternions from IMU-data, based on the Madgwick algrorithm
%
%% Syntax
%    q_out = imu_Madgwick(rate, acc, omega, mag, beta) 
%
%% Input Arguments
% * rate -- Sample rate [Hz]	
% * acc -- 3D linear acceleration [m/sec^2]
% * omega -- 3D angular velocity [rad/sec]
% * mag -- 3D magnetic field orientation
% * beta -- Parameter for Madgwick-algorithm (default=0.1)
% 
%% Output Arguments
% * q_Out -- unit quaternion, describing the orientation relativ to the coordinate
%        system spanned by the local magnetic field, and gravity
% 
%% Notes
% This function is based on the code of SOH Madwick, from 06-11-2012.
%
% The test-file "ExampleData.mat" is also from SOH Madwick, and contains
% calibrated omega, acc and mag data logged from an AHRS device (x-IMU)
% while it was sequentially rotated from 0 degrees, to +90 degree and then
% to -90 degrees around the X, Y and Z axis.  The script first plots the
% example sensor data, then processes the data through the algorithm and
% plots the output as Euler angles.
%
% Note that the corresponding Euler angle (variabler "euler" in 
% "ExampleData.mat") show erratic behaviour in phi and psi
% when theta approaches ±90 degrees. This due to a singularity in the Euler
% angle sequence known as 'Gimbal lock'.  This issue does not exist for a
% quaternion or rotation matrix representation.
%
%% Example
%    in_file = 'data\ExampleData_Madgwick.mat';
%    rate = rate = 1/median(diff(time));
%    q_Madgwick = imu_Madgwick(rate, Accelerometer, Gyroscope*pi/180, Magnetometer);
%

% ------------------
% ver:      0.2
% date:     Aug-2017
% authors: Seb OH Madgwick, ThH

function q_out = imu_Madgwick(rate, acc, omega, mag, beta)

if nargin == 4
    beta = 0.1;     % default value
end

num_data = size(acc, 1);
% addpath('QuatLib_Madgwick');      % include quaternion library

%% Process sensor data through algorithm

AHRS = MadgwickAHRS('SamplePeriod', 1/rate, 'Beta', beta);

q_out = zeros(num_data, 4);
for t = 1:num_data
    AHRS.Update(omega(t,:), acc(t,:), mag(t,:));	% omega units must be radians
    q_out(t, :) = AHRS.Quaternion;
end
