clear; close all; clc
imaqreset;

load('TrainingSets.mat');

saveDataForTrainingSets = true;

test_gesture = 'noisy_cw';
train_gestures = {'circle' 'z' 'l' 'm' 'round' 'x' 'swipe_right'};

% Add the path to the HMM gesture recognition toolkit
addpath('gesture', 'gesture/data/test', 'gesture/data/train');

dynamicDataCollection;

if saveDataForTrainingSets
    switch(test_gesture)
        case 'swipe_right'
            if exist(test_gesture)
                [~, numSets, ~, ~] = size(swipe_right);
                swipe_right = positionData;
                swipe_right(:,numSets+1,:,:) = positionData;
            else
                swipe_right = positionData;
            end
            
        case 'noisy_right'
            if exist(test_gesture)
                [~, numSets, ~, ~] = size(noisy_right);
                noisy_right = positionData;
                noisy_right(:,numSets+1,:,:) = positionData;
            else
                noisy_right = positionData;
            end
            
        case 'cw_circle'
            if exist(test_gesture)
                [~, numSets, ~, ~] = size(cw_circle);
                cw_circle = positionData;
                cw_circle(:,numSets+1,:,:) = positionData;
            else
                cw_circle = positionData;
            end
            
        case 'noisy_cw'
            if exist(test_gesture)
                [~, numSets, ~, ~] = size(noisy_cw);
                noisy_cw = positionData;
                noisy_cw(:,numSets+1,:,:) = positionData;
            else
                noisy_cw = positionData;
            end
            
        case 'ccw_circle'
            if exist(test_gesture)
                [~, numSets, ~, ~] = size(ccw_circle);
                ccw_circle = positionData;
                ccw_circle(:,numSets+1,:,:) = positionData;
            else
                ccw_circle = positionData;
            end
            
        case 'swipe_left'
            if exist(test_gesture)
                [~, numSets, ~, ~] = size(swipe_left);
                swipe_left = positionData;
                swipe_left(:,numSets+1,:,:) = positionData;
            else
                swipe_left = positionData;
            end
    end
    
    save('TrainingSets.mat', 'swipe_right', 'cw_circle', 'ccw_circle', 'swipe_left', 'noisy_right', 'noisy_cw');
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