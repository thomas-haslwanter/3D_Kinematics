%% toRow
% Takes the input, checks if it is a vector, and returns it as a row
%
%% Syntax
%    row_data = toRow(data)
%
%% Input Arguments
% * data -- Input vector
%
%% Output Arguments
% * row_data -- Vector, in row-form
% 

% --------------
% author:   ThH
% date:     Aug-2003
% ver:      1.0

function row_data = toRow(data)

[rows, cols] = size(data);

if min([rows cols]) > 1
	error(['The input to ' upper(mfilename) '!']);
end

if rows > cols
	row_data = data';
else
	row_data = data;
end

