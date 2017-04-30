% choice = questdlg('Would you like to test or train data?', ...
% 	'Gesture Recognition', ...
% 	'Test','Train','Test');
% switch choice
%     case 'Test'
%         num_runs = inf;
%     case 'Train'
%         num_runs = 20;
% end

numTriggers = 20;
framesPerTrigger = 5;

% Color data
% vid_color = videoinput('kinect', 1);
% src_color = getselectedsource(vid_color);
% vid_color.FramesPerTrigger = 1;

% Depth data
vid_depth = videoinput('kinect', 2);
src_depth = getselectedsource(vid_depth);
src_depth.EnableBodyTracking = 'on';
vid_depth.FramesPerTrigger = framesPerTrigger;
% triggerconfig([vid_color vid_depth], 'manual');
triggerconfig(vid_depth, 'manual');
for ctr = 1:numTriggers
    fprintf(['run ' num2str(ctr) ' complete']);
%     start([vid_color vid_depth]);
    start(vid_depth);
%     trigger([vid_color vid_depth]);
    trigger(vid_depth);
    
    [frame, ts, metaData] = getdata(vid_depth);
    for frame = 1:vid_depth.FramesPerTrigger
        positionData(:,:,(ctr-1)*5+frame) = metaData(frame).JointPositions(:,:,1);
    end
end

positionData = reformatPositionData(positionData, framesPerTrigger*numTriggers);
stop(vid_depth)