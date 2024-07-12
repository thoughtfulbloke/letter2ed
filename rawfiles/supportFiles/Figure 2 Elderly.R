# 75+ trend

library(dplyr)
library(tidyr)
library(ggplot2)
library(ggplot2)
library(ggthemes)
library(ggtext)
source("theme.R")
six_cols <- colorblind_pal()(6)

DPE_male <- read.csv("RawData/DPE_PopDecMean_age_sex.csv", skip=3) |> 
  select(c(1,131)) |> 
  rename(Year = 1, seventyfivePlus = X75.Years.and.Over) |> 
  filter(!is.na(seventyfivePlus)) |> 
  mutate(Year = as.numeric(Year),
         Sex = "Male")
DPE_female <- read.csv("RawData/DPE_PopDecMean_age_sex.csv", skip=3) |> 
  select(c(1,267)) |> 
  rename(Year = 1, seventyfivePlus = X75.Years.and.Over.1) |> 
  filter(!is.na(seventyfivePlus)) |> 
  mutate(Year = as.numeric(Year),
         Sex = "Female")

DPE75plus <- bind_rows(DPE_male, DPE_female) |> 
  summarise(.by=Year,
            Subpopulation = sum(seventyfivePlus)) |> 
  filter(Year >2006)

###
LifeModel <- lm(Subpopulation ~ Year, 
                data=DPE75plus |> filter(Year %in% 2012:2016))
DPE75plus$Expected <- LifeModel$coefficients[1] + 
  LifeModel$coefficients[2] * DPE75plus$Year

ggplot(DPE75plus, aes(x=Year, y=Subpopulation))+
  geom_line(aes(y=Expected), colour="#AAAAAA", 
            linetype=2)+
  geom_line(data=DPE75plus |> filter(Year %in% 2012:2016), 
            aes(y=Expected), 
            colour="#AAAAAA") +
  geom_point() +
  theme_davidhood() +
  scale_x_continuous(breaks=c(2010,2015,2020))+
  labs(title="NZ Resident population 75 plus years\nvs 2012-2016 trend",
       y="75 plus poopulation", x="Year",
       caption="Source: infoshare.stats.govt.nz : Population : Population Estimates - DPE : 
Estimated Resident Population by Age and Sex (1991+) (Annual-Dec)")
ggsave(filename="../rawfiles/md_figures/figure2.tiff",
       height=3.3, width = 3.3, dpi=1200, units = "in", bg = "white")
ggsave(filename="../rawfiles/md_figures/figure2.png",
       height=3.3, width = 3.3, dpi=300, units = "in", bg = "white")
ggsave(filename="../md_figures/figure2.png",
       height=3.3, width = 3.3, dpi=300, units = "in", bg = "white")
