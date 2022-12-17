s=size(D);
nocats=s(1);
nosubs=s(2);
noruns=s(3);
notrials=s(4);
novoxels=s(5);

D=permute(D,[2 1 3 4 5]);
D=reshape(D,nosubs,nocats*noruns*notrials*novoxels);

hitRateDiff=[
0.03125
0
0.041666667
0.09375
0.1875
0.020833333
0.052083333
-0.010416667
0.052083333
0.072916667
0.041666667
-0.03125
0.010416667
0
0.125
-0.010416667
0.114583333
-0.041666667
0.020833333
0.052083333
0
];

hitRateDiffZ=zscore(hitRateDiff);
b=D'/hitRateDiffZ';
DReg=D-hitRateDiffZ*b';

%%
D=DReg;
D=reshape(D,nosubs,nocats,noruns,notrials,novoxels);
D=permute(D,[2 1 3 4 5]);
save('psychosis_2mm_all_classes_21subs_averagedTPs_nuisanceRegressed','D','-v7.3')