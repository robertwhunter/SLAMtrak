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


## WRITE-OUT ----
  
df_meta %>% write_csv(here(dir_data, "output", "meta.csv"))
df_meta_short %>% write_csv(here(dir_data, "output", "meta_short.csv"))
df_tcounts %>% write_csv(here(dir_data, "output", "tcounts.csv"))
