clear

load('data/ISPS_BL_EPIgroupMask_2mm_noSpatialSmoothing_patientsN36_controlsN30.mat');

pati=find(~contains(subs,'EPVE')); % Indices of patients
coni=find(contains(subs,'EPVE')); % Indices of controls
nopats=length(pati); % How many patients
nocons=length(coni); % How many controls
novox=size(D,1); % How many voxels

X = D';
y = zeros(nopats+nocons,1); % zero to patients... 
y((nopats+1):end)=1; % ...and one to controls

y_predicted=nan(size(y));

%%
voxinds=1:novox; % no voxel selection       
for test_sub = 1:size(X,1)
            
    X_train = X;
    y_train = y;
    X_train(test_sub,:)=[];
    y_train(test_sub)=[];
    
    y_test = y(test_sub);
    X_test = X(test_sub,:);
    
    pat_ind=find(y_train==0);
    con_ind=find(y_train==1);
    
    % feature selection
%     [~,~,~,stats]=ttest2(X_train(con_ind,:),X_train(pat_ind,:)); % Do a two-sample t-test between the groups
%     voxinds=find(abs(stats.tstat)>1.5); % Which voxels to keep
%     voxinds=find(abs(stats.tstat)>2); % Which voxels to keep

%     classf = @(train_data, train_labels, test_data, test_labels)... 
%         sum(predict(fitcsvm(train_data, train_labels), test_data) ~= test_labels);
%     cvp = cvpartition(y_train,'k',10);
%     opt = statset('display','iter');
%     [fs,history] = sequentialfs(classf,X_train,y_train,'cv',cvp,'options',opt);
    
%     mod=svmtrain(X_train(:,voxinds),y_train); % Train the SVM classifier   
    mod=fitcsvm(X_train(:,voxinds),y_train); % Train the SVM classifier; this is the new function that replaced 'svmtrain'
%     mod=fitcsvm(X_train(:,fs),y_train);

%     yhat=svmclassify(mod,X_test(:,voxinds));  % Classify the test set
    [label,score] = predict(mod,X_test(:,voxinds)); % Classify the test set; this is the new function that replaced 'svmclassify'
%     [label,score] = predict(mod,X_test(:,fs));
    y_predicted(test_sub)=label;
    
    fprintf('Subject %i: real %i, predicted %i\n',test_sub,y_test,label);
            
end

fprintf('\nFinal accuracy %0.1f%%\n',100*sum(y_predicted==y)/length(y))
