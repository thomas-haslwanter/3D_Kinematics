%% stm_s
%     Symbolic spatial transformation matrix about the axis "dim", by an angle with
%   the given name, and translation by the given distances.
%
%
%% Syntax
%    stm_sym = stm_s(dim, alpha, translation) 
%
%% Input Arguments
% * dim -- Axis of rotation. Has to be "0", "1", or "2"
% * alpha -- Name of rotation angle, '0' for no rotation
% * translation -- String! Names of the translation distances, 0 for no translation
%                  along the corresponding axis.
%
%% Output Arguments
% * stm_s -- Corresponding symbolic spatial transformation matrix
% 
%% Notes
% The resulting symbolic matrices can be multiplied with each other.
%
%% Examples
%    Rz_s = stm_s(3, 'theta', [0;0;0]);
%    Tz_s = stm_s(1, 0, '[0, 0, z]');
%    stm_total = Rz_s * Tz_s

% -------------------
% author:   ThH
% date:     April-2018

function stm_sym = stm_s(dim, alpha, translation, precision)
% for whatever reason, the following line crashed inside a function call
% syms R_sym theta phi psi

if nargin < 4
    precision = 3;
end
if nargin < 3
    translation = [0;0;0];
end
if ~isfloat(alpha)
    alpha = sym(alpha);
end
translation = sym(translation);

% Check the input
if ~any(dim == [1,2,3])
    error([upper(f_name) ': dim has to be 1,2, or 3']);
end

stm_sym = sym(eye(4));

if alpha ~= 0
    stm_sym(1:3, 1:3) = R_s(dim, alpha);
end

if nargin == 3
    stm_sym(1:3, end) = translation;
end

% Solve those parts of the equations that can be done numerically
stm_sym = vpa(stm_sym, precision);

end

