%% quat_convert
% Convert quaterion(s) into other representation of rotation(s)
%
% Calculate the rotation matrix corresponding to the quaternion. If
% "inQuat" contains more than one quaternion, the matrix is flattened (to
% facilitate the work with rows of quaternions), and can be restored to
% matrix form by "reshaping" the resulting rows into a (3,3) shape.
%
%% Syntax
%    converted = quat_convert(in_quat, new_type)
%
%% Input Arguments
% * in_quat -- Quaternions or quaternion vectors. (Quaternion vectors are
% expanded to unit quaternions.)
% * new_type -- Output type. Has to be "rotmat" or "Gibbs"
%
%     'rotmat'  ->  rotation matrix
%     'Gibbs'    -> Gibbs vector
% 
%% Output Arguments
% * converted -- Corresponding converted output
% 
%% Notes
% $${\bf{R}} = \left( {\begin{array}{*{20}{c}}
%     {q_0^2 + q_1^2 - q_2^2 - q_3^2}&{2({q_1}{q_2} - {q_0}{q_3})}&{2({q_1}{q_3} + {q_0}{q_2})}\\
%     {2({q_1}{q_2} + {q_0}{q_3})}&{q_0^2 - q_1^2 + q_2^2 -
%     q_3^2}&{2({q_2}{q_3} - {q_0}{q_1})}\\ {2({q_1}{q_3} -
%     {q_0}{q_2})}&{2({q_2}{q_3} + {q_0}{q_1})}&{q_0^2 - q_1^2 - q_2^2 + q_3^2} \\ \end{array}} \right)$$
%
% More info under <http://en.wikipedia.org/wiki/Quaternion>
% 
%% Examples
%    r = quat_convert([0, 0, 0.1], 'rotmat')
%    reshape(r, 3,3)
%

function Result = quat_convert(in_quat, new_type)

[num_data, num_cols] = size(in_quat);

%% Check the input
if num_cols~=3 & num_cols ~=4	% if "in_quat" contains 4 values, take only the "vector"
    error([upper(mfilename) ':The quaternions in QUAT2X need to have 3 or 4 elements!']);
end

% Data conversion
switch new_type
    
    case 'Gibbs'
        q_length = vector_length(in_quat);
        q_rho = 2*asin(q_length);		% the size of the rotation
        
        in_quat = q_vector(in_quat);
        % For rotations by pi (to avoid division by zero):
        gibbs = nans(1, size(in_quat, 1));
        length_one = find(q_length == 1);
        gibbs(length_one) = 0;
        
        % For the rest....
        not_length_one = find(q_length ~= 1);
        
        gibbs(not_length_one) = 1./ sqrt( 1-q_length(not_length_one).^2 );
        Result = repmat(gibbs,1,3) .* in_quat;
        
    case 'rotmat'
        R = zeros(9, num_data);
        q0 = q_scalar(in_quat)';
        q = q_vector(in_quat)';
        
        R(1,:) = q0.^2 + q(1,:).^2 - q(2,:).^2 - q(3,:).^2;
        R(2,:) = 2 * (q(1,:).*q(2,:) + q0.*q(3,:));
        R(3,:) = 2 * (q(1,:).*q(3,:) - q0.*q(2,:));
        R(4,:) = 2 * (q(1,:).*q(2,:) - q0.*q(3,:));
        R(5,:) = q0.^2 - q(1,:).^2 + q(2,:).^2 - q(3,:).^2;
        R(6,:) = 2 * (q(2,:).*q(3,:) + q0.*q(1,:));
        R(7,:) = 2 * (q(1,:).*q(3,:) + q0.*q(2,:));
        R(8,:) = 2 * (q(2,:).*q(3,:) - q0.*q(1,:));
        R(9,:) = q0.^2 - q(1,:).^2 - q(2,:).^2 + q(3,:).^2;
        
        if num_data == 1
            Result = reshape(R, 3, 3);
        else
            Result = R';
        end
    otherwise
        error([' No option ' upper(new_type) ' in ' upper(mfilename)]);
end
