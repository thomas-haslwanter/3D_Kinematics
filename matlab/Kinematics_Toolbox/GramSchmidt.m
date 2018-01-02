%% GramSchmidt
% Gram Schmidt orthogonalization
%
%% Syntax
%    Rmat = GramSchmidt(p1, p2, p3)
%
%% Input Arguments
% * p1 -- First point (Center)
% * p2 -- Second point (Direction of x)
% * p3 -- Third point (in x/y-plane)
%
%% Output Arguments
% * Rmat -- Rotation matrix, flattened [Nx9 matrix]
% 

% --------------
% Ver 0.1
% author: ThH
% date: Aug-2017

function Rmat = GramSchmidt(p1, p2, p3)

% Input check
if ~all(size(p1) == size(p2)) & ~all(size(p1) == size(p3))
    error([upper(mfilename) ': all input arguments must have the same size.']);
end

v1 = p2 - p1;
v2 = p3 - p1;

e1 = normalize(v1);
e2 = normalize(v2 - project_vector(v2, e1));
e3 = cross(e1, e2, 2);

Rmat = [e1, e2, e3];
end