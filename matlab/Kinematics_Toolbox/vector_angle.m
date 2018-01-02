%% vector_angle
% Angle between two vectors.
%
% If one of the vectors has zero length, NaN is returned
%     
%% Syntax
%    angle = vector_angle(v1, v2, dim)
%
%% Input Arguments
% * v1 -- First vector 
% * v2 -- Second vector 
% * dim -- [optional] index over which the angle is calculated.
% "1" if vectors in row-form (default);
% "2" if vectors in column form 
%
%% Output Arguments
% * angle -- Corresponding angles between the vectors [radians]
% 

% -------------     
%	autor:  ThH 
%   date:   Aug. 2017
%	ver:    0.1

function angle = vector_angle(v1, v2, dim)

% make sure the "dim"-argument is 1 or 2
if nargin == 2
    dim = 1;
end

% Check the input, and - if required - extend input vector to matrix
[v1, v2] = check_input(v1, v2, dim, mfilename);

angle = acos(dot(normalize(v1), normalize(v2),2));

% Find indices where the length is 0, and set the corresponding "angle" to "NaN"
zero_length = vector_length(v1)==0 | vector_length(v2)==0;
angle(zero_length) = NaN;

end
