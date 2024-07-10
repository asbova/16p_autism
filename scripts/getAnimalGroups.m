function [behaviorData, sexInfo] = getAnimalGroups(medpcFilepath)
% 
% 
% INPUTS:
%   medpcFilepath:          directory pathway of folder that contains medpc output with raw behavioral data
%
% OUTPUTS:
%   behaviorData:           structure with trial by trial behavioral data for each session, each mouse, each group
%   sexInfo:                structure with the sex of each mouse within each group
    
    protocols = {'Switch_18L6R_SITI_REINFORCE' 'Switch_6L18R_SITI_REINFORCE'};
    
    group.WT = {...
        {'2024-03-05' '2024-03-06' '2024-04-08', 'A811', 'm'} ...
        {'2024-03-05' '2024-03-06' '2024-04-08', 'A800', 'm'} ...
        {'2024-03-05' '2024-03-06' '2024-04-08', 'A803', 'm'} ...
        {'2024-03-05' '2024-03-06' '2024-04-08', 'A812', 'm'} ...
        {'2024-03-05' '2024-03-06' '2024-04-08', 'A777', 'f'} ...
        {'2024-03-05' '2024-03-06' '2024-04-08', 'A796', 'f'} ...
        {'2024-03-05' '2024-03-06' '2024-04-08', 'A805', 'f'} ...
        {'2024-03-05' '2024-03-06' '2024-04-08', 'A806', 'f'} ...
        };
    
    group.HET = {...
        {'2024-03-05' '2024-03-06' '2024-04-08', 'A810', 'm'} ...
        {'2024-03-05' '2024-03-06' '2024-04-08', 'A813', 'm'} ...
        {'2024-03-05' '2024-03-06' '2024-04-08', 'A779', 'f'} ...
        {'2024-03-05' '2024-03-06' '2024-04-08', 'A780', 'f'} ...
        {'2024-03-05' '2024-03-06' '2024-04-08', 'A795', 'f'} ...
        {'2024-03-05' '2024-03-06' '2024-04-08', 'A799', 'f'} ...
        };
    
        
    groupNames = fieldnames(group);
    duration = struct;
    sexInfo = struct;
    for iGroup = 1 : length(groupNames)
        mpcParsed = [];
        counter = 1;
        for jMouse = 1 : length(group.(groupNames{iGroup}))
            dateRange = {group.(groupNames{iGroup}){1,jMouse}{1,2} group.(groupNames{iGroup}){1,jMouse}{1,3}};
            mpc = getDataIntr(medpcFilepath, protocols, group.(groupNames{iGroup}){1,jMouse}{1,4}, dateRange);
            mpcParsed = [mpcParsed, mpc];
            animalID = group.(groupNames{iGroup}){1,jMouse}{1,4};
            sexInfo.(groupNames{iGroup}).(animalID) = group.(groupNames{iGroup}){1,jMouse}{1,5};
            for kSession = 1:length(mpc)
                warning off
                dur = split(between(datetime(group.(groupNames{iGroup}){1,jMouse}{1,1}), datetime(mpcParsed(counter).StartDate, 'InputFormat', 'MM/dd/yy'), {'days'}), 'days');
                warning on
                label = sprintf('%s_duration', mpc(1).Subject);
                duration.(groupNames{iGroup})(kSession).(label) = dur;
                counter = counter + 1;
            end
        end
    behaviorData.(groupNames{iGroup}) = getTrialData(mpcParsed);
    x = behaviorData.(groupNames{iGroup});
    y = duration.(groupNames{iGroup});
    behaviorData.(groupNames{iGroup}) = cell2struct([struct2cell(x); struct2cell(y)], [fieldnames(x); fieldnames(y)]);
    end