%% deg2quat
% Convert axis-angles or plain degree into the corresponding quaternion values.
% Can be used with a plain number or with a vector/matrix.
%
% $| \vec{q} | = sin(\\theta/2)$
%
%% Syntax
% quaternion = deg2quat(degree)
%
%% Input Arguments
% inDeg -- Input angle in degrees.
%
% Can be float, vector, or matrix   
%
%% Output Arguments
% outQuat -- Corresponding quaternion values 
% 
%% Notes
% More info under 
% <http://en.wikipedia.org/wiki/Quaternion>
%% Examples
% deg2quat([10, 20, 30])

function Quat = deg2quat(data_in)

% check the input
% n_channels = size(data_in, 2);
% if (n_channels ~= 1) & (n_channels ~= 3)
%     error([upper(mfilename) ': Input has to have 1 or 3 columns.']);
% end

alpha = mod(data_in,360)*pi/180;
Quat = sin(alpha/2).*sign(sin(alpha));


% 
%     $$| \\vec{q} | = sin(\\theta/2)$$
%

end
