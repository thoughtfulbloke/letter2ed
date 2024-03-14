# table comparing CDR and ASMR predictions

library(dplyr)
library(tidyr)
library(ggplot2)
library(ggplot2)
library(ggthemes)
library(ggtext)
source("theme.R")
six_cols <- colorblind_pal()(6)

autoAge <- paste(0:94,"Years")
autoAge <- c(autoAge,"95 Years and Over")
DPE <- read.csv("StatsNZData/DPE_PopDecMean_age_sex.csv", skip=2,
                col.names = c("Year","Age","Male","Female")) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year)) |> 
  fill(Year) |> 
  filter(Age %in% autoAge) |> 
  mutate(AgeN = as.numeric(gsub(" .*","",Age)),
         Year = as.numeric(Year)) |> 
  gather(key="Sex",value="MeanPopulation", Male:Female) |> 
  filter(AgeN >=75) |> 
  summarise(.by=Year,
            Living75plus = sum(MeanPopulation))

LifeModel <- lm(Living75plus ~ Year, data=DPE |> filter(Year %in% 2012:2016))
DPE$Expected <- LifeModel$coefficients[1] + LifeModel$coefficients[2]*DPE$Year

ggplot(DPE, aes(x=Year, y=Living75plus))+
  geom_point() +
  geom_line(aes(y=Expected), colour=six_cols[2], linetype=2) +
  geom_line(data=DPE |> filter(Year < 2017), aes(y=Expected), colour=six_cols[2]) +
  theme_davidhood() +
  scale_x_continuous(breaks=c(2012,2016,2020))+
  labs(title="Actual 75 years and older vs 2012-2016 trend",
       y="Residents 75 years and Older", x="Year",
       caption="Source: infoshare.stats.govt.nz")
ggsave(filename="md_figures/figure4.png",
       height=4, width = 6, dpi=300, units = "in", bg = "white")
ggsave(filename="../md_figures/figure4.png",
       height=4, width = 6, dpi=300, units = "in", bg = "white")

