clear; close all; clc
imaqreset;
if exist('TrainingSets.mat')
    load('TrainingSets.mat');
end
RightHand = 12;

% set to true if you want to run this algorithm on a live input 
liveInput = false;
% set to true if you are collecting and saving training sets
saveDataForTrainingSets = true;
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
test_gesture = 'swipe_right';
train_gestures = {'cw_circle' 'swipe_right'};

if liveInput
    test_gesture = 'live_input';
end

% Add the path to the HMM gesture recognition toolkit
addpath('gesture', 'gesture/data/test', 'gesture/data/train');

if saveDataForTrainingSets || liveInput
    dynamicDataCollection;
    switch(test_gesture)
        case 'swipe_right'
            if exist(test_gesture)
                [~, numSets, ~] = size(swipe_right);
                for somecounter = 1:3
                    swipe_right(:,numSets+1,somecounter) = positionData(:,:,somecounter);
                end
            else
                swipe_right = positionData;
            end
            
        case 'noisy_right'
            if exist(test_gesture)
                [~, numSets, ~] = size(noisy_right);
                for somecounter = 1:3
                    noisy_right(:,numSets+1,somecounter) = positionData(:,:,somecounter);
                end
            else
                noisy_right = positionData;
            end
            
        case 'cw_circle'
            if exist(test_gesture)
                [~, numSets, ~] = size(cw_circle);
                for somecounter = 1:3
                    cw_circle(:,numSets+1,somecounter) = positionData(:,:,somecounter);
                end
            else
                cw_circle = positionData;
            end
            
        case 'noisy_cw'
            if exist(test_gesture)
                [~, numSets, ~] = size(noisy_cw);
                for somecounter = 1:3
                    noisy_cw(:,numSets+1,somecounter) = positionData(:,:,somecounter);
                end
            else
                noisy_cw = positionData;
            end
            
        case 'ccw_circle'
            if exist(test_gesture)
                [~, numSets, ~] = size(ccw_circle);
                for somecounter = 1:3
                    ccw_circle(:,numSets+1,somecounter) = positionData(:,:,somecounter);
                end
            else
                ccw_circle = positionData;
            end
            
        case 'swipe_left'
            if exist(test_gesture)
                [~, numSets, ~] = size(swipe_left);
                for somecounter = 1:3
                    swipe_left(:,numSets+1,somecounter) = positionData(:,:,somecounter);
                end
            else
                swipe_left = positionData;
            end
    end
    
%     save('TrainingSets.mat', 'swipe_right', 'cw_circle', 'ccw_circle', 'swipe_left', 'noisy_right', 'noisy_cw');
end
    
if ~saveDataForTrainingSets 
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
                testing = ccw_circle;
            case 'cw_circle_test'
                testing = cw_circle_test;
            case 'noisy_cw'
                testing = noisy_cw;
            case 'noisy_right'
                testing = noisy_right;
            case 'swipe_left'
                testing = swipe_left;
            case 'swipe_right_test'
                testing = swipe_right_test;
            case 'live_input'
                testing = positionData;
        end
        plotFigures(testing, 'Testing Figure');
        
        training = cw_circle;
        successful(1) = runHmm(testing, training, 'Clockwise Circle');
        plotFigures(training, 'Clockwise Circle');
        
        training = swipe_right;
        successful(2) = runHmm(testing, training, 'Swipe Right');
        plotFigures(training, 'Swipe Right');
        
        for i = 1:2
            if successful(i) > 0.75
                strcat(string(train_gestures(i)), ': ', num2str(successful(i)*100), '%')
            end
        end
    end
end