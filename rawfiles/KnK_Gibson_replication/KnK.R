library(dplyr)
library(tidyr)
library(lubridate)
NZstmf <- read.csv("NZL_NPstmfout.csv") |> 
  filter(Sex == "b")
NZQTR <- read.csv("TotalQuarterlyPopulationAsAt.csv", skip=3,
                  col.names = c("YRQR","Pop")) |> 
  filter(!is.na(Pop)) |> 
  separate(YRQR, into=c("YR", "QR"), sep="Q", convert = TRUE) |> 
  mutate(asDate = ceiling_date(ISOdate(YR,QR*3,25), 
                               unit="quarter") - days(1),
         Week=isoweek(asDate),
         Year=isoyear(asDate)) |> 
  select(Year,Week,Pop)
## bluntly apply the quarter as a block rather than
## imputing each week, but it should be in the right ballpark

joint <- NZstmf |> left_join(NZQTR, by = join_by(Year, Week)) |> 
  fill(Pop) |> mutate(CDR1K = 1000*Total/Pop,
                      logPop = log(Pop))

KnKexpect <- function(x, weekly_data=joint){
  targetRow <- weekly_data[x,]
  sexis <- targetRow$Sex
  weekno <- targetRow$Week
  if (weekno == 53){weekno <- 52}
  regresset <- weekly_data[weekly_data$Year %in% 2015:2019 & 
                             weekly_data$Week==weekno &
                             weekly_data$Sex==sexis,]
  Knkmodel <- lm(Total ~ Year, data=regresset)
  targetRow$KnKexpected <- Knkmodel$coefficients[1] +
    Knkmodel$coefficients[2] * targetRow$Year
  DRmodel <- lm(CDR1K ~ Year, data=regresset)
  targetRow$CDRexpected <- DRmodel$coefficients[1] +
    DRmodel$coefficients[2] * targetRow$Year
  Popmodel <- lm(Total ~ Year + Pop, data=regresset)
  targetRow$Popexpected <- predict(Popmodel,newdata=targetRow)
  Logmodel <- lm(Total ~ Year + logPop, data=regresset)
  targetRow$Logexpected <- predict(Logmodel,newdata=targetRow)
  return(targetRow)
}

w.Expected <- lapply(1:nrow(NZstmf), KnKexpect)
df.Expected <- bind_rows(w.Expected) 

b2020to2022 <- df.Expected |> 
  filter(Year %in% 2020:2022) |> 
  summarise(Actual = sum(Total), 
            Knk= sum(KnKexpected),
            meanCDR= mean(CDR1K),
            CDRexpected = mean(CDRexpected),
            Pop=sum(Popexpected),
            Log=sum(Logexpected))
  
  
