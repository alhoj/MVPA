clear 

addpath(genpath('/m/nbe/scratch/braindata/shared/toolboxes/bramila//bramila'));
addpath('/m/nbe/scratch/braindata/shared/toolboxes/bramila/bramila/external/clusterstats/')
nii=load_nii('importance_visualization/niis/cleaned/overlap_imagWoD_ttest05_cleaned_clusterTh3.nii');
temp=nii.img;
th_pos=0.5;
th_neg=-0.5;
temp(intersect(find(temp<=th_pos),find(temp>=0)))=0;
temp(intersect(find(temp>=th_neg),find(temp<=0)))=0;
tempmask=clusterit(abs(sign(temp)),1,3,[]);
resultTH=temp.*sign(tempmask);
fprintf('\n')
outp=getallstats(resultTH,1);
fprintf('\n')
outn=getallstats(resultTH,-1);
filename=['dynISC_10TRwin_patients_vs_controls_tstat_negReg_Arousal_cdtP05_pcc.nii'];
save_nii(make_nii(resultTH),filename);
nii=fixOriginator(filename);
save_nii(nii,filename);