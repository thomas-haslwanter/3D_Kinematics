%% test_savgol
% Tests for Savitzky-Golay filter for the "3D_Kinematics toolbox"

% -------------
% author:  ThH

%% Main function to generate tests
function tests = vectorTest

    tests = functiontests(localfunctions);

end

%% Test setup
function [delta] = setUp()

    delta = 1e-2;

end

function assertAlmostEqual(a,b)

    delta = setUp();
    assert( abs(a - b) < delta );

end

%% Test savgol
function test_sgolay(testCase)

    t = 0:0.1:20;
    x = sin(t);
    
    smoothed = savgol(x, 3, 9, 0);
    derivative = savgol(x, 3, 9, 1, 10);

    
    errorMag = norm(x-smoothed);
    assertAlmostEqual(errorMag, 0);
    
    errorMag = norm(cos(t)-derivative);
    assertAlmostEqual(errorMag, 0);
    

end
