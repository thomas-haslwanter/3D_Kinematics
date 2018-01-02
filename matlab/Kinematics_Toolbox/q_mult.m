%% q_mult
% Quaternion multiplication
% If one or both of the quaternions have only three columns,
% the scalar component is calculated such that the lenght of the
% quaternion is one.
%
%% Syntax
%    p=q_mult(q,r)
%
%% Input Arguments
% * q -- First input quaterion
% * r -- Second input quaterion
%
%% Output Arguments
% * p -- Quaternion product q*r 
% 
%% Notes
% If either of the inputs contains only the quaternion vector, the input is
% expanded to unit quaternions.
%

% ----------------------
%   ver:        1.4
%	authors:    JH, ThH
%	date:       Aug-2000

function p=q_mult(q,r)

if (nargin==1)
  r=q;
end

[nq mq]=size(q);
[nr mr]=size(r);

if (mq~=3)&(mq~=4)
  error('first input argument must have 3 or 4 columns');
end
if (mr~=3)&(mr~=4)
  error('second input argument must have 3 or 4 columns');
end
if nq~=nr
  if nq~=1 & nr~=1
	 error('both arguments must have the same number of rows unless one has only one row');
  end
end

if (mq==3)
  lq_2 = 1-sum(q'.^2);
  if min(lq_2) < 0 % Check for numerical problems
	 num_limit = 1e-12;
	 if min(lq_2) < -num_limit 
		error('QUATMULT: vector q too long');
	 else
		lq_2(lq_2<0) = 0; % Correction for numerical problems
	 end
  end
  q=[sqrt(lq_2)', q];
  clear lq_2;
end

if (mr==3)
  lr_2 = 1-sum(r'.^2);
  if min(lr_2) < 0 % Check for numerical problems
	 num_limit = 1e-12;
	 if min(lr_2) < -num_limit 
		error('QUATMULT: vector p too long');
	 else
		lr_2(lr_2<0) = 0; % Correction for numerical problems
	 end
  end
  r=[sqrt(lr_2)', r];
  clear lr_2;
end

p(:,1)=q(:,1).*r(:,1)-q(:,2).*r(:,2)-q(:,3).*r(:,3)-q(:,4).*r(:,4);
p(:,2)=q(:,2).*r(:,1)+q(:,1).*r(:,2)-q(:,4).*r(:,3)+q(:,3).*r(:,4);
p(:,3)=q(:,3).*r(:,1)+q(:,4).*r(:,2)+q(:,1).*r(:,3)-q(:,2).*r(:,4);
p(:,4)=q(:,4).*r(:,1)-q(:,3).*r(:,2)+q(:,2).*r(:,3)+q(:,1).*r(:,4);

if mq==3 & mr==3
  if min(size(p))==1 & p(1)<0 % for a single rotations > 180 deg
	 p(2:4) = -p(2:4);
  else
	 p(p(:,1)<0,:) = -p(p(:,1)<0,:); % for rotations > 180 deg
  end
  p = p(:,2:4);
end
