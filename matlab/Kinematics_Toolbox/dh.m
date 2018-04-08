%% dh
%     Denavit Hartenberg transformation and rotation matrix.
%
%% Syntax
%    dh_mat = dh(theta, d, r, alpha) 
%
%% Input Arguments
% * theta -- rotation angle z axis [deg]
% * d -- transformation along the z-axis
% * r -- transformation along the z-axis
% * alpha -- Angle of rotation [in degrees]
%
%% Output Arguments
% df_mat -- Denavit Hartenberg transformation matrix.
% 
%% Examples
%  theta_1=90;
%  theta_2=90;
%  theta_3=0;
%  dh_mat = dh(theta_1,60,0,0)*dh(0,88,71,90)*dh(theta_2,15,0,0)*dh(0,0,174,-180)*dh(theta_3,15,0,0)
  
%
%% Notes
%    $$T_n^{n - 1}= {Trans}_{z_{n - 1}}(d_n)
%        \\cdot {Rot}_{z_{n - 1}}(\\theta_n) \\cdot {Trans}_{x_n}(r_n) \\cdot {Rot}_{x_n}(\\alpha_n)$$
%

% ------------------
% ver:      0.1
% author:   ThH
% date:     April-2018

function dh_mat = dh(theta, d, r, alpha) 

Rx = stm(1, alpha);
Tx = stm(1, 0, [r, 0, 0]);
Rz = stm(3, theta);
Tz = stm(1, 0, [0, 0, d]);

dh_mat = Tz * Rz * Tx * Rx;

end
