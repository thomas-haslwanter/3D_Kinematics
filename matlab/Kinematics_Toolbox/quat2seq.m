%% quat2seq
%   This function takes a quaternion, and calculates the corresponding angles for sequenctial rotations.
%% Syntax
%   sequence = quat2seq(in_quat, seq)
%
%% Input Arguments
% * in_quat -- input quaternions
% * seq -- Has to be one the following:
%        
%        'Euler'  -> Rz * Rx * Rz
%        'Fick' -> Rz * Ry * Rx
%        'nautical' -> same as "Fick"
%        'Helmholtz' -> Ry * Rz * Rx
%
%% Output Arguments
% * sequence -- corresponding angles [deg], same sequence as in the rotation matrices
%
%% Examples
%   quat2seq([0,0,0.1])
%
%   quaternions = [0,0,0.1; 0,0.2,0]
%   quat2seq(quaternions, 'nautical')
%   quat2seq(quaternions, 'Euler')

function sequence = quat2seq(in_quat, seq)

[num_data, num_cols] = size(in_quat);

% Check the input
if num_cols~=3 & num_cols ~=4	% if "in_quat" contains 4 values, take only the "vector"
    error([upper(mfilename) ':The quaternions in QUAT2SEQ need to have 3 or 4 elements!']);
end

quats = unit_q(in_quat);

if strcmp(seq, 'Fick')
    seq = 'nautical';
end
switch seq
case 'Euler'
        Rs = quat_convert(quats, 'rotmat');
        
        if prod(size(Rs)) == 9
            Rs = reshape(Rs,1,9);
        end
            
        beta = acos(Rs(:,9));

        % Catch numerical artefacts in quat_convert
        epsilon = 1e-6;
        beta(beta<epsilon) = 0;
        
        % special handling for (beta == 0)
        bz = (beta == 0);
        
        % there the gamma-values are set to zero, since alpha/gamma is degenerated
        alpha = nan * ones(size(beta));
        gamma = nan * ones(size(beta));
        
        alpha(bz) = asin(Rs(bz,2));
        gamma(bz) = 0;
        
        alpha(~bz) = atan2(Rs(~bz,7), Rs(~bz,8));
        gamma(~bz) = atan2(Rs(~bz,3), Rs(~bz,6));
        
        sequence = rad2deg([alpha, beta, gamma]);
    
case 'nautical'
        R_zx = 2 * (quats(:,2).*quats(:,4) - quats(:,1).*quats(:,3));
        R_yx = 2 * (quats(:,2).*quats(:,3) + quats(:,1).*quats(:,4));
        R_zy = 2 * (quats(:,3).*quats(:,4) + quats(:,1).*quats(:,2));
        
        phi  = -asin(R_zx);
        theta = asin(R_yx ./ cos(phi));
        psi   = asin(R_zy ./ cos(phi));
        
        sequence = rad2deg([theta, phi, psi]);

case 'Helmholtz'
        R_yx = 2 * (quats(:,2).*quats(:,3) + quats(:,1).*quats(:,4));
        R_zx = 2 * (quats(:,2).*quats(:,4) - quats(:,1).*quats(:,3));
        R_yz = 2 * (quats(:,3).*quats(:,4) - quats(:,1).*quats(:,2));
        
        theta = asin(R_yx);
        phi  = -asin(R_zx ./ cos(theta));
        psi  = -asin(R_yz ./ cos(theta));
        
        sequence = rad2deg([phi, theta, psi]);
    

otherwise
    error([' No option ' upper(new_type) ' in ' upper(mfilename)]);
end

end
