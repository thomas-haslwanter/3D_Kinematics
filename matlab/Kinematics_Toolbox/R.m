%% R
% Rotation matrix for rotation about the "dim"-axis
%
%% Syntax
%    R = R(dim, alpha) 
%
%% Input Arguments
% * dim -- Axis of rotation. Has to be "0", "1", or "2"
% * alpha -- Angle of rotation [in degrees] 
%
%% Output Arguments
% R -- Corresponding matrix for rotation of an object
% 
%% Examples
%    R(2, 45)

% ------------------
% ver:      0.1
% author:   ThH
% date:     Aug-2017

function R = R(dim, alpha)

% Check the input
if ~any(dim == [1,2,3])
    error([upper(mfilename) ': dim has to be 1,2, or 3']);
end

% convert from degrees into radian:
alpha = alpha * pi/180;

switch dim
    case 1
        R = 	[	1			0			0
                0			cos(alpha)		-sin(alpha)
                0 			sin(alpha)		cos(alpha) ];

    case 2
        R = 	[	cos(alpha)		0			sin(alpha)
                0			1			0
                -sin(alpha)		0			cos(alpha) ];

    case 3
        R =	[	cos(alpha)	-sin(alpha)	0
                sin(alpha)	cos(alpha)	0
                0			0	1];
end

end
