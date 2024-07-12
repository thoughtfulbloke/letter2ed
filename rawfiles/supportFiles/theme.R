six_cols <- colorblind_pal()(6)

theme_davidhood <- function(){
  theme_minimal(base_family="Arial",
                base_size = 9) %+replace%  
    theme(axis.line.x = element_line(linewidth=0.2),
          axis.line.y = element_line(linewidth=0.2),
          axis.ticks = element_line(linewidth=0.2),
          axis.title.y.left = element_text(margin = margin(t = 2, r = 2, b = 2, l = 2, unit = "pt")),
          panel.background = element_rect(fill = "#FFFFFF", colour = "#FFFFFF"),
          panel.grid = element_blank(),
          plot.title = element_text(lineheight = 1.18, size=10,
                                    margin=margin(t = 5, r = 0, b = 5, l = 15, unit = "pt"),
                                    hjust=0, vjust=0),
          plot.subtitle = element_text(lineheight = 1.18, size=8,
                                    margin=margin(t = 0, r = 15, b = 5, l = 15, unit = "pt"),
                                    hjust=0),
          plot.background = element_rect(fill = "#FFFFFF", colour="#FFFFFF"),
          plot.caption = element_text(margin=margin(t = 5, r = 5, b = 5, l = 5, unit = "pt"),
                                      lineheight = 1.15,
                                      size=6.5, hjust=1),
          plot.caption.position = "plot")
  
}
