%QUAT/HORZCAT	[a b] for quaternions; same as [a;b]
%QUAT/HORZCAT	[a b] for quaternions; same as [a;b]
%Program Structure:
%\@quat\horzcat.m
%*****************************************************************



out = [];
for i = 1:nargin
  out = [out; varargin{i}.c];
end
c = quat(out);
