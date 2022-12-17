% cleans ripples; i.e. removes clusters smaller than
clear


addpath('/m/nbe/scratch/braindata/shared/toolboxes/NIFTI/');
addpath('/m/nbe/scratch/braindata/shared/toolboxes/bramila/bramila/');
addpath('/m/nbe/scratch/braindata/kauppim1/scripts/clusterstats/');

th=3; % removes clusters smaller than this number^3 voxels

path='/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/niis/';
% path='/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/';
%
files={
%     'overlap_imagWoD_ttest05'
%     'intersubject_CircleDiamond_WithoutD_rightCB_N18_nuisanceRegressed_newImposExtract_cat2_meanOverSubs'

%     'intersubject_CircleDiamond_WithoutD_leftCB_N18_nuisanceRegressed_newImposExtract_cat1_meanOverSubs'
%     'intersubject_CircleDiamond_WithoutD_leftCB_N18_nuisanceRegressed_newImposExtract_cat2_meanOverSubs'
%     'intersubject_CircleDiamond_WithoutD_rightCB_N18_nuisanceRegressed_newImposExtract_cat1_meanOverSubs'
%     'intersubject_CircleDiamond_WithoutD_rightCB_N18_nuisanceRegressed_newImposExtract_cat2_meanOverSubs'
%     'intersubject_CircleDiamond_WithoutD_rightSOC_N18_nuisanceRegressed_newImposExtract_cat1_meanOverSubs'
%     'intersubject_CircleDiamond_WithoutD_rightSOC_N18_nuisanceRegressed_newImposExtract_cat2_meanOverSubs'
    'intersubject_CircleDiamond_WithoutD_leftIPC_N18_nuisanceRegressed_newImposExtract_cat1_meanOverSubs'
%     'intersubject_CircleDiamond_WithoutD_leftIPC_N18_nuisanceRegressed_newImposExtract_cat2_meanOverSubs'
%     'intersubject_CircleDiamond_WithoutD_leftLOTC_N18_nuisanceRegressed_newImposExtract_cat1_meanOverSubs'
%     'intersubject_CircleDiamond_WithoutD_leftLOTC_N18_nuisanceRegressed_newImposExtract_cat2_meanOverSubs'
%     'intersubject_CircleDiamond_WithoutD_rightIOC_N18_nuisanceRegressed_newImposExtract_cat1_meanOverSubs'
%     'intersubject_CircleDiamond_WithoutD_rightIOC_N18_nuisanceRegressed_newImposExtract_cat2_meanOverSubs'
%     'intersubject_CircleDiamond_WithoutD_rightIOC_N18_nuisanceRegressed_newImposExtract_cat1_permtest_uncorrected_zscored'
%     'intersubject_CircleDiamond_WithoutD_rightIOC_N18_nuisanceRegressed_newImposExtract_cat2_permtest_uncorrected_zscored'
%     'intersubject_CircleDiamond_WithoutD_N18_nuisanceRegressed_newImposExtract_cat1_permtest_uncorrected_zscored'
%     'intersubject_CircleDiamond_WithoutD_N18_nuisanceRegressed_newImposExtract_cat2_permtest_uncorrected_zscored'
%     'intersubject_CircleDiamond_TrainedWithoutD_TestedWithD_N18_nuisanceRegressed_newImposExtract_cat1_permtest_uncorrected_zscored'
%     'intersubject_CircleDiamond_TrainedWithoutD_TestedWithD_N18_nuisanceRegressed_newImposExtract_cat2_permtest_uncorrected_zscored'
%     'intersubject_CircleDiamond_TrainedWithoutD_TestedWithD_N18_nuisanceRegressed_newImposExtract_cat1_meanOverSubs'
%     'intersubject_CircleDiamond_TrainedWithoutD_TestedWithD_N18_nuisanceRegressed_newImposExtract_cat2_meanOverSubs'
%     'intersubject_CircleDiamond_WithoutD_N18_nuisanceRegressed_newImposExtract_cat1_meanOverSubs'
%     'intersubject_CircleDiamond_WithoutD_N18_nuisanceRegressed_newImposExtract_cat2_meanOverSubs'
%     'intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat1_meanOverSubs'
%     'intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat2_meanOverSubs'
%     'intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat3_meanOverSubs'
%     'intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat4_meanOverSubs'
%     'intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat5_meanOverSubs'
%     'intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat6_meanOverSubs'
% 'intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat6_vs_cat3_paired-sample_t-test'
% 'intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat1_vs_cat3_paired-sample_t-test'
% 'intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat2_vs_cat3_paired-sample_t-test'
%    'intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat2_permtest_uncorrected_zscored'
%    'intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat1_permtest_uncorrected_zscored'
%    'intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat6_permtest_uncorrected_zscored'
};
%% loading data

mask=load_nii('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mask_verrokit_N21.nii');
maskFS=load_nii('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/mask_4catsFS.nii'); 
inmask = find(mask.img);
inmaskFS=find(maskFS.img);

data=zeros(91,109,91,length(files));
for i=1:length(files)
    temp=load_nii([path files{i} '.nii']);
    data(:,:,:,i)=temp.img;
end
data=reshape(data,91*109*91,[]);
% data(find(data<0))=0;
data=data(inmaskFS,:);
%% thresholding


% for i=1:length(files)
%     temp=data(:,i);
%     thi=quantile(temp(find(temp)),0.95);
%     temp(find(temp<thi))=0; % thresholding categories separately
%     data(:,i)=temp;
% %     data(find(data(:,i)<quantile(data(:),0.95)),i)=0; % thresholding categories together
% end

num=408;
% perc=10;
for i=1:length(files)
%     num=round(length(find(data(:,i)))*(perc/100));
%     num=length(find(zscore(find(data(:,i)))>0))
    temp=data(:,i);
    sorted=sort(temp(find(temp)),'descend');
    if length(sorted)>num
        thi=sorted(num);
        temp(find(temp<thi))=0; % thresholding categories separately
    end
    
    data(:,i)=temp;
end

temp=zeros(91*109*91,length(files));
temp(inmaskFS,:)=data;
data=temp;
% data(setxor(1:size(data,1),inmaskFS),:)=0;

%% clustering & saving files

data=reshape(data,91,109,91,length(files));
for i=1:length(files)
    mask=clusterit_2mm(abs(sign(data(:,:,:,i))),[],th,[]);
%     mask=clusterit_2mm(sign(data(:,:,:,i)),1,th,10);
%     mask=clusterit_2mm(sign(data(:,:,:,i)),1,th,[]);
%     filename=[path files{i} '_CCth' num2str(th) '_clusterMask.nii'];
%     save_nii(make_nii(mask),filename);
%     nii=bramila_fixOriginator(filename);
%     save_nii(nii,filename);
    
    resultTH=data(:,:,:,i).*sign(mask);
    outp{i}=getallstats(resultTH,1);
    %     outn{i}=getallstats(resultTH,-1);
%     filename=[path 'cleaned/' files{i} '_cleaned_th' num2str(th) '_top5percent.nii'];
%     filename=[path 'cleaned/' files{i} '_cleaned_th' num2str(th) '_top' num2str(num) 'vals.nii'];
%     filename=[path 'cleaned/' files{i} '_cleaned_th' num2str(th) '_top' num2str(perc) 'percent.nii'];
%     filename=[path 'cleaned/' files{i} '_cleaned_th' num2str(th) '_posVals.nii'];
%     filename=[path 'cleaned/' files{i} '_cleaned_th' num2str(th) '.nii'];
%     save_nii(make_nii(resultTH),filename);
%     nii=bramila_fixOriginator(filename);
%     save_nii(nii,filename);
end
