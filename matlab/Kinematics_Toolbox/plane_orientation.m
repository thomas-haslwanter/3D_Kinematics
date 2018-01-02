%% plane_orientaion
% The vector perpendicular to the plane defined by three points.
%
%% Syntax
%    n = plane_orientation(p1, p2, p3)
%
%% Input Arguments
% * p1 -- First point
% * p2 -- Second point
% * p3 -- Third point
%
%% Output Arguments
% * n -- Unit vector to the plane spanned by p1, p2, and p3
% 

% ---------------
% Ver 0.1
% author: ThH
% date: Aug-2017

function n = plane_orientation(p1, p2, p3)

% Input check
if ~all(size(p1) == size(p2)) & ~all(size(p1) == size(p3))
    error([upper(mfilename) ': all input arguments must have the same size.']);
end

v12 = p2 - p1;
v13 = p3 - p1;

n = normalize(cross(v12, v13));
end