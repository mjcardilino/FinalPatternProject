clear; close all; clc

% Color data
vid_color = videoinput('kinect', 1);
src_color = getselectedsource(vid_color);
vid_color.FramesPerTrigger = 1;
triggerconfig(vid_color, 'manual');
% preview(vid_color);

% Depth data
vid_depth = videoinput('kinect', 2);
src_depth = getselectedsource(vid_depth);
src_depth.EnableBodyTracking = 'on';
vid_depth.FramesPerTrigger = 1;
triggerconfig(vid_depth, 'manual');
% preview(vid_depth);

while(1)
    start(vid_color);
    start(vid_depth);

    trigger(vid_color);
    trigger(vid_depth);
    
    [frame, ts, metaData] = getdata(vid_depth);
    image = getdata(vid_color);
    skeletonViewer(metaData, image);
    pause(1);
end