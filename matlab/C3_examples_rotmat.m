%% C3_examples_rotmat
% Script for working with rotation matrices.

% Ver 1.0
% author: ThH
% date: Aug-2017

% Simple rotation by 30 deg about the x-axis
Rx_30 = R(1, 30)

% Rotation matrix for aeronautic sequence
R_aero = R_s(3, 'theta') * R_s(2, 'phi') * R_s(1, 'psi')

% Rotation matrix for Euler sequence ...
alpha = 45;
beta = 30;
gamma = 20;
rot_mat = R(3,gamma) * R(1, beta) * R(3, alpha)

% ... and the back-transformation
sequence(rot_mat, 'aero')

% Check if it is correct:
euler = sequence(rot_mat, 'Euler')*180/pi
