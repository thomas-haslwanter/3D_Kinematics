% Exercise 3.1: Orientation of the elements of a modern CT scanner.
% Find the angles to bring an "Axiom Artis dTC" into a desired
% orientation.

% Author: Thomas Haslwanter, Date: Jan-2019


% Calculate R_total
R_total = R_s('z', 'alpha')*R_s('x', 'beta')*R_s('y', 'gamma')


% Find the desired orientation of the CT-scanner
bullet_1 = [5,2,2];
bullet_2 = [5,-2,-4];
n = cross(bullet_1, bullet_2);

ct = nan(3);
ct(:,2) = normalize_vector(bullet_1);
ct(:,3) = normalize_vector(n);
ct(:,1) = cross(ct(:,2), ct(:,3))

disp('Desired Orientation (ct):')
disp(ct)

% Calculate the angle of each CT-element
beta =  asin( ct(3,2) );
gamma = asin( -ct(3,1)/cos(beta) );

% next I assume that -pi/2 < gamma < pi/2:
if sign(ct(3,3)) < 0
    gamma = pi - gamma;
end    

% display output between +/- pi:
if gamma > pi
    gamma = gamma - 2*pi;
end    

alpha = asin( -ct(1,2)/cos(beta) );

alpha_deg = rad2deg( alpha );
beta_deg =  rad2deg( beta  );
gamma_deg = rad2deg( gamma );

% Check if the calculated orientation equals the desired orientation
disp('Calculated Orientation (R):');
rot_mat = R('z', alpha_deg) * R('x', beta_deg) * R('y', gamma_deg);
disp(rot_mat)

out_txt = sprintf('alpha/beta/gamma = %5.1f / %5.1f / %5.1f [deg]\n', ...
                alpha_deg, beta_deg, gamma_deg);
disp(out_txt);

