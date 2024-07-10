%scriptRotarodAnalysis

rootpath = '/Users/asbova/Documents/MATLAB/16p_autism';
addpath(genpath(rootpath))
cd(rootpath)

saveDirectory = fullfile(rootpath, '/results/rotarod');

% Set up data structure.
mouseInfo = readtable('./data/mouseInfo.csv'); % Get mouse information (sex, geneotype).
rotarodData = [];
rotarodData(1).Group = 'Male WT';
rotarodData(2).Group = 'Female WT';
rotarodData(3).Group = 'Male DEL';
rotarodData(4).Group = 'Female DEL';
rotarodData(1).Mice = mouseInfo.MouseID(find(strcmp(mouseInfo.Sex, 'M') & strcmp(mouseInfo.Genotype, 'WT')));
rotarodData(2).Mice = mouseInfo.MouseID(find(strcmp(mouseInfo.Sex, 'F') & strcmp(mouseInfo.Genotype, 'WT')));
rotarodData(3).Mice = mouseInfo.MouseID(find(strcmp(mouseInfo.Sex, 'M') & strcmp(mouseInfo.Genotype, 'DEL')));
rotarodData(4).Mice = mouseInfo.MouseID(find(strcmp(mouseInfo.Sex, 'F') & strcmp(mouseInfo.Genotype, 'DEL')));
for iGroup = 1 : 4
    rotarodData(iGroup).LatencyToFall = zeros(length(rotarodData(iGroup).Mice), 12);
    rotarodData(iGroup).FinalSpeed = zeros(length(rotarodData(iGroup).Mice), 12);
end

% add weights
weightDataTable = readtable('./data/behaviorSheet_C1.csv');
for iGroup = 1 : length(rotarodData)
    currentMice = rotarodData(iGroup).Mice;
    startWeight = NaN(size(currentMice,1), 4);
    endWeight = NaN(size(currentMice,1), 4);
    for jMouse = 1 : size(currentMice,1)
        currentWeightData = weightDataTable(strcmp(weightDataTable.MouseID, char(currentMice(jMouse))),:);
        startWeight(jMouse, :) = (currentWeightData.StartingWeight_g_)';
        endWeight(jMouse, :) = (currentWeightData.EndWeight_g_)';
    end

    rotarodData(iGroup).startWeight = startWeight;
    rotarodData(iGroup).endWeight = endWeight;
end

% Identify rotarod data directories.
dataFolder = './data/rotarod'; % medPC files
dataDirectoryList = dir(dataFolder);
folderNames = {dataDirectoryList.name};
directoryFlags = ~strcmp(folderNames, '.') & ~strcmp(folderNames, '..') & ~strcmp(folderNames, '.DS_Store');
dataDirectoryList = dataDirectoryList(directoryFlags);
nFolders = length(dataDirectoryList); % Each subfolder is a day of data.

trialCount = 1;
for iFolder = 1 : nFolders % Each folder is a different day of data collection.

    cd(rootpath)
    currentDataDirectory = fullfile(dataFolder, dataDirectoryList(iFolder).name);
    cd(currentDataDirectory);
    csvFiles = dir('*.csv');
    csvFileNames = {csvFiles.name};

    % Separate files by sex (male and female) and trial number
    femaleFlags = contains(csvFileNames, 'Female');
    trialFlags{1} = contains(csvFileNames, 'T1');
    trialFlags{2} = contains(csvFileNames, 'T2');
    trialFlags{3} = contains(csvFileNames, 'T3');

    for jTrial = 1 : 3
        % Females
        currentFiles = csvFiles(femaleFlags & trialFlags{jTrial}); 
        for kFile = 1 : length(currentFiles)
            currentData = readtable(currentFiles(kFile).name, 'VariableNamingRule','preserve'); % For some reason, files load differently.
            currentData.Properties.VariableNames(1) = {'Var1'};
            if contains(currentData.Var1(1), 'Rotamex')
                currentData(1,:) = [];
            end
            
            currentIDs = currentData.Var1(17:size(currentData,1)); % Max is 4 mice.
            for lMouse = 1 : length(currentIDs)
                currentMouse = currentIDs(lMouse);
                if any(contains(rotarodData(2).Mice, currentMouse))
                    mouseRow = find(contains(rotarodData(2).Mice, currentMouse));
                    rotarodData(2).LatencyToFall(mouseRow, trialCount) = currentData.Var4(lMouse + 16);
                    rotarodData(2).FinalSpeed(mouseRow, trialCount) = currentData.Var5(lMouse + 16);
                elseif any(contains(rotarodData(4).Mice, currentMouse))
                    mouseRow = find(contains(rotarodData(4).Mice, currentMouse));
                    rotarodData(4).LatencyToFall(mouseRow, trialCount) = currentData.Var4(lMouse + 16);
                    rotarodData(4).FinalSpeed(mouseRow, trialCount) = currentData.Var5(lMouse + 16);
                end
            end
        end

        % Males
        currentFiles = csvFiles(~femaleFlags & trialFlags{jTrial}); 
        for kFile = 1 : length(currentFiles)
            currentData = readtable(currentFiles(kFile).name, 'VariableNamingRule','preserve'); % For some reason, files load differently.
            currentData.Properties.VariableNames(1) = {'Var1'};
            if contains(currentData.Var1(1), 'Rotamex')
                currentData(1,:) = [];
            end

            currentIDs = currentData.Var1(17:size(currentData,1)); % Max is 4 mice.
            for lMouse = 1 : length(currentIDs)
                currentMouse = currentIDs(lMouse);
                if any(contains(rotarodData(1).Mice, currentMouse))
                    mouseRow = find(contains(rotarodData(1).Mice, currentMouse));
                    rotarodData(1).LatencyToFall(mouseRow, trialCount) = currentData.Var4(lMouse + 16);
                    rotarodData(1).FinalSpeed(mouseRow, trialCount) = currentData.Var5(lMouse + 16);
                elseif any(contains(rotarodData(3).Mice, currentMouse))
                    mouseRow = find(contains(rotarodData(3).Mice, currentMouse));
                    rotarodData(3).LatencyToFall(mouseRow, trialCount) = currentData.Var4(lMouse + 16);
                    rotarodData(3).FinalSpeed(mouseRow, trialCount) = currentData.Var5(lMouse + 16);
                end
            end
        end
        trialCount = trialCount + 1;
    end
end
            
% Plot latency to fall for each trial
isNormalized = 0;   % set to 1 to normalize data to weight
figure('Units', 'Normalized', 'OuterPosition', [.1, 0.4, .6, 0.65]); clf;
plotRotarod(rotarodData([1 3]), [1 2], isNormalized); % 4-40 rpm
plotRotarod(rotarodData([2 4]), [3 4], isNormalized);
if isNormalized % Save figure
    saveas(gcf, fullfile(saveDirectory, 'rotarodNormalized.png'));
else
    saveas(gcf, fullfile(saveDirectory, 'rotarod.png'));
end
close all


% Look at relationship between weight and rotarod performance.
correlateWeightRotarodPerformance(rotarodData)
saveas(gcf, fullfile(saveDirectory, 'rotarodWeight.png')) % Save figure
close all


% Look at relationship between rotarod performance and switch task performance.
load(fullfile(rootpath, '/data/switchBehavior.mat'));
sessionGroup = 3;   % collapsed session group to plot

for iGroup = 1 : length(rotarodData)
    groupName = rotarodData(iGroup).Group;
    groupIDs = rotarodData(iGroup).Mice;
    if contains(groupName, 'WT')
        switchData = collapsedData.WT;
    else
        switchData = collapsedData.HET;
    end

    switchMiceIndex = find(contains(fieldnames(switchData),groupIDs));
    rotarodData(iGroup).averageSwitchTimes = switchData(sessionGroup).meanSwitchTime(switchMiceIndex);
end

correlateRotarodSwitch(rotarodData)  % plot
saveas(gcf, fullfile(saveDirectory, 'rotarodVsSwitch.png'));
close all;





    % plot the difference between start and end weights for each group (does one group lose more weight than the other)
    % does it correlate with the performance/latency to fall?