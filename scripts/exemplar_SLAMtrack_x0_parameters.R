# experimental descriptors
exp_tissue_origin <- "liver" 
exp_tissue_target <- "kidney"
exp_species <- "mouse"

baseline_group <- "control group (4TU -ve)"            # baseline control group (often 4TU-negative)
pos_group <- "RNA labelling group"                     # positive experimental group
neg_group <- "control group (Cre -ve)"                 # negative control group in delta-TC analysis (often Cre-negative)


# analysis parameters
mutations_threshold_readcount <- 100  # include reads about this threshold when counting mutations
cR_nudge <- 10e-9                     # shift when plotting mutation rates on a log scale
threshold_TC_centile <- 0.99          # threshold for calling labelled reads