clear
mms='2mm';
blocks=6;
prefix='./results/intrasubject/';
perm=0;
reps=1;
nosubs=21;
for subi=1:nosubs
    for blocki=1:blocks
        dirtolook=sprintf('%sS_%s_%d_sub%d_block%d/',prefix,mms,perm,subi,blocki);
        res=dir([dirtolook '/rep*']);
        for resi=1:reps % This defines the number of repetitions to read, if they haven't run you'll get an error
            try
            load([dirtolook res(resi).name '/' 'conf.mat'])
            catch 
                error('Probably you have not run as many as you claim! ')
            end
            data(:,:,resi,blocki,subi)=conf;
        end
    end
end

data=mean(data,5);
data=mean(data,4);
data=mean(data,3);
data=squeeze(data);

%%
figure(1)

clf
data=squeeze(mean(mean(data,4),2));
bar(data)
hold on
line([0 nosubs+1],[1/length(perfpercat) 1/length(perfpercat)])
axis([0 nosubs+1 0.0 1])
%imagesc(pp)
title(['Classification accuracy per category per subject - ' mms])

figure(2)
data_avg=squeeze(mean(mean(data,2),1));
bar(data_avg)
set(gca,'XTickLabel',{'circle','diamond','nothing'},'FontSize',13);
% set(gca,'XTickLabel',{'diamond w/o D','nothing w/o D','diamond w/ D','nothing w/ D'},'FontSize',10);
% set(gca,'XTickLabel',{'no distractor','distractor'},'FontSize',13);
% set(gca,'XTickLabel',{'circle w/o D','diamond w/o D','nothing w/o D','circle w D','diamond w/ D','nothing w/ D'},'FontSize',10);
% title({'\fontsize{10} Intrasubject classification accuracy per category averaged over subjects';['\fontsize{8} Imagery and null trials w/ and w/o distractor']});
% title({'\fontsize{10} Intrasubject classification accuracy per category averaged over subjects';['\fontsize{8} Imagery w/ and w/o distractor']});
title({'\fontsize{10} Intrasubject classification accuracy per category averaged over subjects';['\fontsize{8} Imagery and null trials']});

hold on
line([0 length(perfpercat)+1],[1/length(perfpercat) 1/length(perfpercat)])
axis([0 length(perfpercat)+1 0 1])
% title(['Classification accuracy per category averaged over subjects - ' mms])


% figure(3)
% sem=std(data)/sqrt(length(data));
% h=barwitherr(sem,data_avg');
% set(h,'FaceColor','r');
% set(gca,'XTickLabel',{'circle','diamond','nothing'},'FontSize',13);
% title({'\fontsize{15} Imagery without distractor';['\fontsize{10} Classification accuracy per category averaged over subjects - ' mms]});
% hold on
% line([0 length(perfpercat)+1],[1/length(perfpercat) 1/length(perfpercat)],'Color','k')
% axis([0 length(perfpercat)+1 0 1])

% figure(4)
% data1=squeeze(mean(mean(pp1,4),2));
% data2=squeeze(mean(mean(pp2,4),2));
% sem1=std(data1)/sqrt(length(data1));
% sem2=std(data2)/sqrt(length(data2));
% data_avg1=squeeze(mean(mean(pp1,2),1));
% data_avg2=squeeze(mean(mean(pp2,2),1));
% h=barwitherr([sem1;sem2]',[data_avg1';data_avg2']');
% set(h,'FaceColor','r');
% set(gca,'XTickLabel',{'circle','diamond','nothing'},'FontSize',13);
% title('\fontsize{10} Intrasubject classification accuracy per category averaged over subjects');
% hold on
% line([0 length(perfpercat)+1],[1/length(perfpercat) 1/length(perfpercat)],'Color','k')
% axis([0 length(perfpercat)+1 0 1])
% legend('without distractor','with distractor','Location','northwest');

% figure(5)
% pp1=mean(pp1,4);
% pp2=mean(pp2,4);
% pp3=mean(pp3,4);
% data1=squeeze(mean(mean(pp1,4),2));
% data2=squeeze(mean(mean(pp2,4),2));
% data3=squeeze(mean(mean(pp3,4),2));
% sem1=std(data1)/sqrt(length(data1));
% sem2=std(data2)/sqrt(length(data2));
% sem3=std(data3)/sqrt(length(data3));
% data_avg1=squeeze(mean(mean(pp1,2),1));
% data_avg2=squeeze(mean(mean(pp2,2),1));
% data_avg3=squeeze(mean(mean(pp3,2),1));
% h=barwitherr([sem1;sem2;sem3],[data_avg1';data_avg2';data_avg3']);
% % set(h,'FaceColor','r');
% set(gca,'XTickLabel',{'circle','diamond','nothing'},'FontSize',13);
% title('\fontsize{10} Intrasubject classification accuracy per category averaged over subjects');
% hold on
% line([0 4],[1/length(perfpercat) 1/length(perfpercat)],'Color','k')
% axis([0 4 0.25 0.75])
% legend('without distractor','with distractor','Location','northeast');