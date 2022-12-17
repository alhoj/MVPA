clear

roi='rightLOTC';

prefix1=['./results/intersubject_CircleDiamond_WithoutD_' roi '_N18_nuisanceRegressed_newImposExtract'];
prefix2=['./results/intersubject_CircleDiamond_TrainedWithoutD_TestedWithD_' roi '_N18_nuisanceRegressed_newImposExtract'];
% prefix1=['./results/intersubject_CircleDiamond_WithD_' roi '_N18_nuisanceRegressed_newImposExtract'];
% prefix2=['./results/intersubject_CircleDiamond_TrainedWithD_TestedWithoutD_' roi '_N18_nuisanceRegressed_newImposExtract'];

mms='2mm';
nosubs=18;
perm=0;
reps=10;
for testi=1:2
    for subi=1:nosubs

        if testi==1
            dirtolook=sprintf('%s/S_%s_%d_sub%d/',prefix1,mms,perm,subi);
        else
            dirtolook=sprintf('%s/S_%s_%d_sub%d/',prefix2,mms,perm,subi);
        end
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
    if testi==1
        pp1=pp;
    else
        pp2=pp;
    end
end
%%
SEM1 = std(pp(:,1))/sqrt(size(pp1,1));
SEM3 = std(pp(:,2))/sqrt(size(pp1,1));
SEM2 = std(pp2(:,1))/sqrt(size(pp2,1));
SEM4 = std(pp2(:,2))/sqrt(size(pp2,1));

%
xtick1=0.2;
xtick3=0.5;
xtick2=0.8;
xtick4=1.1;

bar(mean(pp1(:,1),1),'xData',xtick1,'FaceColor',[0 1 0],'BarWidth',0.2);
hold on
errorbar(mean(pp1(:,1),1),SEM1,'k','xData',xtick1,'LineWidth',1);

bar(mean(pp1(:,2),1),'xData',xtick2,'FaceColor',[0 1 1],'BarWidth',0.2);
errorbar(mean(pp1(:,2),1),SEM2,'k','xData',xtick2,'LineWidth',1);

bar(mean(pp2(:,1),1),'xData',xtick3,'FaceColor',[1 0 0],'BarWidth',0.2);
errorbar(mean(pp2(:,1),1),SEM3,'k','xData',xtick3,'LineWidth',1);

bar(mean(pp2(:,2),1),'xData',xtick4,'FaceColor',[1 0 1],'BarWidth',0.2);
errorbar(mean(pp2(:,2),1),SEM4,'k','xData',xtick4,'LineWidth',1);

%
set(gca,'XTick',[],'YTick',[.4 .5 .6],'XLim',[0 1.3],'YLim',[0.4 0.6])
plot([0 1.3],[0.5 0.5],'--','Color','k','LineWidth',1)
% set(gca,'XTick',[],'YTick',[.2 .4 .6 .8],'XLim',[0 0.7],'YLim',[0.4 1])
% set(gca,'XTick',[],'YTick',[.2 .4 .6 .8 1],'XLim',[0 1],'YLim',[0 1])
% plot([0 1],[0.33 0.33],'--','Color','k','LineWidth',1)
%%
% paired t-test
[~,p1] = ttest(pp1(:,1), pp2(:,1));
[~,p2] = ttest(pp1(:,2), pp2(:,2));

disp(roi)
disp('noD')
disp(mean(pp1(:,1),1))
disp(mean(pp1(:,2),1))
disp('D')
disp(mean(pp2(:,1),1))
disp(mean(pp2(:,2),1))
