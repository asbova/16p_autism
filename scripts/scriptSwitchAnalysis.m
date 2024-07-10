% scriptSwitchAnalysis

rootpath = '/Users/asbova/Documents/MATLAB/16p_autism';
addpath(genpath(rootpath))
cd(rootpath)


medpcFilepath = './data/medpc';
[behaviorData, sexInfo] = getAnimalGroups(medpcFilepath);
collapsedData = collapseSwitchData(behaviorData);
save(fullfile(rootpath, '/data/switchBehavior.mat'), 'collapsedData');

