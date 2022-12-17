clear
mms='2mm';
prefix='./results/intersubject_imagWoD_vs_nullWoD_4catsFS_N18_part1/';
% prefix='./results/intersubject_ImageryAndNull3cats_4catsFS_N18/';
perm=0;
reps=4;
%dir(['../results/S_' mms '_'])
% subs=[1,2,8,9,11,13,15,18,19];
% subs=[1 2 3 10 15 18 21];
nosubs=18;

for subi=1:nosubs
    dirtolook=sprintf('%sS_%s_%d_sub%d/',prefix,mms,perm,subi);
    res=dir([dirtolook '/rep*']);
    %for resi=1:length(res)
    for resi=1:reps
        try
        load([dirtolook res(resi).name '/' 'perfpercat.mat'])
        load([dirtolook res(resi).name '/' 'voxels_to_keep.mat'])
        catch 
            error('Probably you have not run as many as you claim! ')
        end
        
        pp(subi,:,resi)=perfpercat;
        voxels(subi,:,resi)=length(voxels_to_keep);
%         pp(subi,:,1)=perfpercat;
        
    end
end

if size(pp,3)>0
    pp=mean(pp,3);
    voxels=mean(voxels,3);
end
%%
figure(1)

clf
bar(pp)
hold on
line([0 nosubs+1],[1/length(perfpercat) 1/length(perfpercat)])
axis([0 nosubs+1 0.0 1])
%imagesc(pp)
title(['Classification accuracy per category per subject - ' mms])

figure(2)
bar(squeeze(mean(pp,1)))
% set(gca,'XTickLabel',{'imagery w/o D','nothing w/o D','imagery w/ D','nothing w/ D'},'FontSize',13);
% set(gca,'XTickLabel',{'imagery w/o D','imagery w/ D','nothing w/ D'},'FontSize',13);
% set(gca,'XTickLabel',{'circle w/o D','diamond w/o D','nothing w/o D','circle w D','diamond w/ D','nothing w/ D'},'FontSize',10);
hold on
line([0 length(perfpercat)+1],[1/length(perfpercat) 1/length(perfpercat)])
axis([0 length(perfpercat)+1 0 1])
% title({'\fontsize{12} Distractor effect, affected subjects N=5';['\fontsize{8} Intersubject classification accuracy per category averaged over subjects']});
% title({'\fontsize{10} Intersubject classification accuracy per category averaged over subjects';['\fontsize{8} Imagery and null trials']});

