## import miniMAP data ----

here(dir_data, "miniMAP") %>% 
  list.files(pattern = ".hits", full.names = TRUE) -> f

here(dir_data, "miniMAP") %>%
  list.files(pattern = ".hits", full.names = FALSE) %>%
  gsub("__trimmed.hits", "", .) -> fs

fn_lookup <- data.frame("source" = 1:length(f), "library" = fs)
fn_lookup$source <- fn_lookup$source %>% as.character()

here(dir_data, "miniMAP") %>% 
  list.files(pattern = ".hits", full.names = TRUE) %>% 
  map_dfr(read_delim, delim="\t", .id = "source", col_names = FALSE) %>% 
  
  # re-shape
  select(source, gene = X1) %>%
  group_by(source, gene) %>% 
  summarise(
    mapping_hits = n()
  ) %>%
  ungroup() %>%
  complete(source, gene, fill = list(mapping_hits = 0)) %>% 

  # join to meta-data
  left_join(fn_lookup) %>% 
  left_join(df_QC) %>% 
  select(-source, -mapped:-counted) %>% 
  mutate(
    hits_pc = mapping_hits / sequenced * 100
    ) -> df_miniMAP