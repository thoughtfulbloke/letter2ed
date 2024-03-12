library(dplyr)
library(tidyr)

# figure 01a Male death rates by age 
autoAge <- paste(2:99,"years")
autoAge <- c("Less than 1 year","1 year",autoAge,"100 years and over")
VSD <- read.csv("VSD_deaths_age_sex.csv", skip=1,
                col.names = c("Year","Age","Male","Female")) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year)) |> 
  fill(Year) |> 
  filter(Age %in% autoAge) |> 
  group_by(Year) |> 
  slice(2:n()) |> 
  ungroup() |> 
  mutate(Age = ifelse(Age == "Less than 1 year","0 years",Age),
         AgeN = as.numeric(gsub(" .*","",Age)),
         AgeGroup = case_when(AgeN > 94 ~ "95 plus",
                              TRUE ~ as.character(AgeN)),
         Year = as.numeric(Year)) |> 
  summarise(.by = c(Year,AgeGroup),
            Males=sum(Male),
            Females=sum(Female)) |> 
  filter(Year > 2005)

autoAge <- paste(0:94,"Years")
autoAge <- c(autoAge,"95 Years and Over")
DPE <- read.csv("DPEpopulation_by_age_sex.csv", skip=1,
                col.names = c("Year","Age","Sex","MeanPop")) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year),
         Age = ifelse(Age == " ", NA_character_,Age)) |> 
  fill(Year,Age) |> 
  filter(Sex %in% c("Male","Female"),
         Age %in% autoAge) |> 
  mutate(AgeN = as.numeric(gsub(" .*","",Age)),
         AgeGroup = case_when(AgeN > 94 ~ "95 plus",
                              TRUE ~ as.character(AgeN)),
         AnnualPop = as.numeric(MeanPop),
         Year = as.numeric(Year)) |> 
  summarise(.by = c(Year,AgeGroup,Sex),
            Population=sum(AnnualPop, na.rm=TRUE)) |> 
  filter(Year > 2005)

Males <- DPE |> 
  filter(Sex == "Male") |> 
  inner_join(VSD,by = join_by(Year, AgeGroup)) |> 
  mutate(Rate1K = 1000*Males/Population) |> 
  select(Year, AgeGroup, Sex, Rate1K)

# figure 01b Female death rates by age since 2013
Females <- DPE |> 
  filter(Sex == "Female") |> 
  inner_join(VSD,by = join_by(Year, AgeGroup)) |> 
  mutate(Rate1K = 1000*Females/Population) |> 
  select(Year, AgeGroup, Sex, Rate1K)
Rates <- bind_rows(Females,Males)

excess2020to22 <- function(x, rateset=Rates,reference=DPE){
  stndpop <- reference |> filter(Year == x) |> select(-Year)
  stdards <- rateset |> inner_join(stndpop, by= join_by(AgeGroup, Sex)) |> 
    mutate(Stdeath = Rate1K * Population / 1000) |> 
    summarise(.by=Year, Deaths=sum(Stdeath))
  modth = lm(Deaths ~ Year, 
             stdards |> filter(Year %in% 2013:2019))
  stdards$Expected <- modth$coefficients[1] +
    modth$coefficients[2] * stdards$Year
  stdards$excess <- 100*stdards$Deaths/stdards$Expected - 100
  exc <- sum(stdards$excess[stdards$Year %in% 2020:2022])
  return(round(exc,0))
}

excess2020to22(2023)
excess2020to22(2021)
excess2020to22(2019)

DMM <- read.csv("DMM_Standardised_Death_Rates.csv",
                skip=1) |> 
  filter(!is.na(Total.Population)) |> 
  rename(Year=1,SDR=2) |> 
  mutate(Year = as.numeric(Year))
DMModel <- lm(SDR ~ Year, 
              DMM |> filter(Year %in% 2013:2019))
DMM$Expected <- DMModel$coefficients[1] +
  DMModel$coefficients[2] * DMM$Year
DMM$excess <- 100*DMM$SDR/DMM$Expected - 100
exc <- sum(stdards$excess[stdards$Year %in% 2020:2022])

baseline2020to22 <- function(x, rateset=Rates,reference=DPE){
  stndpop <- reference |> filter(Year == 2022) |> select(-Year)
  stdards <- rateset |> inner_join(stndpop, by= join_by(AgeGroup, Sex)) |> 
    mutate(Stdeath = Rate1K * Population / 1000) |> 
    summarise(.by=Year, Deaths=sum(Stdeath))
  yfrom = 2019-x+1
  modth = lm(Deaths ~ Year, 
             stdards |> filter(Year %in% yfrom:2019))
  stdards$Expected <- modth$coefficients[1] +
    modth$coefficients[2] * stdards$Year
  stdards$excess <- 100*stdards$Deaths/stdards$Expected - 100
  exc <- sum(stdards$excess[stdards$Year %in% 2020:2022])
  return(round(exc,0))
}

baseline2020to22(5)
baseline2020to22(7)
baseline2020to22(12)

