%% q_scalar
% Extract the quaternion scalar from a full quaternion.
% 
%% Syntax
%    scalar = q_scalar(in_quat)
%
%% Input Arguments
% * in_quat -- quaternions or quaternion vectors. Quaternion vectors are
% expanded to unit quaternions.
%
%% Output Arguments
% * scalar -- corresponding quaternion scalar 
% 
%% Notes
% More info under <http://en.wikipedia.org/wiki/Quaternion>
% 
%% Examples
%    q_scalar([cos(0.2), 0, 0, sin(0.2);
%              cos(0.1), 0, sin(0.1), 0])

% -----------------
% authors:	JH, ThH
% ver:  0.1
% date:	Aug-2017

function scalar = q_scalar(in_quat)

n_cols = size(in_quat, 2);

if n_cols == 3
    full_quat = unit_q(in_quat);
    scalar = full_quat(:,1);   
elseif n_cols == 4
    scalar = in_quat(:,1);
else
    error([upper(mfilename) ': Input argument must have 3 or 4 columns.']);
end