six_cols <- colorblind_pal()(6)
footer <- paste0("\nGraph made ", trimws(format(Sys.time(), format="%e %b %Y")),". Graphs: thoughtfulnz.quarto.pub/nzcovidreport/ Contact: thoughtfulnz on mastodon.nz or bsky.app\n")

theme_davidhood <- function(){
  theme_minimal(base_family="Open Sans",
                base_size = 9) %+replace%  
    theme(axis.line.x = element_line(linewidth=0.1),
          axis.line.y = element_line(linewidth=0.1),
          axis.ticks = element_line(linewidth=0.2),
          axis.title.y.left = element_text(margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt")),
          strip.background = element_rect(fill= "#FFFFFF", colour="#EFEFEF"),
          strip.text = element_text(margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt")),
          strip.placement = "inside",
          panel.background = element_rect(fill = "#FFFFFF", colour = "#FFFFFF"),
          panel.spacing.x = unit(9, "points"),
          panel.spacing.y = unit(3, "points"),
          panel.grid = element_blank(),
          plot.title = element_text(lineheight = 1.18, size=11,
                                    margin=margin(t = 5, r = 0, b = 5, l = 15, unit = "pt"),
                                    hjust=0, vjust=0),
          plot.subtitle = element_text(lineheight = 1.18, size=8,
                                    margin=margin(t = 0, r = 15, b = 5, l = 15, unit = "pt"),
                                    hjust=0),
          plot.background = element_rect(fill = "#FCFCFC", colour="#FCFCFC"),
          plot.caption = element_text(margin=margin(t = 5, r = 5, b = 5, l = 5, unit = "pt"),
                                      lineheight = 1.15,
                                      size=7, hjust=1),
          plot.caption.position = "plot")
  
}
