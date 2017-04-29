% choice = questdlg('Would you like to test or train data?', ...
% 	'Gesture Recognition', ...
% 	'Test','Train','Test');
% switch choice
%     case 'Test'
%         num_runs = inf;
%     case 'Train'
%         num_runs = 60;
% end

num_runs = 60;

% Color data
vid_color = videoinput('kinect', 1);
src_color = getselectedsource(vid_color);
vid_color.FramesPerTrigger = 1;
triggerconfig(vid_color, 'manual');

% Depth data
vid_depth = videoinput('kinect', 2);
src_depth = getselectedsource(vid_depth);
src_depth.EnableBodyTracking = 'on';
vid_depth.FramesPerTrigger = 1;
triggerconfig(vid_depth, 'manual');

for ctr = 1:num_runs
    start([vid_color vid_depth]);
    trigger([vid_color vid_depth]);
    
    [frame, ts, metaData] = getdata(vid_depth);
end