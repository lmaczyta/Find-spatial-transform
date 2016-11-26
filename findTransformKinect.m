function [ Rotation, Translation, MeanDistance] = findTransformKinect( name_file_kinect_reference, name_file_second_kinect)
% Find the transformation between two Kinects
% The inputs are 2 files which contains the measures for 2 kinects. The
% files are supposed to contain the same number of measures. Each pair of
% measure is also supposed to be taken at times close enough to assume that
% the image is the same.
% The points detected with a high confidence are the only ones taken into
% account. In order to get a high enough precision, several measures should
% be used.
% Output : the transformation between the 2 kinects. The mean distance
% between the points measured with the first kinect and the transformation
% of the measures of the second kinect is also given.


%% Searching for the transformation

[CoordinatesRef, PrecisionRef] = readMeasures(name_file_kinect_reference);
[CoordinatesTr, PrecisionTr] = readMeasures(name_file_second_kinect);


if length(PrecisionRef) ~= length(PrecisionTr)
    %fprintf('Warning : the number of measures should be the same for the 2 kinects.\nA result will still be given, but it should only be used for debug\n');
    error('Warning : the number of measures should be the same for the 2 kinects.\nA result will still be given, but it should only be used for debug\n');
    
    % For debug only, the number of measures is adjusted
    numMeasures = min(length(PrecisionRef),length(PrecisionTr));
    CoordinatesRef = CoordinatesRef(:,1:numMeasures);
    PrecisionRef = PrecisionRef(1:numMeasures);
    CoordinatesTr = CoordinatesTr(:,1:numMeasures);
    PrecisionTr = PrecisionTr(1:numMeasures);
end
    

% Only the points detected with high confidence are kept. In order to do
% this, the weights of the other points are set to a low value.
PointsRef = (PrecisionRef == 2);
PointsTr = (PrecisionTr == 2);

% 1 if the points is properly detected by the 2 kinects, 0 otherwise
PointsKept = PointsRef.*PointsTr;

% The final weights
weights = 0.99 * PointsKept + 0.01;


% Parameters of the icp algorithm
rndvec=uint32(randperm(size(CoordinatesRef,2))-1);
sizernd=ceil(1.45*size(CoordinatesRef,2));
[tmp, tmp, TreeRoot] = kdtree( CoordinatesRef', []);
nbIter = 40;

% Getting the transformation
[Rotation Translation] = icpCpp(CoordinatesRef, CoordinatesTr, weights, rndvec, sizernd, TreeRoot, nbIter);


%% Evaluating the precision transformation

% The coordinates of the second kinect transformed
CoordinatesTrReplaced = Rotation*CoordinatesTr + repmat(Translation, 1, size(CoordinatesTr, 2));

Distances = zeros(1, size(CoordinatesTr, 2));
for i=1:length(Distances)
    Distances(i) = norm(CoordinatesRef(:,i) - CoordinatesTrReplaced(:,i), 2);
end

MeanDistance = sum(Distances)/ length(Distances);




