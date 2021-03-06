function [registered] = skeletonViewer(metaData, image, ctr)

registered = 0;
skeleton = metaData.JointPositions(:,:,1);
nSkeleton = metaData.IsBodyTracked(1);

SkeletonConnectionMap = [ [4 3];  % Neck
                          [3 21]; % Head
                          [21 2]; % Right Leg
                          [2 1];
                          [21 9];
                          [9 10];  % Hip
                          [10 11];
                          [11 12]; % Left Leg
                          [12 24];
                          [12 25];
                          [21 5];  % Spine
                          [5 6];
                          [6 7];   % Left Hand
                          [7 8];
                          [8 22];
                          [8 23];
                          [1 17];
                          [17 18];
                          [18 19];  % Right Hand
                          [19 20];
                          [1 13];
                          [13 14];
                          [14 15];
                          [15 16];
                        ];

% Find the indexes of the tracked bodies.
anyBodiesTracked = any(metaData.IsBodyTracked ~= 0);
trackedBodies = find(metaData.IsBodyTracked);

% Find number of Skeletons tracked.
registered = length(trackedBodies);

colorJointIndices = metaData.ColorJointIndices(:, :, trackedBodies);

if registered > 0
    imshow(image);
    title(['CaptureNumber' num2str(ctr)]); hold on;
    
    for i = 1:size(SkeletonConnectionMap,1)
        for body=1:registered
            X1 = [colorJointIndices(SkeletonConnectionMap(i,1),1,body) colorJointIndices(SkeletonConnectionMap(i,2),1,body)];
            Y1 = [colorJointIndices(SkeletonConnectionMap(i,1),2,body) colorJointIndices(SkeletonConnectionMap(i,2),2,body)];
            line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'r');
        end
    hold on;
    end
    
    fprintf(['metaData' num2str(ctr) '\n']);
    
    S = struct;
    S.('metaData') = metaData;
    S.('imageData') = image;
    
    save(['metaData' num2str(ctr)], '-struct', 'S');
    clear S;
end

end