## READ-IN ----

df_meta <- read_csv(here(dir_data, "output", "meta.csv"))
df_meta_short <- read_csv(here(dir_data, "output", "meta_short.csv"))
df_tcounts <- read_csv(here(dir_data, "output", "tcounts.csv"))

if (exp_type == "slamdunk") {
  df_QC <- read_csv(here(dir_data, "output", "QC.csv"))
  df_mutations_L <- read_csv(here(dir_data, "output", "mutations_L.csv"))
  df_marker_origin <- read_csv(here(dir_data, "output", "markers_origin.csv"))
  df_marker_target <- read_csv(here(dir_data, "output", "markers_target.csv"))
}

if (exp_type == "smallslam") {
  df_marker_origin <- read_csv(here(dir_data, "output", "markers_origin_small.csv"))
  df_marker_target <- read_csv(here(dir_data, "output", "markers_target_small.csv"))
}


## FACTORS ----

if (exp_tissue_origin != exp_tissue_target) {

  df_tcounts$tissue %>% 
    as.factor() %>% 
    fct_relevel(exp_tissue_origin, exp_tissue_target) -> df_tcounts$tissue
  
} 

if (exp_tissue_origin == exp_tissue_target) {
  
  df_tcounts$tissue %>% 
    as.factor() -> df_tcounts$tissue
  
}

here(dir_data, "input", "SLAMtrack_x2_factors.R") %>% source()
