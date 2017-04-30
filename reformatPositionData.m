function [formattedData] = reformatPositionData(originalData, numFrames)
% Function to reformat the position data gathered from Kinect to be able to
% plug it into the HMM functions

RightHand = 12;

for currentFrame = 1:numFrames
    for xyz = 1:3
        formattedData(currentFrame, 1, xyz) = ...
            originalData(RightHand, xyz, currentFrame);
    end
end
end