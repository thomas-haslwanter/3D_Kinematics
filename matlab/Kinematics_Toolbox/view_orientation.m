% VIEW_ORIENTATION	Visualize a quaternion-movement
% 	This program draws an oriented arrow, and moves it as described by
%	the input "q_pos". "spacer" lets you skip every "spacer" point.
%   The last argument is optional; if provided, an avi-File is saved
%   showing the orientation-movement of the object.
%
%	Call: view_orientation(q_pos, spacer, aviFile)
%	E.g.: view_orientation(pos, 5);
%         view_orientation(pos, 1, 'test.avi');
% 
% ThH, May-2011
% Ver 1.1
% **********************

function view_orientation(q_pos, spacer, aviFile)

if nargin == 3
    videoFlag = 1;
    vidObj = VideoWriter(aviFile);
    vidObj.FrameRate = 10;
    open(vidObj);
else
    videoFlag = 0;
end

% Get the data
slim = .2;
obj.x = [1 0 0];
obj.y = [0 1 -1]*slim;
obj.z = [0 0 0]*slim;
dz = [-0.01 0.01];

col(1) = 'r';
col(2) = 'g';

q_pos = q_pos(1:spacer:end, :);

% Make the object
object = {};
for ii = 1:2
	for jj = 1:length(q_pos)
		object(ii).start= [obj.x' obj.y' obj.z'+dz(ii)];
		object(ii).rotated{jj} = rotate_vector(object(ii).start, q_pos(jj,:) );
	end
end

% Make the plot ----------------------------
close

% Draw the axes
ax(1) = line([-1 1], [0 0], [0 0]);
ax(2) = line([0 0], [-1 1], [0 0]);
ax(3) = line([0 0], [0 0], [-1 1]);

% Draw the object ...
for ii = 1:2
	object(ii).handle = patch(object(ii).start(:,1), object(ii).start(:,2), object(ii).start(:,3), col(ii));
end

% ... and move it:
for jj = 1:length(object(1).rotated)
	for ii = 1:2
		set(object(ii).handle, 'Xdata', object(ii).rotated{jj}(:,1));
		set(object(ii).handle, 'Ydata', object(ii).rotated{jj}(:,2));
		set(object(ii).handle, 'Zdata', object(ii).rotated{jj}(:,3));
		% 		shg
	end
	pause(0.08);
	drawnow;
        
	if jj == 1
		view(3);
		axis equal
        xlabel('X-axis');
        ylabel('Y-axis');
        zlabel('Z-axis');
		wh = waitbar(0, '');   
		set(wh, 'Name', 'Spinnning ...');
	else
		waitbar(jj/length(q_pos), wh);
    end
    
    if videoFlag
        currFrame = getframe;
        writeVideo(vidObj,currFrame);
    end

end
close(wh)
if videoFlag
    close(vidObj);
    disp(['Video written to ' aviFile]);
end
pause(2)
close
