function make_slurm_run_jobs
%MAKE_SLURM_RUN_JOBS This function makes automatically a slurm bash script 
% to run all the jobs that are located within the ./jobs folder
curpath=pwd;
fid=fopen('slurm_run_jobs_auto.sh','w');


fprintf(fid,'#!/bin/sh\n\n');

fprintf(fid,'chmod 755 %s/jobs/*\n\n',curpath);


fprintf(fid,'# This is the part where we submit the jobs that we cooked\n\n');

fprintf(fid,'for j in $(ls -1 "%s/jobs/");do\n',curpath);
 fprintf(fid,'sbatch "%s/jobs/"$j\n',curpath);
 fprintf(fid,'sleep 0.01\n');
fprintf(fid,'done\n');
fprintf(fid,'echo "All jobs submitted!"\n\n');

fprintf(fid,'#rm slurm-*\n');

fclose(fid);
system('chmod 755 slurm_run_jobs_auto.sh');
end