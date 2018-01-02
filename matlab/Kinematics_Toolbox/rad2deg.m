%% rad2deg
% Convert radians into degree.
% Can be used with a plain number or with a vector/matrix.
%
% $ radValue = degValue * 180/pi$
%
%% Syntax
% outDeg = rad2deg(inRad)
%
%% Input Arguments
% inRad -- Input angle in radians.
%
% Can be float, vector, or matrix   
%
%% Output Arguments
% outDeg -- Corresponding degrees values 
% 
%% Examples
% rad2deg([0.1, pi/4])

function outDeg = rad2deg(inRad)

outDeg = inRad *180/pi;

end
