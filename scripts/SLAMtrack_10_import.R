## IMPORT META-DATA AND SUMMARY FILES ----

df_meta <- here(dir_data, "input", "metadata.csv") %>% read_csv()
df_files <- here(dir_data, "slamdunk", "summary") %>% read_tsv(skip = 1)

# repair names for this instance only
here(dir_data, "input", "SLAMtrack_x1_repairnames.R") %>% source()

df_files %>% 
  mutate(
    library = FileName %>% 
      sub('.*/', '', .) %>% 
      gsub("_.f*q_slamdunk_mapped_filtered.bam", "", .) %>% 
      gsub("_trimmed.f*q_slamdunk_mapped_filtered.bam", "", .) 
  ) -> df_files

df_files %>% 
  select(library, sample_name = SampleName) %>% 
  left_join(df_meta, .) -> df_meta

df_meta %>% 
  select(
    library, sample_name, tissue, group
  ) -> df_meta_short

df_files %>% 
  left_join(df_meta_short, by = c("library")) %>% 
  select(
    library, tissue, group, sample_name, Sequenced, Mapped, Retained, Counted) -> df_QC

colnames(df_QC) <- tolower(colnames(df_QC))


#### READ IN MULTQC DATA ----

# here(dir_data, "slamdunk", "multiqc_data", "multiqc_data.json") %>% fromJSON() -> QC_slamdunk
# here(dir_data, "slamdunk", "multiqc_data", "multiqc_general_stats.txt") %>% read_tsv() -> df_QC


## IMPORT TCOUNTS ----

here(dir_data, "slamdunk", "count") %>% 
  list.files(pattern = "_mapped_filtered_tcount_collapsed.csv", full.names = TRUE) -> f

here(dir_data, "slamdunk", "count") %>%
  list.files(pattern = "_mapped_filtered_tcount_collapsed.csv", full.names = FALSE) %>%
  gsub("_.fq_slamdunk_mapped_filtered_tcount_collapsed.csv", "", .) %>% 
  gsub("_trimmed.fq_slamdunk_mapped_filtered_tcount_collapsed.csv", "", .) -> fs

fn_lookup <- data.frame("source" = 1:length(f), "library" = fs)
fn_lookup$source <- fn_lookup$source %>% as.character()

f %>% 
  map_dfr(read_delim, delim="\t", .id = "source") %>% 
  left_join(fn_lookup, .) %>% 
  left_join(df_meta_short, .) -> df_tcounts

df_tcounts$gene_name <- df_tcounts$gene_name %>% as.factor()

df_tcounts <- df_tcounts %>% filter(readsCPM > 0)


## IMPORT MUTATION RATES

# read in MUTATIONS mapped to UTRs

here(dir_data, "slamdunk", "stats") %>% 
  list.files(pattern = "_mapped_filtered_mutationrates_utr.csv", full.names = TRUE) -> f

here(dir_data, "slamdunk", "stats") %>%
  list.files(pattern = "_mapped_filtered_mutationrates_utr.csv", full.names = FALSE) %>%
  gsub("_.f*q_slamdunk_mapped_filtered_mutationrates_utr.csv", "", .) %>% 
  gsub("_trimmed.f*q_slamdunk_mapped_filtered_mutationrates_utr.csv", "", .) -> fs

fn_lookup <- data.frame("source" = 1:length(f), "library" = fs)
fn_lookup$source <- fn_lookup$source %>% as.character()

f %>%
  map_dfr(read_table2, skip=2, .id = "source") %>%
  left_join(fn_lookup, .) %>%
  left_join(df_meta_short, .) -> df_mutations

df_mutations$Name <- df_mutations$Name %>% as.factor()

# takes a long time to run because of the first mutate step
df_mutations %>%
  filter(ReadCount > mutations_threshold_readcount) %>%
  select(sample_name, Name, Strand, A_A:N_N) %>% 
  select(-contains("N_", ignore.case = F), -contains("_N", ignore.case = F)) %>% 
  rowwise() %>%
  mutate(
    A_count = sum(c_across(contains("A_"))),
    C_count = sum(c_across(contains("C_"))),
    G_count = sum(c_across(contains("G_"))),
    T_count = sum(c_across(contains("T_")))
  ) %>%
  ungroup() %>%
  select(-`A_A`, -`C_C`, -`G_G`, -`T_T`) %>%
  pivot_longer(
    cols = `A_C`:`T_G`,
    names_to = "mutation",
    values_to = "mutation_count") %>%
  mutate(
    mutation_rate = case_when(
      substr(mutation,1,1) == "A" ~ mutation_count / A_count,
      substr(mutation,1,1) == "C" ~ mutation_count / C_count,
      substr(mutation,1,1) == "G" ~ mutation_count / G_count,
      substr(mutation,1,1) == "T" ~ mutation_count / T_count
    )
  ) -> df_mutations_L

df_mutations_L$mutation <- df_mutations_L$mutation %>% gsub("_", ">", .) %>% as.factor()


## IMPORT CELL MARKER LOOK-UP TABLE ----

# From CellMarker database
# https://academic.oup.com/nar/article/47/D1/D721/5115823
# http://biocc.hrbmu.edu.cn/CellMarker/index.jsp
# http://biocc.hrbmu.edu.cn/CellMarker/download/Mouse_cell_markers.txt

df_marker_full <- here(dir_data, "input", "all_cell_markers.txt") %>% read_tsv

df_marker_full %>% 
  filter(
    tolower(speciesType) == exp_species,
    cellType == "Normal cell",
    tolower(tissueType) %in% c(exp_tissue_origin_organ, exp_tissue_target_organ)) %>% 
  select(
    tissue = tissueType,
    cell = cellName,
#    marker = cellMarker,
    gene = geneSymbol
  ) -> df_marker

  df_marker$gene %>% strsplit(split = ",") -> df_marker$gene
  df_marker %>% unnest(gene) -> df_marker
  
  df_marker$gene %>% trimws() %>% as.factor() -> df_marker$gene
  df_marker$cell %>% as.factor() -> df_marker$cell
  df_marker %>% unique() %>% drop_na() %>% filter(gene != "NA") -> df_marker
  
  df_marker %>% filter(tolower(tissue) == exp_tissue_origin_organ) -> df_marker_origin
  df_marker %>% filter(tolower(tissue) == exp_tissue_target_organ) -> df_marker_target
  
  

## WRITE-OUT ----
  
df_meta %>% write_csv(here(dir_data, "output", "meta.csv"))
df_meta_short %>% write_csv(here(dir_data, "output", "meta_short.csv"))
df_QC %>% write_csv(here(dir_data, "output", "QC.csv"))
df_tcounts %>% write_csv(here(dir_data, "output", "tcounts.csv"))
df_mutations_L %>% write_csv(here(dir_data, "output", "mutations_L.csv"))
df_marker_origin %>% write_csv(here(dir_data, "output", "markers_origin.csv"))
df_marker_target %>% write_csv(here(dir_data, "output", "markers_target.csv"))
