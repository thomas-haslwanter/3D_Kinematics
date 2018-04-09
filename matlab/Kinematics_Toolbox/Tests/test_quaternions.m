%% test_quaternions
% Tests for quaternion-functions for the "3D_Kinematics toolbox"

% authors:  ThH
% date:     April-2018


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

function assertAlmostEqual(a,b)
    [quats, delta] = setUp();
    assert( abs(a - b) < delta );
end

%% Test q_scalar
function test_q_scalar(testCase)
    expected = 0.1;
    q_in = [expected 0.2 0.3 0.4];

    assert(expected == q_scalar(q_in));
end


%% Test quat2seq
function test_quat2seq(testCase)
    angle = 0.2;
    a = [cos(angle/2), 0,0,sin(angle/2)];
    b = [cos(0.2), 0,0,sin(0.2)];

    seq = quat2seq([a;b], 'nautical');
    assertAlmostEqual(angle, deg2rad(seq(1,1)));

    seq = quat2seq(a, 'nautical');
    assertAlmostEqual(angle, deg2rad(seq(1,1)));

    seq = quat2seq(a, 'Fick');
    assertAlmostEqual(angle, deg2rad(seq(1,1)));

    seq = quat2seq(a, 'Euler');
    assertAlmostEqual(angle, deg2rad(seq(1,1)));

    seq = quat2seq(a, 'Helmholtz');
    assertAlmostEqual(angle, deg2rad(seq(1,2)));
end

%% Test deg2quat
function test_deg2quat(testCase)
    assertAlmostEqual(deg2quat(10), 0.087155742747658166);

     result = deg2quat([10, 170, 190, -10]);
     correct =  [ 0.08715574,  0.9961947 , -0.9961947 , -0.08715574];
     errorMag = norm(result - correct)
     assertAlmostEqual(errorMag, 0);

end

%% Test quat_convert
function test_quat_convert(testCase)
    result = quat_convert([0, 0, 0.1], 'rot_mat')
    correct = [ 0.98      , -0.19899749,  0.        ;
                0.19899749,  0.98      ,  0.        ;
                0.        ,  0.        ,  1.        ];
    errorMag = norm(result - correct)
    assertAlmostEqual(errorMag, 0);

    result = quat_convert([0, 0, 0.1; 0, 0.1, 0], 'rot_mat')
    correct = [ 0.98      , -0.19899749,  0.        ,  0.19899749,  0.98      , 0.        ,  0.        ,  0.        ,  1.        ;
                0.98      ,  0.        ,  0.19899749,  0.        ,  1.        , 0.        , -0.19899749,  0.        ,  0.98      ];
    error = norm(result - correct)
    assertAlmostEqual(errorMag, 0);

end

%% Test q_vector
function test_q_vector(testCase)
    result = q_vector([cos(0.1), 0, 0, sin(0.1)])
    correct = [ 0.        ,  0.        ,  0.09983342];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);
    
    result = q_vector([cos(0.1), 0., 0, sin(0.1);
                       cos(0.2), 0, sin(0.2), 0]);
    correct = [ 0.        ,  0.        ,  0.09983342;
                0.        ,  0.19866933,  0.        ];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);

end
        
%% Test q_mult
function test_q_mult(testCase)
    [quats, delta] = setUp();

    result = q_mult(quats.qz, quats.qz);
    correct =  [ 0.98006658,  0.        ,  0.        ,  0.19866933];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);

    result = q_mult(quats.qz, quats.qy) ;
    correct = [ 0.99003329, -0.00996671,  0.09933467,  0.09933467];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);

    result = q_mult(quats.quatMat, quats.quatMat);
    correct = [ 0.98006658,  0.        ,  0.        ,  0.19866933;
                0.98006658,  0.        ,  0.19866933,  0.        ];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);

    result = q_mult(quats.quatMat, quats.qz);
    correct = [ 0.98006658,  0.        ,  0.        ,  0.19866933;
                0.99003329,  0.00996671,  0.09933467,  0.09933467];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);

    result = q_mult(quats.q3x, quats.q3x);
    correct = [ 0.19866933,  0.        ,  0.        ];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);
end

%% Test q_conj
function test_q_conj(testCase)
    q= [0, 0, 1];
    result = q_conj(q);
    correct =  [ 0.,  0.,  0.,  -1.];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);

    q = [cos(0.1),0,0,sin(0.1);
         cos(0.2), 0, sin(0.2), 0];
    result = q_conj(q);
    correct =  [ 0.99500417, -0.        , -0.        , -0.09983342;
                 0.98006658, -0.        , -0.19866933, -0.        ];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);
end

%% Test q_inv
function test_q_inv(testCase)
    [quats, delta] = setUp();

    result = q_mult(quats.qz, q_inv(quats.qz));
    correct =  [ 1.,  0.,  0.,  0.];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);

    result = q_mult(quats.quatMat, q_inv(quats.quatMat)); 
    correct =  [ 1.,  0.,  0.,  0.;
                 1.,  0.,  0.,  0.];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);

    result = q_mult(quats.q3x, q_inv(quats.q3x));
    correct =  [ 0.,  0.,  0.];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);
end

%% Test quat2deg
function test_quat2deg(testCase)
    [quats, delta] = setUp();

    result = quat2deg(quats.qz);
    correct =  [  0.       ,   0.       ,  11.4591559];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);

    result = quat2deg(quats.quatMat);
    correct =  [  0.       ,   0.       ,  11.4591559;
                  0.       ,  11.4591559,   0.       ];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);

    result = quat2deg(0.2);
    correct =  23.07391807;
    errorMag = abs(result - correct);
    assertAlmostEqual(errorMag, 0);
end

%% Test unit_q
function test_unit_q(testCase)
    result = unit_q([0,0,sin(0.1); 0,sin(0.2),0]);
    correct = [ 0.99500417,  0.        ,  0.        ,  0.09983342;
                0.98006658,  0.        ,  0.19866933,  0.        ];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);
end
        

%% Test test_calc_quat
function test_calc_quat(testCase)
    v0 = [0., 0., 100.];
    vel = repmat(v0, 1000,1);
    rate = 100;
    out = calc_quat(deg2rad(vel), [0., 0., 0.], rate, 'sf');
    result = out(end,:);
    correct =  [-0.76040597, 0., 0., 0.64944805];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);
end

%% Test test_calc_angvel
function test_calc_angvel(testCase)
    rate = 1000;
    t = 0:(1/rate):10;
    x = 0.1 * sin(t);
    y = 0.2 * sin(t);
    z = zeros(size(t));
    
    q = [x', y', z'];
    vel = calc_angvel(q, rate, 5, 2);
    qReturn = calc_quat(vel, q(1,:), rate, 'sf' );
    errorMag = max(max(abs( q-qReturn(:,2:end) )));
    assert(errorMag < 1e-3);    % less stringent for this test
end
