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
