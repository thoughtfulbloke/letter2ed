library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(ggtext)
source("theme.R")
six_cols <- colorblind_pal()(6)

VSD <- read.csv("StatsNZData/VSD_DeathsDec_age_sex.csv",
                skip=1, col.names = c("Year","Age",
                                      "Male","Female")) |> 
  filter(!is.na(Male)) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year)) |> 
  fill(Year) |> 
  mutate(Year = as.numeric(Year)) |> 
  filter(Year == 2019)|> 
  slice(26:126) |> 
  mutate(Deaths = Male + Female,
         Age = ifelse(Age == "Less than 1 year",
                      "0 years",Age),
         AgeN = as.numeric(gsub(" yea.*","",Age)),
         AgeN = ifelse(AgeN > 89, 90, AgeN)) |> 
  summarise(.by=AgeN, Deaths=sum(Deaths))

DPE <- read.csv("StatsNZData/DPE_PopDecMean_age_sex.csv",
                skip=2, col.names = c("Year","Age",
                                     "Male","Female"))  |> 
  filter(!is.na(Male)) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year)) |> 
  fill(Year) |> 
  mutate(Year = as.numeric(Year)) |> 
  filter(Year == 2019) |> 
  slice(c(1:95,134)) |> 
  mutate(Lives = Male + Female,
         AgeN = as.numeric(gsub(" Yea.*","",Age)),
         AgeN = ifelse(AgeN > 89, 90, AgeN)) |> 
  summarise(.by=AgeN, Lives=sum(Lives))

ITM <- read.csv("StatsNZData/ITM_2019AgeSex.csv", skip=4, 
                col.names = c("Age","Female","Male")) |> 
  slice(c(1:90,127)) |> 
  mutate(Moves = as.numeric(Male) + as.numeric(Female),
         AgeN = as.numeric(gsub(" Yea.*","",Age)),
         AgeN = ifelse(AgeN > 89, 90, AgeN)) |> 
  summarise(.by=AgeN, Moves=sum(Moves))

Deaths <- VSD |> 
  inner_join(DPE, by = join_by(AgeN)) |> 
  mutate(percent = 100*Deaths/Lives,
         series="Deaths")
Moves <- ITM |> 
  inner_join(DPE, by = join_by(AgeN)) |> 
  mutate(percent = 100*Moves/Lives,
         series="Migration")

bind_rows(Deaths, Moves) |> 
ggplot(aes(x=AgeN, y=percent, fill=series))+
  geom_col(width = .8, position="dodge") +
  theme_davidhood() +
  theme(legend.position = "top",
        legend.key.size = unit(.5,"line")) +
  scale_fill_manual(values=six_cols, name="Series:")+
  scale_x_continuous(breaks=c(0,30,60,90),
                     labels=c("under 1","30","60","90+")) +
  labs(title="2019 Deaths vs. Migrants as percentage of resident population",
       y="Percentage", x="Age",
       caption="Source: infoshare.stats.govt.nz")
ggsave(filename="md_figures/figure3.png",
       height=4, width = 6, dpi=300, units = "in", bg = "white")
ggsave(filename="../md_figures/figure3.png",
       height=4, width = 6, dpi=300, units = "in", bg = "white")
