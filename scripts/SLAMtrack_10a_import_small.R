library(tidyverse)
library(here)

## IMPORT META-DATA ----

df_meta <- here(dir_data, "input", "metadata.csv") %>% read_csv()

df_meta %>% 
  select(
    library, sample_name, tissue, group
  ) -> df_meta_short


## IMPORT TCOUNTS ----

dir_scounts <- here(dir_data, "Summary")

fn_scounts <- list.files(dir_scounts, pattern = "_scount.csv", full.names = TRUE) %>% set_names()
fn_scounts %>% 
  purrr::map_dfr(read_csv, .id = "library") %>% 
  mutate(library = word(basename(library))) %>%  
  mutate(library = gsub("_scount.csv", "", library)) %>% 
  left_join(df_meta_short, .) -> df_tcounts

df_tcounts <- df_tcounts %>% rename("gene_name" = gene)

df_tcounts$gene_name <- df_tcounts$gene_name %>% as.factor()

df_tcounts <- df_tcounts %>% filter(readsCPM > 0)


## IMPORT CELL MARKER LOOK-UP TABLE ----

# From A mouse tissue atlas of small noncoding RNA
# https://www.pnas.org/content/117/41/25634
# https://www.pnas.org/highwire/filestream/951687/field_highwire_adjunct_files/4/pnas.2002277117.sd04.xlsx # Dataset S04


df_marker_small <- here(dir_data, "input", "cell_markers_miRNA.csv") %>% read_csv

restriction_threshold <- 100

df_marker_small %>% 
  filter(tolower(Tissue) %in% c(exp_tissue_origin_organ, exp_tissue_target_organ)) %>% 
  select(-Arm, -Gene) %>% 
  drop_na() %>% 
  pivot_wider(names_from = Tissue, values_from = Expression) -> df_marker_small_wide

if (exp_tissue_origin_organ != exp_tissue_target_organ) {

  df_marker_small_wide %>% 
    mutate(
      ratio = .[[2]] / .[[3]],
      tissue = case_when(
        ratio > 1 ~ colnames(df_marker_small_wide)[2],
        ratio < 1 ~ colnames(df_marker_small_wide)[3]
      ),
      restricted = case_when(
        ratio < 1/restriction_threshold | ratio > restriction_threshold ~ TRUE
      )) %>% 
    filter(restricted == TRUE) -> df_marker_small_restricted
  
}

if (exp_tissue_origin_organ == exp_tissue_target_organ) {

  df_marker_small_wide %>% 
    mutate(
      tissue = exp_tissue_origin_organ
    ) %>% 
    filter(.[[2]] > 0.1) -> df_marker_small_restricted
}

df_marker_small_restricted %>% 
  mutate(
    tissue = tolower(tissue),
    cell = tissue,
    gene = paste0("Mus musculus (house mouse) ", miRNA)
  ) -> df_marker_small_restricted

df_marker_small_restricted %>% 
  filter(tissue == tolower(exp_tissue_origin_organ)) %>% 
  select(tissue, cell, gene) -> df_marker_origin_small

df_marker_small_restricted %>% 
  filter(tissue == tolower(exp_tissue_target_organ)) %>% 
  select(tissue, cell, gene) -> df_marker_target_small


## WRITE-OUT ----
  
df_meta %>% write_csv(here(dir_data, "output", "meta.csv"))
df_meta_short %>% write_csv(here(dir_data, "output", "meta_short.csv"))
df_tcounts %>% write_csv(here(dir_data, "output", "tcounts.csv"))
df_marker_origin_small %>% write_csv(here(dir_data, "output", "markers_origin_small.csv"))
df_marker_target_small %>% write_csv(here(dir_data, "output", "markers_target_small.csv"))
