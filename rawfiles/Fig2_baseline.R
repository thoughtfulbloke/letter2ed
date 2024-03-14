library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(ggtext)
source("theme.R")

ASMR <- read.csv("StatsNZData/DMM_SDR_TotPop.csv", skip=1, 
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
  annotate("polygon",x=xis,y=yis,fill=six_cols[3])+
  geom_point(size=0.3) +
         geom_line(aes(y=longExp), linetype=2)+
         geom_line(aes(y=shortExp), linetype=2) +
  geom_line(data=ASMR |> filter(Year < 2017), aes(y=longExp)) +
  geom_line(data=ASMR |> filter(Year < 2017),aes(y=shortExp)) +
  theme_davidhood() +
  theme(plot.title = element_markdown(lineheight = 1.18, size=11,
                                      margin=margin(t = 5, r = 15, b = 5, l = 0, unit = "pt"),
                                      hjust=0, vjust=0)) +
  labs(title=paste0("<span style='color:", six_cols[3],"'>Structural Error</span> from an overlong baseline period in predicting 2017-2019"),
       subtitle="Normal 7 year baseline 2010-2016, overlong baseline 1991-2016",
       y="Age Standardised Mortality Rates", x="",
       caption="Source: infoshare.stats.govt.nz : Death Rates : Standard")
ggsave(filename="md_figures/figure2.png",
       height=4, width = 6, dpi=300, units = "in", bg = "white")
ggsave(filename="../md_figures/figure2.png",
       height=4, width = 6, dpi=300, units = "in", bg = "white")
