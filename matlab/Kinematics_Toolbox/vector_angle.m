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
%            0 < angle < pi
%            If the elements in v1 are in row-form, the output
%            is a column vector (default); if the input is in
%            column-form the output is a row-vector.
% 

% -------------     
%	autor:  ThH 

function angle = vector_angle(v1, v2, dim)

% make sure the "dim"-argument is 1 or 2
if nargin == 3
    assert(dim==1 | dim==2);
else
    dim = 1;
end

% Check the input, and - if required - extend input vector to matrix
[v1, v2] = check_input(v1, v2, dim, mfilename);

angle = acos(dot(normalize(v1), normalize(v2),2));

% Find indices where the length is 0, and set the corresponding "angle" to "NaN"
zero_length = vector_length(v1)==0 | vector_length(v2)==0;
angle(zero_length) = NaN;

if dim == 2
    angle = angle';
end
end
