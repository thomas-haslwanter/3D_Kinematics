%% rotmat_convert
% Convert a rotation matrix to a different representation
%
%% Syntax
%    converted = rotmat_convert(rot_mat, to)
%
%% Input Arguments
% * rot_mat -- Input rotation matrix [3x3], or rotation matrices [Nx9]
% * to -- Output type. Has to be "quat" or "Gibbs"
%
%    'quat' -> quaterions
%    'Gibbs'  -> Gibbs vectors
%
%% Output Arguments
% * converted -- Corresponding quaternions or Gibbs-vectors 
% 

% ------------------
% ver:      0.1
% date:     Aug-2017
% author:   ThH

function converted = rotmat_convert(rot_mat, to)

if nargin == 1
    to = 'quat'
end

% for easier readability
R = rot_mat;

if size(rot_mat, 2) == 9
    R = reshape(rot_mat', 3, 3, []);
end

switch to
    case 'quat'
        X = sqrt([
            1 + R(1,1,:) - R(2,2,:) - R(3,3,:);
            1 - R(1,1,:) + R(2,2,:) - R(3,3,:);
            1 - R(1,1,:) - R(2,2,:) + R(3,3,:)]);
        Y = [R(3,2,:) - R(2,3,:);
            R(1,3,:) - R(3,1,:);
            R(2,1,:) - R(1,2,:)];
        converted = 0.5 * copysign(X,Y);
        q_0 = sqrt(1-sum(converted.^2));
        converted = [q_0; converted]';
%         converted = reshape(converted, 4, [])';
        
    case 'Gibbs'
        % since the "trace" command has difficulties in higher dimensions
        trace_nd = repmat(R(1,1,:) + R(2,2,:) + R(3,3,:), 3,1);
        converted = [
            R(3,2,:)-R(2,3,:);
            R(1,3,:)-R(3,1,:);
            R(2,1,:)-R(1,2,:)] ./ (1 + trace_nd);
        converted = reshape(converted, 3, [])';
    otherwise
        error([upper(mfilename) ': Sorry, currently only ''quat'' and ''Gibbs'' are supported.'])
end

