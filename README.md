# MVPA

## WHAT IS IT
Codes for multivariate pattern analysis (MVPA) of fMRI data based on artificial neural networks

## HOW TO USE

-common_model_initialization.m: Initializes the model.

-shape_dataset.m: Reads the data and formats it in a usable way according to what you want to do (i.e., permutation or not, intersubject or not, what resolution, what subject, what block etc.).

-deeper_simple.m: Runs the subscripts, trains the network, evaluates it and saves the results. This script uses the two scripts above.

-classify_all.m: Here you can run multiple runs of the classifier for different settings.

-make_script_array.m: Generates and submits scripts to run on triton (using Slurm).
