if ~exist('mms','var')
    mms='2mm';
end

if ~exist('intra','var')
    intra=0;
end

if intra
    disp('intrasubject classification')
else
    disp('intersubject classification')
end

% if ~exist('convradius')
%     convradius=3;
% end

%load(['/m/nbe/scratch/braindata/gostopa1/psychosis/fullformat/psychosis_' mms '_10tps_full_format.mat']); nosubs=11; tps=3:5;
load(['/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/fullformat/psychosis_' mms '_' data_id '.mat']); 

nosubs=length(subs);

if length(size(D))>5
    tps=3:5;
    D=mean(D(:,:,:,:,:,tps),6);
end

switch distractor
    case 0
        D=D(1:3,:,:,:,:);
        disp('only cats w/out distractor');
    case 1
        D=D(4:6,:,:,:,:);
        disp('only cats w/ distractor');
    case 2
        temp=zeros(3,nosubs,size(D,3),16,size(D,5));
        temp(1,:,:,1:8,:)=D(1,subs,:,:,:);
        temp(1,:,:,9:16,:)=D(4,subs,:,:,:);
        temp(2,:,:,1:8,:)=D(2,subs,:,:,:);
        temp(2,:,:,9:16,:)=D(5,subs,:,:,:);
        temp(3,:,:,1:8,:)=D(3,subs,:,:,:);
        temp(3,:,:,9:16,:)=D(6,subs,:,:,:);
        D=temp;
        disp('combined w/out and w/ distractor cats');  
    case 3 
        temp=zeros(3,nosubs,size(D,3),size(D,4),size(D,5));
        temp(1,:,:,1:4,:)=D(1,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(1,:,:,5:8,:)=D(2,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(2,:,:,1:4,:)=D(4,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(2,:,:,5:8,:)=D(5,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(3,:,:,:,:)=D(6,subs,:,:,:);
        D=temp;
        disp('combined imageries -> three categories = imag w/o D, imag w/ D, and null w/ D'); 
    case 4
        temp=zeros(4,nosubs,size(D,3),size(D,4),size(D,5));
        temp(1,:,:,1:4,:)=D(1,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(1,:,:,5:8,:)=D(2,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
    %     temp(1,:,:,:,:)=mean(D([1 2],subs,:,:,:),1);
    %     temp(1,:,:,:,:)=D(2,subs,:,:,:);
        temp(2,:,:,:,:)=D(3,subs,:,:,:);
        temp(3,:,:,1:4,:)=D(4,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(3,:,:,5:8,:)=D(5,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
    %     temp(3,:,:,:,:)=mean(D([4 5],subs,:,:,:),1);
    %     temp(3,:,:,:,:)=D(5,subs,:,:,:);
        temp(4,:,:,:,:)=D(6,subs,:,:,:);
        D=temp;
        disp('combined circle and diamond imageries -> four categories');
    case 5
        temp=zeros(2,nosubs,size(D,3),size(D,4),size(D,5));
        temp(1,:,:,1:4,:)=D(1,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(1,:,:,5:8,:)=D(2,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(2,:,:,1:4,:)=D(4,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(2,:,:,5:8,:)=D(5,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        D=temp;
        disp('two categories: imag w/o D and imag w/ D');
    case 6
        temp=zeros(2,nosubs,size(D,3),size(D,4),size(D,5));
        temp(1,:,:,1:4,:)=D(4,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(1,:,:,5:8,:)=D(5,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(2,:,:,:,:)=D(6,subs,:,:,:);
        D=temp;
        disp('two categories: imag w/ D and null w/ D');
    case 7
        temp=zeros(2,nosubs,size(D,3),size(D,4),size(D,5));
        temp(1,:,:,:,:)=D(3,subs,:,:,:);
        temp(2,:,:,:,:)=D(6,subs,:,:,:);
        D=temp;
        disp('two categories: null w/o D and null w/ D');
    case 8
        temp=zeros(2,nosubs,size(D,3),16,size(D,5));
    %     temp(1,:,:,1:4,:)=D(1,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
    %     temp(1,:,:,5:8,:)=D(2,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(1,:,:,1:8,:)=mean(D([1 2],subs,:,:,:),1);
    %     temp(1,:,:,9:12,:)=D(4,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
    %     temp(1,:,:,13:16,:)=D(5,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(1,:,:,9:16,:)=mean(D([4 5],subs,:,:,:),1);
        temp(2,:,:,1:8,:)=D(3,subs,:,:,:);
        temp(2,:,:,9:16,:)=D(6,subs,:,:,:);
        D=temp;
        disp('two categories: imag w/o and w/ D, and null w/o and w/ D');
    case 9
        load('TrialsRandParts.mat')
        D=D(:,:,:,parts2(randPart,:),:); % define if parts1 or parts2 (parts 1 for ROI definition, parts2 for testing classification accuracies
        temp=zeros(4,nosubs,size(D,3),size(D,4),size(D,5));
        temp(1,:,:,1:2,:)=D(1,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(1,:,:,3:4,:)=D(2,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(2,:,:,:,:)=D(3,subs,:,:,:);
        temp(3,:,:,1:2,:)=D(4,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(3,:,:,3:4,:)=D(5,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
        temp(4,:,:,:,:)=D(6,subs,:,:,:);
        D=temp;
        disp('combined circle and diamond imageries -> four categories; split data');
    case 10
        D=D(1:2,:,:,:,:);
        disp('circle and diamond w/out distractor');
    case 11
        D2=D(4:5,:,:,:,:);
        D=D(1:2,:,:,:,:);
        disp('train with circle and diamond w/out distractor and test with circle and diamond w/ distractor');
    case 12
        D=D(4:5,:,:,:,:);
        disp('circle and diamond w/ distractor');
    case 13
        D2=D(1:2,:,:,:,:);
        D=D(4:5,:,:,:,:);
        disp('train with circle and diamond w/ distractor and test with circle and diamond w/out distractor');
    case 14
        D2=D(4:6,:,:,:,:);
        D=D(1:3,:,:,:,:);
        disp('train with cats w/out distractor and test with cats w/ distractor');
    otherwise
        disp('all categories');
end

s=size(D);
nocats=s(1);
noruns=s(3);
notrials=s(4);
novoxels=s(5);


%%

if ~exist('subi','var')
    subi=1; 
end

testinds=subi;
traininds=setxor(subi,1:nosubs);

if exist('intra','var')
    if intra==1
       
       D=permute(D(:,subi,:,:,:),[1 3 2 4 5 ]);
       if exist('D2','var')
           D2=permute(D2(:,subi,:,:,:),[1 3 2 4 5 ]);
       end
       testinds=block;
       traininds=setxor(block,1:noruns);
    end
end

if ~exist('perm','var')
    perm=0;
end

s=size(D);
noruns=s(3);

D_train=reshape(permute(D(:,traininds,:,:,:),[5 1 2 3 4]),novoxels,nocats,length(traininds)*noruns*notrials);
if exist('D2','var')
    s=size(D2);
    noruns=s(3);
    D_test=reshape(permute(D2(:,testinds,:,:,:),[5 1 2 3 4]),novoxels,nocats,length(testinds)*noruns*notrials);
else
    D_test=reshape(permute(D(:,testinds,:,:,:),[5 1 2 3 4]),novoxels,nocats,length(testinds)*noruns*notrials);
end
snew_train=size(D_train);
snew_test=size(D_test);


%% feature selection
if feature_selection==1
    for voxeli=1:novoxels
        % One-way analysis of variance 
        p(voxeli)=anova1(permute(D_train(voxeli,:,:),[3 2 1]),[],'off');
        % paired t-test between imagery and null trials to find the imagery regions of the brain
    %     [~,p(voxeli),~,stats(voxeli)] = ttest(D_imag(voxeli,:),D_null(voxeli,:));
    end
    %
    p_thres=0.05;
    voxels_to_keep=find(p<p_thres);
    disp(['voxels after feature selection: ' num2str(length(voxels_to_keep))])
    
elseif feature_selection==2
    load(['/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/fullformat/psychosis_' mms '_all_classes_21subs_averagedTPs.mat']); 
    temp=zeros(4,nosubs,size(D,3),size(D,4),size(D,5));
    temp(1,:,:,1:4,:)=D(1,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
    temp(1,:,:,5:8,:)=D(2,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
    temp(2,:,:,:,:)=D(3,subs,:,:,:);
    temp(3,:,:,1:4,:)=D(4,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
    temp(3,:,:,5:8,:)=D(5,subs,:,sort(randsample(1:size(D,4),(size(D,4)/2))),:);
    temp(4,:,:,:,:)=D(6,subs,:,:,:);
    D=temp;
    Dfs=reshape(permute(D(:,traininds,:,:,:),[5 1 2 3 4]),novoxels,s(1),length(traininds)*s(3)*s(4));
    for voxeli=1:novoxels
        % One-way analysis of variance 
        p(voxeli)=anova1(permute(Dfs(voxeli,:,:),[3 2 1]),[],'off');
        % paired t-test between imagery and null trials to find the imagery regions of the brain
    %     [~,p(voxeli),~,stats(voxeli)] = ttest(D_imag(voxeli,:),D_null(voxeli,:));
    end
    %
    p_thres=0.05;
    voxels_to_keep=find(p<p_thres);
    
elseif feature_selection==3
    addpath('/m/nbe/scratch/braindata/shared/toolboxes/NIFTI/');
    atlas=load_nii('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/brainnetome_atlas_w_cerebellum_v2.nii');
%     rois=load_nii('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/importance_visualization/niis/intersubject_imagWoD_vs_nullWoD_4catsFS_N18_randPart_cat1_permtestTh05_CCth7_clusterMask.nii');
%     rois=rois.img;
    mask=load_nii('/m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mask_verrokit_N21.nii');
    inmask=find(mask.img);
    voxels_to_keep=[];
    for i=1:length(roi)
        voxels_to_keep=[voxels_to_keep; find(atlas.img(inmask)==roi(i))];
    end
else
    voxels_to_keep=1:novoxels;
end
%

switch classification_cats
    case 'all'
        disp('Classifying all categories')
        classification_cats=1:nocats;
    case '2cats_IwoD_NwoD'
        disp('Classifying imagery and null trials without distractor')
        classification_cats=[1 2];
    case '2cats_IwoD_IwD'
        disp('Classifying imagery trials with and without distractor')
        classification_cats=[1 3];
    case '2cats_NwoD_NwD'
        disp('Classifying null trials with and without distractor')
        classification_cats=[2 4];
    case '2cats_IwD_NwD'
        disp('Classifying imagery and null trials with distractor')
        classification_cats=[3 4];
    case '3cats'
        disp('Classifying imagery without and with distractor, and null with distractor')
        classification_cats=[1 3 4];
    otherwise
        classification_cats=1:nocats;
end

D_train=D_train(voxels_to_keep,classification_cats,:);
D_test=D_test(voxels_to_keep,classification_cats,:);

novoxels=length(voxels_to_keep);
nocats=length(classification_cats);

%%
X_test=[]; X_train=[];
%Y_train=[]; Y_test=[];

labs_test=[];  labs_train=[];

for cati=1:nocats
    X_train=[X_train ; squeeze(D_train(:,cati,:))'];
    X_test=[X_test ; squeeze(D_test(:,cati,:))'];
    vec=zeros(nocats,1);
    vec(cati)=1;
    
    labs_train=[labs_train repmat(cati,1,(snew_train(3)))];
    labs_test=[labs_test repmat(cati,1,(snew_test(3)))];
    
end

if perm>0
    labs_train=labs_train(randperm(length(labs_train)));
end

Y_train=dummyvar(labs_train);
Y_test=dummyvar(labs_test);

x=X_train;
y=Y_train;

x=zscore(x,[],1);

x_test=X_test;
x_test=zscore(x_test,[],1);
y_test=Y_test;


noins=size(x,2);
noouts=size(y,2);

disp('Data read!')
