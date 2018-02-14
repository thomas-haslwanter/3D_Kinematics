%% quat2deg
% Calculate the axis-angle corresponding to a given quaternion.
%
% $$\theta = 2* asin(q)$$
%
%% Syntax
%    degree = quat2deg(in_quat)
%
%% Input Arguments
% * in_quat -- Input quaternion(s) or quaternion vector(s)
%
%% Output Arguments
% * degree - corresponding values, in deg
% 
%% Notes
% More info under <http://en.wikipedia.org/wiki/Quaternion>
%
%% Examples
%    scale2deg(0.1)
%    scale2deg([0.1, 0.1, 0])
%    scale2deg([cos(0.1), 0, sin(0.1), 0])
%    scale2deg([cos(0.1), 0, sin(0.1), 0; cos(0.2), 0, 0, sin(0.2)])

% ------------------
% ver:      0.1
% author:   ThH
% date:     Aug-2017


function degree = quat2deg(in_quat)

% Check the input properties
n_cols = size(in_quat, 2);


if max(size(in_quat)) == 1
    degree = 2 * asin(in_quat) * 180/pi;
else
    if n_cols~=3 & n_cols~=4
        error([upper(mfilename) ': Input argument must have 3 or 4 columns.']);
    else
        vector = q_vector(in_quat);
        q_length = sqrt(sum(vector.^2,2));
        rho = 2 * asin(q_length) * 180/pi;			% the size of the rotation
        
        degree = repmat(rho, 1, 3) .* normalize(vector);
    end
end

end