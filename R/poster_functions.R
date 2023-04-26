library(tidyverse)
library(patchwork)

fxn_make_poster <- function(.title){

annual_plot / daily_plot +
  plot_layout(heights = c(.25,1)) +
  plot_annotation(title = .title,
                  theme = theme(plot.title = element_text(hjust = 0.5,
                                                          size = 90),
                                text = element_text(family="amatic-sc", face = "bold", color = "white"),
                                plot.background = element_rect(fill = "grey25", colour="grey25"),
                                panel.background = element_rect(fill = "grey25", colour="grey25"),
                                plot.margin = margin(rep(70,4))))
}
