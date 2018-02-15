%% sequence
% Takes a rotation matrix, and calculates the corresponding angles for sequential rotations.
%
%% Syntax
%    angles = sequence(rot_mat, to) 
%
%% Input Arguments
% * rot_mat -- Input rotation matrix [3x3], or matrices [Nx9]
% * to -- Output format. Has to be one of the following:
% Euler / Fick / nautical / Helmholtz
%
%     Euler <-> Rz * Rx * Rz
%     Fick <-> Rz * Ry * Rx
%     nautical <-> same as "Fick"
%     Helmholtz <-> Ry * Rz * Rx
%
%% Output Arguments
% * angles --- corresponding 3 rotation angles [alpha, beta, gamma],
%           in the sequence of the rotation matrices
% 
%
%% Notes
% The following formulas are used:
%
% *Euler*
%
% $$\beta   = -arcsin(\sqrt{ R_{xz}^2 + R_{yz}^2 }) * sign(R_{yz})$$
%
% $$\gamma = arcsin(\frac{R_{xz}}{sin\beta})$$
%
% $$\alpha   = arcsin(\frac{R_{zx}}{sin\beta})$$
%
% *nautical / Fick*
%
% $$\theta   = arctan(\frac{R_{yx}}{R_{xx}})$$
%
% $$\phi = arcsin(R_{zx})$$
%
% $$\psi   = arctan(\frac{R_{zy}}{R_{zz}})$$
%
% Note that it is assumed that psi < pi !
%
% *Helmholtz*
%
% $$\theta = arcsin(R_{yx})$$
%
% $$\phi = -arcsin(\frac{R_{zx}}{cos\theta})$$
%
% $$\psi = -arcsin(\frac{R_{yz}}{cos\theta})$$
%
%
% Note that it is assumed that psi < pi
%

% ------------------
% ver:      0.1
% date:     Aug-2017
% author:   ThH

function angles = sequence(rot_mat, to)

% Set the default
if nargin == 1
    to = 'nautical'
end

% "Fick" is the same as "nautical"
to = strrep(to, 'Fick', 'nautical');

% for easier readability
R = rot_mat;

if ~prod(size(rot_mat)==[3,3])
    R = reshape(rot_mat', 3, 3, []);
end

switch to
    case 'nautical'        
        phi =  -asin(R(3,1,:));
        psi =   asin(R(3,2,:) ./ cos(phi) );
        theta = asin(R(2,1,:) ./ cos(phi) );
        
        angles = reshape([theta ,phi, psi], 3, [])';
        
    case 'Helmholtz'        
        theta = asin(R(2,1,:));
        psi =  -asin(R(2,3,:) ./ cos(theta) );
        phi = asin(R(3,1,:) ./ cos(theta) );
        
        angles = reshape([phi, theta, psi], 3, [])';
        
    case 'Euler'
        epsilon = 1e-6;
        beta = - asin(sqrt(R(1,3,:).^2 + R(2,3,:).^2)) .* sign(R(2,3,:))
        small_indices =  beta < epsilon;
        
        % Assign memory for alpha and gamma
        alpha = nan(size(beta));
        gamma = nan(size(beta));
        
        % For small beta
        beta(small_indices) = 0;
        gamma(small_indices) = 0;
        alpha(small_indices) = asin(R(2,1,small_indices));
        
        % for the rest
        gamma(~small_indices) = asin( R(1,3,~small_indices)./sin(beta) );
        alpha(~small_indices) = asin( R(3,1,~small_indices)./sin(beta) );
        
          % That equation seems to be wrong
%         beta = asin(R(3,1,:));
%         alpha = asin(R(3,2,:) ./ cos(beta) );
%         gamma = asin(R(2,1,:) ./ cos(beta) );
      
        angles = reshape([gamma, beta, alpha], 3, [])';
        
    otherwise
        error([upper(mfilename) ': Sorry, currently only the following options'
            'are supported:\n',
            'nautical [default]\n',
            'Fick\n',
            'Helmholtz\n',
            'Euler\n'])
end

