clear
mms='2mm';
blocks=6;
prefix='./results/intersubject_4cats_N18_nuisanceRegressed/';
perm=0;
reps=10;
nosubs=18;
%%
for subi=1:nosubs

    dirtolook=sprintf('%sS_%s_%d_sub%d/',prefix,mms,perm,subi);
    res=dir([dirtolook '/rep*']);
    for resi=1:reps % This defines the number of repetitions to read, if they haven't run you'll get an error
        try
%         load([dirtolook res(resi).name '/' 'results.mat'])
        results=load([dirtolook res(resi).name '/' 'conf.mat']);
        catch 
            error('Probably you have not run as many as you claim! ')
        end
        confmat(:,:,resi,subi)=results.conf;
    end

end
%%
confmat=mean(confmat,4);
confmat=mean(confmat,3);
confmat=squeeze(confmat);

%%
nsamples=sum(confmat(:,1));
colormap(parula)
imagesc(confmat/nsamples*100,[0 50])
