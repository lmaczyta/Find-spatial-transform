% A script which finds the transformation of all the kinects
 
% Compile the c++ files which will be used to compute the icp (not necessary if it is already done).
try
    make
end

nameFileKinectReference = 'PositionA.txt';
nameFileKinectB = 'PositionB.txt';
nameFileKinectC = 'PositionC.txt';
 
[RotationAB TranslationAB MeanDistanceAB] = findTransformKinect(nameFileKinectReference, nameFileKinectB);
[RotationAC TranslationAC MeanDistanceAC] = findTransformKinect(nameFileKinectReference, nameFileKinectC);

% In order to place a point P = (x;y;z) of B in the same system of coordinates than A,
% the operation to do is:
% P = RotationAB * P + TranslationAB;

