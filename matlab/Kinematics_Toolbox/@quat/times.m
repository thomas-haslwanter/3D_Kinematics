%QUAT/TIMES a.*b for quaternions
%QUAT/TIMES a.*b for quaternions
%	a has to be a quaterion, and b a vector of the same length
%Program Structure:
%\@quat\times.m
%*****************************************************************



a = quat(a);
if length(a) ~= length(b)
  error('quaternion-length has to be equal vector-length')
end

c = a.c .* (b(:)*ones(1,4));

c = quat(c);

