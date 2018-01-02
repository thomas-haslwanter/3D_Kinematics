%% calc_quat
% This function converts angular velocity to quaternion position.
%
%% Syntax
% |orientation = calc_quat(velocity, q0, time_rate, coordinate_system)|
%
%% Input Arguments
% * velocity -- Input 3D angular velocity [rad/s]
% * q0 -- starting orientation [quaternion]
% * time_rate -- Either time[s], which must have the same length as "velocity", OR(!) sampling rate [Hz]
% * coordinate_system -- space-fixed ("sf") or body_fixed ("bf")
% 
%% Output Arguments
% * orientation -- Calculated orientation [quaterion]
% 
%% Examples
%  |out_pos = calc_quat(vel, [0 0 0], 100, 'sf');|
%  |out_pos = calc_quat(vel, [.7 0 0], 0:0.1:10, 'bf')|
%
%% Notes
% Take care that you choose a high enough sampling rate!
%

% -------------
%	ver:    2.3
%	author: ThH
%   date:   Aug-2017

function q_pos = calc_quat(velocity, q0, time_rate, coordinate_system)

% Preprocess the input:
if length(time_rate) == 1	% if the sampling rate in Hz is given
    rate = time_rate;
    dt_NonZero = [1:length(velocity)]';
else						% if a vector of time-values is given
    time = time_rate;
    clear time_rate
    if size(time,1)<size(time,2)    % make sure it is a column
        time = time';
    end
    dt = diff(time);
    dt(end+1) = 0;    % diff(x) is one shorter than "x"
    if length(velocity) ~= length(time)
        error('"velocity" and "time" have to have the same length!');
    end
    dt_NonZero = find(dt~=0);
    rate(dt_NonZero) = 1./dt(dt_NonZero);   % note that this gives a row-vector! Therefore:
    rate = rate';
end

% Convert from deg/s to radian/s
% velocity = velocity * pi/180;

vel_t = sqrt(sum(velocity.^2,2)); 
vel_NonZero = find(vel_t~=0);

% For each position, calculate the corresponding quaternion:
non_zero = intersect(dt_NonZero, vel_NonZero); % non-zero: to avoid divide by zero

% Idea: delta_q(x) = vel(x)/vel_total * (q_total) [and the same for y and z]
%   vel(x)/vel_total ... normalized direction vector,
%	q_total = sin(v_total*dt/2) ... magnitude of the rotation
%   dt = 1/rate ... time interval

% initialization
q_delta = zeros(length(velocity), 3);
q_pos = zeros(length(velocity),4);
q_pos(1,:) = unit_q(q0);

% magnitude of position steps ...
if length(rate)==1
    dq_total = sin(vel_t(non_zero)./(2*rate));
else
    dq_total = sin(vel_t(non_zero)./(2*rate(non_zero)));
end

% ... combined with the direction of the rotation
q_delta(non_zero,:) = velocity(non_zero,:).* repmat(dq_total./vel_t(non_zero), 1,3);
% delta(~non_zero,:) = 0;

% and finally, sum up the different steps
for ii = 1:length(velocity)-1		% note that the last velocity is ignored!
    switch lower(coordinate_system)
        case 'sf'
            q_pos(ii+1,:) = q_mult(unit_q(q_delta(ii,:)),q_pos(ii,:));
        case 'bf'
            q_pos(ii+1,:) = q_mult(q_pos(ii,:), unit_q(q_delta(ii,:)));
        otherwise
            error(['COORDINATE_SYSTEM has to be "sf" or "bf", not ' upper(coordinate_system)]);
    end
end
disp('done')