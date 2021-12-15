## SET PARAMETERS ----

# experimental descriptors
exp_dir <- "slamdunk_210910"
exp_tissue_origin <- "liver" 
exp_tissue_target <- "kidney"
exp_species <- "mouse"

baseline_group <- "4TUneg"            # baseline control group (often 4TU-negative)
pos_group <- "crepos"                 # positive experimental group
neg_group <- "creneg"                 # negative control group in delta-TC analysis (often Cre-negative)


# analysis parameters
mutations_threshold_readcount <- 100  # include reads about this threshold when counting mutations
cR_nudge <- 10e-9                     # shift when plotting mutation rates on a log scale
threshold_TC_centile <- 0.99          # threshold for calling labelled reads



## LOAD LIBRARIES ----

library(tidyverse)
library(here)


## SET PATHS ----

dir_root <- "~/OneDrive - University of Edinburgh/R files/Labdata - RNAseq"
dir_data <- here(dir_root, "Data_SLAMDUNK")
dir_scripts <- here("scripts")
dir_active <- here(dir_data, exp_dir)


## SET-UP SCRIPTS ----

here(dir_scripts, "SLAMtrack_01_plotting_themes.R") %>% source()
here(dir_scripts, "SLAMtrack_02_miscellaneous_functions.R") %>% source()
here(dir_scripts, "SLAMtrack_20_plotting_functions.R") %>% source()


# here(dir_scripts_RWH, "Set_theme_ggplot2.R") %>% source()
# here(dir_scripts_RWH, "Useful_functions.R") %>% source()
# here(dir_scripts_RWH, "Clustering.R") %>% source()

# source(paste0(dir_scripts, "1d_quantseq_plotting_functions.R"))
# source("~/OneDrive - University of Edinburgh/R files/Labdata - RNAseq/Scripts_smallSLAM/3_analysis_TABACO.R")
