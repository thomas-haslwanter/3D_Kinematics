%% kalman_quat
% Calclulate the orientation from IMU magnetometer data using a Kalman Filter.
% 
%% Syntax
%    q_out = kalman_quat(rate, acc, omega, mag) 
%
%% Input Arguments
% * rate -- Sample rate [Hz]	
% * acc -- 3D Linear acceleration [m/sec^2]
% * omega -- 3D angular velocity [rad/sec]
% * mag -- 3D magnetic field orientation
% 
%% Output Arguments
% * q_out -- Unit quaternion, describing the orientation relativ to the coordinate
%        system spanned by the local magnetic field, and gravity
% 
%% Notes
% Based on "Design, Implementation, and Experimental Results of a Quaternion-Based
% Kalman Filter for Human Body Motion Tracking" Yun, X. and Bachman, E.R., IEEE
% TRANSACTIONS ON ROBOTICS, VOL. 22, 1216-1227 (2006)

% ------------------
% ver:      0.1
% date:     Aug-2017
% author:   ThH

function q_out = kalman_quat(rate, acc, omega, mag)


% Define constants
g_def = 9.80665;

% Assign relevant measurement data
angvelIn = omega;
accelIn = acc;
magfieldIn = mag;

data_len = length(accelIn);
time = (1:data_len)/rate;

%% Set parameters for Kalman Filter
tstep = 1/rate;

tau = [0.5 0.5 0.5];
% tau = [0.5 0.5 0.5];      %value [sec] used in relevant paper (Yun)

% Initialize state vector x_k and measurement vector z_k
z_k = zeros(7,1);
z_k_pre = zeros(7,1);
x_k = zeros(7,1);

% Initialize error covariance matrix P_k
P_k = eye(7);

% Initialize discrete state transition matrix Phi_k
Phi_k = zeros(7);
for ii = 1:3
    Phi_k(ii,ii) = exp(-tstep/tau(ii));
end

% Identity matrix H_k
H_k = eye(7);

% Initialize process noise matrix Q_k
D = 0.0001*[0.4 0.4 0.4];
% D = [0.4 0.4 0.4];	%value [rad²/sec²] used in relevant paper (Yun)

Q_k = zeros(7);
for ii = 1:3
    Q_k(ii,ii) = (D(ii)/(2*tau(ii)))*(1-exp(-2*tstep/tau(ii)));
end

% Evaluate measurement noise covariance matrix R_k
r_angvel = 0.01;
% r_angvel = 0.01;      %value [rad²/sec²] used in relevant paper (Yun)

r_quats = 0.0001;
% r_quats = 0.0001;     %value used in relevant paper (Yun)

R_k = zeros(7);
for ii = 1:7
    if ii<=3
        R_k(ii,ii) = r_angvel;
    else
        R_k(ii,ii) = r_quats;
    end
end

% Assign memory
q_out = nan(data_len, 4);

%% Calculation of orientation for every time step
for idx1 = 1:data_len
	accelVec = accelIn(idx1,:);
	magVec = magfieldIn(idx1,:);
    angvelVec = angvelIn(idx1,:);
    z_k_pre = z_k;
    % Evaluate quaternion based on acceleration and magnetic field data
    accelVec_n = accelVec/norm(accelVec);
	magVec_hor = magVec-accelVec_n*dot(accelVec_n,magVec);
	magVec_n = magVec_hor/norm(magVec_hor);
    basisVectors = [magVec_n' cross(accelVec_n, magVec_n)' accelVec_n'];
% 	RotBasis{1} = basisVectors;
	quatRef = -rotmat_convert(basisVectors,'quat');
	quatRef0 = sqrt(1-(quatRef(1)^2+quatRef(2)^2+quatRef(3)^2));
	quatRef = [quatRef0 quatRef];
    % Update measurement vector z_k
    z_k(1:3) = angvelVec;
    z_k(4:7) = quatRef;
    % Calculate Kalman Gain
    K_k = P_k*H_k'*(H_k*P_k*H_k'+R_k)^-1;
    % Update state vector x_k
    x_k = x_k+K_k*(z_k-z_k_pre);
    % Evaluate discrete state transition matrix Phi_k
    Phi_k(4,:) = [-x_k(5)*tstep/2 -x_k(6)*tstep/2 -x_k(7)*tstep/2 1 -x_k(1)*tstep/2 -x_k(2)*tstep/2 -x_k(3)*tstep/2];
    Phi_k(5,:) = [x_k(4)*tstep/2 -x_k(7)*tstep/2 x_k(6)*tstep/2 x_k(1)*tstep/2 1 x_k(3)*tstep/2 -x_k(2)*tstep/2];
    Phi_k(6,:) = [x_k(7)*tstep/2 x_k(4)*tstep/2 -x_k(5)*tstep/2 x_k(2)*tstep/2 -x_k(3)*tstep/2 1 x_k(1)*tstep/2];
    Phi_k(7,:) = [-x_k(6)*tstep/2 x_k(5)*tstep/2 x_k(4)*tstep/2 x_k(3)*tstep/2 x_k(2)*tstep/2 -x_k(1)*tstep/2 1];
    % Update error covariance matrix
    P_k = (eye(7)-K_k*H_k)*P_k;
    % Projection of state quaternions
    x_k(4:7) = x_k(4:7)'+q_mult(0.5*x_k(4:7)',[0 x_k(1:3)']);
    x_k(4:7) = x_k(4:7)/norm(x_k(4:7));c
    x_k(1:3) = zeros(3,1);
	x_k(1:3) = tstep*(-x_k(1:3)+z_k(1:3));
    q_out(idx1,:) = x_k(4:7);
    % Projection of error covariance matrix
    P_k = Phi_k*P_k*Phi_k'+Q_k;
end

