% Exercise 1.3: Simulation of a "simple" pendulum.

% Author: Thomas Haslwanter, Date: Jan-2019


function Ex_1_1_Solution()
    %Main Function


    % Starting position: 5 deg
    [time, angle] = calculate_trajectory(5);
    subplot(211)
    plot(time, angle);
    xlim([0, max(time)]);
    ylabel('Angle [deg]');
    title('Pendulum');
    
    % Starting position: 70 deg
    [time, angle] = calculate_trajectory(70);
    subplot(212)
    plot(time, angle);
    xlim([0, max(time)]);
    ylabel('Angle [deg]');
    xlabel('Time [sec]');
    
    % Save the figure, and show the user the corresponding info
    outFile = 'pendulum.jpg';
    print('-djpeg90', outFile);
    disp(['Image saved to ' outFile]);
end


function [time, phi_deg] = calculate_trajectory(phi_0)
    % Simulate a pendulum in 2-D
    % The equation of motion is:
    %     \frac{d^2 \phi}{dt^2} = -\frac{g}{l} \sin(phi)
    % Also, writes the data to an out-file.
    %
    % Parameters
    % ----------
    % phi_0 : float
    %     starting angle [deg].
    %
    % Returns
    % -------
    % time : Time samples [s]
    % angle : Pendulum angle [deg]

    tMax = 5;      % duration of simulation [sec]
    rate = 1000;  % sampling rate [Hz]

    dt = 1 / rate;
    time = 0:dt:tMax;

    % Initial conditions
    phi = deg2rad(phi_0);  % rad
    omega = 0;  % rad/s

    % Numerical integration with the Euler-Cromer method, which is more stable
    for ii = 1: (length(time) - 1)
        phi(ii+1) = phi(ii) + omega(ii)*dt;
        omega(ii+1) = omega(ii) + acc_func(phi(ii+1))*dt;
    end

    phi_deg = rad2deg(phi);
end


function acc = acc_func(alpha)
    % Differential equation of motion
    % 
    % Parameters:
    % -----------
    % alpha : float
    %     Starting angle [deg]
    % 
    % Returns:
    % --------
    % time : ndarray
    %     Time values for the movement of the pendulum.
    % phi : ndarray
    %     Pendulum angle [deg]

    % Define constants and parameters
    g = 9.81;     % gravity, [m/s^2]
    length_pendulum = 0.20;  % [m]
    
    acc = -g/length_pendulum * sin(alpha);
end

