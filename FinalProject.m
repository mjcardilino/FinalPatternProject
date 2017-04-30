clear; close all; clc
imaqreset;

% load('TrainingSets.mat');

saveDataForTrainingSets = true;

test_gesture = 'somegesture';
train_gestures = {'circle' 'z' 'l' 'm' 'round' 'x'};

% Add the path to the HMM gesture recognition toolkit
addpath('gesture', 'gesture/data/test', 'gesture/data/train');

dynamicDataCollection;

if saveDataForTrainingSets
    switch(test_gesture)
        case 'somegesture'
            if exist(test_gesture)
                [~, numSets, ~, ~] = size(somegesture);
                somegesture = positionData;
                somegesture(:,numSets+1,:,:) = positionData;
            else
                somegesture = positionData;
            end
    end
else
    for trained_sets = 1:length(train_gestures)
        if trained_sets <= 6
            training = get_xyz_data('data/train',string(train_gestures(trained_sets)));
            testing = get_xyz_data('data/test',test_gesture);
        end
        
        successful(trained_sets) = runHmm(testing, training, string(train_gestures(trained_sets)));
    end
    
    for i = 1:trained_sets
        if successful(i) > 0.75
            strcat(string(train_gestures(i)), ': ', num2str(successful(i)*100), '%')
        end
    end
end