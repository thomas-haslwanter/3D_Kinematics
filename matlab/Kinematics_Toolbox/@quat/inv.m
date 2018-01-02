%QUAT/INV	inverse for quaternions
%QUAT/INV	inverse for quaternions
%Program Structure:
%\@quat\inv.m
%*****************************************************************



a = quat(a);

% inverse of a
a_inv = [a.c(:,1) -a.c(:,2:4)]./ (sum(a.c.^2,2)*ones(1,4));

