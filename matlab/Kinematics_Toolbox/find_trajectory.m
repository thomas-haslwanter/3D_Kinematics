%% find_trajectory
% Calculate trajectory from object position/orientation and relative position
% 
% $$\vec C(t) = \vec M(t) + \vec r(t) = \vec M(t) + (\bf{R}_{mov}(t) \cdot \vec r(t_0)$$
% 
% Movement trajetory of a point on an object, from the position and
% orientation of a sensor, and the relative position of the point at t=0.
%
%% Syntax
%    trajectory = find_trajectory(r0, Position, Orientation)
%
%% Input Arguments
% * r0 -- 3D Position of point relative to center of markers, when the object is in the reference position.
% * Position -- x/y/z coordinates of COM, relative to the reference position [Nx3-Matrix]
% * Orientation --Orientation relative to reference orientation, expressed as quaternion-vector [Nx3-Matrix]
% 
%% Output Arguments
% * trajectory -- x/y/z coordinates of the position on the object, relative to the reference position of the markers
% 
%% Examples
%
% <include>find_trajectory_demo.m</include>
%

function trajectory = find_trajectory(r0, Position, Orientation)

trajectory = Position + rotate_vector(r0, Orientation);

