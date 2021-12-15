## LIBRARIES ----

library(ggplot2)
library(cowplot)
library(ggsci)
library(RColorBrewer)
library(ggridges)


## PALETTES ----

palette_SLAMtrack_1 <- c("red", "blue", "green", "orange", "darkgrey", "lightblue", "purple", "black")
palette_SLAMtrack_2 <- c("red", "blue", "darkgreen", "purple", "black", "pink", "orange", "lightblue", "lightgreen")
palette_biotypes <- c("DarkGrey", "LightGrey", "Pink", "LightGreen", "DarkBlue", "Yellow", "Purple", "Orange", "DarkGreen", "DodgerBlue", "Red")

# sc_SLAMtrack_groups <- scale_colour_manual(values = palette_SLAMtrack_1)
# sf_SLAMtrack_groups <- scale_fill_manual(values = palette_SLAMtrack_1)
sc_SLAMtrack_groups <- scale_colour_locuszoom()
sf_SLAMtrack_groups <- scale_fill_locuszoom()
# 
# sc_SLAMtrack_highlights <- scale_color_manual(values = c("red", "lightgrey"))
# 
sc_SLAMtrack1 <- scale_colour_brewer(palette = "Paired")
sf_SLAMtrack1 <- scale_fill_brewer(palette = "Paired")
# 
# sc_SLAMtrack2 <- scale_colour_brewer(palette = "Spectral")
# sf_SLAMtrack2 <- scale_fill_brewer(palette = "Spectral")
# 
# sc_SLAMtrack3 <- scale_colour_locuszoom()
# sf_SLAMtrack3 <- scale_fill_locuszoom()
# 
# sf_SLAMtrack4 <- scale_fill_viridis_c(option = "magma", direction = -1, limits = c(0, 0.1))
# sf_SLAMtrack4L <- scale_fill_viridis_c(option = "magma", direction = -1, trans = "log", breaks = c(0.00001, 0.0001, 0.001, 0.01, 0.1))
# 
# sc_SLAMtrack5 <- scale_colour_viridis_c(option = "magma", direction = -1)
# sc_SLAMtrack5_fixed <- scale_colour_viridis_c(option = "magma", limits=c(0,0.1), direction = -1)
# sc_SLAMtrack5L <- scale_colour_viridis_c(option = "magma", direction = -1, trans = "log", breaks = c(0.00001, 0.0001, 0.001, 0.01), na.value = "green")
# sc_SLAMtrack5L_fixed <- scale_colour_viridis_c(option = "magma", direction = -1, trans = "log", breaks = c(0.00001, 0.0001, 0.001, 0.01), limits = c(1e-6, 1e-1), na.value = "green")
# 
# sf_SLAMtrack5 <- scale_fill_viridis_c(option = "magma", direction = -1)
# sf_SLAMtrack5L <- scale_fill_viridis_c(option = "magma", direction = -1, trans = "log", breaks = c(1,10,100,1000,10000,100000))



## THEMES ----

theme_SLAMtrack <- function() {
  theme_minimal (base_size = 20, base_family = "Arial") +
    theme (
      panel.grid.major = element_line("grey", 0.1, 1), 
      panel.grid.minor = element_line("grey", 0.1, 2), 
      axis.line = element_line("darkgrey", 0.5, 0), 
      axis.text.x = element_text(size = rel(0.6), margin=margin(10,0,0,0)), 
      axis.text.y = element_text(size = rel(0.6), margin=margin(0,0,0,10)), 
      strip.text = element_text(colour = "black", size = rel(1.0), face="bold"),
      plot.caption = element_text(size = rel(0.6), face="italic", hjust = 0, margin=margin(30,0,0,0)),
      legend.background = element_blank(),
      legend.key = element_blank(),
      legend.title = element_text(size = rel(0.6), face="bold"),
      legend.text = element_text(size = rel(0.6)),
      legend.key.height=unit(2,"line")
    )
}

add_theme_SLAMtrack <- function(p) {
  p +
  theme_SLAMtrack() +
  guides(color = guide_legend(override.aes = list(alpha = 1))) +
  sc_SLAMtrack_groups +
  sf_SLAMtrack_groups
}

remove_guide_fill <- function(p) p + guides(color=guide_legend(override.aes=list(fill=NA))) 

theme_smaller <- function() theme(axis.text = element_text(size = 8),
                                  strip.text = element_text(size = 8),
                                  legend.text = element_text(size = 8),
                                  legend.title = element_text(size = 12),
                                  axis.title = element_text(size = 12),
                                  plot.title = element_text(size = 14)
)

theme_SLAMtrack_mutations_plot <- function() {
  theme_SLAMtrack() +
    theme (
      panel.grid.major.y = element_blank(), 
      panel.grid.minor.y = element_blank(), 
      axis.line.y = element_blank(), 
      axis.text.y = element_blank(),
      axis.title.y = element_blank()
    )
}

theme_SLAMtrack_horizontal <- function() {
  theme_SLAMtrack() +
    theme (
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank(),
      panel.grid.major.y = element_line("grey", 0.1, 1), 
      panel.grid.minor.y = element_line("grey", 0.1, 2), 
      axis.line.y = element_blank(), 
      axis.line.x = element_line("black", 0.5, 1)
    )
}
