% test between classification importance maps
clear

addpath('/m/nbe/scratch/braindata/shared/toolboxes/NIFTI/');
addpath('/m/nbe/scratch/braindata/shared/toolboxes/bramila/bramila/');

data_path='/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/';
% prefix='atanh';
% prefix2='ImageryWithDistractor';
type='intersubject_allcats_N18_nuisanceRegressed_newImposExtract';
nosubs=18;
nocats=6;
% group1=[1 4 5 10 11];
% group2=[2 3 6 7 8 9];
mask=load_nii('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mask_verrokit_N21.nii'); mask=mask.img;
maskFS=load_nii('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/mask_4catsFS.nii'); maskFS=maskFS.img;
%
data=zeros(91,109,91,nosubs,nocats);
for subi=1:nosubs
    for cati=1:nocats
        temp=load_nii([data_path 'niis/' type '_sub' num2str(subi) '_cat' num2str(cati) '.nii']);
        data(:,:,:,subi,cati)=temp.img;
    end
end
%
data=reshape(data,91*109*91,nosubs,nocats);
inmask = find(maskFS);
data=data(inmask,:,:);

novoxels=size(data,1);
%%
catp=2;
catn=3;
[~,p,~,stats]=ttest(squeeze(data(:,:,catp))',squeeze(data(:,:,catn))');
significant_voxels=intersect(find(p<0.05),find(stats.tstat>0));

% count=1;
% for voxeli=1:novoxels
%     [~,p(voxeli),~,stats(voxeli)]=ttest(squeeze(data(voxeli,:,1)),squeeze(data(voxeli,:,2)));
% %     [~,p1(voxeli),~,stats1(voxeli)]=ttest(squeeze(data(voxeli,:,3)),squeeze(data(voxeli,:,1)));
% %     [~,p2(voxeli),~,stats2(voxeli)]=ttest(squeeze(data(voxeli,:,3)),squeeze(data(voxeli,:,4)));
%     if p(voxeli)<0.05 %&& p2(voxeli)<0.05 && stats1(voxeli).tstat>0 && stats2(voxeli).tstat>0
%         significant_voxels(count)=voxeli;
%         count=count+1;
%     end
% %     [p(voxeli),~,stats(voxeli)] = anova1(squeeze(data(voxeli,:,:)),[],'off');
% %     if (p(voxeli)<0.05 && stats(voxeli).means(3)==max(stats(voxeli).means))
% %         significant_voxels(count)=voxeli;
% %         count=count+1;
% %     end
% end


    %% save uncorrected volume
%     significant_voxels = find(p<0.05);
    new_brain = zeros(91,109,91);
    new_brain=reshape(new_brain,91*109*91,[]);
    new_brain(inmask(significant_voxels))=stats.tstat(significant_voxels);
    new_brain=reshape(new_brain,91,109,91);

    disp('saving nii...')
    %filename=[data_path prefix1 '_vs_' prefix2 '_cat' num2str(cati) '_uncorrected.nii'];
    filename=[data_path 'niis/' type '_cat' num2str(catp) '_vs_cat' num2str(catn) '_paired-sample_t-test.nii'];
    save_nii(make_nii(new_brain),filename);
    nii=bramila_fixOriginator(filename);
    save_nii(nii,filename);

    %% fdr correction
%     disp('fdr...')
    pFDR = mafdr(p, 'BHFDR', 'true');
    significant_voxels_fdr = find(pFDR<0.05);
    
    new_brain = zeros(91,109,91);
    new_brain=reshape(new_brain,91*109*91,[]);
    new_brain(inmask(significant_voxels_fdr))=stats.tstat(significant_voxels_fdr);
    new_brain=sign(new_brain);
    new_brain=reshape(new_brain,91,109,91);

    disp('saving nii...')
    filename=[data_path 'niis/' type '_cat1_vs_cat3_paired-sample_t-test_fdr.nii'];
    save_nii(make_nii(new_brain),filename);
    nii=bramila_fixOriginator(filename);
    save_nii(nii,filename);


% [~,p,~,stats]=ttest(data1,data2);
%[~,p,~,stats]=ttest2(data(inmask,group1)',data(inmask,group2)');
%[~,p,~,stats]=ttest(data(inmask,group1)');
% [~,p2,~,stats2]=ttest(data(inmask,group1)',0,'Tail','right');

% save uncorrected volume
% significant_voxels = find(p<0.001);
% new_brain = zeros(91,109,91);
% new_brain=reshape(new_brain,91*109*91,[]);
% new_brain(inmask(significant_voxels))=stats.tstat(significant_voxels);
% new_brain=sign(new_brain);
% new_brain=reshape(new_brain,91,109,91);
% 
% disp('saving nii...')
% filename=[data_path prefix1 '_uncorrected.nii'];
% save_nii(make_nii(new_brain),filename);
% nii=bramila_fixOriginator(filename);
% save_nii(nii,filename);
% 
% % fdr correction
% disp('fdr...')
% pFDR = mafdr(p, 'BHFDR', 'true');
% 
% significant_voxels = find(pFDR<0.05);
% new_brain = zeros(91,109,91);
% new_brain=reshape(new_brain,91*109*91,[]);
% new_brain(inmask(significant_voxels))=stats.tstat(significant_voxels);
% new_brain=sign(new_brain);
% new_brain=reshape(new_brain,91,109,91);
% 
% disp('saving nii...')
% filename=[data_path prefix1 '_fdr.nii'];
% save_nii(make_nii(new_brain),filename);
% nii=bramila_fixOriginator(filename);
% save_nii(nii,filename);