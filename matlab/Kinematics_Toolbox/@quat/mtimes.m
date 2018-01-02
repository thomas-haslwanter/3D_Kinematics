%QUAT/MTIMES a*b for quaternions
%QUAT/MTIMES a*b for quaternions
%Program Structure:
%\@quat\mtimes.m
%*****************************************************************



a = quat(a);
b = quat(b);

c(:,1)=a.c(:,1).*b.c(:,1)-a.c(:,2).*b.c(:,2)-a.c(:,3).*b.c(:,3)-a.c(:,4).*b.c(:,4);
c(:,2)=a.c(:,2).*b.c(:,1)+a.c(:,1).*b.c(:,2)-a.c(:,4).*b.c(:,3)+a.c(:,3).*b.c(:,4);
c(:,3)=a.c(:,3).*b.c(:,1)+a.c(:,4).*b.c(:,2)+a.c(:,1).*b.c(:,3)-a.c(:,2).*b.c(:,4);
c(:,4)=a.c(:,4).*b.c(:,1)-a.c(:,3).*b.c(:,2)+a.c(:,2).*b.c(:,3)+a.c(:,1).*b.c(:,4);

c = quat(c);

