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

1) `slamdunk/` or `Summary/` - standard output from slamdunk or smallslam pipeline respectively  
2) `input/` - containing `metadata.csv`, `all_cell_markers.txt`, `exp_setup.txt`, `exp_setup.png` and bespoke Rscripts
3) `output/` - empty (will be filled by SLAMtrack outputs)  


The `metadata.csv` file can have any desired user-determined fields, but must include:  

- `sample_name`  
- `group`  
- `tissue`  

The `exp_setup.txt` file contains a free-text description of the experimental design.  
The `exp_setup.png` file contains a picture of the experimental design.  


The bespoke R scripts are:  

- `SLAMtrack_x0_parameters.R`  
- `SLAMtrack_x1_repairnames.R` - optional code to amend sample names in the slamdunk summary file  
- `SLAMtrack_x2_factors.R` - optional code to set factor order (e.g. for experimental groups) 


Need to set parameters in `SLAMtrack_x0_parameters.R`, e.g.:  

```{r example_parameters}

# experimental descriptors
exp_tissue_origin <- "liver" 
exp_tissue_target <- "kidney"
exp_tissue_origin_organ <- "liver"
exp_tissue_target_organ <- "kidney"

exp_species <- "mouse"

baseline_group <- "4TUneg"            # baseline control group (often 4TU-negative)
pos_group <- "crepos"                 # positive experimental group
neg_group <- "creneg"                 # negative control group in delta-TC analysis (often Cre-negative)

```

Default parameters are set in `SLAMtrack_x0_parameters_deault.R` in the generic scripts directory; these can be over-written in the `SLAMtrack_x0_parameters.R` file in the input directory.  

```{r default_parameters}

# analysis parameters
mutations_threshold_readcount <- 100    # include reads about this threshold when counting mutations
cR_nudge <- 10e-9                       # shift when plotting mutation rates on a log scale

threshold_TC_centile <- 0.99            # threshold for calling labelled reads

threshold_coT <- 100                    # threshold for inclusion in delta analysis
threshold_median_cpm_abundant <- 5      # threshold for abundance in tissue of origin in delta analysis 
threshold_delta_basal_centile <- 0.95   # threshold for calling labelled reads in tissue of origin 
threshold_delta_target_centile <- 0.95  # threshold for calling labelled reads in target tissue

```


## Workflow

1) ensure data, `input`, and `output` directories are correctly set up  
2) edit parameters in `SLAMtrack_00_setup.R`  
3) source `SLAMtrak_render.R` to load the rendering functions  
4) call `pre_render_SLAMtrak(fname, exp_type)` to pull in raw data  
5) call `render_SLAMtrak(fname, exp_type)` to render the markdown documents  

...where `fname` is the name of the data directory and `exp_type` is either "slamdunk" or "smallslam".  


## Outputs

Intermediate .csv datafiles - to save time when re-importing data for analysis.  
Html reports with figures as separate files.  
