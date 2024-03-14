# table comparing CDR and ASMR predictions

library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(ggtext)
library(patchwork)
library(forcats)

autoAge <- paste(2:99,"years")
autoAge <- c("Less than 1 year","1 year",autoAge,"100 years and over")
VSD <- read.csv("StatsNZData/VSD_DeathsDec_age_sex.csv", skip=1,
                col.names = c("Year","Age","Male","Female")) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year)) |> 
  fill(Year) |> 
  filter(Age %in% autoAge) |> 
  group_by(Year, Age) |> 
  slice(1) |> 
  ungroup() |> 
  mutate(Age = ifelse(Age == "Less than 1 year","0 years",Age),
         AgeN = as.numeric(gsub(" .*","",Age)),
         Year = as.numeric(Year)) |> 
  gather(key="Sex",value="Deaths", Male:Female) |> 
  mutate(AgeN = ifelse(AgeN > 94,95, AgeN)) |> 
  summarise(.by=c(Year,Sex,AgeN),
            Deaths = sum(Deaths))


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
  select(Year, AgeN, Sex, MeanPopulation)

Stnd <- DPE |> filter(Year == 2018) |> 
  select(AgeN, Sex, StndPopulation = MeanPopulation)

totalStndPop = sum(Stnd$StndPopulation)

ASMR <- VSD |> 
  inner_join(DPE, by = join_by(Year, Sex, AgeN)) |> 
  inner_join(Stnd, by = join_by(Sex, AgeN)) |> 
  mutate (StnDth = StndPopulation * Deaths / MeanPopulation) |> 
  summarise(.by = Year,
            ASMR1K = 1000*sum(StnDth)/totalStndPop)

CDR <- read.csv(StatsNZData/DMM_CDRDec_TotPop.csv)



