%% seq2quat
%    This function takes a angles from sequenctial rotations  and calculates the corresponding quaternions.
%
%% Syntax
%   quats = seq2quat(rot_angles, seq)
%
%% Input Arguments
% * rot_angles -- sequential rotation angles [deg]
% * seq -- Has to be one the following:
%        
%        'Euler'  -> Rz * Rx * Rz
%        'Fick' -> Rz * Ry * Rx
%        'nautical' -> same as "Fick"
%        'Helmholtz' -> Ry * Rz * Rx
%
%% Output Arguments
% * quats -- corresponding quaternions
%
%% Examples
%   seq2quat([90, 23.074, -90], 'Euler')
%    
%% Notes
%    The equations are longish, and can be found in 3D-Kinematics, 4.1.5 "Relation to Sequential Rotations"

function quats = seq2quat(rot_angles, seq)

[num_data, num_cols] = size(rot_angles);

% Check the input
if num_cols~=3 
    error([upper(mfilename) ':The input sequence in SEQ2QUAT must have 3 elements!']);
end

if strcmp(seq, 'Fick')
    seq = 'nautical';
end

rot_angles = deg2rad(rot_angles);
quats = nan * ones(num_data, 4);

switch seq
case 'Euler'
    alpha = rot_angles(:,1);
    beta = rot_angles(:,2);
    gamma = rot_angles(:,3);
    
    c_al = cos(alpha/2);
    s_al = sin(alpha/2);
    c_be = cos(beta/2);
    s_be = sin(beta/2);
    c_ga = cos(gamma/2);
    s_ga = sin(gamma/2);
    
    quats(:,1) = c_al.*c_be.*c_ga - s_al.*c_be.*s_ga;
    quats(:,2) = c_al.*s_be.*c_ga + s_al.*s_be.*s_ga;
    quats(:,3) = s_al.*s_be.*c_ga - c_al.*s_be.*s_ga;
    quats(:,4) = c_al.*c_be.*s_ga + s_al.*c_be.*c_ga;
    
case 'nautical'
    theta = rot_angles(:,1);
    phi = rot_angles(:,2);
    psi = rot_angles(:,3);
    
    c_th = cos(theta/2);
    c_ph = cos(phi/2);
    c_ps = cos(psi/2);
    s_th = sin(theta/2);
    s_ph = sin(phi/2);
    s_ps = sin(psi/2);
    
    quats(:,1) = c_th.*c_ph.*c_ps + s_th.*s_ph.*s_ps;
    quats(:,2) = c_th.*c_ph.*s_ps - s_th.*s_ph.*c_ps;
    quats(:,3) = c_th.*s_ph.*c_ps + s_th.*c_ph.*s_ps;
    quats(:,4) = s_th.*c_ph.*c_ps - c_th.*s_ph.*s_ps;

case 'Helmholtz'
    phi = rot_angles(:,1);
    theta = rot_angles(:,2);
    psi = rot_angles(:,3);
    
    c_th = cos(theta/2);
    c_ph = cos(phi/2);
    c_ps = cos(psi/2);
    
    s_th = sin(theta/2);
    s_ph = sin(phi/2);
    s_ps = sin(psi/2);

    quats(:,1) = c_th.*c_ph.*c_ps - s_th.*s_ph.*s_ps;
    quats(:,2) = c_th.*c_ph.*s_ps + s_th.*s_ph.*c_ps;
    quats(:,3) = c_th.*s_ph.*c_ps + s_th.*c_ph.*s_ps;
    quats(:,4) = s_th.*c_ph.*c_ps - c_th.*s_ph.*s_ps;

otherwise
    error([' No option ' upper(new_type) ' in ' upper(mfilename)]);
end

end
