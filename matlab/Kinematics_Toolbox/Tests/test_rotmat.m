%% test_rotmat
% Tests for rotation-matrix functions for the "3D_Kinematics toolbox"

% authors:  ThH
% date:     April-2018

%% Main function to generate tests
function tests = rotmatTest

    tests = functiontests(localfunctions);

end

%% Test setup
function [delta] = setUp()

    delta = 1e-5;

end

function assertAlmostEqual(a,b)

    delta = setUp();
    assert( abs(a - b) < delta );

end

%% Test convert
function test_rotmat_convert(testCase)

    result = rotmat_convert(quat_convert([0, 0, 0.1], 'rot_mat'), 'quat');
    correct = [ 0.99498744,  0.        ,  0.        ,  0.1       ];
    errorMag = norm(result - correct);
    assertAlmostEqual(errorMag, 0);
    
end


%% Test dh
function test_dh(testCase)
  theta_1=90;
  theta_2=90;
  theta_3=0;
  dh_mat = dh(theta_1,60,0,0)*dh(0,88,71,90)*dh(theta_2,15,0,0)*dh(0,0,174,-180)*dh(theta_3,15,0,0);

  correct = [ -0.0000   -0.0000   -1.0000   -0.0000;
    0.0000    1.0000   -0.0000   71.0000;
    1.0000   -0.0000   -0.0000  322.0000;
         0         0         0    1.0000];
    assertAlmostEqual(min(min(abs(dh_mat-correct))), 0);

end

        
    
%% Test dh_symbolic
function test_dh_symbolic(testCase)

    dh_sym = vpa(dh_s('theta_1',60,0,0) * dh_s('theta_2',15,0,0)*dh_s(0,15,0,'beta_1'), 2);

    disp(dh_sym);

end


%% Test Euler
function test_Euler(testCase)

    testmat = [sqrt(2)/2, -sqrt(2)/2, 0;
               sqrt(2)/2,  sqrt(2)/2, 0;
                0, 0, 1];
    Euler = sequence(testmat, 'Euler');
    correct = [0, 0, pi/4];
    assertAlmostEqual(norm(correct - Euler), 0);
    
    alpha = 10;
    beta = 20;
    gamma = 30;
    mat_euler = R(3, gamma) * R(1, beta) * R(3, alpha);
    angles_euler = rad2deg(sequence(mat_euler, 'Euler'));
    correct = [gamma, beta, alpha];
    assertAlmostEqual(norm(correct - angles_euler), 0);

end


%% Test Fick
function test_Fick(testCase)

    testmat = [sqrt(2)/2, -sqrt(2)/2, 0;
               sqrt(2)/2,  sqrt(2)/2, 0;
                    0, 0, 1];
    Fick = sequence(testmat, 'nautical');
    correct = [pi/4, 0, 0];
    assertAlmostEqual(norm(correct - Fick), 0);

end


%% Test Helmholtz
function test_Helmholtz(testCase)

    testmat = [sqrt(2)/2, -sqrt(2)/2, 0;
               sqrt(2)/2,  sqrt(2)/2, 0;
                0, 0, 1];
    Helm = sequence(testmat, 'Helmholtz');
    correct = [0, pi/4, 0];
    assertAlmostEqual(norm(correct - Helm), 0);

end


%% Test R_axis1
function test_R_axis1(testCase)

    R1 = [1,0,0;
          0, sqrt(2)/2, -sqrt(2)/2;
          0, sqrt(2)/2,  sqrt(2)/2];
    
    assertAlmostEqual(min(min(abs(R1 - R(1, 45)))), 0);

end

%% Test R_axis2
function test_R_axis2(testCase)

    R2 = [ sqrt(2)/2, 0, sqrt(2)/2;
            0, 1, 0;
            -sqrt(2)/2, 0, sqrt(2)/2];
    assertAlmostEqual(min(min(abs(R2 - R(2, 45)))), 0);
    
end

%% Test R_axis3
function test_R_axis3(testCase)

    R3 = [sqrt(2)/2, -sqrt(2)/2, 0;
          sqrt(2)/2,  sqrt(2)/2, 0;
            0, 0, 1];
    assertAlmostEqual(min(min(abs(R3 - R(3, 45)))), 0);

end
        
    
%% Test R_symbolic
function test_symbolic(testCase)

    R_nautical = R_s(3, 'theta') * R_s(2, 'phi') * R_s(1, 'psi');
    disp(R_nautical);

end


%% Test seq2quat
function test_seq2quat(testCase)

    angle = 10;
    a = [angle, 0, 0];
    quats = seq2quat(a, 'nautical');
    assertAlmostEqual(quats(4), sin(deg2rad(angle/2)));
    
    angles = [0,0,0;
             10,0,0;
             20,10,5];
    angles2 = quat2seq(seq2quat(angles,'nautical'), 'nautical');
    errorMag = sum(sum((angles-angles2).^2));
    assertAlmostEqual(errorMag,0)

end


%% Test stm
function test_stm(testCase)
   stm_mat = stm(2, 45, [1,2,3]);

  correct = [ 0.7071         0    0.7071    1.0000;
         0    1.0000         0    2.0000;
   -0.7071         0    0.7071    3.0000;
         0         0         0    1.0000];

    assertAlmostEqual(min(min(abs(stm_mat-correct))), 0);

end

        
    
%% Test stm_symbolic
function test_stm_symbolic(testCase)
    Rz_s = stm_s(3, 'theta', [0;0;0]);
    Tz_s = stm_s(1, 0, '[0, 0, z]');
    stm_sym = Rz_s * Tz_s;


    disp(stm_sym);

end
