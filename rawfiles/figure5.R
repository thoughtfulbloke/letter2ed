library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(ggtext)
library(patchwork)
source("theme.R")
six_cols <- colorblind_pal()(6)

VSD <- read.csv("DMM_CDRdec.csv", skip=1) |> 
  rename(Year=1, Deaths=2) |> 
  filter(!is.na(Deaths)) |> 
  mutate(Year = as.numeric(Year)) 

model <- lm(Deaths ~ Year, data=VSD |> filter(Year %in% 2012:2016))
VSD$expected <- model$coefficients[1] + 
  VSD$Year * model$coefficients[2]

ggplot(VSD |> filter(Year %in% 2010:2019), aes(x=Year, y=Deaths))+
  geom_point(size=0.3) +
         geom_line(aes(y=expected), linetype=2, colour=six_cols[2])+
  geom_line(data=VSD |> filter(Year %in% 2012:2016), aes(y=expected), colour=six_cols[2]) +
  theme_minimal(base_family="Open Sans",
                base_size = 6) +
  theme(
    plot.background = element_rect(fill = "#FAFAFA", colour="#FAFAFA"),
    panel.background = element_rect(fill = "#FFFFFF", colour = "#FFFFFF"),
    panel.spacing.x = unit(9, "points"),
    panel.spacing.y = unit(3, "points"),
    panel.grid = element_blank(),
    strip.background = element_rect(fill= "#FFFFFF", colour="#EFEFEF"),
    strip.text = element_text(margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt")),
    strip.placement = "inside",
    axis.title.y.left = element_text(margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt"))
  ) +
  labs(title="The crude death in 2017-2019 are above the 5 year linear trend for 2012-2016",
       subtitle="This is because, before covid, the accelerating aging population is accelerating deaths",
       y="Crude Death Rate", x="")

ggsave(filename="figure5.png",
       height=4, width = 6, dpi=300, units = "in", bg = "white")

VSD$perc = 100*VSD$Deaths/VSD$expected-100


## https://www.abs.gov.au/articles/measuring-australias-excess-mortality-during-covid-19-pandemic-until-first-quarter-2023#methodology


