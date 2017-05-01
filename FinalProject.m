clear; close all; clc
imaqreset;
if exist('TrainingSets.mat')
    load('TrainingSets.mat');
end
RightHand = 12;

% set to true if you want to run this algorithm on a live input
liveInput = false;
% set to true if you are collecting and saving training sets
saveDataForTrainingSets = false;

usingJonathonsTestSet = false;
usingJonathonsDataSets = true;
usingOurDataSets = true;

saveFigures = false;

% Jonathan Hall's data sets:
% test_gesture = 'circle'
% train_gestures = {'circle' 'z' 'l' 'm' 'round' 'x'};

% Our possible test gestures:
% cw_circle_test
% swipe_right_test
% halfAndHalfTestData
test_gesture = 'halfAndHalfTestData';
% train_gestures = {'cw_circle' 'swipe_right'};
train_gestures = {'cw_circle' 'swipe_right' 'circle' 'z' 'l' 'm' 'round' 'x'};

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
            
        case 'cw_circle'
            if exist(test_gesture)
                [~, numSets, ~] = size(cw_circle);
                for somecounter = 1:3
                    cw_circle(:,numSets+1,somecounter) = positionData(:,:,somecounter);
                end
            else
                cw_circle = positionData;
            end
    end
    
    save('TrainingSets.mat', 'swipe_right', 'cw_circle', 'halfAndHalfTestData');
end

if ~saveDataForTrainingSets
    if usingJonathonsTestSet
        testing = get_xyz_data('data/test',test_gesture);
    else
        switch(test_gesture)
            case 'cw_circle_test'
                testing = cw_circle_test;
            case 'swipe_right_test'
                testing = swipe_right_test;
            case 'live_input'
                testing = positionData;
            case 'halfAndHalfTestData'
                testing = halfAndHalfTestData;
        end
    end
    
    if usingJonathonsDataSets
        for trained_sets = 3:length(train_gestures)
            training = get_xyz_data('data/train',string(train_gestures(trained_sets)));
            [successful(trained_sets), loglikelihood(:,trained_sets), threshold(trained_sets), found(:,trained_sets)] = ...
                runHmm(testing, training, string(train_gestures(trained_sets)));
            plotFigures(training, string(train_gestures(trained_sets)));
        end
    end
    
    if usingOurDataSets
        plotFigures(testing, 'Testing Figure');
        
        training = cw_circle;
        [successful(1), loglikelihood(:,1), threshold(1), found(:,1)] = runHmm(testing, training, 'Clockwise Circle');
        plotFigures(training, 'Clockwise Circle');
        
        training = swipe_right;
        [successful(2), loglikelihood(:,2), threshold(2), found(:,2)] = runHmm(testing, training, 'Swipe Right');
        plotFigures(training, 'Swipe Right');
    end
end

train_gestures
loglikelihood
threshold
found

if saveFigures
    h = get(0,'children');
    for i=1:length(h)
        saveas(h(i), ['figure' num2str(i)], 'jpg');
    end
end