## MUTATIONS ----

reshape_mutations_for_TABACO <- function(df, plot_strand) {
  df %>% 
    filter(Strand == plot_strand) %>%
    mutate(
      base_from = substr(mutation, 1, 1),
      base_to = substr(mutation, 3, 3),
      freq = 1/mutation_rate
    ) 
}

plot_TABACO_grid_rates <- function(df_in) {
  df_in %>% mutate(
    base_from = paste0(base_from,">"),
    base_to = paste0(">",base_to)
  ) %>% 
    ggplot(aes(colour = group, y = mutation_rate)) + 
    geom_boxplot(outlier.shape = NA) +
    ylim(0, 0.006) +
    facet_grid(rows = vars(base_to), cols = vars(base_from)) +
    ylab("Mutation rate") +
    theme_SLAMtrack_horizontal() + 
    theme(axis.text.x = element_blank()) +
    sc_SLAMtrack_groups
}



## MARKER GENES ----

merge_markers <- function(df_tcounts, df_markers, cpm_threshold = 10, top_n = 8) {
  
  df_tcounts %>% 
    left_join(df_markers, by = c("gene_name" = "gene")) -> df_merged
  
  df_merged$cell %>% NA_sub_x("Not a marker gene") -> df_merged$cell
  
  df_merged %>% 
    group_by(cell) %>% 
    summarise(
      n_genes_high = sum(readsCPM > cpm_threshold)
    ) %>% 
    arrange(desc(n_genes_high)) -> df_ranked
  
  df_merged %>% 
    filter(cell %in% df_ranked$cell[1:top_n]) %>% 
    return()
  
}

merge_markers_delta <- function(df_tcounts, df_markers, cpm_threshold = 10, top_n = 8) {
  
  df_tcounts %>% 
    left_join(df_markers, by = c("gene_name" = "gene")) -> df_merged
  
  df_merged$cell %>% NA_sub_x("Not a marker gene") -> df_merged$cell
  
  df_merged %>% 
    select(-tissue) %>% 
    drop_na() %>% 
    group_by(cell) %>% 
    summarise(
      n_genes_high = sum(mean_CPM > cpm_threshold)
    ) %>% 
    arrange(desc(n_genes_high)) -> df_ranked
  
  df_merged %>% 
    filter(cell %in% df_ranked$cell[1:top_n]) %>% 
    return()
  
}

plot_markers_points <- function(df_plot) {
  df_plot %>% 
    ggplot(aes(y = group, x = conversionRate, colour = group)) +
    geom_point(alpha = 0.05, aes(size = readsCPM)) +
    facet_wrap(~cell, nrow = 2, labeller = label_wrap_gen()) +
    scale_x_sqrt() +
    xlab("T>C conversion rate") -> p
  
  p %>% add_theme_SLAMtrack() + theme_smaller()
}

plot_markers_ridges <- function(df_plot) {
  df_plot %>% 
    mutate(conversionRate = conversionRate + cR_nudge) %>% 
    ggplot(aes(y = 1, x = conversionRate, colour = group)) +
    geom_density_ridges(fill = NA) +
    facet_wrap(~cell, nrow = 2, labeller = label_wrap_gen()) +
    scale_x_log10() +
    xlab("T>C conversion rate") +
    ylab("proability density") -> p
  
  p %>% add_theme_SLAMtrack() + theme_smaller()
}

plot_markers_points_delta <- function(df_plot, cpm_threshold = 10, delta_threshold = 1) {
  df_plot %>% 
    filter(abs(delta) < delta_threshold) %>% 
    filter(mean_CPM >= cpm_threshold) %>% 
    ggplot(aes(x = cell, y = delta, size = mean_CPM)) +
    # geom_boxplot(colour = "pink") +
    geom_jitter(alpha = 0.3, width = 0.1) +
    coord_flip() +
    theme_SLAMtrack()
}

plot_markers_ridges_delta <- function(df_plot, cpm_threshold = 10, delta_threshold = 1) {
  df_plot %>% 
    filter(abs(delta) < delta_threshold) %>% 
    filter(mean_CPM >= cpm_threshold) %>% 
    ggplot(aes(x = cell, y = delta)) +
    # geom_boxplot(colour = "pink") +
    geom_density_ridges() +
    coord_flip() +
    theme_SLAMtrack()
}
