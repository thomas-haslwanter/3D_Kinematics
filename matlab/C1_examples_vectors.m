%% C1_examples_vectors
% Script for working with vectors.
%
% For simplicity, the functions are applied to individual vectors. However, all
% functions also work on rows of vectors.

% Ver 1.0
% author: ThH
% date: Aug-2017

%% Set the input data
v0 = [0,0,0];
v1 = [1,0,0];
v2 = [1,1,0];
q = [0, 0.1, 0];

%% Perform a few vector functions on vectors
% Calculate the length
length_v2 = norm(v2)

% Angle between two vectors
angle = vector_angle(v1, v2)

% Normalize a vector
v2_normalized = normalize(v2)

% Project a vector on another one
projected = project_vector(v1, v2)

% Calculate the plane defined by three points
plane_orientation(v0, v1, v2)

% Gram-Schmidt Orthogonalization
rot_mat = GramSchmidt(v0, v1, v2);
reshape(rot_mat, 3,3)

% Find quaternion that rotates one vector into another
q_shortest = q_shortest_rotation(v1, v2)
rotate_vector(v1, q)
