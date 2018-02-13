%% test_quaternions
% Tests for quaternion-functions for the "3D_Kinematics toolbox"

% authors:  ThH
% date:     Aug-2017
% ver:      0.1

%% Main function to generate tests
function tests = quatTest
tests = functiontests(localfunctions);
end

%% Test setup
function [quats, delta] = setUp()
    quats.qz = [cos(0.1), 0, 0, sin(0.1)];
    quats.qy = [cos(0.1), 0, sin(0.1), 0];
    quats.quatMat = [quats.qz;
                     quats.qy];
    quats.q3x = [sin(0.1), 0, 0];
    quats.q3y = [2, 0, sin(0.1), 0];
    delta = 1e-4;

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


%% Test quat2seq
function test_quat2seq(testCase)
    [quats, delta] = setUp();

    angle = 0.2;
    a = [cos(angle/2), 0,0,sin(angle/2)];
    b = [cos(0.2), 0,0,sin(0.2)];

    seq = quat2seq([a;b], 'nautical');
    assert(abs(angle - deg2rad(seq(1,1)))<delta);

    seq = quat2seq(a, 'nautical');
    assert(abs(angle - deg2rad(seq(1,1)))<delta);

    seq = quat2seq(a, 'Fick');
    assert(abs(angle - deg2rad(seq(1,1)))<delta);

    seq = quat2seq(a, 'Euler');
    assert(abs(angle - deg2rad(seq(1,1)))<delta);

    seq = quat2seq(a, 'Helmholtz');
    assert(abs(angle - deg2rad(seq(1,2)))<delta);
end
