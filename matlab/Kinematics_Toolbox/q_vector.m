%% q_vector
% Extract the vector part from a full quaternion.
% 
%% Syntax
%    vector = q_vector(in_quat)
%
%% Input Arguments
% * in_quat -- Quaternions or quaternion vectors. (Quaternion vectors are
% expanded to unit quaternions.)
%
%% Output Arguments
% * vector --  Corresponding quaternion vector(s)
% 
%% Notes
% More info under <http://en.wikipedia.org/wiki/Quaternion>
%
%% Examples
%     q_vector([cos(0.2), 0, 0, sin(0.2);
%               cos(0.1), 0, sin(0.1), 0])

% -----------------
% authors:	JH, ThH
% ver:  0.1
% date:	Aug-2017

function vector = q_vector(in_quat)

n_cols = size(in_quat, 2);

if n_cols == 3
    vector = in_quat;
elseif n_cols == 4
    vector = in_quat(:,2:4);
else
    error([upper(mfilename) ': Input argument must have 3 or 4 columns.']);
end