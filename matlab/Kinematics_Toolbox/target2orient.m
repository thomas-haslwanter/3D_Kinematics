%% target2orient
%   Converts a target vector into a corresponding orientation.
%   Useful for targeting devices, such as eyes, cameras, or missile trackers.
%   Based on the assumption, that in the reference orientation, the targeting
%   device points forward.
%
%% Syntax
%  orientation = target2orient(target, orient_type)
%
%% Input Arguments
% * target -- Input vector
% * orient_type -- Has to be one the following:
%        
%       'Fick' -> Rz * Ry
%       'nautical' -> same as "Fick"
%       'Helmholtz' -> Ry * Rz
%       'quat' -> quaternion
%
%% Output Arguments
% * orientation -- Corresponding orientation
%    For rotation matrices, same sequence as the matrices [deg].
%    For quaternions, the quaternion vector.
%    
%    Note that the last column of the sequence angles, and the first column
%    of the quaterion, will always be zero, because a rotation about
%    the line-of-sight has no effect.
%
%% Examples
%   a = [3,3,0];
%   b = [5., 0, 5];
%   target2orient(a, 'quat')
%   target2orient([a,b])
    

function orientation = target2orient(target, orient_type)

[num_data, num_cols] = size(target);

% Check the input
if num_cols~=3 
    error([upper(mfilename) ':The input target in ORIENT2QAT must have 3 elements!']);
end

if strcmp(orient_type, 'Fick')
    orient_type = 'nautical';
end

switch orient_type
    case 'quat'
        orientation = q_shortest_rotation([1,0,0], target);
        
    case 'nautical'
        n = normalize(target);
        
        theta = atan2(n(:,2), n(:,1));
        phi = -asin(n(:,3));
        
        orientation =  [theta, phi, zeros(size(theta))];
        orientation = rad2deg(orientation);

    case 'Helmholtz'
        n = normalize(target);
        
        phi = -atan2(n(:,3), n(:,1));
        theta = asin(n(:,2));
        
        orientation =  [phi, theta, zeros(size(theta))];
        orientation = rad2deg(orientation);

    otherwise
        error([' No option ' upper(orient_type) ' in ' upper(mfilename)]);
end

end
