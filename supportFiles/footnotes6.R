library(dplyr)

DMM <- read.csv("RawData/DMM_CDRDec_TotPop.csv",
                skip=1) |> 
  filter(!is.na(Total.Population)) |> 
  rename(Year=1,CDR=2) |> 
  mutate(Year = as.numeric(Year))
DMModel <- lm(CDR ~ Year, 
              DMM |> filter(Year %in% 2015:2019))
DMM$Expected <- DMModel$coefficients[1] +
  DMModel$coefficients[2] * DMM$Year
cumulatime <- DMM |> filter(Year >= 2020, Year <=2022)
percentage = 100 * sum(cumulatime$CDR) /
  sum(cumulatime$Expected) - 100
print(round(percentage,0))




