library(dplyr)
library(tidyr)

# Deaths, male/female single years then aggregate 95+
DeathAges <- paste(2:99,"years")
DeathAges <- c("Less than 1 year","1 year",DeathAges,"100 years and over")
VSD <- read.csv("StatsNZData/VSD_DeathsDec_age_sex.csv", skip=1,
                col.names = c("Year","Age","Male","Female")) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year)) |> 
  fill(Year) |> 
  filter(Age %in% DeathAges) |> 
  group_by(Year,Age) |> #100 years + repeated in file so slicing 2nd
  slice(1) |> 
  ungroup() |> 
  mutate(Age = ifelse(Age == "Less than 1 year","0 years",Age),
         AgeN = as.numeric(gsub(" .*","",Age)),
         AgeGroup = case_when(AgeN > 94 ~ 95,
                              TRUE ~ AgeN),
         Year = as.numeric(Year)) |> 
  summarise(.by = c(Year,AgeGroup),
            Male=sum(Male),
            Female=sum(Female)) |> 
  filter(Year > 2005) |> 
  gather(key="Sex", value="Deaths", Male, Female) 

# Population Male/Female single years then 95+
PopAges <- paste(0:94,"Years")
PopAges <- c(PopAges,"95 Years and Over")
DPE <- read.csv("StatsNZData/DPE_PopDecMean_age_sex.csv", skip=2,
                col.names = c("Year","Age","Male","Female")) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year),
         Age = ifelse(Age == " ", NA_character_,Age)) |> 
  fill(Year,Age) |> 
  filter(Age %in% PopAges) |> 
  mutate(AgeN = as.numeric(gsub(" .*","",Age)),
         AgeGroup = case_when(AgeN > 94 ~ 95,
                              TRUE ~ AgeN),
         Year = as.numeric(Year)) |> 
  summarise(.by = c(Year,AgeGroup),
            Male=sum(Male),
            Female=sum(Female)) |> 
  filter(Year > 2005) |> 
  gather(key="Sex", value="Population", Male, Female) 

# function for a liner regression off a chosen baseline with
# a selected standard year
excess2020to22 <- function(stdyr=2022, NZdeaths=VSD, NZpop=DPE, 
                           basestart=2013, basestop=2019){
  stndpop <- NZpop |> filter(Year == stdyr) |> 
    select(-Year) |> rename(StPop = Population)
  stndmort <- NZdeaths |> 
    inner_join(NZpop, by = join_by(Year, AgeGroup, Sex)) |> 
    inner_join(stndpop, by = join_by(AgeGroup, Sex)) |> 
    mutate(st_deaths_age = StPop * Deaths/Population) |> 
    summarise(.by=Year, StandardDeaths=sum(st_deaths_age))
  LMstandard = lm(StandardDeaths ~ Year, 
             stndmort |> filter(Year %in% basestart:basestop))
  stndmort$Expected <- LMstandard$coefficients[1] +
    LMstandard$coefficients[2] * stndmort$Year
  stndmort$excess <- 100 * stndmort$StandardDeaths / 
    stndmort$Expected - 100
  cumexc <- sum(stndmort$excess[stndmort$Year %in% 2020:2022])
  return(round(cumexc,0))
}

# Footnote 4 calculations:

excess2020to22(stdyr=2023)
excess2020to22(stdyr=2021)
excess2020to22(stdyr=2019)

# 1961 standard population is just the Standard Death Rates
# from infoshare
DMM <- read.csv("StatsNZData/DMM_SDR_TotPop.csv",
                skip=1) |> 
  filter(!is.na(Total.Population)) |> 
  rename(Year=1,SDR=2) |> 
  mutate(Year = as.numeric(Year))
DMModel <- lm(SDR ~ Year, 
              DMM |> filter(Year %in% 2013:2019))
DMM$Expected <- DMModel$coefficients[1] +
  DMModel$coefficients[2] * DMM$Year
DMM$excess <- 100*DMM$SDR/DMM$Expected - 100
cumexc <- sum(DMM$excess[DMM$Year %in% 2020:2022])
print(round(cumexc,0))

# Footnote 5 calculations

excess2020to22(basestart=2015)
excess2020to22(basestart=2013)


