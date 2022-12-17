clear
addpath(genpath('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/')) % add the path for the nifti toolbox
addpath(genpath('/m/nbe/scratch/braindata/shared/toolboxes/bramila/'))
mms='2mm';
subs=1:18;
nsubs=length(subs);

resultType='intersubject_CircleDiamond_WithoutD_leftLOTC_N18_nuisanceRegressed_newImposExtract';
resultPath=['/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/results/' resultType];
resultID='permtest_uncorrected';
th=0.05;
zscoring=0;

curpath=pwd; % This just finds the current path

template=load_nii('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/aux_files/MNI152_T1_2mm.nii'); % The template to copy to the header
maskfilename= '/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mask_verrokit_N21.nii'; % The mask to find the locations where to put the importances
mask=load_nii(maskfilename);
inmask=find(mask.img);
%%
perm=0;
reps=10;
% reps=randi(10,1)

dirtolook=sprintf('%s/S_%s_%d_sub1/',resultPath,mms,perm);
res=dir([dirtolook '/rep*']);
load([dirtolook res(1).name '/' 'results.mat'])
% load([dirtolook res(1).name '/' 'impos.mat'])
group_data=zeros(length(inmask),size(results.impos,2),nsubs);
% group_data=zeros(length(inmask),size(impos,2),nsubs);
% rng('shuffle');
% tempi=randi(10,1)
for subi=subs 
%     disp(['loading data of subject ' num2str(subi)])
    data=zeros(length(inmask),size(results.impos,2),reps); % voxels, categories, runs
    dirtolook=sprintf('%s/S_%s_%d_sub%d/',resultPath,mms,perm,subi);
    res=dir([dirtolook '/rep*']);
    for repi=1:reps
%         disp(['block ' num2str(blocki)])
        try
%             load([dirtolook res(tempi).name '/' 'results.mat'])
            load([dirtolook res(repi).name '/' 'results.mat'])
%             load([dirtolook res(repi).name '/' 'impos.mat'])
        catch 
            error('Probably you have not run as many as you claim! ')
        end
%         temp=squeeze(mean(impos,1));

%         if zscoring
%             data(results.voxels_to_keep,:,repi)=zscore(double(results.impos));
%         else
            data(results.voxels_to_keep,:,repi)=results.impos; % data(voxels,categories,reps)
%         end
%         data(results.voxels_to_keep,:,repi)=zscore(double(impos));
    end
    data(isnan(data))=0; % Replace the NaN values just in case   
    % data=mean(data,2); % categories
    data=squeeze(mean(data,3)); % reps
    if zscoring
        group_data(:,:,subi)=zscore(data);
    else
        group_data(:,:,subi)=data;
    end
end
impos_mean=squeeze(mean(group_data,3));
% impos_mean=zscore(impos_mean);
%impos_mean=squeeze(mean(zscore(group_data,3)));
%% 
perm=1;
reps=1000;
group_data_perm=zeros(length(inmask),size(results.impos,2),reps,nsubs);

for subi=subs 
    disp(['loading data of subject ' num2str(subi)])
    data=zeros(length(inmask),size(results.impos,2),reps); % voxels, categories, runs
    dirtolook=sprintf('%s/S_%s_%d_sub%d/',resultPath,mms,perm,subi);
    res=dir([dirtolook '/rep*']);
    for repi=1:reps
%         disp(['rep #' num2str(repi)])
        try
            load([dirtolook res(repi).name '/' 'results.mat'])

        catch 
            system(['rm -r ' dirtolook res(repi).name])
%             error('Probably you have not run as many as you claim! ')
        end
        if zscoring
            data(results.voxels_to_keep,:,repi)=zscore(double(results.impos));
        else
            data(results.voxels_to_keep,:,repi)=results.impos; % data(voxels,categories,reps)
        end

    end
%     data(isnan(data))=0; % Replace the NaN values just in case   
    % data=mean(data,2); % categories
%     data=squeeze(mean(data,3)); % reps
    
    group_data_perm(:,:,:,subi)=data;
end
clear data
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
       
    if zscoring
        filename=['/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/niis/' resultType '_cat' num2str(cati) '_' resultID '_zscored.nii']; % Set the filename for the low resolution nifti  
    else
        filename=['/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/niis/' resultType '_cat' num2str(cati) '_' resultID '_nonzscored.nii']; % Set the filename for the low resolution nifti    
    end
    save_nii(make_nii(newbrain),filename);
    nii=bramila_fixOriginator(filename);
    save_nii(nii,filename);
end
disp('done!')