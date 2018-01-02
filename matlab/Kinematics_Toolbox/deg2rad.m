%% deg2rad
% Convert degree into radians.
% Can be used with a plain number or with a vector/matrix.
%
% $ radValue = degValue * pi/180$
%
%% Syntax
% radians = deg2rad(degree)
%
%% Input Arguments
% inDeg -- Input angle in degrees.
%
% Can be float, vector, or matrix   
%
%% Output Arguments
% outRad -- Corresponding radian values 
% 
%% Examples
% deg2rad([10, 20, 30])

function outRad = deg2rad(inDeg)

outRad = inDeg *pi/180;

end
