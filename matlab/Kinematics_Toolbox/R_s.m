%% R_s
% Symbolic rotation matrix for rotation about the "dim"-axis.
%
% For rotation about the x/y/z axis, the angle names
% "psi", "phi", "theta" are used, respectively. (This allows to 
% subsequently multyply different matrices, and keep the symbolic
% angles apart.)
%
%% Syntax
%    R_sym = R_s(dim, label) 
%
%% Input Arguments
% * dim -- Axis of rotation. Has to be "0", "1", or "2"
% * label -- Name of angle
%
%% Output Arguments
% * R_s -- Corresponding symbolic rotation matrix
% 
%% Notes
% The resulting symbolic matrices can be multiplied with each other.
%
%% Examples
%    Rx = R_s(2, 'phi');
%    Ry = R_s(3, 'theta');
%    R_total = Rx * Ry

% -------------------
% ver:      0.1
% author:   ThH
% date:     Aug-2017

function R_sym = R_s(dim, label)
% for whatever reason, the following line crashed inside a function call
% syms R_sym theta phi psi
R_sym = sym('R_sym');
angle = sym(label);

% Check the input
if ~any(dim == [1,2,3])
    error([upper(f_name) ': dim has to be 1,2, or 3']);
end

switch dim
case 1
    R_sym = [1      0       0;
             0 cos(angle) -sin(angle);
             0 sin(angle) cos(angle)];

case 2
    R_sym = [cos(angle)  0 sin(angle);
                0        1       0;
            -sin(angle)  0 cos(angle)];

case 3
    R_sym = [cos(angle) -sin(angle) 0;
             sin(angle)  cos(angle) 0;
                0           0       1];
end

end

