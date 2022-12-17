clear
addpath(genpath('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/')) % add the path for the nifti toolbox
% auxtext='atanh'; % Put whatever you might want as a prefix for the generated nifti files
mms='2mm';
nsub=18;
blocks=6;
reps=1;
perm=0;
group=[1 2 3 5 6 7 8 10 11 12 13 15 16 17 18 19 20 21];
resultType='intrasubject_circle-diamond-null_N18'; % intrasubject or intersubject
resultPath=['/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/results/' resultType '/'];
curpath=pwd; % This just finds the current path

%maskfilename= './importance_visualization/aux_files/mask_2mm.nii'; % The mask to find the locations where to put the importances
maskfilename= '/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mask_verrokit_N21.nii';
template=load_nii('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/aux_files/MNI152_T1_2mm.nii'); % The template to copy to the header

%%
mask=load_nii(maskfilename);
inmask=find(mask.img);
dirtolook=sprintf('%sS_%s_%d_sub1_block1/',resultPath,mms,perm);
res=dir([dirtolook '/rep*']);
load([dirtolook res(1).name '/' 'impos.mat'])
group_data=zeros(length(inmask),size(impos,2),nsub);
for subi=1:nsub
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
%     disp(['subject ' num2str(subi) ' - voxels after feature selection: ' num2str(length(voxels_to_keep)) '/' num2str(length(inmask))]);
    data(isnan(data))=0; % Replace the NaN values just in case   
    % data=mean(data,2); % categories
%     data=mean(data,3); % samples
    data=mean(data,3); % repetitions
    data=mean(data,4); % blocks
    data=squeeze(data); % -> (voxels, categories)
    group_data(:,:,subi)=data;
end

%%  save individual importance maps for each category
for subi=1:nsub
    disp(['processing subject ' num2str(subi)]);
    for cati=1:size(group_data,2)
        
        newnii=vector2pic(squeeze(group_data(:,cati,subi)),maskfilename); % Make the data from vector to 3-D image
        newnii.hdr=template.hdr; % Copy the header from the template
        newnii.hdr.dime.bitpix=16; % Correct something that I don't remember what it is
        newnii.hdr.dime.datatype=16; % Correct one omre thing that I don't remember what it is

        filename=[curpath '/importance_visualization/niis/' resultType '_sub' num2str(subi) '_cat' num2str(cati) '.nii']; % Set the filename for the low resolution nifti
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
% group_data=mean(group_data,3);
group_data=tanh(mean(atanh(group_data),3));
% group_data=mean(group_data(:,:,group),3);
id='meanOverSubs';
% id='affectedSubsN10';
for cati=1:size(data,2)    
    
    newnii=vector2pic(squeeze(group_data(:,cati)),maskfilename); % Make the data from vector to 3-D image
    newnii.hdr=template.hdr; % Copy the header from the template
    newnii.hdr.dime.bitpix=16; % Correct something that I don't remember what it is
    newnii.hdr.dime.datatype=16; % Correct one omre thing that I don't remember what it is

    %     filename=[curpath '/niis/' auxtext '_' resultType '_sub' num2str(subi) '_cat' num2str(cati) '.nii']; % Set the filename for the low resolution nifti
    %     filename_hires=[curpath '/niis/' auxtext '_' resultType '_sub' num2str(subi) '_cat' num2str(cati) '_hires.nii'];  % Set the filename for the high resolution nifti (the same but with a "_hires" in the end)
    filename=[curpath '/importance_visualization/niis/' resultType '_cat' num2str(cati) '_' id '.nii']; % Set the filename for the low resolution nifti
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
% filename=[curpath '/importance_visualization/niis/' auxtext '_' resultType '_meanOverCats_meanOverSubs.nii']; % Set the filename for the low resolution nifti
% % filename_hires=[curpath '/importance_visualization/niis/' auxtext '_' resultType '_meanOverCats_meanOverSubs_hires.nii'];  % Set the filename for the high resolution nifti (the same but with a "_hires" in the end)
% % filename_hires=[curpath '/importance_visualization/niis/' auxtext '_' resultType '_meanOverCats_meanOverSubs_2mm.nii'];
% 
% save_nii(newnii,filename) % Save the nifti directly
% Then use flirt to upsample the nifti file; remember to "ml fsl" before starting matlab
% system(['flirt -in ' filename ' -applyxfm -init ./importance_visualization/aux_files/4mm_to_0.5mm.mat -out ' filename_hires  ' -paddingsize 0.0 -interp trilinear -ref ./importance_visualization/aux_files/mni152bet.nii'])
% system(['flirt -in ' filename ' -applyxfm -init ./importance_visualization/aux_files/trans4to2mm.mat -out ' filename_hires  ' -paddingsize 0.0 -interp trilinear -ref ./importance_visualization/aux_files/MNI152_T1_2mm.nii'])
% system(['gzip -df ./importance_visualization/niis/' auxtext '*.gz']) % and unzip the file (it is probably in nii.gz format)
