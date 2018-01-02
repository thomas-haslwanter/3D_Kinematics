%QUAT/MLDIVIDE a/b for quaternions
%QUAT/MLDIVIDE a/b for quaternions
%Program Structure:
%\@quat\mldivide.m
%*****************************************************************



a = quat(a);
b = quat(b);

c = a*inv(b);

