%% q_conj
% Conjugate of a quaternion.
%
% Also valid if Q is a matrix with each row a quaternion or the vector
% part of a q.
%
%% Syntax
%    p = q_conj(q)
%
%% Input Arguments
% * q -- Input quaternion
%
%% Output Arguments
% * p -- Conjugate quaternion to q 
% 

% ---------------------------------
% authors: Joachim Heimberger & ThH
% ver:  0.2
% date: Aug-2017 

function p = q_conj(q)

% Check the input properties
[nq mq]=size(q);

if (mq~=3)&(mq~=4)
  error('input argument must have 3 or 4 columns');
end

% Extend quaternion vectors to a unit quaternion
if (mq==3)
  q = unit_q(q);
end

p=[q(:,1), -q(:,2:4)];
