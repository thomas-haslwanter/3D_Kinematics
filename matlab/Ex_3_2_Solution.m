% Exercise 3.2: Calculate the trajectory of an observed particle, when
% location and orientation of the observer are changing.
% The velocities correspond to particle velocities in a central potential.

% Author: Thomas Haslwanter, Date: Jan-2019

shift = [0, 100, -50];
rotation = 34;   % [deg;


% Get the data
inFile = 'planet_trajectory_2d.txt';
data = load(inFile);

% Calculate the 3D trajectory
zData = -data(:,2)*tan(deg2rad(30));
data3D = [data,zData];
data3D(:,3) = data3D(:,3) - 200;

% Calculate and plot the 3-D velocity;
window_length = 61;
polyorder = 3;
deriv = 1;
delta = 0.1;
rate = 1/delta;
vel3D = savgol(data3D, polyorder, window_length, deriv, rate);

% Show the data
plot( vel3D(:,1), vel3D(:,2) );
axis('equal');
title('x/y Velocity');
xlabel('x');
ylabel('y');
shg
disp('Hit any key to continue ...');
pause

% Just to show how to elegantly create 3 subplots
for ii = 1:3
    subplot(3,1,ii);
    plot(vel3D(:,ii));
    ylabel(['axis_' num2str(ii)]);
end
xlabel('Time [pts]');
subplot(311)
title('Velocities');
shg
disp('Hit any key to continue ...');
pause

% Shift the location of the camera
data_shifted = data3D - shift;

% Rotate the orientation of the camera
data_shiftRot = (R('x', rotation) * data_shifted')';

% Plot the shifted and rotated trajectory
outFile = 'shifted_rotated.jpg';

close('all');
plot(data_shiftRot(:,1), data_shiftRot(:,2));
axis('equal');
line(xlim, [0,0],'LineStyle', '--');
line([0,0],ylim, 'LineStyle', '--');
xlabel('x');
ylabel('y');
title('Shifted & Rotated');

print('-djpeg90', outFile)
disp(['Data saved to ' outFile]);

