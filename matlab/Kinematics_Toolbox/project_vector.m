%project_vector  Project one vector onto another
%
%% Syntax
%    projected = project_vector(v1, v2, dim)
%
%% Input Arguments
% * v1 -- Vector to be projected
% * v2 -- Vector projected onto
% * dim -- [optional] "1" if vectors in row-form (default); "2" if vectors in column
% form 
%
%% Output Arguments
% * projected -- Projection of v1 along v2 
% 
%% Examples
% 

% --------------
% author: ThH

function projected = project_vector(v1, v2, dim)

% make sure the "dim"-argument is 1 or 2
if nargin == 2
    dim = 1;
end

if dim == 2
    v1 = v1';
    v2 = v2';
end

% Check the input, and - if required - extend input vector to matrix
[v1, v2] = check_input(v1, v2, dim, mfilename);

e2 = normalize(v2);

ndim = size(v1, 2);
projected = repmat(dot(v1, e2, 2), 1, ndim) .* e2;
end
