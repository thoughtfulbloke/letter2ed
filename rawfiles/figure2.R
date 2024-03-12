library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(ggtext)
library(patchwork)

ASMR <- read.csv("DMM_Standardised_Death_Rates.csv", skip=1, 
                 col.names = c("Year","ASMR1K")) |> 
  filter(!is.na(ASMR1K)) |> 
  mutate(Year = as.numeric(Year)) |> 
  filter(Year > 1990)

longmod <- lm(ASMR1K ~ Year, data=ASMR |> filter(Year < 2017))
ASMR$longExp <- longmod$coefficients[1] + 
  ASMR$Year * longmod$coefficients[2]

shortmod <- lm(ASMR1K ~ Year, data=ASMR |> filter(Year %in% 2010:2016))
ASMR$shortExp <- shortmod$coefficients[1] + 
  ASMR$Year * shortmod$coefficients[2]
ASMR$shortExp[ASMR$Year < 2010] <- NA_real_

xis<- c(2017,
        2018,
        2019,
        2019,
        2018,
        2017)
yis <- c(
  3.180031,
  3.073993,
  2.967956,
  3.351429,
  3.406429,
  3.461429)

structural_over17_19 <- sum(ASMR$shortExp[ASMR$Year %in% 2017:2019] /
  ASMR$longExp[ASMR$Year %in% 2017:2019])

ggplot(ASMR |> filter(Year < 2020), 
              aes(x=Year, y=ASMR1K))+
  annotate("polygon",x=xis,y=yis,fill="skyblue")+
  geom_point(size=0.3) +
         geom_line(aes(y=longExp), linetype=2)+
         geom_line(aes(y=shortExp), linetype=2) +
  geom_line(data=ASMR |> filter(Year < 2017), aes(y=longExp)) +
  geom_line(data=ASMR |> filter(Year < 2017),aes(y=shortExp)) +
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
  labs(title="Structural Error created when applying an overlong baseline period to predicting mortality in 2017-2019",
       subtitle="Normal 7 year baseline 2010-2016, overlong baseline 1991-2016",
       y="Age Standardised Mortality Rates", x="")

ggsave(filename="figure2.png",
       height=4, width = 6, dpi=300, units = "in", bg = "white")

# insetgraph <- ggplot(ASMR |> filter(Year < 2020, Year > 2014), 
#                      aes(x=Year, y=ASMR1K))+
#   geom_line(aes(y=longExp))+
#   geom_line(aes(y=shortExp))+
#   geom_point(size=0.3)
# outergraph<- ggplot(ASMR |> filter(Year < 2020), 
#        aes(x=Year, y=ASMR1K))+
#   geom_line(aes(y=longExp))+
#   geom_line(aes(y=shortExp))+
#   geom_point(size=0.3) +annotate("polygon",x=xis,y=yis,colour="blue")
# outergraph + annotation_custom(ggplotGrob(insetgraph), 
#                                xmin = 2008, xmax = 2019,
#                                ymin = 4.5, ymax = 6)

StructErr <- data.frame(startYr <- 2006:2016)

prederror <- function(x, asm = ASMR |> filter(Year %in% 2002:2019)){
  modelm <- lm(ASMR1K ~ Year, data=asm |> filter(Year %in% x:2016))
  asm$expec <- modelm$coefficients[1]+ asm$Year * modelm$coefficients[2]
  output <- data.frame(V1=asm$expec)
  names(output) <- paste0("e",x)
  return(output)
}
## https://www.abs.gov.au/articles/measuring-australias-excess-mortality-during-covid-19-pandemic-until-first-quarter-2023#methodology


