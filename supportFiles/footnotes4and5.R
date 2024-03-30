library(dplyr)
library(tidyr)

# Deaths, rearranged into long-style database form
# Single years then 100+ by sex
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

# Population Male/Female single years then 95+
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

# need deaths to be the same age range as population
VSD95 <- VSD |> 
  mutate(AgeN = ifelse(AgeN > 95, 95, AgeN)) |> 
  summarise(.by=c(Year,Sex,AgeN),
            Deaths=sum(Deaths))
# function for a liner regression off a chosen baseline with
# a selected standard year
cumulative_annual_excess <- function(stdyr=2022, NZdeaths=VSD95, NZpop=DPE, 
                           basestart=2013, basestop=2019,
                           exfrom=2020, exto=2022){
  stndpop <- NZpop |> filter(Year == stdyr) |> 
    select(-Year) |> rename(StPop = Population)
  stndmort <- NZdeaths |> 
    inner_join(NZpop, by = join_by(Year, AgeN, Sex)) |> 
    inner_join(stndpop, by = join_by(AgeN, Sex)) |> 
    mutate(st_deaths_age = StPop * Deaths/Population) |> 
    summarise(.by=Year, StandardDeaths=sum(st_deaths_age))
  LMstandard = lm(StandardDeaths ~ Year, 
             stndmort |> filter(Year %in% basestart:basestop))
  stndmort$Expected <- LMstandard$coefficients[1] +
    LMstandard$coefficients[2] * stndmort$Year
  cumulatime <- stndmort |> filter(Year >= exfrom, Year <=exto)
  percentage = 100 * sum(cumulatime$StandardDeaths) /
    sum(cumulatime$Expected) - 100
  return(percentage)
}

# Footnote 4 calculations:

round(cumulative_annual_excess(stdyr=2023),0)
round(cumulative_annual_excess(stdyr=2021),0)
round(cumulative_annual_excess(stdyr=2019),0)

# 1961 standard population is just the Standard Death Rates
# from infoshare
DMM <- read.csv("RawData/DMM_SDR_TotPop.csv",
                skip=1) |> 
  filter(!is.na(Total.Population)) |> 
  rename(Year=1,SDR=2) |> 
  mutate(Year = as.numeric(Year))
DMModel <- lm(SDR ~ Year, 
              DMM |> filter(Year %in% 2013:2019))
DMM$Expected <- DMModel$coefficients[1] +
  DMModel$coefficients[2] * DMM$Year
cumulatime <- DMM |> filter(Year >= 2020, Year <=2022)
percentage = 100 * sum(cumulatime$SDR) /
  sum(cumulatime$Expected) - 100
print(round(percentage,0))

# Footnote 5 calculations
print(round(cumulative_annual_excess(basestart=2015),0))
print(round(cumulative_annual_excess(basestart=2013),0))


