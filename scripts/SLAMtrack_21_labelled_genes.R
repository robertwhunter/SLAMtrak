#### get_delta function ----

get_delta <- function(df, exp_tissue, group1, group2) {
  
  # first filter to exclude coverageOnTs < threshold
  # drop any genes without valid conversionRate in both groups (drop_na at end)  
  
  df %>% 
    filter(tissue %in% exp_tissue) %>% 
    filter(coverageOnTs >= threshold_coT) %>% 
    filter(group %in% c(group1, group2)) %>% 
    select(group, sample_name, gene_name, cR = conversionRate, readsCPM) -> df
  
  df %>%
    group_by(gene_name) %>%
    summarise(
      median_CPM = median(readsCPM)
    ) -> df_cpm
  
  df %>%
    group_by(gene_name, group) %>%
    summarise(
      median_CR = median(cR)
    ) %>%
    pivot_wider(names_from = group, values_from = median_CR) %>%
    mutate(
      delta := !!as.name(group2) - !!as.name(group1)) -> df_delta
  
  df %>%
    group_by(gene_name, group) %>%
    summarise(
      sum_CR = sum(cR)
    ) %>%
    pivot_wider(names_from = group, values_from = sum_CR) %>%
    mutate(
      sum_all := !!as.name(group1) + !!as.name(group2)) %>%
    select(gene_name, sum_all) -> df_sum
  
  df_delta %>%
    left_join(df_sum, by = "gene_name") %>%
    left_join(df_cpm, by = "gene_name") %>%
    mutate(
      `delta sign` = case_when(
        delta > 0 ~ "pos",
        delta < 0 ~ "neg",
        delta == 0 ~ "zero")
    ) %>%
    drop_na() %>%
    return()
  
}

#### delta plotting functions ----

delta_tabulate <- function(df_delta) df_delta %>% group_by(`delta sign`) %>% summarise(n = length(gene_name)) %>% knitr::kable()


delta_plot_distrubution <- function(df_delta, Q95 = 0) {
  
  #  df_delta %>% 
  #    ggplot(aes(x = delta, y = 1)) + 
  #    geom_density_ridges() -> p_test
  
  #  ytop <- ggplot_build(p_test)$layout$panel_params[[1]]$y.range[2]
  #  yrug <- -(ytop / 20)
  
  df_delta %>% 
    ggplot(aes(x = delta, y = 1)) + 
    geom_density_ridges(fill = NA) + 
    #  geom_point(aes(y = yrug), alpha = 0.01, colour = "red", shape = "|") +
    geom_vline(aes(xintercept = 0), linetype = 2, colour = "red") +
    xlab("gene-wise delta T>C") +
    ylab("count") +
    theme_SLAMtrack() +
    theme_smaller() -> p
  
  if (Q95 != 0) p <- p + geom_vline(aes(xintercept = Q95), linetype = 1, colour = "blue")
  
  zoom <- df_delta$delta %>% quantile(0.98)
  
  list(
    plot_full = p,
    plot = p + coord_cartesian(xlim = c(-zoom, zoom)) 
  ) %>% return()
  
}


delta_plot_vs_cpm <- function(df_delta) {
  
  df_delta %>% 
    ggplot(aes(x = median_CPM, y = delta)) + 
    geom_point(alpha = 0.01) +
    geom_smooth() +
    scale_x_log10() +
    geom_hline(aes(yintercept = 0), linetype = 2, colour = "red") +
    xlab("gene abundance \n(median cpm across all samples)") +
    theme_SLAMtrack() -> q
  
  zoom <- df_delta$delta %>% quantile(0.98)
  
  list(
    plot_full = q,
    plot = q + coord_cartesian(ylim = c(-zoom, zoom)) 
  ) %>% return()
  
}


delta_plot_rug <- function(df_delta) {
  
  zoom <- df_delta$delta %>% quantile(0.99)
  
  df_delta %>% 
    group_by(labelled_in_origin) %>% 
    summarise(
      mean = mean(delta),
      sd = sd(delta),
      n = length(delta)) %>% 
    mutate(
      sem = sd/sqrt(n),
      CI_upper = mean + 1.96*sem,
      CI_lower = mean - 1.96*sem
    ) -> df_stats
  
  df_delta %>% 
    ggplot(aes(x = delta, y = labelled_in_origin)) + 
    geom_point(alpha = 0.3, colour = "red", shape = "|") +
    geom_vline(aes(xintercept = 0), linetype = 2, colour = "red") +
    geom_point(data = df_stats, aes(x = mean, y = labelled_in_origin)) +
    geom_errorbar(data = df_stats, aes(x = mean, xmin = CI_lower, xmax = CI_upper, y = labelled_in_origin), width = 0.3) +
    xlab("gene-wise delta T>C") +
    ylab("count") + 
    coord_cartesian(xlim=c(-zoom, zoom)) +
    theme_SLAMtrack() 
  
}


delta_merge_markers <- function(df_delta, df_markers, cpm_threshold = 10, top_n = 8) {
  
  df_delta %>% 
    left_join(df_markers, by = c("gene_name" = "gene")) -> df_merged
  
  df_merged$cell %>% NA_sub_x("Not a marker gene") -> df_merged$cell
  
  df_merged %>% 
    select(-tissue) %>% 
    drop_na() %>% 
    group_by(cell) %>% 
    summarise(
      n_genes_high = sum(median_CPM > cpm_threshold)
    ) %>% 
    arrange(desc(n_genes_high)) -> df_ranked
  
  df_merged %>% 
    filter(cell %in% df_ranked$cell[1:top_n]) %>% 
    return()
  
}

delta_plot_markers_points <- function(df_plot) {
  df_plot %>% 
    ggplot(aes(x = cell, y = delta, size = median_CPM)) +
    geom_jitter(alpha = 0.3, width = 0.1) +
    geom_hline(yintercept = 0, colour = "Red", linetype = 2) +
    coord_flip() +
    theme_SLAMtrack()
}

delta_plot_markers_ridges <- function(df_plot) {
  df_plot %>% 
    ggplot(aes(x = delta, y = cell)) +
    geom_density_ridges(fill = "black", colour = NA, alpha = 0.6, panel_scaling = FALSE) + 
    theme_SLAMtrack()
}
