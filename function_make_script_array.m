function function_make_script_array(cfg)

% delete logs/*
% delete jobs/*

% mkdir jobs
% mkdir logs
%addpath(genpath('/triton/becs/scratch/braindata/gostopa1/MATLAB_scripts/nnctps/'))

jobind = cfg.ind;
% display('Making jobs ...')

% jobind=jobind+1;
fid = fopen(['./jobs/job_' num2str(jobind) '.sh'],'w');

fprintf(fid,'#!/bin/bash\n\n');

fprintf(fid,'#SBATCH -p batch\n');
fprintf(fid,'#SBATCH -t 00:04:59\n');
fprintf(fid,['#SBATCH --array=1-' num2str(cfg.reps) '\n\n']);
fprintf(fid,['#SBATCH -o ' './logs/log_' num2str(jobind) '_%%a\n']);
fprintf(fid,'#SBATCH --qos=normal\n\n');
fprintf(fid,'#SBATCH --mem-per-cpu=80000\n\n');

%fprintf(fid,'module load matlab\n');
fprintf(fid,'sleep .$[( $RANDOM %% 10 ) ]s\n\n'); % Sleep for a random amount of time, so that the rng will give different seed
fprintf(fid,['matlab -nojvm -r "cd ' pwd '/;rng(''shuffle'');mms=''2mm'';svm=' num2str(cfg.svm) ';intra=' num2str(cfg.intra) ';subi=' num2str(cfg.sub) ';subs=[' num2str(cfg.subs) '];perm=' num2str(cfg.perm) ';block=' num2str(cfg.block) ';distractor=' num2str(cfg.distractor) ';data_id=''' cfg.data_id ''';results_id=''' cfg.results_id ''';classification_cats=''' cfg.classification_cats ''';feature_selection=' num2str(cfg.feature_selection) ';roi=[' num2str(cfg.roi) ']; randPart=' num2str(cfg.randPart) '; deeper_simple;;exit;"']); 
% fprintf(fid,['matlab -nojvm -r "cd ' pwd '/;rng(''shuffle'');' scriptToRun ';exit;"']); 
%matlab -nojvm -r "cd /m/nbe/scratch/braindata/jaalho/psykoosi/visuaaliset_mielikuvat/mvpa/;rng('shuffle');mms='4mm;intra=1;subi=1;perm=0;block=1; deeper_simple;;exit;"
%fprintf(fid,['python ' scriptToRun]); % If it is a python script



fclose(fid);





display('Done making jobs!')

end
