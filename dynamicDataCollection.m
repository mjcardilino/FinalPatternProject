numTriggers = 1;
framesPerTrigger = 5;

% Depth data
vid_depth = videoinput('kinect', 2);
src_depth = getselectedsource(vid_depth);
src_depth.EnableBodyTracking = 'on';
vid_depth.FramesPerTrigger = framesPerTrigger;
% triggerconfig([vid_color vid_depth], 'manual');
triggerconfig(vid_depth, 'manual');
for ctr = 1:numTriggers
    fprintf(['run ' num2str(ctr) ' complete']);
    start(vid_depth);
    trigger(vid_depth);
    
    [frame, ts, metaData] = getdata(vid_depth);
    for frame = 1:vid_depth.FramesPerTrigger
        positionData(:,:,(ctr-1)*5+frame) = metaData(frame).JointPositions(:,:,1);
    end
end
stop(vid_depth)

positionData = reformatPositionData(positionData, framesPerTrigger*numTriggers);