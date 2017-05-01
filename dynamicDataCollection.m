numTriggers = 1;
framesPerTrigger = 100;

% Depth data
vid_depth = videoinput('kinect', 2);
src_depth = getselectedsource(vid_depth);
src_depth.EnableBodyTracking = 'on';
vid_depth.FramesPerTrigger = framesPerTrigger;
% triggerconfig([vid_color vid_depth], 'manual');
triggerconfig(vid_depth, 'manual');
ctr = 1;
triggered = 0;
while triggered < 2
    fprintf(['run ' num2str(ctr) ' complete']);
    start(vid_depth);
    trigger(vid_depth);
    
    [frame, ts, metaData] = getdata(vid_depth);
    trackedBody = find(metaData(1).IsBodyTracked == 1);
    if ~isempty(trackedBody)
        triggered = triggered + 1
    end
    if triggered == 2
        for frame = 1:vid_depth.FramesPerTrigger
            positionData(:,:,(ctr-1)*5+frame) = metaData(frame).JointPositions(:,:,trackedBody(1));
        end
    end
end
stop(vid_depth)

positionData = reformatPositionData(positionData, framesPerTrigger*numTriggers);