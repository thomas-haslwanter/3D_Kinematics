%% R
% Rotation matrix for rotation about the "dim"-axis
%
%% Syntax
%    r_mat = R(dim, alpha) 
%
%% Input Arguments
% * dim -- Axis of rotation. Has to be "0", "1", or "2"
% * alpha -- Angle of rotation [in degrees] 
%
%% Output Arguments
% r_mat -- Corresponding matrix for rotation of an object
% 
%% Examples
%    R(2, 45)

% ------------------
% author:   ThH
% date:     April-2018

function r_mat = R(dim, alpha)

% Check the input
if ~any(dim == [1,2,3])
    error([upper(mfilename) ': dim has to be 1,2, or 3']);
end

% convert from degrees into radian:
alpha = alpha * pi/180;

switch dim
    case 1
        r_mat = 	[	1			0			0
                0			cos(alpha)		-sin(alpha)
                0 			sin(alpha)		cos(alpha) ];

    case 2
        r_mat = 	[	cos(alpha)		0			sin(alpha)
                0			1			0
                -sin(alpha)		0			cos(alpha) ];

    case 3
        r_mat =	[	cos(alpha)	-sin(alpha)	0
                sin(alpha)	cos(alpha)	0
                0			0	1];
end

end
