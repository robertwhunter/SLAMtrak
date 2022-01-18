gene_of_interest <- "mmu-miR-122-" # liver
gene_of_interest <- "mmu-miR-126" # endothelial
gene_of_interest <- "mmu-miR-196" # kidney
gene_of_interest <- "mmu-miR-192" # liver again but also kidney
 
# NB need to ensure not calling 4-digit miRs and including isoforms etc. - perhaps better as a list?


df_tcounts %>% 
  filter(grepl(gene_of_interest, gene_name)) %>% 
    ggplot(aes(x = group, y = conversionRate)) +
      geom_boxplot(width = 0.2, fill = "red", colour = "grey", alpha = 0.2) +
      geom_jitter(width = 0.1, alpha = 0.6) +
      facet_wrap(~tissue) +
      theme_SLAMtrack() +
      sc_SLAMtrack_groups +
      ggtitle(gene_of_interest)
