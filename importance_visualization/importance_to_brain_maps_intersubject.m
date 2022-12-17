clear
addpath(genpath('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/')) % add the path for the nifti toolbox
% auxtext='atanh'; % Put whatever you might want as a prefix for the generated nifti files
mms='2mm';
% subs=setxor(4,1:21); % exclude subject 4
% subs=setxor([10 13],1:18); % for ImageryAndNull_N18
% subs=setxor([9],1:18); % for ImageryAndNull_N18_nuisanceRegressed
subs=1:18;
nsubs=length(subs);
reps=10;
perm=0;
% resultType='intersubject_ImageryAndNull_N18_nuisanceRegressed'; 
% resultType='intersubject_ImageryAndNull3cats_N18_nuisanceRegressed';
% resultType='intersubject_ImageryAndNull_N18_nuisanceRegressed_rerun';
resultType='intersubject_CircleDiamond_WithoutD_rightCB_N18_nuisanceRegressed_newImposExtract';
% resultType='intersubject_CircleDiamond_TrainedWithoutD_TestedWithD_N18_nuisanceRegressed_newImposExtract';
resultPath=['/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/results/' resultType '/'];
curpath=pwd; % This just finds the current path

maskfilename= '/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mask_verrokit_N21.nii'; % The mask to find the locations where to put the importances
template=load_nii('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/aux_files/MNI152_T1_2mm.nii'); % The template to copy to the header

%
mask=load_nii(maskfilename);
inmask=find(mask.img);
dirtolook=sprintf('%sS_%s_%d_sub1/',resultPath,mms,perm);
res=dir([dirtolook '/rep*']);
load([dirtolook res(1).name '/' 'results.mat'])
group_data=zeros(length(inmask),size(results.impos,2),nsubs);
for subi=subs 
    disp(['loading data of subject ' num2str(subi)])
    data=zeros(length(inmask),size(results.impos,2),reps); % voxels, categories, runs
    dirtolook=sprintf('%sS_%s_%d_sub%d/',resultPath,mms,perm,subi);
    res=dir([dirtolook '/rep*']);
    for repi=1:reps
%         disp(['block ' num2str(blocki)])
        try
            load([dirtolook res(repi).name '/' 'results.mat'])
        catch 
            error('Probably you have not run as many as you claim! ')
        end
%         temp=squeeze(mean(zscore(impos),1));
%         data(results.voxels_to_keep,:,repi)=zscore(results.impos); % data(voxels,categories,blocks)
        data(results.voxels_to_keep,:,repi)=results.impos;
    end
    data(isnan(data))=0; % Replace the NaN values just in case   
    % data=mean(data,2); % categories
    data=squeeze(mean(data,3)); % blocks
    group_data(:,:,subi)=data;
end

      
%  save individual importance maps for each category
for subi=subs
    disp(['processing subject ' num2str(subi)]);
    for cati=1:size(group_data,2)
        
        newnii=vector2pic(squeeze(group_data(:,cati,subi)),maskfilename); % Make the data from vector to 3-D image
        newnii.hdr=template.hdr; % Copy the header from the template
        newnii.hdr.dime.bitpix=16; % Correct something that I don't remember what it is
        newnii.hdr.dime.datatype=16; % Correct one omre thing that I don't remember what it is

        filename=['/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/niis/' resultType '_sub' num2str(subi) '_cat' num2str(cati) '.nii']; % Set the filename for the low resolution nifti
%         filename_hires=[curpath '/importance_visualization/niis/' auxtext '_' resultType '_sub' num2str(subi) '_cat' num2str(cati) '_hires.nii'];  % Set the filename for the high resolution nifti (the same but with a "_hires" in the end)
%         filename_hires=[curpath '/importance_visualization/niis/' auxtext '_' resultType '_sub' num2str(subi) '_cat' num2str(cati) '_2mm.nii'];
        %         filename=[curpath '/importance_visualization/niis/' auxtext '_' resultType '_sub' num2str(subi) '.nii']; % Set the filename for the low resolution nifti
%         filename_hires=[curpath '/importance_visualization/niis/' auxtext '_' resultType '_sub' num2str(subi) '_hires.nii'];  % Set the filename for the high resolution nifti (the same but with a "_hires" in the end)

        save_nii(newnii,filename) % Save the nifti directly
        % Then use flirt to upsample the nifti file; remember to "ml fsl" before starting matlab
%         system(['flirt -in ' filename ' -applyxfm -init ./importance_visualization/aux_files/4mm_to_0.5mm.mat -out ' filename_hires  ' -paddingsize 0.0 -interp trilinear -ref ./importance_visualization/aux_files/mni152bet.nii'])
%         system(['flirt -in ' filename ' -applyxfm -init ./importance_visualization/aux_files/trans4to2mm.mat -out ' filename_hires  ' -paddingsize 0.0 -interp trilinear -ref ./importance_visualization/aux_files/MNI152_T1_2mm.nii'])
%         system(['gzip -df ./importance_visualization/niis/' auxtext '*.gz']) % and unzip the file (it is probably in nii.gz format)
        
    end
end

%% save group mean importance maps for each category
group_data=mean(group_data,3);
% group_data=tanh(mean(atanh(group_data),3));
% group_data=mean(group_data(:,:,group),3);
id='meanOverSubs';
% id='affectedSubsN5';
for cati=1:size(data,2)    
    
    newnii=vector2pic(squeeze(group_data(:,cati)),maskfilename); % Make the data from vector to 3-D image
    newnii.hdr=template.hdr; % Copy the header from the template
    newnii.hdr.dime.bitpix=16; % Correct something that I don't remember what it is
    newnii.hdr.dime.datatype=16; % Correct one omre thing that I don't remember what it is

    %     filename=[curpath '/niis/' auxtext '_' resultType '_sub' num2str(subi) '_cat' num2str(cati) '.nii']; % Set the filename for the low resolution nifti
    %     filename_hires=[curpath '/niis/' auxtext '_' resultType '_sub' num2str(subi) '_cat' num2str(cati) '_hires.nii'];  % Set the filename for the high resolution nifti (the same but with a "_hires" in the end)
    filename=['/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/niis/' resultType '_cat' num2str(cati) '_' id '.nii']; % Set the filename for the low resolution nifti
    %filename_hires=[curpath '/importance_visualization/niis/' auxtext '_' resultType '_cat' num2str(cati) '_meanOverSubs_hires.nii'];  % Set the filename for the high resolution nifti (the same but with a "_hires" in the end)
%     filename_hires=[curpath '/importance_visualization/niis/' auxtext '_' resultType '_cat' num2str(cati) '_' id '_2mm.nii'];
    
    save_nii(newnii,filename) % Save the nifti directly
    % Then use flirt to upsample the nifti file; remember to "ml fsl" before starting matlab
    %system(['flirt -in ' filename ' -applyxfm -init ./importance_visualization/aux_files/4mm_to_0.5mm.mat -out ' filename_hires  ' -paddingsize 0.0 -interp trilinear -ref ./importance_visualization/aux_files/mni152bet.nii'])
%     system(['flirt -in ' filename ' -applyxfm -init ./importance_visualization/aux_files/trans4to2mm.mat -out ' filename_hires  ' -paddingsize 0.0 -interp trilinear -ref ./importance_visualization/aux_files/MNI152_T1_2mm.nii'])
%     system(['gzip -df ./importance_visualization/niis/' auxtext '*.gz']) % and unzip the file (it is probably in nii.gz format)
end
    

%% save importance maps averaged over subjects and categories
% group_data=mean(group_data,2);
% newnii=vector2pic(squeeze(group_data),maskfilename); % Make the data from vector to 3-D image
% newnii.hdr=template.hdr; % Copy the header from the template
% newnii.hdr.dime.bitpix=16; % Correct something that I don't remember what it is
% newnii.hdr.dime.datatype=16; % Correct one omre thing that I don't remember what it is
% 
% %     filename=[curpath '/niis/' auxtext '_' resultType '_sub' num2str(subi) '_cat' num2str(cati) '.nii']; % Set the filename for the low resolution nifti
% %     filename_hires=[curpath '/niis/' auxtext '_' resultType '_sub' num2str(subi) '_cat' num2str(cati) '_hires.nii'];  % Set the filename for the high resolution nifti (the same but with a "_hires" in the end)
% filename=[curpath '/importance_visualization/niis/' resultType '_meanOverCats_meanOverSubs.nii']; % Set the filename for the low resolution nifti
% % filename_hires=[curpath '/importance_visualization/niis/' auxtext '_' resultType '_meanOverCats_meanOverSubs_hires.nii'];  % Set the filename for the high resolution nifti (the same but with a "_hires" in the end)
% % filename_hires=[curpath '/importance_visualization/niis/' auxtext '_' resultType '_meanOverCats_meanOverSubs_2mm.nii'];
% 
% save_nii(newnii,filename) % Save the nifti directly
% % Then use flirt to upsample the nifti file; remember to "ml fsl" before starting matlab
% % system(['flirt -in ' filename ' -applyxfm -init ./importance_visualization/aux_files/4mm_to_0.5mm.mat -out ' filename_hires  ' -paddingsize 0.0 -interp trilinear -ref ./importance_visualization/aux_files/mni152bet.nii'])
% % system(['flirt -in ' filename ' -applyxfm -init ./importance_visualization/aux_files/trans4to2mm.mat -out ' filename_hires  ' -paddingsize 0.0 -interp trilinear -ref ./importance_visualization/aux_files/MNI152_T1_2mm.nii'])
% % system(['gzip -df ./importance_visualization/niis/' auxtext '*.gz']) % and unzip the file (it is probably in nii.gz format)
