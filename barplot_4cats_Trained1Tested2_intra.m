clear

classif_method = 'svm';
classif_type = 'intra';

plot = 1;

rois={
      'leftIPC'
      'leftIOC'
      'leftSOC'
      'leftLOTC'
      'rightIPC'
      'rightIOC'
      'rightSOC'
      'rightLOTC'
};

mms='2mm';
nosubs=18;
noblocks=6;
noshapes=2;
noconds=2;
norois=length(rois);
perm=0;
reps=10;
%%
data_anova = zeros(noshapes*noconds*nosubs*norois,1);
for roii=1:length(rois)
    prefix1=['./results/' classif_method '_' classif_type 'subject_CircleDiamond_WithoutD_' rois{roii} '_N18_nuisanceRegressed_newImposExtract'];
    prefix2=['./results/' classif_method '_' classif_type 'subject_CircleDiamond_TrainedWithoutD_TestedWithD_' rois{roii} '_N18_nuisanceRegressed_newImposExtract'];
    for testi=1:2
        for subi=1:nosubs
            for blocki=1:noblocks        
                if testi==1
                    dirtolook=sprintf('%s/S_%s_%d_sub%d_block%d/',prefix1,mms,perm,subi,blocki);
                else
                    dirtolook=sprintf('%s/S_%s_%d_sub%d_block%d/',prefix2,mms,perm,subi,blocki);
                end

                res=dir([dirtolook '/rep*']);

                for resi=1:reps
                    try
                    load([dirtolook res(resi).name '/' 'results.mat'])

                    catch 
                        error('Probably you have not run as many as you claim! ')
                    end

                    pp(subi,blocki,:,resi)=results.perfpercat;

                end
            end
        end
        if size(pp,4)>0
            pp=mean(pp,4);
        end
        if testi==1
            pp1=pp;
        else
            pp2=pp;
        end
    end
    %
    pp1 = squeeze(mean(pp1,2));
    pp2 = squeeze(mean(pp2,2));
    %
    ind_start = (roii-1)*(noshapes*noconds*nosubs)+1;
    data_anova(ind_start:ind_start+(noshapes*noconds*nosubs)-1) = [pp1(:);pp2(:)];

    SEM1 = std(pp1(:,1))/sqrt(size(pp1,1));
    SEM3 = std(pp1(:,2))/sqrt(size(pp1,1));
    SEM2 = std(pp2(:,1))/sqrt(size(pp2,1));
    SEM4 = std(pp2(:,2))/sqrt(size(pp2,1));

    %
    if plot
        xtick1=0.2;
        xtick3=0.5;
        xtick2=0.8;
        xtick4=1.1;

        bar([pp1(:,1) pp2(:,1)])
        yline(0.5, '--','Color','k','LineWidth',1)
        print(gcf,['./figures/revision_neuropsychologia/' classif_method '_' classif_type '_accuracies_withoutD_' rois{roii} '.png'],'-dpng','-r300');
        close all
        bar([pp1(:,1) pp2(:,1)])
        yline(0.5, '--','Color','k','LineWidth',1)
        print(gcf,['./figures/revision_neuropsychologia/' classif_method '_' classif_type '_accuracies_withD_' rois{roii} '.png'],'-dpng','-r300');          
        close all
        
        bar(mean(pp1(:,1),1),'xData',xtick1,'FaceColor',[0 1 0],'BarWidth',0.2);
        hold on
        errorbar(mean(pp1(:,1),1),SEM1,'k','xData',xtick1,'LineWidth',1);

        bar(mean(pp2(:,1),1),'xData',xtick2,'FaceColor',[0 1 1],'BarWidth',0.2);
        errorbar(mean(pp2(:,1),1),SEM2,'k','xData',xtick2,'LineWidth',1);

        bar(mean(pp1(:,2),1),'xData',xtick3,'FaceColor',[1 0 0],'BarWidth',0.2);
        errorbar(mean(pp1(:,2),1),SEM3,'k','xData',xtick3,'LineWidth',1);

        bar(mean(pp2(:,2),1),'xData',xtick4,'FaceColor',[1 0 1],'BarWidth',0.2);
        errorbar(mean(pp2(:,2),1),SEM4,'k','xData',xtick4,'LineWidth',1);

        %
        set(gca,'XTick',[],'YTick',[.4 .5 .6 .7],'XLim',[0 1.3],'YLim',[0.4 0.7])
        yline(0.5, '--','Color','k','LineWidth',1)
        print(gcf,['./figures/revision_neuropsychologia/' classif_method '_' classif_type '_accuracies_' rois{roii} '.png'],'-dpng','-r300');  
        % set(gca,'XTick',[],'YTick',[.2 .4 .6 .8],'XLim',[0 0.7],'YLim',[0.4 1])
        % set(gca,'XTick',[],'YTick',[.2 .4 .6 .8 1],'XLim',[0 1],'YLim',[0 1])
        % plot([0 1],[0.33 0.33],'--','Color','k','LineWidth',1)
        close all
    end
    %%
    % paired t-test
    disp('Accuracies:')
    disp(['circle - noD: ' num2str(mean(pp1(:,1),1)) '; circle - D: ' num2str(mean(pp2(:,1),1))])
    disp(['diamond - noD: ' num2str(mean(pp1(:,2),1)) '; diamond - D: ' num2str(mean(pp2(:,2),1))])
    [~,p1] = ttest(pp1(:,1), pp2(:,1));
    [~,p2] = ttest(pp1(:,2), pp2(:,2));
    disp([rois{roii} ': p1= ' num2str(p1) ', p2= ' num2str(p2)])
end
    
%% anova

% g_shapes = repmat([repmat({'circle'},nosubs,1); repmat({'diamond'},nosubs,1)],noconds*norois,1);
% g_conds = repmat([repmat({'no distractor'},nosubs*2,1); repmat({'distractor'},nosubs*2,1)],norois,1);
% g_rois = repelem(rois,noshapes*noconds*nosubs);
% % [p,tbl] = anovan(data_anova,nosubs);
% [~,~,stats] = anovan(data_anova,{g_shapes g_conds g_rois},'model','full','varnames',{'shape','cond','roi'});