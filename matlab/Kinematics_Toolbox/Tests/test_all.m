%% test_all
% Test runner for 3D Kinematics

% authors:  ThH
% ver:      0.1

test = {'test_quaternions', 'test_rotmat', 'test_savgol', 'test_find_trajectory', 'test_vector'};

for ii = 1:length(test)
%     disp(test{ii});
    runtests(test{ii})
end
disp('Done');
