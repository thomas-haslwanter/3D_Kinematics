%% q_shortest_rotation
% Quaternion indicating the shortest rotation from one vector into another.
% 
% You can read "qrotate" as either "quaternion rotate" or as "quick rotate".
%
%% Syntax
%     quat = q_shortest_rotation(v1, v2, dim)
%
%% Input Arguments
% * v1 -- Vector(s) 1, to be rotated
% * v2 -- Vector(s) 2, rotated into
% * dim -- [Optional] "1" (default) if vectors are in row-form; "2" if
% vectors are in column form
%
%% Output Arguments
% * quat -- Quaternion, describing the shortest rotation from v1 to v2
% 
%% Notes
% Either of the two inputs can consist of a single vector.
 
% --------------
% Ver 0.1
% author: ThH
% date: Aug-2017

function quat = q_shortest_rotation(v1, v2, dim)

% make sure the "dim"-argument is 1 or 2
if nargin == 2
    dim = 1;
end
if min(size(v1)) == 1
    v1 = toRow(v1);
end
if min(size(v2)) == 1
    v2 = toRow(v2);
end

% Check the input, and - if required - extend input vector to matrix
[v1, v2] = check_input(v1, v2, dim, mfilename);

% calculate the direction
n = normalize(cross(v1,v2));
     
% find the angle, and calculate the quaternion
angle12 = vector_angle(v1,v2);
quat = n .* repmat(sin(angle12/2), 1, 3);
end