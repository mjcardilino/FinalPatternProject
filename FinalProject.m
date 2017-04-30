clear; close all; clc
imaqreset;

test_gesture = 'circle';
train_gestures = {'circle' 'z' 'l' 'm' 'round' 'x'};

% Add the path to the HMM gesture recognition toolkit
addpath('gesture', 'gesture/data/test', 'gesture/data/train');

dynamicDataCollection;

for trained_sets = 1:length(train_gestures)
    if trained_sets <= 6
        training = get_xyz_data('data/train',string(train_gestures(trained_sets)));
        testing = get_xyz_data('data/test',test_gesture);
    end
    
    successful(trained_sets) = runHmm(testing, training, string(train_gestures(trained_sets)));
end