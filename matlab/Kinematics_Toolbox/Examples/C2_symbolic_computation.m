%% C2_symbolic_computation
% Script to demonstrate of symbolic computations.
%

% Ver 1.0
% author: ThH
% date: Aug-2017


% Define symbolic rotation matrices
Rx = R_s(1, 'psi');
Ry = R_s(2, 'phi');
Rz = R_s(3, 'theta');

% Calculate the rotation matrix for the nautical sequence
R_nautical = Rz * Ry * Rx

% Result
% ------
% R_nautical =
% [ cos(phi)*cos(theta), cos(theta)*sin(phi)*sin(psi) - cos(psi)*sin(theta), sin(psi)*sin(theta) + cos(psi)*cos(theta)*sin(phi)]
% [ cos(phi)*sin(theta), cos(psi)*cos(theta) + sin(phi)*sin(psi)*sin(theta), cos(psi)*sin(phi)*sin(theta) - cos(theta)*sin(psi)]
% [           -sin(phi),                                  cos(phi)*sin(psi),                                  cos(phi)*cos(psi)]
