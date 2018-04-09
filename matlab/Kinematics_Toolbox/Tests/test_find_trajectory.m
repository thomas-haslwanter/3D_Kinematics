% test_find_trajectory
%
% ver:      0.1
% author:   ThH
% date:     Aug-2017
%*********************************************************

clear all; close all;

t = 0:0.1:10;
trans = [1 1 0];
translation = t' * trans;

M(1,:) = [0, 0, 0];
M(2,:) = [1, 0, 0];
M(3,:) = [1, 1, 0];
M = M - repmat(mean(M), 3, 1);

q = [zeros(2, length(t)); deg2quat(100*t')']';

M1 = rotate_vector(M(1,:), q) + translation;
M2 = rotate_vector(M(2,:), q) + translation;
M3 = rotate_vector(M(3,:), q) + translation;

data = [M1, M2, M3];
[pos, ori] = analyze_3Dmarkers(data, data(1,:));
r0 = [1,2,3];
movement = find_trajectory(r0, pos, ori);

plot(movement)
xlabel('Time [sec]')
ylabel('Position')
legend('x', 'y', 'z')