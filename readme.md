---
title: "SLAMtrack - readme"
author: "RWH"
date: "`r format(Sys.time(), '%d %B %Y')`"

output: 
  html_document:
    theme: readable 
    highlight: pygments 
    anchor_sections: FALSE

---

```{r setup, include=FALSE}

knitr::opts_chunk$set(
  eval = FALSE,
  echo = TRUE
)
  
```


# Overview of SLAMtrack

# Set-up

## Data inputs

A data directory containing three sub-directories:  

1) `slamdunk/` - standard output from slamdunk pipeline  
2) `input/` - contanining `metadata.csv`, `all_cell_markers.txt` and `exp_setup.txt`
3) `output/` - empty (will be filled by SLAMtrack outputs)  

The `metadata.csv` file can have any desired user-determined fields, but must include:  

- `sample_name`  
- `group`  
- `tissue`  


The `exp_setup.txt` file contains a free-text description of the experimental design.  


## Scripts

Need to set parameters in `SLAMtrack_00_setup.R`, e.g.:  

```{r example_parameters}

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

```

Can add code to the following optional scripts:  

- `SLAMtrack_x1_repairnames.R` - to amend sample names in the slamdunk summary file  
- `SLAMtrack_x2_factors.R` - to set factor order (e.g. for experimental groups)  

Before running any of the .Rmd files, need to run the `SLAMtrack_10_import.R` script once.  


## Outputs

Intermediate .csv datafiles - to save time when re-importing data for analysis.  

Html reports with figures as separate files.  
