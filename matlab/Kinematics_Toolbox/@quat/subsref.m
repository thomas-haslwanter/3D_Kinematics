%QUAT/SUBSREF
%QUAT/SUBSREF
%Program Structure:
%\@quat\subsref.m
%*****************************************************************



switch s.type
case '()'
  switch length(s.subs)
  case 1
    b = a.c(s.subs{1},:);
  case 2
    b = a.c(s.subs{1},s.subs{2});
  end
otherwise
  error('Specify the quaternion component of q as q(4) or q(3,4)');
end

b = quat(b);

