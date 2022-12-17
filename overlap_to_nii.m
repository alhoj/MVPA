clear
addpath('/m/nbe/scratch/braindata/shared/toolboxes/NIFTI/');
addpath('/m/nbe/scratch/braindata/shared/toolboxes/bramila/bramila/');
addpath('/m/nbe/scratch/braindata/kauppim1/scripts/clusterstats/');

% imagWoD_vs_nullWoD=data(:,1);
% imagWoD_vs_imagWD=data(:,2);
% imagWD_vs_imagWoD=data(:,3);
% imagWD_vs_nullWD=data(:,4);
% nullWoD_vs_nullWD=data(:,[7 8]);
% imag_vs_null=data(:,[9 10]);
% imagWoD_vs_nullWoD=load_nii('importance_visualization/niis/intersubject_4cats_N18_nuisanceRegressed_cat1_vs_cat2_paired-sample_t-test.nii'); imagWoD_vs_nullWoD=imagWoD_vs_nullWoD.img;
% nullWD_vs_nullWoD=load_nii('importance_visualization/niis/intersubject_4cats_N18_nuisanceRegressed_cat4_vs_cat2_paired-sample_t-test.nii'); nullWD_vs_nullWoD=nullWD_vs_nullWoD.img;
% imagWoD_vs_imagWD=load_nii('importance_visualization/niis/intersubject_4cats_N18_nuisanceRegressed_cat1_vs_cat3_paired-sample_t-test.nii'); imagWoD_vs_imagWD=imagWoD_vs_imagWD.img;
% imagWD_vs_imagWoD=load_nii('importance_visualization/niis/intersubject_4cats_N18_nuisanceRegressed_cat3_vs_cat1_paired-sample_t-test.nii'); imagWD_vs_imagWoD=imagWD_vs_imagWoD.img;
% imagWD_vs_nullWD=load_nii('importance_visualization/niis/intersubject_4cats_N18_nuisanceRegressed_cat3_vs_cat4_paired-sample_t-test.nii'); imagWD_vs_nullWD=imagWD_vs_nullWD.img;
% iwod=load_nii('importance_visualization/niis/cleaned/intersubject_4cats_N18_nuisanceRegressed_cat1_unthresholded_cleaned_th3.nii'); iwod=iwod.img;
% nwod=load_nii('importance_visualization/niis/cleaned/intersubject_4cats_N18_nuisanceRegressed_cat2_unthresholded_cleaned_th3.nii'); nwod=nwod.img;
% iwd=load_nii('importance_visualization/niis/cleaned/intersubject_4cats_N18_nuisanceRegressed_cat3_unthresholded_cleaned_th3.nii'); iwd=iwd.img;
% nwd=load_nii('importance_visualization/niis/cleaned/intersubject_4cats_N18_nuisanceRegressed_cat4_unthresholded_cleaned_th3.nii'); nwd=nwd.img;

% CwoD_vs_NwoD=load_nii('importance_visualization/niis/intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat1_vs_cat3_paired-sample_t-test.nii'); CwoD_vs_NwoD=CwoD_vs_NwoD.img;
% DwoD_vs_NwoD=load_nii('importance_visualization/niis/intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat2_vs_cat3_paired-sample_t-test.nii'); DwoD_vs_NwoD=DwoD_vs_NwoD.img;
NwD_vs_NwoD=load_nii('importance_visualization/niis/intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat6_vs_cat3_paired-sample_t-test.nii'); NwD_vs_NwoD=NwD_vs_NwoD.img;
% CwoD_vs_NwD=load_nii('importance_visualization/niis/intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat1_vs_cat6_paired-sample_t-test.nii'); CwoD_vs_NwD=CwoD_vs_NwD.img;
% DwoD_vs_NwD=load_nii('importance_visualization/niis/intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat2_vs_cat6_paired-sample_t-test.nii'); DwoD_vs_NwD=DwoD_vs_NwD.img;
% 
% CwD_vs_NwD=load_nii('importance_visualization/niis/intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat4_vs_cat6_paired-sample_t-test.nii'); CwD_vs_NwD=CwD_vs_NwD.img;
% DwD_vs_NwD=load_nii('importance_visualization/niis/intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat5_vs_cat6_paired-sample_t-test.nii'); DwD_vs_NwD=DwD_vs_NwD.img;
% CwD_vs_NwoD=load_nii('importance_visualization/niis/intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat4_vs_cat3_paired-sample_t-test.nii'); CwD_vs_NwoD=CwD_vs_NwoD.img;
% DwD_vs_NwoD=load_nii('importance_visualization/niis/intersubject_allcats_N18_nuisanceRegressed_newImposExtract_cat5_vs_cat3_paired-sample_t-test.nii'); DwD_vs_NwoD=DwD_vs_NwoD.img;

%%
resultID='overlap_allcats_IwoD_ttest05';
% overlap=intersect(find(imagWoD_vs_imagWD),find(imagWoD_vs_nullWoD));
overlap1=intersect(find(CwoD_vs_NwoD),find(DwoD_vs_NwoD));
overlap2=intersect(find(CwoD_vs_NwD),find(DwoD_vs_NwD));
overlap=intersect(overlap1,overlap2);

% overlap1=intersect(find(CwD_vs_NwD),find(DwD_vs_NwD));
% overlap2=intersect(find(CwD_vs_NwoD),find(DwD_vs_NwoD));
% overlap=intersect(overlap1,overlap2);
%%
newbrain=zeros(91,109,91);
newbrain=reshape(newbrain,91*109*91,[]);
newbrain(overlap)=1;
newbrain=reshape(newbrain,91,109,91);
filename=['./importance_visualization/niis/' resultID '.nii'];
save_nii(make_nii(newbrain),filename);
nii=bramila_fixOriginator(filename);
save_nii(nii,filename);
%%
clusterTh=2;
mask=clusterit_2mm(sign(newbrain),[],clusterTh,[]);
resultTH=newbrain.*sign(mask);
outp=getallstats(resultTH,1);
filename=['./importance_visualization/niis/cleaned/' resultID '_cleaned_clusterTh3.nii'];
save_nii(make_nii(resultTH),filename);
nii=bramila_fixOriginator(filename);
save_nii(nii,filename);