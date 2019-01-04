% Exercise 1.1: Solve equations of motion for sinusoidally moving accelerometer.

% author: Thomas Haslwanter, date: Jan-2019

%Main Function
function Ex_1_1_Solution()

    %% Set up the parameters
    % for the plot
    duration = 10;
    rate = 50; 

    % for the sine-wave
    freq = 2;
    amp = 5;         

    % initial conditions
    v0 = 0;
    p0 = 15;   

    %% Calculate derived values
    omega = 2*pi * freq;
    dt = 1/rate;
    time = 0:dt:duration;
    acc = amp * sin(omega*time);

    %% Analytical and numerical solutions
    fh = analytical(amp, omega, time, p0, v0, acc);
    simple_integration(fh, time, v0, p0, acc);
end

    
function fh = analytical(amp, omega, time, p0, v0, acc)
    % Analytical solution of a sinusoidal acceleration
    % 
    % Returns
    % -------
    % fh : figure handle for the new figure
    
    %% Analytical solution
    vel = amp/omega * (1 - cos(omega*time)) + v0;
    pos = -amp/omega^2 * sin(omega*time) + (amp/omega + v0)*time + p0;

    fh = figure;

    subplot(311);
    plot(time, acc);
    ylabel('Acceleration');

    subplot(312);
    plot(time, vel);
    ylabel('Velocity');

    subplot(313);
    plot(time, pos);
    ylabel('Position');
    xlabel('Time [sec]');
end

function simple_integration(fh, time, v0, p0, acc)
    % Numerical integration of the movement equations
    % 
    % Paramters:
    % ----------
    % fh : figure handle for the figure with the analytical plots
    
    %% Initial conditions
    vel = v0;
    pos = p0;

    dt = time(2) - time(1);
    
    %% Numerical solution
    for ii = 1:(length(time)-1)
        vel(ii+1) = vel(ii) + acc(ii)*dt;
        pos(ii+1) = pos(ii) + vel(ii+1)*dt;    % Euler-Cromer method
    end
    
    %% Superpose the lines on the previous plots
    figure(fh);

    subplot(312);
    hold('on');
    plot(time, vel);

    subplot(313)
    hold('on');
    plot(time, pos);
    legend('analytical', 'numerical')
end
