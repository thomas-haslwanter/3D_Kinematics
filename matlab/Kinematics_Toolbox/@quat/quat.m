%QUAT	Quaternion class constructor
%QUAT	Quaternion class constructor
%Program Structure:
%\@quat\quat.m
%*****************************************************************



if nargin == 0
  q.c = [];
  q = class(q, 'quat');
elseif isa(a, 'quat')
  q = a;
else
  if min(size(a))==1			
    if max(size(a))==3		% 3-vector input
      q.c = [sqrt(1-sum(a.^2)) a(:)'];
    elseif max(size(a))==4	% quaternion input
      q.c = a;
    else						% vector input
      q.c = [sqrt(1-a(:).^2) zeros(length(a),2) a(:)];
    end    
  elseif min(size(a))==2	% two vectors
    if max(size(a))==3      
      if size(a,1) == 3 & size(a,2) == 2
        a = a';
      end
      q.c = [sqrt(1-sum(a.^2,2)) a];      
    elseif max(size(a))==4
      if size(a,1) == 4 & size(a,2) == 2
        a = a';
      end
      q.c = a;      
    else
      error('Useless input to quaternion constructor!');
    end
    q.c = [sqrt(1-sum(a.^2,2)) a];
  elseif min(size(a))==3	% a 3-matrix
    if size(a,1) == 3 & size(a,2) ~= 3
      a = a';
    end
    q.c = [sqrt(1-sum(a.^2,2)) a];
  elseif min(size(a))>4
    error('A quaternion must have less than 4 columns!');
  else    
    q.c = a;
  end

  q = class(q, 'quat');
end

