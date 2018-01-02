%QUAT/MINUS	a-b for quaternions
%QUAT/MINUS	a-b for quaternions
%Program Structure:
%\@quat\minus.m
%*****************************************************************



a = quat(a);
b = quat(b);

c = a.c - b.c;

c = quat(c);

