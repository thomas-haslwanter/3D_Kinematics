%% test_all
% Test runner for 3D Kinematics

% authors:  ThH
% ver:      0.1

test = {'test_quaternions', 'test_rotmat', 'test_find_trajectory', 'test_vector'};
test = {'test_savgol'};

for ii = 1:length(test)
%     disp(test{ii});
    runtests(test{ii})
end
disp('Done');
