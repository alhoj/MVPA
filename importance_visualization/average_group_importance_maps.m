clear
addpath('/m/nbe/scratch/braindata/shared/toolboxes/NIFTI/');
addpath('/m/nbe/scratch/braindata/shared/toolboxes/bramila/bramila/')
datapath='/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/';
% subs=[1 2 3 10 15 18 21]; % DeffImag
% subs=[5 6 11 12 14 17 19 20]; % DNoEffImag
% subs=[1 2 3 5 6 7 8 10 11 12 13 15 16 17 18 19 20 21];
% subs=setxor([10 13],1:18); resultID='subs10_13_excluded'; % for ImageryAndNull_N18
% subs=setxor([9],1:18); resultID='sub9_excluded'; % for ImageryAndNull_N18_nuisanceRegressed
% subs=setxor([9 12 13],1:18); resultID='subs9_12_13_excluded'; % for intra_ImageryAndNull3cats_N18_nuisanceRegressed
subs=setxor([9 13],1:18); resultID='subs9_13_excluded'; % for inter_ImageryAndNull3cats_N18_nuisanceRegressed
% subs=1:18;

cats=[1 2]; 
resultType='intersubject_IwoD_vs_IwD_avg_4catsFS_N18_nuisanceRegressed';
% resultType='atanh_intersubject_ImageryAndNull_N18';
%%
for cati=cats
    data=zeros(91,109,91,length(subs));
    for subi=1:length(subs)
%         disp(['loading data for subject ' num2str(subi)]);
        temp=load_nii([datapath 'importance_visualization/niis/' resultType '_sub' num2str(subs(subi)) '_cat' num2str(cati) '.nii']);
        data(:,:,:,subi)=temp.img;
    end
    data=tanh(mean(atanh(data),4));
%     data=mean(data,4);
    filename=[datapath 'importance_visualization/niis/' resultType '_cat' num2str(cati) '_meanOverSubs_' resultID '.nii'];
    save_nii(make_nii(data),filename);
    nii=bramila_fixOriginator(filename);
    save_nii(nii,filename);
end
% data=mean(data,4);
% filename=[datapath 'importance_visualization/niis/' resultType '_meanOverCats_meanOver' resultID 'Subs.nii'];
% save_nii(make_nii(data),filename);
% nii=bramila_fixOriginator(filename);
% save_nii(nii,filename);