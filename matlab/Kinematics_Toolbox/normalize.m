%% normalize
% Normalizes given n-D input vectors.
%
%% Syntax
%    norm_vector = normalize(in_vector, dim)
%
%% Input Arguments
% * in_vector -- Input vector(s)
% * dim -- Dimension along which to normalize (must be "1" or "2")
%
%% Output Arguments
% * norm_vector -- Normalized vector(s)
% 

% ------------------
%	autor:  ThH 
%   date:   Aug. 2017
%	ver:    2.0


function norm_vector = normalize(in_vector, dim)

% make sure the "dim"-argument is 1 or 2
if nargin == 1
    dim = 1;
else
    if dim ~= 1 & dim ~= 2
        error(['NORMALIZE: dim has to be 1 or 2']);
    elseif dim == 2
        in_vector = in_vector';
    end
end

ndim = size(in_vector, 2);

% Normalize the vector
vector_length = repmat(sqrt(sum(in_vector.^2,2)),1,ndim);
norm_vector = zeros(size(in_vector));
index_finite = (vector_length(:,1)~=0);
norm_vector(index_finite,:) = in_vector(index_finite,:) ./ vector_length(index_finite,:);
end