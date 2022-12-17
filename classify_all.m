mms='4mm'
data_id='10tps_all_classes_full_format';
distractor=2;
intra=0; % 0: intersubject, 1 intrasubject
perm=0; %0: normal run - 1: permutations run
for iter=1:1 % How many iterations
    for subi=1:11 % Which subjects    
        deeper_simple;
    end
end

%%
mms='2mm';
data_id='10tps_all_classes_full_format';
distractor=0;
intra=1; % 0: intersubject, 1 intrasubject
perm=0; %0: normal run - 1: permutations run
for iter=1 % How many iterations
    for subi=1:11 % Which subjects
        for block=1:6 % Which blocks
            deeper_simple;
        end
    end
end

%%
mms='2mm'

intra=1; % 0: intersubject, 1 intrasubject
perm=0; %0: normal run - 1: permutations run
for iter=1 % How many iterations
    for subi=1 % Which subjects
        for block=1 % Which blocks
            deeper_simple;
        end
    end
end
