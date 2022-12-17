clear
delete logs/*
delete jobs/*
% system('rm -r results/intrasubject/*')
% system('rm -r results/intersubject/*')

cfg = [];
cfg.data_id = 'all_classes_21subs_averagedTPs_nuisanceRegressed';
cfg.ind = 101;
cfg.svm = 0; % 1=svm, 0=nn
cfg.intra = 1; % intrasubject=1 or intersubject=0
cfg.perm = 0; % permutations or not
cfg.reps = 1;
cfg.subs = [1 2 3 5 6 7 8 10 11 12 13 15 16 17 18 19 20 21]; % subs 4, 9, 14 excluded
cfg.distractor = 13; % 0->without; 1->with; 2->combined w/ and w/out distractor cats, 3->combined imageries, 3 cats; 4->combined imageries, 4 cats; 5-> 2 cats=imag w/o D and imag w/ D; 6-> 2 cats: imag w/ D and null w/ D; 
                % 7-> 2 cats: null w/o D and null w/ D; 8-> 2 cats: imag w/o and w/ D, and null w/o and w/D; 9-> same as 4, but with data split in two; 10->circle and diamond w/out distractor; 11->train with circle and diamond w/out distractor and test with circle and diamond w/ distractor; 
                % 12 -> circle and diamond w/ distractor; 13->train with circle and diamond w/ distractor and test with circle and diamond w/out distractor
cfg.feature_selection = 3; % 0->no, 1->yes (anova), 2->use different data in FS (define in shape_dataset.m), 3-> use rois  
cfg.classification_cats = 'all';
cfg.randPart = 1; % only if cfg.distractor = 9

if cfg.svm
    classif_method = 'svm';
else
    classif_method = 'nn';
end

if cfg.intra
    blocks = 6; % how many blocks
    classif_type = 'intra';
else
    blocks = 1;
    classif_type = 'inter';
end

% roi=[201 97 85 91 205 143 123 135]+1; % larger LOTC
% LOTC=[201 97 85 91 205 143 123]; % LOTC
% IPC=[141 145 137 139]; % IPC
% SOC=[127 151 147 197 153 209]; % SOC
% IOC=[105 135 189 191 193 199 203 207]; % IOC
% rois={LOTC LOTC+1 IPC IPC+1 SOC SOC+1 IOC IOC+1};
% roi_labels={'leftLOTC','rightLOTC','leftIPC','rightIPC','leftSOC','rightSOC','leftIOC','rightIOC'};
% roi=[247, 249, 251, 254, 257, 260, 263, 266, 269, 272]; % left CB
% roi=[248, 250, 253, 256, 259, 262, 265, 268, 271, 274]; % right CB
rois = 1:210; % all cortical rois
roi_labels = strsplit(num2str(rois));

% for roii=1:length(rois)
for roii=181:210
%     cfg.roi = rois{roii};
    cfg.roi = [roii];    
    
    if cfg.distractor == 10
        cfg.results_id=[classif_method '_' classif_type 'subject_CircleDiamond_WithoutD_' roi_labels{roii} '_N18_nuisanceRegressed_newImposExtract'];
    elseif cfg.distractor == 11
        cfg.results_id=[classif_method '_' classif_type 'subject_CircleDiamond_TrainedWithoutD_TestedWithD_' roi_labels{roii} '_N18_nuisanceRegressed_newImposExtract'];
    elseif cfg.distractor == 12
        cfg.results_id=[classif_method '_' classif_type 'subject_CircleDiamond_WithD_' roi_labels{roii} '_N18_nuisanceRegressed_newImposExtract'];
    elseif cfg.distractor == 13
        cfg.results_id=[classif_method '_' classif_type 'subject_CircleDiamond_TrainedWithD_TestedWithoutD_' roi_labels{roii} '_N18_nuisanceRegressed_newImposExtract'];
    end

    for sub=1:length(cfg.subs) % how many subjects 
        cfg.sub = sub;
        for block=1:blocks
            cfg.block = block;
            function_make_script_array(cfg)
            cfg.ind = cfg.ind+1;
        end
    end
end

%% run the jobs

make_slurm_run_jobs
system('source slurm_run_jobs_auto.sh');
