tic
addpath(genpath('/m/nbe/scratch/braindata/gostopa1/myGithub/newer/DeepNNs/'))
%% 
if ~exist('perm')
    perm=0;
end

if ~exist('regionlr')
    regionlr=0.05;
end

shape_dataset;

%%
clear model

if ~svm
    layers=[noins noouts];
    common_model_initialization
    %model.layers(1).lr=regionlr;
end

%%
% model.optimizer='RMSprop_m';
% model.optimizer='SGD';
% model.optimizer='ADAM';
if svm
%     model = fitcsvm(X_train,Y_train(:,1));
%     model = fitcsvm(X_train,Y_train(:,1), ...
%             'KernelFunction','rbf');
    model = fitclinear(X_train,Y_train(:,1));
    [label,out_test] = predict(model,X_test);
    
    % make out_test compatible with that from nn
    out_test = out_test*-1;
    out_test = normalize(out_test, 'range', [-0.99 0.99]);
    out_test(find(out_test<0)) = 1+out_test(find(out_test<0));
    
    perf = 100*sum(Y_test(:,1)==label)/length(y_test);    
    impos = model.Beta;
else
    model = model_train_fast_momentum(model);
    % model=model_train_fast(model);
    model.epoch=0; [model,out_test] = forwardpassing(model,[x_test]); 
    perf=get_perf(out_test,y_test);
    %[impos,model]=extract_LRP(model,x);
    % [impos,model]=extract_LRPWX(model,x);
    [impos,model]=extract_LRPWX_ones(model,x);
    impos=squeeze(mean(impos,1)); % average over samples to reduce size 
    % for layeri=1:length(model.layers)
    %     imp(layeri).impos=model.layers(layeri).R;
    % end
end
    
[~,machine]=system('hostname');
if strcmp(machine(1:end-1),'jouni.nbe.aalto.fi')
    show_network(model)
end

display(['Classification accuracy: ' sprintf('%2.2f',perf)])
conf=get_conf(out_test,y_test);
perfpercat=diag(conf)./sum(conf)';
ID=randi(100000000);
toc

% result_dir=['./results/intersubject_ImageryAndNull2catsCombinedD_N18_nuisanceRegressed_perm/S_' mms '_' num2str(perm) '_sub' num2str(subi) '/rep'  num2str(ID) '/'];

result_dir=['./results/' results_id '/S_' mms '_' num2str(perm) '_sub' num2str(subi) '/rep'  num2str(ID) '/'];

if exist('intra')
    if intra==1
        result_dir=['./results/' results_id '/S_' mms '_' num2str(perm) '_sub' num2str(subi) '_block' num2str(block) '/rep'  num2str(ID) '/'];
    end   
end

mkdir(result_dir);
results=[];
results.perf=perf;
results.conf=conf;
results.perfpercat=perfpercat;
results.impos=impos;
results.voxels_to_keep=voxels_to_keep;

save([result_dir 'results.mat'],'results','-v7.3');
% save([ result_dir 'perf.mat'],'perf','-v7.3');
% save([ result_dir 'impos.mat'],'impos','-v7.3');
% save([ result_dir 'conf.mat'],'conf','-v7.3');
% save([ result_dir 'perfpercat.mat'],'perfpercat','-v7.3');
% save([ result_dir 'voxels_to_keep.mat'],'voxels_to_keep','-v7.3');
disp('done!')
