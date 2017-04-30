function [] = plotFigures(dataToPlot, plotTitle)
colors = ['r' 'g' 'b' 'k' 'c'];
figure; hold on;
title(plotTitle)
if strcmp(plotTitle, 'Testing Figure')
    plot3(dataToPlot(:,:,1), dataToPlot(:,:,2), dataToPlot(:,:,3));
else
    for i = 1:15
        plot3(dataToPlot(:,i,1), dataToPlot(:,i,2), dataToPlot(:,i,3), ...
            colors(mod(i,5)+1));
    end
end