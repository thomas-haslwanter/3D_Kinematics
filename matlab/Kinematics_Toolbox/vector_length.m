%VECTOR_LENGTH Length of n-dimensional vectors
%
% Parameters
% ----------
% in_vector : NxM matrix, with M-dim vectors
%       Note that the vectors must be in row-form
%
% Returns
% -------
% vector_length : Nx1 vector
%       Length of vector
%

% -----------
% autor:  ThH 

function v_length = vector_length(in_vector, dim)

% make sure the "dim"-argument is 1 or 2
if nargin == 1
    dim = 2;
else
    if dim ~= 1 & dim ~= 2
        error(['NORMALIZE: dim has to be 1 or 2']);
    elseif dim == 1
        in_vector = in_vector';
    end
end

ndim = size(in_vector, 2);

% Normalize the vector
v_length = sqrt(sum(in_vector.^2,2));
end
