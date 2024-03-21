# working out that if 2020 had the same death rates by age as 2019
# and the loss in migration, how much would the death rate go up by.

library(dplyr)
library(tidyr)

# ITM Migration
# ITM has lowest open category of 90+
# so sets the age limits for others.
autoAge <- paste(0:89,"Years")
autoAge <- c(autoAge,"90 Years and over")
ITM <- read.csv("StatsNZData/ITM_agesex20192020.csv", skip=3,
                col.names = c("Sex","Age","y19","y20")) |> 
  mutate(Sex = ifelse(Sex == " ", NA_character_,Sex)) |> 
  fill(Sex) |> 
  filter(Age %in% autoAge) |> 
  mutate(change = y20-y19,
         AgeN = as.numeric(gsub(" Yea.*","",Age)))

# VSD deaths
autoAge <- paste(0:99,"years")
autoAge <- c("Less than 1 year", "1 year", autoAge,"100 years and over")
VSD <- read.csv("StatsNZData/VSD_DeathsDec_age_sex.csv", skip=1,
                col.names = c("Year","Age","Male","Female")) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year)) |> 
  fill(Year) |> 
  filter(Age %in% autoAge, Year == 2019) |> 
  group_by(Age) |> 
  slice(1) |> 
  ungroup() |> 
  gather(key="Sex", value="Deaths", Male:Female) |> 
  mutate(Age = ifelse(Age == "Less than 1 year",
                      "0 years", Age),
    AgeN = as.numeric(gsub(" yea.*","",Age)),
         AgeN = ifelse(AgeN > 90, 90, AgeN)) |> 
  summarise(.by=c(Sex,AgeN),
            RawDeaths = sum(Deaths)) 

  
# DPE Population
autoAge <- paste(0:94,"Years")
autoAge <- c(autoAge,"95 Years and Over")
DPE <- read.csv("DPEpopulation_by_age_sex.csv", skip=1,
                col.names = c("Year","Age","Sex","MeanPop")) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year),
         Age = ifelse(Age == " ", NA_character_,Age)) |> 
  fill(Year,Age) |> 
  filter(Sex %in% c("Male","Female"),
         Age %in% autoAge, Year == 2019) |> 
  mutate(AgeN = as.numeric(gsub(" Yea.*","",Age)),
         AgeN = ifelse(AgeN > 90, 90, AgeN),
         MeanPop = as.numeric(MeanPop)) |> 
  summarise(.by=c(Sex,AgeN),
            Population = sum(MeanPop)) 

combo <- ITM |> 
  inner_join(DPE, by = join_by(Sex, AgeN)) |> 
  inner_join(VSD, by = join_by(Sex, AgeN)) |> 
  mutate(DR = RawDeaths/Population,
         DR1K = 1000 * DR,
         DthChg = change*DR)
ITMchange <- sum(combo$change)
ITMdeathchange <- sum(combo$DthChg)
ITMpop19 <- sum(combo$Population)
ITMdeath19 <- sum(combo$RawDeaths)
######

# VSD deaths
autoAge <- paste(0:99,"years")
autoAge <- c("Less than 1 year", "1 year", autoAge,"100 years and over")
VSD <- read.csv("StatsNZData/VSD_DeathsDec_age_sex.csv", skip=1,
                col.names = c("Year","Age","Male","Female")) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year)) |> 
  fill(Year) |> 
  filter(Age %in% autoAge, Year == 2019) |> 
  group_by(Age) |> 
  slice(1) |> 
  ungroup() |> 
  gather(key="Sex", value="Deaths", Male:Female) |> 
  mutate(Age = ifelse(Age == "Less than 1 year",
                      "0 years", Age),
         AgeN = as.numeric(gsub(" yea.*","",Age)),
         AgeN = ifelse(AgeN > 95, 95, AgeN)) |> 
  summarise(.by=c(Sex,AgeN),
            RawDeaths = sum(Deaths)) 


# DPE Population
autoAge <- paste(0:94,"Years")
autoAge <- c(autoAge,"95 Years and Over")
DPE <- read.csv("DPEpopulation_by_age_sex.csv", skip=1,
                col.names = c("Year","Age","Sex","MeanPop")) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year),
         Age = ifelse(Age == " ", NA_character_,Age)) |> 
  fill(Year,Age) |> 
  filter(Sex %in% c("Male","Female"),
         Age %in% autoAge, Year == 2019) |> 
  mutate(AgeN = as.numeric(gsub(" Yea.*","",Age)),
         AgeN = ifelse(AgeN > 95, 95, AgeN),
         MeanPop = as.numeric(MeanPop)) |> 
  summarise(.by=c(Sex,AgeN),
            Population = sum(MeanPop)) 

combo <- DPE |> 
  inner_join(VSD, by = join_by(Sex, AgeN)) |> 
  arrange(Sex,AgeN) |> 
  group_by(Sex) |> 
  mutate(DR = RawDeaths/Population,
         DR1K = 1000 * DR,
         in20 = lag(Population - RawDeaths),
         in20 = ifelse(AgeN == 95,
                       Population - RawDeaths + in20,
                       in20)) |> 
  ungroup() |> 
  filter(AgeN != 0) |> 
  mutate(D20 = in20*DR)

DR19 <- sum(combo$RawDeaths)
DR20 <- sum(combo$D20)
deltaAging <- DR20 - DR19
