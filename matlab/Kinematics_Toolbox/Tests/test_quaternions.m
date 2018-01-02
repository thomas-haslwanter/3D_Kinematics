%% test_quaternions
% Tests for quaternion-functions for the "3D_Kinematics toolbox"

% authors:  ThH
% date:     Aug-2017
% ver:      0.1

%% Main function to generate tests
function tests = quatTest
tests = functiontests(localfunctions);
end

%% Test q_scalar
function test_q_scalar(testCase)
expected = 0.1;
q_in = [expected 0.2 0.3 0.4];

assert(expected == q_scalar(q_in));
end

%% Test q_inv
function test_q_inv(testCase)
epsilon = 1e-10;
theta = pi/4;
q_in = [cos(theta/2) 0 sin(theta/2) 0];
expected = q_in .* [1 -1 -1 -1];

assert( norm(q_inv(q_in)-expected) < epsilon );
end
