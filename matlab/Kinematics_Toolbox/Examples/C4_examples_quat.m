%% C4_examples_quat
% Script demonstarting operations with quaternions.

% Ver 1.0
% author: ThH
% date: Aug-2017

% Just the magnitude
alpha = [10, 20]
q_size = deg2quat(alpha)

% Input quaternion vector
disp(['Input angles: ' num2str(alpha)]);
alpha_rad  = deg2rad(alpha);

disp('Input:')
q_vec = [0, sin(alpha_rad(1)/2), 0;
         0, 0, sin(alpha_rad(2)/2)]
% Unit quaternion
disp('Unit quaternions:');
q_unit = unit_q(q_vec);

% Also add a non-unit quaternion
q_non_unit = [1, 0, sin(alpha_rad(1)/2), 0];
disp('General quaternions:');
q_data = [q_unit; q_non_unit]

%Inversion
disp('Inverted:');
q_inverted = q_inv(q_data)

% Conjugation
disp('Conjugated:');
q_conjugated = q_conj(q_data)

% Multiplication
disp('Multiplied:');
q_multiplied = q_mult(q_data, q_data)

% Scalar and vector part
disp('Scalar part:');
q_scalars = q_scalar(q_data)

disp('Vector part:');
q_vectors = q_vector(q_data)

% Convert to axis angle
disp('Axis angle:');
q_axisangle = scale2deg(q_unit)

% Conversion to a rotation matrix
disp('First rotation matrix')
rotmats = quat_convert(q_unit, 'rot_mat')
rotmat = reshape(rotmats(1,:), 3,3)

