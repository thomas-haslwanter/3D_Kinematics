% Exercise 6.1: Simulation of a "simple" pendulum.
% This is not as simple as it looks. The signs are a bugger (force vs
% acceleration, up vs down, orientation of coordinate system). Also, I was
% surprised how quickly one gets artefacts in the reconstruction:
% already with a sample rate of 1 kHz, artefacts sneak in!


% Author: Thomas Haslwanter, Date: Jan-2019

function Ex_6_2_Solution()
%Main function

pendulum = 0.20;  % [m]
[sim_data, sample_rate] = generate_data(pendulum);

% Get the data: this is just to show how such data can be read in again
% data = pd.io.parsers.read_table(outFile, skipinitialspace=True)

% From the measured data, reconstruct the movement:
% First, find the sampling rate from the time
[phi_calc, pos_calc] = reconstruct_movement(sim_data.omega, ...
    sim_data.gifReBody, ...
    pendulum, sample_rate);

% Show the results - this should be a smooth oscillation
show_data(sim_data, phi_calc, pos_calc, pendulum);
end



function [sim_data, sample_rate] = generate_data(length_pendulum)
% Simulate a pendulum in 2D, and write the data to an out-file.
%
% Parameters
% ----------
% length_pendulum : float
%     Length of the pendulum [m]
%
% Returns
% -------
% sim_data : Matlab structure
%     Contains 'time', 'phi', 'omega', 'gifBHor', 'gifBVer'
% rate : float
%     Sampling rate [Hz]
%
% Notes
% -----
% The equation of motion is
%
% \frac{d^2 \phi}{dt^2} = -\frac{g}{l} \sin(phi)

tMax = 2;      % duration of simulation [sec]
sample_rate = 10000  % sampling rate [Hz]
g = 9.81;      % [m/s^2]

dt = 1 / sample_rate;
time = 0:dt:tMax;

acc_func = @(alpha) -g/length_pendulum * sin(alpha);

% Memory allocation
omega = nan(length(time));
phi   = nan(length(time));

% Initial conditions
phi = 0.1;  % rad
omega = 0;  % rad/s
tStatic = 0.1;  % initial static setup [sec]

% Numerical integration
for ii = 1:(length(time)-1)
    phi(ii + 1) = phi(ii) + omega(ii) * dt;
    if time(ii) < tStatic  % static initial condition
        omega(ii + 1) = 0;
    else
        % Euler-Cromer method, is more stable
        omega(ii + 1) = omega(ii) + acc_func(phi(ii + 1)) * dt;
    end
end

% Find the position, velocity, and acceleration
% The origin is at the center of the rotation
pos = length_pendulum * [sin(phi') -cos(phi')];

polyorder = 3;
window_length = 5;
sample_rate = 1/dt;
vel = savgol(pos, polyorder, window_length, 1, sample_rate);
acc = savgol(pos, polyorder, window_length, 2, sample_rate);

% Add gravity
g = 9.81;   % gravity, [m/s^2]
accGravity = [0, g];
gifReSpace = accGravity + acc;

% Transfer into a body-fixed system
num_rows = size(gifReSpace,1);
gifReBody = nan(size(gifReSpace));
for ii = 1: num_rows
    gifReBody(ii,:) = rotate( gifReSpace(ii,:), -phi(ii) );
end

% Save the data to a structure
sim_data.time = time;
sim_data.phi = phi;
sim_data.omega = omega;
sim_data.gifReBody = gifReBody;
end


function show_data(data, phi, pos, length)
% Plots of the simulation, and comparison with original data
%
% Parameters
% ----------
% data :  Pandas DataFrame
%     Contains 'time', 'phi', 'omega', 'gifBHor', 'gifBVer'
% phi : ndarray, shape (N,)
%     Angles of the reconstructed movement.
% pos : ndarray, shape (N,2)
%     x/y-positions of the reconstructed movement.
% length : float
%     Length of the pendulum.

% Show Phi
subplot(311);
plot(data.time, phi);
xticklabels({});
ylabel('Phi [rad]');

% Show Omega
subplot(312);
plot(data.time, data.omega);
xticklabels({});
ylabel('Omega [rad/s]');

% Show measured force
subplot(313);
plot(data.time, data.gifReBody);
xlabel('Time [sec]');
ylabel('GIF re Body [m/s^2]');
legend('Hor', 'Ver');
shg;

% x,y plot of the position
figure
subplot(121)
plot(pos(:, 1), pos(:, 2));
title('Position: Y vs X');
xlabel('X');
ylabel('Y');

subplot(122)
plot(data.time, pos(:, 1));
xlabel('Time [sec]');
ylabel('X-Pos');
title('Position: X(t), and sin(Phi)(t)');
hold('on');

% Just to check if the results match
plot(data.time, length * sin(phi), 'r');
legend('X', 'L*sin(Phi)');
shg;
end


function rotated =  rotate(data, phi)
% Rotate 2d data in column form
%
% Parameters
% ----------
% data : ndarray, shape (2,)
%     x/y-data to be rotated.
% phi : float
%     Angle of 2-D rotation.
%
% Returns
% -------
% rotated : ndarray, shape (2,)
%     Rotated data.

Rmat = [cos(phi), -sin(phi),
        sin(phi),  cos(phi)];
rotated = (Rmat * data')';
end


function [phi, pos] =  reconstruct_movement(omega, gifMeasured, length_pendulum, rate)
% From the measured data, reconstruct the movement
%
% Parameters
% ----------
% omega : ndarray, shape (N,)
%     Angular velocity [rad/s]
% gifMeasured : ndarray, shape (N,2)
%     Gravito-inertial force per unit mass [kg m/s^2]
% length : float
%     Length of pendulum [m]
%
% Returns
% -------
% phi : ndarray, shape (N,)
%     Angle of pendulum [rad]
% pos : ndarray, shape (N,2)
%     x/y-position of pendulum [m]

dt = 1/rate;
g = 9.81;      % [m/s^2]

% Initial orientation
gif_t0 = gifMeasured(1,:);
phi0 = atan2(gif_t0(1), gif_t0(2));

% Calculate phi, by integrating omega
phi = cumtrapz(omega)*dt + phi0;

% From phi and the measured acceleration, get the movement acceleration
accReSpace = nan(size(gifMeasured));
for ii = 1:length(phi)
    accReSpace(ii,:) = rotate(gifMeasured(ii,:), phi(ii)) - [0, g];
end

% Position and Velocity through integration
vel = nan(size(accReSpace));
pos = nan(size(accReSpace));

init = length_pendulum * [sin(phi(1)), -cos(phi(1))];
for ii = 1: size(accReSpace, 2)
    vel(:, ii) = cumtrapz(accReSpace(:, ii))*dt;
    pos(:, ii) = cumtrapz(vel(:, ii))*dt;
    pos(:, ii) = pos(:, ii) + init(ii);  % initial condition
end

end


