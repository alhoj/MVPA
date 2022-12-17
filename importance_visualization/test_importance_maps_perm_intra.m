clear
addpath(genpath('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/')) % add the path for the nifti toolbox
addpath(genpath('/m/nbe/scratch/braindata/shared/toolboxes/bramila/'))
mms='2mm';
subs=18;
nsubs=length(subs);

resultType='intrasubject_circle-diamond-null_N18';
resultPath=['/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/results/' resultType '/'];
resultID='permtest_uncorrected';
th=0.05;

curpath=pwd; % This just finds the current path

template=load_nii('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/aux_files/MNI152_T1_2mm.nii'); % The template to copy to the header
maskfilename= '/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mask_verrokit_N21.nii'; % The mask to find the locations where to put the importances
mask=load_nii(maskfilename);
inmask=find(mask.img);
%%
perm=0;
reps=1;
blocks=6;
dirtolook=sprintf('%sS_%s_%d_sub1_block1/',resultPath,mms,perm);
res=dir([dirtolook '/rep*']);
load([dirtolook res(1).name '/' 'impos.mat'])
group_data=zeros(length(inmask),size(impos,2),length(subs));
for subi=1:subs
    data=zeros(length(inmask),size(impos,2),reps,blocks);
    for blocki=1:blocks
        dirtolook=sprintf('%sS_%s_%d_sub%d_block%d/',resultPath,mms,perm,subi,blocki);
        res=dir([dirtolook '/rep*']);
        for resi=1:reps % This defines the number of repetitions to read, if they haven't run you'll get an error
            try
                load([dirtolook res(resi).name '/' 'impos.mat'])
                load([dirtolook res(resi).name '/' 'voxels_to_keep.mat'])
            catch 
                error('Probably you have not run as many as you claim! ')
            end
            data(voxels_to_keep,:,resi,blocki)=zscore(impos); % data(voxels,categories,samples,repetitions,blocks)           
        end
    end
    disp(['subject ' num2str(subi) ' - voxels after feature selection: ' num2str(length(voxels_to_keep)) '/' num2str(length(inmask))]);
    data(isnan(data))=0; % Replace the NaN values just in case   
    % data=mean(data,2); % categories
%     data=mean(data,3); % samples
%     data=mean(data,4); % repetitions
    data=mean(data,4); % blocks
    data=squeeze(data); % -> (voxels, categories)
    group_data(:,:,subi)=data;
end
impos_mean=squeeze(mean(group_data,3));

%% perm
resultType='intrasubject_circle-diamond-null_N18_perm';
resultPath=['/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/results/' resultType '/'];
perm=1;
reps=1000;
blocks=6;
dirtolook=sprintf('%sS_%s_%d_sub1_block1/',resultPath,mms,perm);
res=dir([dirtolook '/rep*']);
load([dirtolook res(1).name '/' 'impos.mat'])
group_data_perm=zeros(length(inmask),size(impos,2),reps,length(subs));
for subi=1:subs
    disp(subi)
    data=zeros(length(inmask),size(impos,2),reps,blocks);
    for blocki=1:blocks
        
        dirtolook=sprintf('%sS_%s_%d_sub%d_block%d/',resultPath,mms,perm,subi,blocki);
        res=dir([dirtolook '/rep*']);
        for resi=1:reps % This defines the number of repetitions to read, if they haven't run you'll get an error
            disp(resi)
            try
                load([dirtolook res(resi).name '/' 'impos.mat'])
                load([dirtolook res(resi).name '/' 'voxels_to_keep.mat'])
            catch 
                error('Probably you have not run as many as you claim! ')
            end
            data(voxels_to_keep,:,resi,blocki)=zscore(impos); % data(voxels,categories,samples,repetitions,blocks)           
        end
    end
%     disp(['subject ' num2str(subi) ' - voxels after feature selection: ' num2str(length(voxels_to_keep)) '/' num2str(length(inmask))]);
    data(isnan(data))=0; % Replace the NaN values just in case   
    % data=mean(data,2); % categories
%     data=mean(data,3); % samples
%     data=mean(data,4); % repetitions
    data=mean(data,4); % blocks
%     data=squeeze(data); % 
    group_data_perm(:,:,:,subi)=data;
end
% 
impos_mean_perm=squeeze(mean(group_data_perm,4));
% impos_mean_perm=squeeze(mean(zscore(group_data_perm,4)));
% group_data_perm(find(group_data_perm<0))=0;
% impos_mean_perm_p=squeeze(mean(group_data_perm,4));
% impos_mean_z=squeeze(tanh(mean(atanh(group_data),3)));
% impos_mean_perm_z=squeeze(tanh(mean(atanh(group_data_perm),4)));
clear group_data_perm

%%
impos_mean_th=impos_mean;
for cati=1:size(impos_mean,2)
    for voxeli=1:size(impos_mean,1)

        distr_perm_mean=sort(squeeze(impos_mean_perm(voxeli,cati,:)),'descend');
        higher_perm_mean=find(distr_perm_mean>squeeze(impos_mean(voxeli,cati)),1,'last');
        if isempty(higher_perm_mean)
            higher_perm_mean = 1; 
        end
        
        pval=higher_perm_mean/reps;
        if pval>th
            impos_mean_th(voxeli,cati)=0;
        end
    end
    disp(['significant voxels, category ' num2str(cati) ': ' num2str(length(find(impos_mean_th(:,cati))))])
end


%% save permutation test thresholded group mean importance maps for each category

for cati=1:size(impos_mean_th,2) 
% for cati=1:size(impos_mean,2)
    
    newbrain=zeros(91,109,91);
    newbrain(inmask)=impos_mean_th(:,cati);
%     newbrain(inmask)=impos_mean(:,cati);
       
    filename=['/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/niis/' resultType '_cat' num2str(cati) '_' resultID '.nii']; % Set the filename for the low resolution nifti    
    save_nii(make_nii(newbrain),filename);
    nii=bramila_fixOriginator(filename);
    save_nii(nii,filename);
end
disp('done!')