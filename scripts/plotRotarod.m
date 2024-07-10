function plotRotarod(rotarodData, plotIndex, isNormalized)
% 
% 
% INPUTS:
%   rotarodData:        data structure with behavioral data for each trial, each session, each mouse
%   plotIndex:          
%
% OUTPUTS:
%

    if contains(rotarodData(1).Group, 'Female')
        plotColors = {[243 178 191] ./ 255, [242 0 48] ./ 255} ;
    else
        plotColors = {[124 210 233] ./ 255, [40 140 171] ./ 255} ;
    end

    if isNormalized
        weightsWT = rotarodData(1).startWeight;
        weightsDEL = rotarodData(2).startWeight;
    else
        weightsWT = ones(length(rotarodData(1).Mice), 4);
        weightsDEL = ones(length(rotarodData(2).Mice), 4);
    end

    % Plot 4-40 latency to fall.
    latencyDataWT(:,1:3) = rotarodData(1).LatencyToFall(:,1:3)./weightsWT(:,1);
    latencyDataWT(:,4:6) = rotarodData(1).LatencyToFall(:,4:6)./weightsWT(:,2);
    latencyDataDEL(:,1:3) = rotarodData(2).LatencyToFall(:,1:3)./weightsDEL(:,1);
    latencyDataDEL(:,4:6) = rotarodData(2).LatencyToFall(:,4:6)./weightsDEL(:,2);
    meanLatencyData(:,1) = mean(latencyDataWT, 1)';
    meanLatencyData(:,2) = mean(latencyDataDEL, 1)';
    subplot(2,2,plotIndex(1));
    cla; hold on;
    plotBarWithJitter(latencyDataWT, latencyDataDEL, meanLatencyData, plotColors);
    if ~isNormalized
        ylabel('Latency to Fall (s)');
    else
        ylabel({'Latency to Fall (s)'; 'Normalized to Weight'})
    end
    xticks(1:6)
    xlabel('Trials')
    title('4-40 rpm')

    % Plot 8-80 latency to fall.
    latencyDataWT(:,1:3) = rotarodData(1).LatencyToFall(:,7:9)./weightsWT(:,1);
    latencyDataWT(:,4:6) = rotarodData(1).LatencyToFall(:,10:12)./weightsWT(:,2);
    latencyDataDEL(:,1:3) = rotarodData(2).LatencyToFall(:,7:9)./weightsDEL(:,1);
    latencyDataDEL(:,4:6) = rotarodData(2).LatencyToFall(:,10:12)./weightsDEL(:,2);
    meanLatencyData(:,1) = mean(latencyDataWT, 1)';
    meanLatencyData(:,2) = mean(latencyDataDEL, 1)';
    subplot(2,2,plotIndex(2));
    cla; hold on;
    plotBarWithJitter(latencyDataWT, latencyDataDEL, meanLatencyData, plotColors);
    if ~isNormalized
        ylabel('Latency to Fall (s)');
    else
        ylabel({'Latency to Fall (s)'; 'Normalized to Weight'})
    end
    xticks(1:6)
    xlabel('Trials')
    title('8-80 rpm')

end



function plotBarWithJitter(group1Data, group2Data, meanData, plotColors)    
    b = bar(meanData, 'FaceColor', 'flat');
    for iGroup = 1 : 2
        b(iGroup).CData = plotColors{iGroup};
    end
    legend('WT', '16pDEL', 'AutoUpdate', 'off', 'Location', 'northwest')

    for iTrial = 1 : size(group1Data, 2)
        for jMouse = 1 : size(group1Data, 1)
            pm = plot((iTrial)-0.2 + 0.1*jMouse/length(group1Data), group1Data(jMouse, iTrial), 'ko');
            set(pm, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k', 'MarkerSize', 3); 
        end
    end
    for iTrial = 1 : size(group2Data, 2)
        for jMouse = 1 : size(group2Data, 1)
            pm = plot((iTrial)+0.1 + 0.15*jMouse/length(group2Data), group2Data(jMouse, iTrial), 'k*');
            set(pm, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k', 'MarkerSize', 3); 
        end
    end
end

    
    