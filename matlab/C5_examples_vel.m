%% C5_examples_quat
% Script showing work with angular velocities.

% Ver 1.0
% author: ThH
% date: Aug-2017

% Camera Looking 10 deg down, and rotating with 100 deg/s about an earth-vertical axis
% for 5 sec, sample-rate 100 Hz

% Paramters
down = deg2rad(10);       % deg
duration = 10;    % sec
rate = 100;      % Hz

% Setup
q_start = [0, sin(down/2), 0];
dt = 1/rate;
t = 0:dt:duration;
omega = repmat([0, 0, deg2rad(100)], length(t), 1); 

% Orientation calculation
q_moving = calc_quat(omega, q_start, rate, 'sf');

% Visualization
subplot(1,2,1);
plot(t, q_vector(q_moving));
xlabel('Time [sec]');
ylabel('Orientation [quat]');
title('Rotation about g, with 100 deg/s');

% Note that even for this simple arrangement, the camera-orientation 
% in space is far from simple to see!!

% And back from orientation to velocity
omega_recalc = calc_angvel(q_moving, rate, 15, 2);

subplot(1,2,2);
plot(t, rad2deg(omega_recalc));
xlabel('Time [sec]');
ylabel('Angular Velocity [deg/s]');
title('Back-transformation');
shg
