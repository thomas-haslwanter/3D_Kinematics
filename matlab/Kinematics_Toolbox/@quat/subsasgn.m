%QUAT/SUBSREF
%QUAT/SUBSREF
%Program Structure:
%\@quat\subsasgn.m
%*****************************************************************



switch s.type
case '()'
  switch length(s.subs)
  case 1
    a.c(s.subs{1},:) = quat(b);
  case 2
    a.c(s.subs{1},s.subs{2}) = b;
  end
otherwise
  error('Specify the quaternion component of q as q(4) or q(3,4)');
end

