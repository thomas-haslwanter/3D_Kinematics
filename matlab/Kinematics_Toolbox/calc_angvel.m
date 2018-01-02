%% calc_angvel
% Calculates the velocity from the quaternions or the vector part thereof
% supplied in an Mx4 or Mx3 matrix x with sampling rate 'rate'.
%
% The result is written into the (M-2)x3-matrix v.
%% Syntax
% v = quat2vel(x, rate, look, pol) 
%
%% Input Arguments
% * x -- Input quaternion [Nx3 or Nx4]
% * rate -- Sample rate
% * look -- Number of points before and behind center
% * pol -- Degree of the polynomial
%
%% Output Arguments
% vel -- Angular velocity [(N-2)x 3]

% authors:  JH & ThH
% date:     Jan-2007
% ver:      1.7

function v = calc_angvel(x, rate, look, pol)

num_threshold = 1e-12;

s = size(x);
if s(2)~=3 & s(2)~=4
   error('the first input argument must have 3 or 4 columns')
end

if nargin == 1, dt = 0.01; end

if s(2) == 3
   x0_2 = 1-sum(x.^2,2);
   x0_2((x0_2<0) & (x0_2>-num_threshold))=0;	% to avoid numerical problems, which can occur for |x| close to 1
   x = [sqrt(x0_2), x];
end

% v = savgol3(x, look, pol, 1, rate);		% default: 3,2,1
v = savgol(x, pol, 2*look+1, 1, rate);		% default: 3,2,1
v = 2 * q_mult(v,q_inv(x));
if ~isreal(v)
   disp('WARNING: imaginary part in the velocity!');
end
v = v(:,2:4);
