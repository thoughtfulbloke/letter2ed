library(dplyr)

DMM <- read.csv("StatsNZData/DMM_CDRDec_TotPop.csv",
                skip=1) |> 
  filter(!is.na(Total.Population)) |> 
  rename(Year=1,CDR=2) |> 
  mutate(Year = as.numeric(Year))
DMModel <- lm(CDR ~ Year, 
              DMM |> filter(Year %in% 2015:2019))
DMM$Expected <- DMModel$coefficients[1] +
  DMModel$coefficients[2] * DMM$Year
DMM$excess <- 100 * DMM$CDR / DMM$Expected - 100
cumexc <- sum(DMM$excess[DMM$Year %in% 2020:2022])
print(round(cumexc,0))




