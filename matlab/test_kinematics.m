%% Main function to generate tests
function tests = kinematicsTest
tests = functiontests(localfunctions);
end

%% Test Functions
function testFunctionNormalize(testCase)
    delta = 1e-5;
    result = normalize([3, 0, 0]);
    correct = [ 1.,  0.,  0.];
    error = norm(result-correct);
    assert(error < delta);   
end

%% Optional file fixtures  
function setupOnce(testCase)  % do not change function name
	% e.g. change path
end

function teardownOnce(testCase)  % do not change function name
% change back to original path, for example
end

%% Optional fresh fixtures  
function setup(testCase)  % do not change function name
% open a figure, for example
end

function teardown(testCase)  % do not change function name
% close figure, for example
end