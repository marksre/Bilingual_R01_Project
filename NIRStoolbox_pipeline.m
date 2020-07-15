%% Load data
datadir=uigetdir();

disp('Loading in .nirs data files...')
raw = nirs.io.loadDirectory(datadir, {'Subject','Task'});
disp('All .nirs files loaded!')
disp('-----------------------')

% set the duration to be 6 sec
for i=1:length(raw)
    for j=1:length(raw(i).stimulus.values{1}.dur)
        raw(i).stimulus.values{1}.dur(j)=6;
    end
    for j=1:length(raw(i).stimulus.values{2}.dur)
        raw(i).stimulus.values{2}.dur(j)=6;
    end
    for j=1:length(raw(i).stimulus.values{3}.dur)
        raw(i).stimulus.values{3}.dur(j)=6;
    end
end

%% First Level Analysis
disp('Running data resample...')
resample=nirs.modules.Resample();
resample.Fs=5;
downraw=resample.run(raw);

disp('Converting Optical Density...')
odconv=nirs.modules.OpticalDensity();
od=odconv.run(downraw);

disp('Applying  Modified Beer Lambert Law...')
mbll=nirs.modules.BeerLambertLaw();
hb=mbll.run(od);

disp('Trimming .nirs files...')
trim=nirs.modules.TrimBaseline();
trim.preBaseline=5;
trim.postBaseline=5;
hb_trim=trim.run(hb);

disp('Processing complete!')
disp('-----------------------')

disp('Now running subject-level GLM!')
firstlevelglm=nirs.modules.AR_IRLS();
firstlevelbasis = nirs.design.basis.Canonical();
disp('Initial GLM complete')

% Adding temporal & dispersion derivatives to canonical HRF function, DCT matrix to account for signal drift over time
firstlevelbasis.incDeriv=1;
firstlevelglm.trend_func=@(t) nirs.design.trend.dctmtx(t,0.001);
disp('Added DCT matrix + 2 derivatives')

% HRF peak time = 6s based on Friederici and Booth papers (e.g. Brauer, Neumann & Friederici, 2008, NeuroImage)
firstlevelbasis.peakTime = 6;
firstlevelglm.basis('default') = firstlevelbasis;
disp('Peak time set at 6s')

tic
SubjStats=firstlevelglm.run(hb_trim);
disp('Ready to save SubjStats...')
toc

save('SubjStats')
disp('Done!')

%% Demographics Behavioral Correlation
Demo = nirs.modules.AddDemographics();
Demo.demoTable = readtable('/Users/xiaosuhu/Documents/MATLAB/PROJECT_BilingualRO1/Demo_Variables_N83_NIRStoolbox.xlsx');
Demo.varToMatch='Subject';
SubjStats = Demo.run(SubjStats);

%% Group Level Analysis
% Run GLM with SEPARATE conditions and NO REGRESSORS. Only TASK (conditions) vs. REST
% Interaction between task and condition (compare two tasks in one model)
tic
disp('Running GroupStats1 GLM')
grouplevelpipeline=nirs.modules.MixedEffects();
grouplevelpipeline.formula ='beta ~ -1 + Task:cond + lwid_raw + age + p1_education + (1|Subject)';
GroupStats1 = grouplevelpipeline.run(SubjStats);
disp('GroupStats done!')
toc

% writetable(GroupStats1.table,'nirstool_grouplevel.xlsx');
% 
% %% Rename the stims for output
% 
% j = nirs.modules.RenameStims();
% 
% j.listOfChanges = {
%     'stim_channel1:01', 'Easy';
%     'stim_channel2:01', 'Hard';
%     'stim_channel3:01', 'Control'; };
% 
% GroupStats1=j.run(GroupStats1);
% SubjStats=j.run(SubjStats);
% 
% for i=1:10
%     writetable(SubjStats(i).table,'nirstool_subjectlevel.xlsx','Sheet',strcat('Sub',num2str(i)));
% end