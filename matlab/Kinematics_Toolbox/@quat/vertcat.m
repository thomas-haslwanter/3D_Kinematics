%QUAT/VERTCAT	[a; b] for quaternions
%QUAT/VERTCAT	[a; b] for quaternions
%Program Structure:
%\@quat\vertcat.m
%*****************************************************************



out = [];
for i = 1:nargin
  out = [out; varargin{i}.c];
end
c = quat(out);
