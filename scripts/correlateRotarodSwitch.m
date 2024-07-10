function correlateRotarodSwitch(rotarodData) 
% 
% 
% INPUTS:
%   rotarodData:        data structure with behavioral data for each trial, each session, each mouse
%
% OUTPUTS:
%

    trialsToAnalyze = [6 12];
    plotColors = {[124 210 233] ./ 255, [243 178 191] ./ 255, [40 140 171] ./ 255, [242 0 48] ./ 255} ;

    figure(1); clf;
    allLatencies = [];
    allSwitch = [];
    for iGroup = 1 : length(rotarodData)
        latencyData = rotarodData(iGroup).LatencyToFall(:, trialsToAnalyze);
        switchData = rotarodData(iGroup).averageSwitchTimes';
        allLatencies = [allLatencies; latencyData];
        allSwitch = [allSwitch; switchData];

        for jSession = 1 : 2
            subplot(1,2,jSession); 
            hold on;
            scatter(switchData, latencyData(:,jSession), 100, 'MarkerFaceColor', plotColors{iGroup}, 'MarkerEdgeColor', 'white');
        end
    end
        
    for iSession = 1 : 2
        subplot(1,2,iSession);
        xlim([8 14]);
        xlabel('Average Switch Time (s)');
        ylabel('Latency to Fall (s)');
        if iSession == 1
            title('4-40 rpm');
        else
            title('8-80 rpm')
        end

        % plot line of best fit
        coefficients = polyfit(allSwitch, allLatencies(:,iSession), 1);
        xFit = linspace(min(allSwitch), max(allSwitch), 1000);
        yFit = polyval(coefficients , xFit);
        hold on;
        plot(xFit, yFit, 'k-', 'LineWidth', 2); % Plot fitted line.

        currentYlimits = get(gca,'ylim');
        [r, p] = corr(allSwitch, allLatencies(:,iSession));
        text(12.3, currentYlimits(2) - 5, sprintf('r = %0.2f', r), 'FontSize', 12);
        text(12.3, currentYlimits(2) - 10, sprintf('p = %0.2f', p), 'FontSize', 12);
    end
