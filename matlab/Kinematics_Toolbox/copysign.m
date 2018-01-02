%% copysign
% Return x with the sign of y. 
%
%% Syntax
%  |signed_copy = copysign(x,y)|
%
%% Input Arguments
% * x -- Input values
% * y -- Input signs
%
%% Output Arguments
% * signed_copy -- absolute value of x, with the sign of y 
% 
%% Examples
% copysign([2,3], [-4, 5])

% --------------
% ver:      0.1
% author:   ThH
% date:     Aug-2017

function x_signed = copysign(x,y)

x_signed = abs(x) .* sign(y);

end