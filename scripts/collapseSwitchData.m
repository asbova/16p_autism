function collapsedStructure = collapseSwitchData(behaviorData)
% 
% 
% INPUTS:
%   behaviorData:           structure with trial by trial behavioral data for each session, each mouse, each group
%
% OUTPUTS:
%   collapsedStructure      structure with collapsed trial by trial behavioral data and average behavioral measures for
%                           the collapsed sessions for each mouse (e.g., average switch departure, CV, nospokes, etc.)
  
    
    groupNames = fieldnames(behaviorData);
    collapsedStructure = struct;
    
    % Collapse multiple sessions of data together
    for iGroup = 1 : length(groupNames)
        mouseIDs = fieldnames(behaviorData.(groupNames{iGroup}));
        for jMouse = 1 : length(mouseIDs)/2
            dateGroup1 = [behaviorData.(groupNames{iGroup}).(sprintf('%s_duration', mouseIDs{jMouse}))] > 3 & [behaviorData.(groupNames{iGroup}).(sprintf('%s_duration', mouseIDs{jMouse}))] <= 6;
            collapsedStructure.(groupNames{iGroup})(1).(mouseIDs{jMouse}) = [behaviorData.(groupNames{iGroup})(dateGroup1).(mouseIDs{jMouse})];
            
            dateGroup2 = [behaviorData.(groupNames{iGroup}).(sprintf('%s_duration', mouseIDs{jMouse}))] >= 11 & [behaviorData.(groupNames{iGroup}).(sprintf('%s_duration', mouseIDs{jMouse}))] <= 13;
            collapsedStructure.(groupNames{iGroup})(2).(mouseIDs{jMouse}) = [behaviorData.(groupNames{iGroup})(dateGroup2).(mouseIDs{jMouse})];
            
            dateGroup3 = [behaviorData.(groupNames{iGroup}).(sprintf('%s_duration', mouseIDs{jMouse}))] >= 14 & [behaviorData.(groupNames{iGroup}).(sprintf('%s_duration', mouseIDs{jMouse}))] <= 16;
            collapsedStructure.(groupNames{iGroup})(3).(mouseIDs{jMouse}) = [behaviorData.(groupNames{iGroup})(dateGroup3).(mouseIDs{jMouse})];
            
            dateGroup4 = [behaviorData.(groupNames{iGroup}).(sprintf('%s_duration', mouseIDs{jMouse}))] >= 23 & [behaviorData.(groupNames{iGroup}).(sprintf('%s_duration', mouseIDs{jMouse}))] <= 25;
            collapsedStructure.(groupNames{iGroup})(4).(mouseIDs{jMouse}) = [behaviorData.(groupNames{iGroup})(dateGroup4).(mouseIDs{jMouse})];
            
            dateGroup5 = [behaviorData.(groupNames{iGroup}).(sprintf('%s_duration', mouseIDs{jMouse}))] == 26;
            collapsedStructure.(groupNames{iGroup})(5).(mouseIDs{jMouse}) = [behaviorData.(groupNames{iGroup})(dateGroup5).(mouseIDs{jMouse})];
            
            dateGroup6 = [behaviorData.(groupNames{iGroup}).(sprintf('%s_duration', mouseIDs{jMouse}))] >= 27 & [behaviorData.(groupNames{iGroup}).(sprintf('%s_duration', mouseIDs{jMouse}))] <= 28;
            collapsedStructure.(groupNames{iGroup})(6).(mouseIDs{jMouse}) = [behaviorData.(groupNames{iGroup})(dateGroup6).(mouseIDs{jMouse})];           
        end
        collapsedStructure.(groupNames{iGroup})(1).TrainingDays = 6;
        collapsedStructure.(groupNames{iGroup})(2).TrainingDays = 11:13;
        collapsedStructure.(groupNames{iGroup})(3).TrainingDays = 14:16;
        collapsedStructure.(groupNames{iGroup})(4).TrainingDays = 23:25;
        collapsedStructure.(groupNames{iGroup})(5).TrainingDays = 26;
        collapsedStructure.(groupNames{iGroup})(6).TrainingDays = 27:28;
    end
    

    %Get average switch times, cv, etc. for each mouse
    for iGroup = 1 : length(groupNames)
        mouseIDs = fieldnames(collapsedStructure.(groupNames{iGroup})(:,1:end-1));
        for jMouse = 1 : length(mouseIDs)-1
            for kSession = 1 : size(collapsedStructure.(groupNames{iGroup}), 2)
                if ~isempty(collapsedStructure.(groupNames{iGroup})(kSession).(mouseIDs{jMouse}))
                    switchDeparts = [collapsedStructure.(groupNames{iGroup})(kSession).(mouseIDs{jMouse}).SwitchDepart];
                    ratio = [collapsedStructure.(groupNames{iGroup})(kSession).(mouseIDs{jMouse}).ratio];
                    shortRatio = [collapsedStructure.(groupNames{iGroup})(kSession).(mouseIDs{jMouse}).shortRatio];
                    longRatio = [collapsedStructure.(groupNames{iGroup})(kSession).(mouseIDs{jMouse}).longRatio];   
                    index = 1; nNosepokes = []; firstNosepoke = []; % get number of nosepokes and first nosepoke time for switch trials
                    for lTrial = 1 : size(collapsedStructure.(groupNames{iGroup})(kSession).(mouseIDs{jMouse}),2)
                        if collapsedStructure.(groupNames{iGroup})(kSession).(mouseIDs{jMouse})(lTrial).programmedDuration == 18000 & ~isempty(collapsedStructure.(groupNames{iGroup})(kSession).(mouseIDs{jMouse})(lTrial).SwitchDepart)
                            nNosepokes(index) = length(collapsedStructure.(groupNames{iGroup})(kSession).(mouseIDs{jMouse})(lTrial).ShortRsp) + length(collapsedStructure.(groupNames{iGroup})(kSession).(mouseIDs{jMouse})(lTrial).LongRsp);
                            firstNosepoke(index) = min([collapsedStructure.(groupNames{iGroup})(kSession).(mouseIDs{jMouse})(lTrial).ShortRsp collapsedStructure.(groupNames{iGroup})(kSession).(mouseIDs{jMouse})(lTrial).LongRsp]);
                            index = index + 1;
                        end
                    end
                    averageSwitch = mean(switchDeparts);
                    stDevSwitch = std(switchDeparts);
                    cvSwitch = stDevSwitch/averageSwitch;
                    nTrial = length(collapsedStructure.(groupNames{iGroup})(kSession).(mouseIDs{jMouse}));
                    nSwitchTrial = length(switchDeparts);
                    %SEMSwitch = std(data)/sqrt(length(data));
                    meanRatio = mean(ratio);
                    meanShortRatio = mean(shortRatio);
                    meanLongRatio = mean(longRatio);
                    meanNnosepokes = mean(nNosepokes);
                    meanFirstNosePoke = mean(firstNosepoke);
                else
                    switchDeparts = [];
                    ratio = [];
                    averageSwitch = mean(switchDeparts);
                    stDevSwitch = std(switchDeparts);
                    cvSwitch = stDevSwitch/averageSwitch;
                    nTrial = length(collapsedStructure.(groupNames{iGroup})(kSession).(mouseIDs{jMouse}));
                    nSwitchTrial = length(switchDeparts);
                    %SEMSwitch = std(data)/sqrt(length(data));
                    meanRatio = mean(ratio);
                end
                collapsedStructure.(groupNames{iGroup})(kSession).CV(1,jMouse) = cvSwitch;
                collapsedStructure.(groupNames{iGroup})(kSession).meanSwitchTime(1,jMouse) = averageSwitch;
                collapsedStructure.(groupNames{iGroup})(kSession).numberTrials(1,jMouse) = nTrial;
                collapsedStructure.(groupNames{iGroup})(kSession).numberSwitchTrials(1,jMouse) = nSwitchTrial;
                collapsedStructure.(groupNames{iGroup})(kSession).successRate(1,jMouse) = meanRatio;
                collapsedStructure.(groupNames{iGroup})(kSession).successRateShort(1,jMouse) = meanShortRatio;
                collapsedStructure.(groupNames{iGroup})(kSession).successRateLong(1,jMouse) = meanLongRatio;
                collapsedStructure.(groupNames{iGroup})(kSession).meanNumberNosepokes(1,jMouse) = meanNnosepokes;
                collapsedStructure.(groupNames{iGroup})(kSession).meanFirstNosepoke(1,jMouse) = meanFirstNosePoke;
            end
        end
    end




end