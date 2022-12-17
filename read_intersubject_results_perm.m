% clear

% prefix='./results/intersubject_CircleDiamond_WithoutD_leftCB_N18_nuisanceRegressed_newImposExtract';
% prefix='./results/intersubject_CircleDiamond_TrainedWithoutD_TestedWithD_leftCB_N18_nuisanceRegressed_newImposExtract';
% prefix='./results/intersubject_allcats_N18_nuisanceRegressed_newImposExtract';
mms='2mm';
nosubs=18;

%

perm=0;
reps=10;
for subi=1:nosubs
    
    dirtolook=sprintf('%s/S_%s_%d_sub%d/',prefix,mms,perm,subi);
    res=dir([dirtolook '/rep*']);
    
    for resi=1:reps
        try
        load([dirtolook res(resi).name '/' 'results.mat'])
        
        catch 
            error('Probably you have not run as many as you claim! ')
        end
        
        pp(subi,:,resi)=results.perfpercat;
        
        
    end
    vox(subi,:)=length(results.voxels_to_keep);
end

if size(pp,3)>0
    pp=mean(pp,3);
end

%%
perm=1;
reps=1000;
for subi=1:nosubs
    disp(['subject ' num2str(subi)])
    dirtolook=sprintf('%s/S_%s_%d_sub%d/',prefix,mms,perm,subi);
    res=dir([dirtolook '/rep*']);
    if length(res)<reps
        disp(['too few repetitions for subject ' num2str(subi) ' -> ' num2str(length(res))])
    end
    
    for resi=1:reps
        try
        load([dirtolook res(resi).name '/' 'results.mat'])
        catch 
        
        end
        
        pp_perm(subi,:,resi)=results.perfpercat;
        
    end
end
% permutation test
pp_mean=squeeze(mean(pp,1));
pp_perm_mean=squeeze(mean(pp_perm,1));
for c=1:size(pp,2)
    for s=1:size(pp,1)
        distr_perm=sort(squeeze(pp_perm(s,c,:)),'descend');
        higher_perm=find(distr_perm>squeeze(pp(s,c)),1,'last'); % how many permuted values are larger than the original
        if isempty(higher_perm)
            higher_perm = 1; 
        end
    end
    
    distr_perm_mean=sort(squeeze(pp_perm_mean(c,:)),'descend');
    higher_perm_mean=find(distr_perm_mean>squeeze(pp_mean(c)),1,'last');
    if isempty(higher_perm_mean)
        higher_perm_mean = 1; 
    end
    
    disp(['category ' num2str(c) ': permutation test p-value: ' num2str(higher_perm_mean/reps)])

end

%%
f1=figure(1);
clf
clear str str2
hold

str.data=pp(:,1);
str2.data=squeeze(pp_perm(:,1,:));
str.location=1;
str2.location=1;
h=violin_funct(str,0.02,3,[0 0 1]);
h=violin_funct(str2,0.02,3,[1 0 0]);

str.data=pp(:,2);
str2.data=squeeze(mean(pp_perm(:,2,:),3));
str.location=2;
str2.location=2;
h=violin_funct(str,0.02,3,[0 0 1]);
h=violin_funct(str2,0.02,3,[1 0 0]);

