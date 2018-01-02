%QUAT/PLUS	a+b for quaternions
%QUAT/PLUS	a+b for quaternions
%Program Structure:
%\@quat\plus.m
%*****************************************************************



a = quat(a);
b = quat(b);

c = a.c + b.c;

c = quat(c);

