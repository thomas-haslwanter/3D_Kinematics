%% q_inv
% Quaternion inversion
%
%% Syntax
%    p=quat_inv(q)
%
%% Input Arguments
% * q -- Input quaternion
%
%% Output Arguments
% * p -- Inverse quaternion to q 
% 

% ---------------------------------
% authors:	JH, ThH
% ver:  1.3
% date:	Aug-2017

function inverse_quat = q_inv(in_quat)

% Check the input properties
n_cols = size(in_quat, 2);

if n_cols~=3 & n_cols~=4
  error([upper(mfilename) ': Input argument must have 3 or 4 columns.']);
end

if n_cols == 3
	inverse_quat = -in_quat;
else
	n = sum(in_quat.^2')';
	p = q_conj(in_quat);
	inverse_quat = [p(:,1)./n p(:,2)./n p(:,3)./n p(:,4)./n];
end

