# SLAMtrack

## Overview  

These `.Rmd` files are designed to analyse SLAMseq data from experiments tracking extracellular RNA (exRNA).  The input data can take the form of mRNA data (output from [slamdunk](https://t-neumann.github.io/slamdunk/) pipeline) or small RNA data (output from [smallSLAM](https://github.com/robertwhunter/smallSLAM) pipeline).  In an exRNA-tracking experiment, RNA is labelled in a cell or tissue of **origin**; labelled RNA is then sought in a **target** cell or tissue.  

There are five markdown files:  

- `1_QC` - basic data description / QC  
- `2_mutations` \* - pairwise nucleotide conversion rates (i.e. not just T>C)  
- `3_TC`- T>C conversion rates  
- `4_labelled_genes` - identifying labelled genes  
- `5_miniMAP` \* - looking for candidate genes  

\* - currently only set up for slamdunk (NOT smallSLAM) data


## Set-up

### Data inputs

A data directory containing three sub-directories:  

1) `slamdunk/` - standard output from slamdunk pipeline  
2) `input/` - contanining `metadata.csv`, `all_cell_markers.txt` and `exp_setup.txt`
3) `output/` - empty (will be filled by SLAMtrack outputs)  

The `metadata.csv` file can have any desired user-determined fields, but must include:  

- `sample_name`  
- `group`  
- `tissue`  


The `exp_setup.txt` file contains a free-text description of the experimental design.  


### Scripts

Need to set parameters in `SLAMtrack_00_setup.R`, e.g.:  

```{r example_parameters}

# experimental descriptors
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

Render all markdown files by running `SLAMtrack_render.R` and calling `pre_render_SLAMtrak` then `render_SLAMtrak`.  


## Outputs

Intermediate .csv datafiles - to save time when re-importing data for analysis.  

Html reports with figures as separate files.  
