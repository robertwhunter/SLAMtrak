## READ-IN ----

df_meta <- read_csv(here(dir_active, "output", "meta.csv"))
df_meta_short <- read_csv(here(dir_active, "output", "meta_short.csv"))
df_QC <- read_csv(here(dir_active, "output", "QC.csv"))
df_tcounts <- read_csv(here(dir_active, "output", "tcounts.csv"))
df_mutations_L <- read_csv(here(dir_active, "output", "mutations_L.csv"))
df_marker_origin <- read_csv(here(dir_active, "output", "markers_origin.csv"))
df_marker_target <- read_csv(here(dir_active, "output", "markers_target.csv"))

## FACTORS ----

df_tcounts$tissue %>% 
  as.factor() %>% 
  fct_relevel(exp_tissue_origin, exp_tissue_target) -> df_tcounts$tissue

here(dir_scripts, "SLAMtrack_x2_factors.R") %>% source()
