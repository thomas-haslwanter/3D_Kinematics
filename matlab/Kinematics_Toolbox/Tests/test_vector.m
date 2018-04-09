%% test_vector
% Tests for vector functions for the "3D_Kinematics toolbox"

% authors:  ThH
% ver:      0.1

%% Main function to generate tests
function tests = vectorTest

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

%% Test copysign
function test_copysign(testCase)
    x = [2,  3, 4, 5];
    y = [-1, 0, 1, -1];

    result = copysign(x,y);
    correct = [-2, 0, 4, -5];

    errorMag = norm(result-correct);
    assertAlmostEqual(errorMag, 0);

end

%% Test deg2rad
function test_deg2rad(testCase)
    deg = [-45, 0, 90;
            -90, 0, 45];
    rad = [-pi/4, 0, pi/2;
            -pi/2, 0, pi/4];

    result = deg2rad(deg);
    correct = rad;

    assertAlmostEqual(min(min(abs(correct-result))), 0);

    assertAlmostEqual(deg2rad(deg(1,1)), rad(1,1));
end


%% Test GramSchmidt
function test_GramSchmidt(testCase)
    P1 = [0, 0, 0;
          1,2,3];
    P2 = [1, 0, 0;
          4,1,0];
    P3 = [1, 1, 0;
          9,-1,1];
    result = GramSchmidt(P1,P2,P3);
    correct = [ 1, 0, 0, 0, 1, 0, 0, 0, 1;
    0.6882472, -0.22941573, -0.6882472 , 0.62872867, -0.28470732, 0.72363112, -0.36196138, -0.93075784, -0.05170877];
        
    assertAlmostEqual(sum(sum(abs(result-correct))), 0);

end

%% Test normalize
function test_normalize(testCase)

    result = normalize([3, 0, 0]);
    correct = [ 1, 0, 0];
    errorMag = norm(result-correct);
    assertAlmostEqual(errorMag, 0);

end

%% Test plane_orientation
function test_plane_orientation(testCase)
    P1 = [0, 0, 0;
          0,0,0];
    P2 = [1, 0, 0; 
          0,1,0];
    P3 = [1, 1, 0;
          0,0,1];
    
    result = plane_orientation(P1,P2,P3);
    correct = [ 0,  0, 1 ;
                1., 0, 0];
    
    assertAlmostEqual(sum(sum(abs(result-correct))), 0);

end


%% Test project
function test_project_vector(testCase)

    v1 = [1, 2, 3;
          4, 5, 6];
    v2 = [1,0,0;
          0,1,0];
    correct = [ 1, 0, 0;
                0, 5, 0];
    result = project_vector(v1,v2);
    assertAlmostEqual(sum(sum(abs(result-correct))), 0);
    
    result = project_vector(v1,v2,1);
    assertAlmostEqual(sum(sum(abs(result-correct))), 0);
    
end

%% Test q_shortest_rotation
function test_q_shortest_rotation(testCase)
    v1 = [1,0,0;
          1,1,0];
    v2 = [1,1,0;
          2,0,0];
    
    result = q_shortest_rotation(v1,v2);
    correct = [ 0,0, 0.38268343;
                0,0,-0.38268343];

    assertAlmostEqual(sum(sum(abs(result-correct))), 0);
    
    result = q_shortest_rotation(v1(1,:), v2(1,:));
    correct =  [0,0,0.38268343];

    errorMag = norm(result-correct);
    assertAlmostEqual(errorMag, 0);

end

%% Test rotate_vector
function test_rotate_vector(testCase)
    x = [1, 0, 0;
         0, 1, 0;
         0, 0, 1];
    result = rotate_vector(x, [0, 0, sin(0.1)]);
    correct = [ 0.98006658,  0.19866933,  0;
               -0.19866933,  0.98006658,  0;
                0,           0,           1];

    assertAlmostEqual(sum(sum(abs(result-correct))), 0);

end


%% Test target2orient
function test_target2orient(testCase)
    a = [1,1,0];
    b = [1., 0, 1];
    angle = 45;
    
    result =  target2orient([a;b], 'Helmholtz');
    correct = [ 0, angle, 0;
                -angle, 0, 0];
    assertAlmostEqual(sum(sum(abs(result-correct))), 0);

    result =  target2orient([a;b], 'Fick');
    correct = [ angle, 0, 0;
                0, -angle, 0];
    assertAlmostEqual(sum(sum(abs(result-correct))), 0);
    
    q_angle = deg2quat(angle);
    result =  target2orient([a;b], 'quat');
    correct = [ 0, 0, q_angle;
                0, -q_angle, 0];
    assertAlmostEqual(sum(sum(abs(result-correct))), 0);
    
    result =  target2orient([a], 'quat');
    correct = [ 0, 0, q_angle];
    assertAlmostEqual(sum(sum(abs(result-correct))), 0);
end


%% Test toRow
function test_toRow(testCase)
    v_row = [1,2,3];
    v_col = v_row';

    result = toRow(v_row);
    assert(all(size(result) == size(v_row)));

    result = toRow(v_col);
    assert(all(size(result) == size(v_row)));

end

%% Test rad2deg
function test_rad2deg(testCase)
    deg = [-45, 0, 90;
            -90, 0, 45];

    result = rad2deg(deg2rad(deg));
    correct = deg;

    assertAlmostEqual(min(min(abs(correct-result))), 0);

end


%% Test vector_angle
function test_vector_angle(testCase)
    v1 = [1, 0, 0;
          1, 0, 0;
          0, 1, 0;
          0, 1, 0];
    v2 = [1, 1, 0;
          sqrt(0.75), 0.5, 0;
          1, 1, 0;
          sqrt(0.75), 0.5, 0];

    result = vector_angle(v1, v2) * 180/pi;
    correct = [45, 30, 45, 60]';
    errorMag = norm(result-correct);
    assertAlmostEqual(errorMag, 0);

    result = vector_angle(v1, v2, 1) * 180/pi;
    errorMag = norm(result-correct);
    assertAlmostEqual(errorMag, 0);
    
    result = vector_angle(v1', v2', 2) * 180/pi;
    errorMag = norm(result-correct');
    assertAlmostEqual(errorMag, 0);
    
    assertAlmostEqual(vector_angle(v1(1,:), v2(1,:))*180/pi, 45);
end


%% Test vector_length
function test_vector_length(testCase)

    vectors = [1, 0, 0;
               2, 0, 0;
               1, 1, 1];

    result = vector_length(vectors);
    correct = [1, 2, sqrt(3)]';

    errorMag = norm(result-correct);
    assertAlmostEqual(errorMag, 0);
    
    assertAlmostEqual(vector_length([1,2,3]), sqrt(14));

end
