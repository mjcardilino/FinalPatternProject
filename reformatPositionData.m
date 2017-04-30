function [formattedData] = reformatPositionData(originalData, numFrames)
% Function to reformat the position data gathered from Kinect to be able to
% plug it into the HMM functions

numJoints = 25;

for currentJoint = 1:numJoints
    for currentFrame = 1:numFrames
        for xyz = 1:3
            formattedData(currentFrame, 1, xyz, currentJoint) = ...
                originalData(currentJoint, xyz, currentFrame);
        end
    end
end
end