clear; close all; clc
imaqreset;
load('TrainingSets.mat');
RightHand = 12;

% set to true if you are collecting training sets
saveDataForTrainingSets = false;
% set to true and uncomment lines 11-12 to use Jonathan's data set, set to
% false & use lines 22-23 for our collected data sets
usingJonathonsDataSets = false;

% Jonathan Hall's data sets:
% test_gesture = 'circle'
% train_gestures = {'circle' 'z' 'l' 'm' 'round' 'x'};

% Our possible test gestures:
% ccw_circle
% cw_circle_test
% noisy_cw
% noisy_right
% swipe_left
% swipe_right_test
test_gesture = 'ccw_circle';
train_gestures = {'cw_circle' 'swipe_right'};

% Add the path to the HMM gesture recognition toolkit
addpath('gesture', 'gesture/data/test', 'gesture/data/train');

if saveDataForTrainingSets
    dynamicDataCollection;
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
    if usingJonathonsDataSets
        testing = get_xyz_data('data/test',test_gesture);
        
        for trained_sets = 1:lenth(train_gestures)
            training = get_xyz_data('data/train',string(train_gestures(trained_sets)));
            successful(trained_sets) = runHmm(testing, training, string(train_gestures(trained_sets)));
        end
        
        for i = 1:trained_sets
            if successful(i) > 0.75
                strcat(string(train_gestures(i)), ': ', num2str(successful(i)*100), '%')
            end
        end
    else
        switch(test_gesture)
            case 'ccw_circle'
                testing = ccw_circle(:,:,:,RightHand);
            case 'cw_circle_test'
                testing = cw_circle_test(:,:,:,RightHand);
            case 'noisy_cw'
                testing = noisy_cw(:,:,:,RightHand);
            case 'noisy_right'
                testing = noisy_right(:,:,:,RightHand);
            case 'swipe_left'
                testing = swipe_left(:,:,:,RightHand);
            case 'swipe_right_test'
                testing = swipe_right_test(:,:,:,RightHand);
        end
        plotFigures(testing, 'Testing Figure');
        
        training = cw_circle(:,:,:,RightHand);
        successful(1) = runHmm(testing, training, 'Clockwise Circle');
        plotFigures(training, 'Clockwise Circle');
        
        training = swipe_right(:,:,:,RightHand);
        successful(2) = runHmm(testing, training, 'Swipe Right');
        plotFigures(training, 'Swipe Right');
        
        for i = 1:2
            if successful(i) > 0.75
                strcat(string(train_gestures(i)), ': ', num2str(successful(i)*100), '%')
            end
        end
    end
end