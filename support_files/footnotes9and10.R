# working out that if 2020 had the same death rates by age as 2019
# and the loss in migration, how much would the death rate go up by.

library(dplyr)
library(tidyr)

# ITM Migration
# ITM has lowest open category of 90+
# so sets the age limits for others.
colist <- c(1,(c(1:90,127) * 2))
ITMf <- read.csv("RawData/ITM_Dec_age_sex.csv", skip=4) |> 
  select(all_of(colist)) 
names(ITMf) <- c("Year", paste0("X",0:90))
ITMflong <- ITMf |> 
  filter(!is.na(X20)) |> 
  gather(key="AgeText", value="Net", -Year) |> 
  mutate(Sex="Female")

colist <- c(1,((c(1:90,127) * 2) +1))
ITMm <- read.csv("RawData/ITM_Dec_age_sex.csv", skip=4) |> 
  select(all_of(colist)) 
names(ITMm) <- c("Year", paste0("X",0:90))
ITMmlong <- ITMm |> 
  filter(!is.na(X20)) |> 
  gather(key="AgeText", value="Net", -Year) |> 
  mutate(Sex="Male")

ITM <- bind_rows(ITMflong,ITMmlong) |> 
  mutate(AgeN = as.numeric(gsub("X","",AgeText)),
         Year = as.numeric(Year)) |> 
  arrange(Sex, AgeN, Year) |> 
  group_by(Sex,AgeN) |> 
  mutate(followingYear = lead(Net),
         change2following = followingYear - Net ) |> 
  ungroup() |> 
  select(Year,Sex,AgeN,Net,change2following)

# VSD deaths

VSD_male <- read.csv("RawData/VSD_Deaths_Dec_age_sex.csv", skip=2) |> 
  select(c(1,27:127)) |> 
  rename(Year = X., X0.years = Less.than.1.year, X1.years=X1.year) |> 
  filter(!is.na(X0.years)) |> 
  gather(key="Agetext", value="Deaths", -Year) |> 
  mutate(Ageshort = gsub("^X","",Agetext),
         AgeN = as.numeric(gsub("[^0123456789].*","",Ageshort)),
         Sex="Male",
         Year = as.numeric(Year)) |> 
  select(Year, Sex, AgeN, Deaths)
VSD_female <- read.csv("RawData/VSD_Deaths_Dec_age_sex.csv", skip=2) |> 
  select(c(1,154:254)) |> 
  rename(Year = X., X0.years = Less.than.1.year.1, X1.years=X1.year.1) |> 
  filter(!is.na(X0.years)) |> 
  gather(key="Agetext", value="Deaths", -Year) |> 
  mutate(Ageshort = gsub("^X","",Agetext),
         AgeN = as.numeric(gsub("[^0123456789].*","",Ageshort)),
         Sex="Female",
         Year = as.numeric(Year)) |> 
  select(Year, Sex, AgeN, Deaths)

VSD <- bind_rows(VSD_male, VSD_female)

# DPE Population

DPE_male <- read.csv("RawData/DPE_PopDecMean_age_sex.csv", skip=3) |> 
  select(c(1,2:96,135)) |> 
  rename(Year = X.) |> 
  filter(!is.na(X0.Years)) |> 
  gather(key="Agetext", value="Population", -Year) |> 
  mutate(Ageshort = gsub("^X","",Agetext),
         AgeN = as.numeric(gsub("[^0123456789].*","",Ageshort)),
         Sex="Male",
         Year = as.numeric(Year)) |> 
  select(Year, Sex, AgeN, Population)
DPE_female <- read.csv("RawData/DPE_PopDecMean_age_sex.csv", skip=3) |> 
  select(c(1,138:232,271)) |> 
  rename(Year = X.) |> 
  filter(!is.na(X0.Years.1)) |> 
  gather(key="Agetext", value="Population", -Year) |> 
  mutate(Ageshort = gsub("^X","",Agetext),
         AgeN = as.numeric(gsub("[^0123456789].*","",Ageshort)),
         Sex="Female",
         Year = as.numeric(Year)) |> 
  select(Year, Sex, AgeN, Population)

DPE <- bind_rows(DPE_male, DPE_female) |> 
  mutate(Population = as.numeric(Population),
         Population = ifelse(is.na(Population), 0, Population))

rm(list = ls()[!ls() %in% c("DPE", "ITM", "VSD")])

# Footnote 7
# matched to ITM ages 
VSDmatched <- VSD |> 
  mutate(AgeN = ifelse(AgeN > 90, 90, AgeN)) |>
    summarise(.by=c(Year, Sex, AgeN),
              Deaths = sum(Deaths))
DPEmatched <- DPE |> 
  mutate(AgeN = ifelse(AgeN > 90, 90, AgeN)) |>
  summarise(.by=c(Year, Sex, AgeN),
            Population = sum(Population))


combo <- ITM |> 
  inner_join(DPEmatched, by = join_by(Year, Sex, AgeN)) |> 
  inner_join(VSDmatched, by = join_by(Year, Sex, AgeN)) |> 
  mutate(DR = Deaths/Population,
         DthChg = change2following*DR)
ITM_deaths = sum(combo$DthChg[combo$Year==2019])
ITM_2019 = sum(combo$Net[combo$Year==2019])
ITM_2020 = sum(combo$Net[combo$Year==2020])
ITM_populaton <- ITM_2020 - ITM_2019
  
############################
# Footnote 8

VSDmatched <- VSD |> 
  mutate(AgeN = ifelse(AgeN > 95, 95, AgeN)) |>
  summarise(.by=c(Year, Sex, AgeN),
            Deaths = sum(Deaths))

Deaths_2019 <- VSDmatched |> 
  filter(Year == 2019) |> 
  select(Sex,AgeN,Deaths2019=Deaths)
Population_2019 <- DPE |> 
  filter(Year == 2019) |> 
  select(Sex,AgeN,Population2019=Population)
Deathrate_2019 <- Population_2019 |> 
  inner_join(Deaths_2019, by = join_by(Sex, AgeN)) |> 
  mutate(Deathrate2019 = Deaths2019/Population2019) |> 
  select(Sex, AgeN, Deathrate2019)
# population age 0 has the complication of births
# so just doing 1 and up
Pop_nomigration_2020 <- Population_2019 |> 
  inner_join(Deaths_2019, by = join_by(Sex, AgeN)) |> 
  mutate(Population_2020 = Population2019 - Deaths2019,
         AgeN = AgeN + 1,
         AgeN = ifelse(AgeN > 95, 95,AgeN)) |>
  summarise(.by = c(Sex, AgeN),
            Population_2020 = sum(Population_2020))
NonmigrationDeaths2020 <- Pop_nomigration_2020 |> 
  inner_join(Deathrate_2019, by = join_by(Sex, AgeN)) |> 
  mutate(unmigratedDeaths = Population_2020 * Deathrate2019)
DeathsIn2019 = sum(Deaths_2019$Deaths2019[Deaths_2019$AgeN > 0])
DeathsIn2020 = sum(NonmigrationDeaths2020$unmigratedDeaths)
Nomigrant_death_growth <- DeathsIn2020 - DeathsIn2019


####
