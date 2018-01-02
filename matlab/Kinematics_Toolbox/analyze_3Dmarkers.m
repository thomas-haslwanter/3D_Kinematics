%analyze_3Dmarkers   Calculates the x/y/z-coordinates of 3 markers
%
%   Call: [position, orientation] = analyze_3Dmarkers(MarkerPos, ReferencePos)
%   e.g.: [PosOut, OrientOut] = analyze_3Dmarkers(MarkerPos, ReferencePos)
%
%	Input:
%		MarkerPos ... 9 col, containing the x/y/z coordinates of 3 markers
%		ReferencePos ... 1x9 matrix, content as MarkerPos
%
%	Output: PosOut ... Translation of the center-of-gravity
%		OrientOut ... Orientation relative to ReferenceOrientation,
%		expressed as quaternion
%
%*****************************************************************

%	ver 2.0
%	author: ThH
%   date:   Aug-2017
% ------------------

function [position, orientation, cog_ref, refOrientation] = analyze_3Dmarkers(MarkerPos, ReferencePos)

numPoints = size(MarkerPos, 1);

% First calculate the Position of the center of gravity
cols.x = [1 4 7];
cols.y = cols.x+1;
cols.z = cols.x+2;

cog = [ (sum(MarkerPos(:, cols.x),2)), ...
    (sum(MarkerPos(:, cols.y),2)), ...
    (sum(MarkerPos(:, cols.z),2))];

cog= cog/3;

cog_ref = [ (sum(ReferencePos(:, cols.x),2)), ...
    (sum(ReferencePos(:, cols.y),2)), ...
    (sum(ReferencePos(:, cols.z),2))];

cog_ref= cog_ref/3;

position = cog  - repmat(cog_ref, numPoints, 1);

% Then the orientation
orientation = nan(numPoints, 3);

refOrientation = FindOrientation(...
    ReferencePos(1:3), ReferencePos(4:6), ReferencePos(7:9));

for ii = 1:numPoints
    % The three points define a triangle. The first rotation is such that the
    % orientation of the reference-triangle, defined as the direction
	% perpendicular to the triangle, is rotated along the shortest path to
	% the current orientation.
	% In other words, this is a rotation outside the plane spanned by the three
	% marker points.
    curOrientation = FindOrientation(...
        MarkerPos(ii,1:3), MarkerPos(ii,4:6), MarkerPos(ii,7:9));
    alpha = vector_angle(refOrientation, curOrientation);

	% Catch 0 orientation change
    if alpha>0
        n1 = cross(refOrientation, curOrientation);
        n1 = n1/norm(n1);
        q1 = n1 * sin(alpha/2);
    else
        q1 = [0 0 0];
    end

    % Now rotate the triangle into this orientation ...
    refPos_after_q1 = rotate_vector(reshape(ReferencePos,3,3)', q1);

    % ... and see which further rotation is necessary to make it fit to the
	% actual data. This is any rotation in(!) the plane spanned by the three
	% marker points
    ba_curPos = MarkerPos(ii,1:3)-MarkerPos(ii,4:6);
    ba_refPos_after_q1 = refPos_after_q1(1,:)-refPos_after_q1(2,:);
    beta = vector_angle(ba_curPos, ba_refPos_after_q1);
    
    q2 = curOrientation * sin(beta/2);

    if dot(cross(ba_refPos_after_q1,ba_curPos),curOrientation)<0
        q2 = -q2;
    end
    orientation(ii,:) = q_mult(q2, q1);
end

%*****************************************************************
% For a triangle, the orientation is given by the unit vector perpendicular
% to the triangle
function normOrientation = FindOrientation(oa, ob, oc)

ba = oa-ob;  % Original: ab= ob-oa;
bc = oc-ob;  % Original: ac= oc-oa;   
RefDir = cross(ba,bc); % Original: cross(ab,ac);
% RefDir = cross(bc,ba);  % Markers a,b,c MUST be arranged clockwise
normOrientation = RefDir / norm(RefDir);
