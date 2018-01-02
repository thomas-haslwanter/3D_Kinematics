%% check_input
% Utility function, that checks for two vector inputs.
%
% Input matrices must have the same dimension, or one input must be a
% vector.
%
%% Syntax
% |[v1_checked, v2_checked] = check_input(v1, v2, dim, f_name)|
%
%% Input Arguments
% * v1 -- First input vector
% * v2 -- Second input vector
% * dim -- Dimension of input (has to be "1" or "2")
% * fname -- Name of calling function

% --------------
% Ver 0.1
% author: ThH
% date: Aug-2017

function [v1_checked, v2_checked] = check_input(v1, v2, dim, f_name)
% make sure the "dim"-argument is 1 or 2
if dim ~= 1 & dim ~= 2
    error([upper(f_name) ': dim has to be 1 or 2']);
elseif dim == 2
    v1 = v1';
    v2 = v2';
end


% The matrices must have the same dimension,
% or one input must be a vector
if ~all(size(v1) == size(v2))
    % one of the inputs must be a vector
    if min([size(v1), size(v2)]) ~= 1
        error([upper(f_name) ': The inputs must have the same dimension, '
            'or the second input must be a vector']);
    elseif size(v1,1) == 1
        v1 = repmat(v1, size(v2,1), 1);
    else
        v2 = repmat(v2, size(v1,1), 1);
    end
end

v1_checked = v1;
v2_checked = v2;
end
