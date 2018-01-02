%% test_all
% Test runner for 3D Kinematics

% authors:  ThH
% date:     Aug-2017
% ver:      0.1

test = {'test_quaternions'};

for ii = 1:length(test)
%     disp(test{ii});
    runtests(test{ii})
end
disp('Done');