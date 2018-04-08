%% stm
% Spatial Transformation Matrix for rotation about the "dim"-axis
%
%% Syntax
%    stm_mat = stm(dim, alpha, translation) 
%
%% Input Arguments
% * dim -- Axis of rotation. Has to be "0", "1", or "2"
% * alpha -- Angle of rotation [in degrees]
% * translation -- 3x1 translation vector [optional]
%
%% Output Arguments
% stm_mat -- spatial transformation matrix, for rotation about the 
%            specified axis, and translation by the given vector
% 
%% Examples
%    stm(2, 45, [1,2,3])

% ------------------
% ver:      0.1
% author:   ThH
% date:     April-2018

function stm_mat = stm(dim, alpha, translation)

% Check the input
if ~any(dim == [1,2,3])
    error([upper(mfilename) ': dim has to be 1,2, or 3']);
end

if nargin == 2
    translation = [0; 0; 0];
end

stm_mat = eye(4);
stm_mat(1:3, 1:3) = R(dim, alpha);
stm_mat(1:3, end) = translation;

end
