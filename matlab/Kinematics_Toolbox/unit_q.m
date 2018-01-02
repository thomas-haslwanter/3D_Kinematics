%% unit_q
% Utility function, which turns a quaternion vector into a unit quaternion.
% If the input is already a full quaternion, the output equals the input.
%
%
%% Syntax
%    out_quat = unit_q(in_quat)
%
%% Input Arguments
% * in_quat -- Input quaternion vector(s)
%
%% Output Arguments
% * out_quat -- Corresponding unit quaternion

% -------------     
%	autor:  ThH 
%   date:   Aug. 2017
%	ver:    0.1

function out_quat = unit_q(in_quat)

% check the size of the input
n_channels = size(in_quat, 2);
if n_channels == 3
    q_length = 1 - sum(in_quat.^2,2);
	numLimit = 1e-12;
	% Check for numerical problems
    if min(q_length) < -numLimit
        error([upper(mfilename) ': Quaternion is too long!'])
    else
        % Correct for numerical problems
        q_length(q_length<0) = 0;
        out_quat = [sqrt(q_length), in_quat];
    end
    
elseif n_channels == 4
    out_quat = in_quat;
else
    error([upper(mfilename) ': Input has to have 3 or 4 columns.']);
end

end