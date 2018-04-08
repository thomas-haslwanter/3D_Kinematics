%% dh_s
%   Symbolic Denavit Hartenberg transformation and rotation matrix.
%
%
%% Syntax
%    dh_sym = dh_s(theta, d, r, alpha)
%
%% Input Arguments
% * theta -- rotation angle z axis [deg]
% * d -- transformation along the z-axis
% * r -- transformation along the z-axis
% * alpha -- Angle of rotation [in degrees]k
%
%% Output Arguments
% * dh_sym -- Symbolic rotation and transformation  matrix 4x4
% 
%
%% Examples
%   dh_total = vpa(dh_s('theta_1',60,0,0)*dh(0,88,71,deg2rad(90))* dh_s('theta_2',15,0,0)*dh(0,0,174,deg2rad(-180))*dh_s('theta_3',15,0,0), 2)

% -------------------
% author:   ThH
% date:     April-2018

function dh_sym = dh_s(theta, d, r, alpha)

if nargin < 4
    alpha = 0;
end

if nargin < 3
    r = 0;
end

if nargin < 2
    d = 0;
end

translation_x = zeros(3,1);
if isstr(r)
    r = sym(r);
end
translation_x(1) = r;

translation_z = zeros(3,1);
if isstr(d)
    d = sym(d);
end
translation_z(3) = d;

% Calculate Denavit-Hartenberg transformation matrix
Rx = stm_s(1, alpha);
Tx = stm_s(1, 0, translation_x);
Rz = stm_s(3, theta);
Tz = stm_s(1, 0, translation_z);

dh_sym = simplify(Tz * Rz * Tx * Rx);

end

