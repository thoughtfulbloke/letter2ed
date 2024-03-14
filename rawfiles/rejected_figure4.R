library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(ggtext)
source("theme.R")
six_cols <- colorblind_pal()(6)

CMR <- read.csv("DMM_CDRdec.csv", skip=1, 
                 col.names = c("Year","CDR1K")) |> 
  filter(!is.na(CDR1K)) |> 
  mutate(Year = as.numeric(Year)) 

mod7y <- lm(CDR1K ~ Year, data=CMR |> filter(Year %in% 2013:2019))
CMR$mod7y <- mod7y$coefficients[1] + 
  CMR$Year * mod7y$coefficients[2]

mod5y <- lm(CDR1K ~ Year, data=CMR |> filter(Year %in% 2015:2019))
CMR$mod5y <- mod5y$coefficients[1] + 
  CMR$Year * mod5y$coefficients[2]
CMR$percent5year <- 100*CMR$CDR1K/CMR$mod5y-100
CMR$percent7year <- 100*CMR$CDR1K/CMR$mod7y-100

excessdf <- data.frame(Baseline = c("2015-2019", "2013-2019", "2015-2019", "2013-2019",
                          "2015-2019", "2013-2019", "2015-2019", "2013-2019"),
           Year = c("2020","2020","2021","2021","2022","2022","nett","nett"),
           value = c(round(CMR$percent5year[CMR$Year == 2020],2),
                     round(CMR$percent7year[CMR$Year == 2020],2),
                     round(CMR$percent5year[CMR$Year == 2021],2),
                     round(CMR$percent7year[CMR$Year == 2021],2),
                     round(CMR$percent5year[CMR$Year == 2022],2),
                     round(CMR$percent7year[CMR$Year == 2022],2),
                     round(sum(CMR$percent5year[CMR$Year %in% 2020:2022]),2),
                     round(sum(CMR$percent7year[CMR$Year %in% 2020:2022]),2)))
innergraph <- ggplot(excessdf, aes(x=Year,y=Baseline, label=value))+
  geom_tile(fill="white", colour="black") +geom_text() + theme_tufte()  +
  scale_x_discrete(position = "top")+
  labs(title="Excess as percent of expected", y="Baseline\n ",x="")
  
ggplot(CMR |> filter(Year %in% 2012:2023), 
              aes(x=Year, y=CDR1K))+
  annotation_custom(ggplotGrob(innergraph), 
                    xmin = 2012, xmax = 2019,
                    ymin = 7, ymax = 7.5)+
  geom_point(size=0.3) +
         geom_line(aes(y=mod7y), linetype=2, colour=six_cols[2])+
         geom_line(aes(y=mod5y), linetype=2, colour=six_cols[3]) +
  geom_line(data=CMR |> filter(Year %in% 2013:2019), aes(y=mod7y), colour=six_cols[2]) +
  geom_line(data=CMR |> filter(Year %in% 2015:2019),aes(y=mod5y), colour=six_cols[3]) +
  theme_davidhood() +
  labs(title="Crude Mortality Rate (ignoring aging) and excess relative to linear baseline",
       subtitle="Orange: 2013-17 baseline, Blue:2015-2019 baseline",
       y="Crude Mortality Rates", x="")

ggsave(filename="~/Desktop/figure4.png", height=4, width = 6, dpi=300, 
       units = "in", bg = "white")

