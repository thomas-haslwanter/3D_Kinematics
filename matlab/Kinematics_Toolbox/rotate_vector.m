%% rotate_vector
% Rotates a given column of 3D vectors by a (fixed or variable) quaternion
%
% $$\vec{v}_{out} = q_{rot} * \vec{v}_{in} * q_{rot}^{-1}$$
%
% where "*" is a quaternion multiplication, and "^(-1)" indicates the
% inverse.
%
%% Syntax
%    vec_out = rotate_vector(vec_in, q_rot)
%
%% Input Arguments
% * vec_in -- 3D vector
% * q_rot -- Quaternion describing the rotation
% 
%% Output Arguments
% * vec_out -- Rotated vector
% 
%% Notes
% Either input can be a simple vector, or a matrix.

% ------------------
%	ver 2.0
%	author: ThH
%   date:   Aug-2017

function vec_out = rotate_vector(vec_in, q_rot)

% Check the input ...
[vec_rows, vec_cols] = size(vec_in);
[quat_rows, quat_cols] = size(q_rot);

% ... 3D vector ....
[vec_rows, vec_cols] = size(vec_in);
if vec_cols ~= 3
	disp(['The 3D vector in ' upper(mfilename) ' must have 3 columns!']);
	vec_out = [];
	return
else	% add a q0-component, for the quaternion multiplication:
	vec_in = [zeros(vec_rows, 1) vec_in];
end

% ... and quaternion:
% if quat_cols ~= 3
% 	disp(['The quaternion in ' upper(mfilename) ' must have 3 columns!']);
% 	vec_out = [];
% 	return
% end

% If the quaternion is constant for all 3D vectors ...
if quat_rows == 1
	q_rot = repmat(q_rot, vec_rows, 1);
end

% ... or if the 3D-vector is constant for all quaternions:
if vec_rows == 1
	vec_in = repmat(vec_in, quat_rows, 1);
end

% Rotate the vector ...
vec_out = q_mult(q_rot, q_mult(vec_in, q_inv(q_rot)));

%... and drop the inital "0"
vec_out = vec_out(:,2:4);
