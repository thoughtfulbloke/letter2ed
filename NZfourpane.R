library(dplyr)
library(tidyr)

Dth <- read.csv("VSD_Death_by_Age_Dec.csv", skip=2)
Dth00_59 <- Dth |> select(Year = X., Less.than.1.year:X59.years) |> 
  filter(!is.na(X50.years)) |> 
  mutate(Year = as.numeric(Year)) |> 
  gather(key="Age",value="Dths", -Year) |> 
  summarise(.by=Year, Deaths = sum(Dths)) |> 
  filter(Year >2012) |> 
  mutate(dataset = "Resident Deaths",
         Age = "age 0 to 59\n33% of deaths") |> 
  rename(Number = Deaths)
Dth60_79 <- Dth |> select(Year = X., X60.years:X79.years) |> 
  filter(!is.na(X70.years)) |> 
  mutate(Year = as.numeric(Year)) |> 
  gather(key="Age",value="Dths", -Year) |> 
  summarise(.by=Year, Deaths = sum(Dths)) |> 
  filter(Year >2012) |> 
  mutate(dataset = "Resident Deaths",
         Age = "age 60 to 79\n27% of deaths") |> 
  rename(Number = Deaths)
Dth80_plus <- Dth |> select(Year = X., X80.years:X100.years.and.over.1) |> 
  filter(!is.na(X85.years)) |> 
  mutate(Year = as.numeric(Year)) |> 
  gather(key="Age",value="Dths", -Year) |> 
  summarise(.by=Year, Deaths = sum(Dths)) |> 
  filter(Year >2012) |> 
  mutate(dataset = "Resident Deaths",
         Age = "age 80 plus\n40% of deaths") |> 
  rename(Number = Deaths)
Tdth00 <- sum(Dth00_59$Deaths)
Tdth60 <- sum(Dth60_79$Deaths)
Tdth80 <- sum(Dth80_plus$Deaths)
Tdth80/(Tdth00 + Tdth60 + Tdth80)

Pop <- read.csv("DPE_Mean_Pop_by_Age_Dec.csv", skip=3)
Pop00_59 <- Pop |> select(Year = X., X0.Years:X59.Years) |> 
  filter(!is.na(X50.Years)) |> 
  mutate(Year = as.numeric(Year)) |> 
  gather(key="Age",value="pop", -Year) |> 
  summarise(.by=Year, Pop = sum(pop)) |> 
  filter(Year >2012) |> 
  mutate(dataset = "Resident Population (100,000)",
         Age = "age 0 to 59\n33% of deaths",
         Pop = Pop/100000) |> 
  rename(Number = Pop)
Pop60_79 <- Pop |> select(Year = X., X60.Years:X79.Years) |> 
  filter(!is.na(X70.Years)) |> 
  mutate(Year = as.numeric(Year)) |> 
  gather(key="Age",value="pop", -Year) |> 
  summarise(.by=Year, Pop = sum(pop)) |> 
  filter(Year >2012) |> 
  mutate(dataset = "Resident Population (100,000)",
         Age = "age 60 to 79\n27% of deaths",
         Pop = Pop/100000) |> 
  rename(Number = Pop)
Pop80_plus <- Pop |> select(Year = X., X80.Years:X94.Years,X95.Years.and.Over) |> 
  filter(!is.na(X85.Years)) |> 
  mutate(Year = as.numeric(Year)) |> 
  gather(key="Age",value="pop", -Year) |> 
  summarise(.by=Year, Pop = sum(as.numeric(pop), na.rm=TRUE)) |> 
  filter(Year >2012) |> 
  mutate(dataset = "Resident Population (100,000)",
         Age = "age 80 plus\n40% of deaths",
         Pop = Pop/100000) |> 
  rename(Number = Pop)

DR00_59 <- Dth00_59 |> select(-dataset) |> 
  inner_join(Pop00_59, by = join_by(Year, Age)) |>
  mutate(Rate = Number.x/Number.y,
         dataset ="Death Rate per 100,000") |> 
  select(-Number.x, -Number.y) |> 
  rename(Number = Rate)

DR60_79 <- Dth60_79 |> select(-dataset) |> 
  inner_join(Pop60_79, by = join_by(Year, Age)) |>
  mutate(Rate = Number.x/Number.y,
         dataset ="Death Rate per 100,000") |> 
  select(-Number.x, -Number.y) |> 
  rename(Number = Rate)

DR80_plus <- Dth80_plus |> select(-dataset) |> 
  inner_join(Pop80_plus, by = join_by(Year, Age)) |>
  mutate(Rate = Number.x/Number.y,
         dataset ="Death Rate per 100,000") |> 
  select(-Number.x, -Number.y) |> 
  rename(Number = Rate)

Dth00_59mod <- lm(Number ~ Year, Dth00_59 |> filter(Year %in% 2013:2019))
Dth60_79mod <- lm(Number ~ Year, Dth60_79 |> filter(Year %in% 2013:2019))
Dth80_plusmod <- lm(Number ~ Year, Dth80_plus |> filter(Year %in% 2013:2019))
Pop00_59mod <- lm(Number ~ Year, Pop00_59 |> filter(Year %in% 2013:2019))
Pop60_79mod <- lm(Number ~ Year, Pop60_79 |> filter(Year %in% 2013:2019))
Pop80_plusmod <- lm(Number ~ Year, Pop80_plus |> filter(Year %in% 2013:2019))
DR00_59mod <- lm(Number ~ Year, DR00_59 |> filter(Year %in% 2013:2019))
DR60_79mod <- lm(Number ~ Year, DR60_79 |> filter(Year %in% 2013:2019))
DR80_plusmod <- lm(Number ~ Year, DR80_plus |> filter(Year %in% 2013:2019))
Dth00_59$Expected <- Dth00_59mod$coefficients[1] + 
  Dth00_59$Year * Dth00_59mod$coefficients[2]
Dth60_79$Expected <- Dth60_79mod$coefficients[1] + 
  Dth60_79$Year * Dth60_79mod$coefficients[2]
Dth80_plus$Expected <- Dth80_plusmod$coefficients[1] + 
  Dth80_plus$Year * Dth80_plusmod$coefficients[2]
Pop00_59$Expected <- Pop00_59mod$coefficients[1] + 
  Pop00_59$Year * Pop00_59mod$coefficients[2]
Pop60_79$Expected <- Pop60_79mod$coefficients[1] + 
  Pop60_79$Year * Pop60_79mod$coefficients[2]
Pop80_plus$Expected <- Pop80_plusmod$coefficients[1] + 
  Pop80_plus$Year * Pop80_plusmod$coefficients[2]
DR00_59$Expected <- DR00_59mod$coefficients[1] + 
  DR00_59$Year * DR00_59mod$coefficients[2]
DR60_79$Expected <- DR60_79mod$coefficients[1] + 
  DR60_79$Year * DR60_79mod$coefficients[2]
DR80_plus$Expected <- DR80_plusmod$coefficients[1] + 
  DR80_plus$Year * DR80_plusmod$coefficients[2]

facets <- bind_rows(Dth00_59, Dth60_79, Dth80_plus,
                    Pop00_59, Pop60_79, Pop80_plus,
                    DR00_59, DR60_79, DR80_plus)
library(ggplot2)
library(ggthemes)
library(ggtext)
library(patchwork)
source("theme.R")

c1r1 <- ggplot(Dth00_59, aes(x=Year, y=Number)) +
  geom_point() +
  geom_line(aes(y=Expected), colour=six_cols[2], linetype=2) +
  geom_line(data=Dth00_59 |> filter(Year < 2020),
            aes(y=Expected), colour=six_cols[2]) +
  scale_y_continuous(n.breaks=4) +
  scale_x_continuous(breaks=c(2015,2020)) +
  theme_davidhood() +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank()) +
  labs(title="Resident Deaths", y="under 60 age")
c1r2 <- ggplot(Dth60_79, aes(x=Year, y=Number)) +
  geom_point() +
  geom_line(aes(y=Expected), colour=six_cols[2], linetype=2) +
  geom_line(data=Dth60_79 |> filter(Year < 2020),
            aes(y=Expected), colour=six_cols[2]) +
  scale_y_continuous(n.breaks=4) +
  scale_x_continuous(breaks=c(2015,2020)) +
  theme_davidhood() +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank()) +
  labs(y="age 60 to 80")
c1r3 <- ggplot(Dth80_plus, aes(x=Year, y=Number)) +
  geom_point() +
  geom_line(aes(y=Expected), colour=six_cols[2], linetype=2) +
  geom_line(data=Dth80_plus |> filter(Year < 2020),
            aes(y=Expected), colour=six_cols[2]) +
  scale_y_continuous(n.breaks=3) +
  scale_x_continuous(breaks=c(2015,2020)) +
  theme_davidhood() +
  theme(axis.title.x = element_blank()) +
  labs(y="age 80 plus") 
c2r1 <- ggplot(Pop00_59, aes(x=Year, y=Number)) +
  geom_point() +
  geom_line(aes(y=Expected), colour=six_cols[2], linetype=2) +
  geom_line(data=Pop00_59 |> filter(Year < 2020),
            aes(y=Expected), colour=six_cols[2]) +
  scale_y_continuous(n.breaks=3) +
  scale_x_continuous(breaks=c(2015,2020)) +
  theme_davidhood() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank()) +
  labs(title="Resident Population\n(100,000s)")
c2r2 <- ggplot(Pop60_79, aes(x=Year, y=Number)) +
  geom_point() +
  geom_line(aes(y=Expected), colour=six_cols[2], linetype=2) +
  geom_line(data=Pop60_79 |> filter(Year < 2020),
            aes(y=Expected), colour=six_cols[2]) +
  scale_y_continuous(n.breaks=3) +
  scale_x_continuous(breaks=c(2015,2020)) +
  theme_davidhood() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank()) 
c2r3 <- ggplot(Pop80_plus, aes(x=Year, y=Number)) +
  geom_point() +
  geom_line(aes(y=Expected), colour=six_cols[2], linetype=2) +
  geom_line(data=Pop80_plus |> filter(Year < 2020),
            aes(y=Expected), colour=six_cols[2]) +
  scale_x_continuous(breaks=c(2015,2020))+
  theme_davidhood() +
  theme(axis.title.y = element_blank()) +
  labs(x="year")
c3r1 <- ggplot(DR00_59, aes(x=Year, y=Number)) +
  geom_point() +
  geom_line(aes(y=Expected), colour=six_cols[2], linetype=2) +
  geom_line(data=DR00_59 |> filter(Year < 2020),
            aes(y=Expected), colour=six_cols[2]) +
  scale_y_continuous(n.breaks=3) +
  scale_x_continuous(breaks=c(2015,2020)) +
  labs(title="Resident Deathrate\nper 100,000") +
  theme_davidhood() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank()) 
c3r2 <- ggplot(DR60_79, aes(x=Year, y=Number)) +
  geom_point() +
  geom_line(aes(y=Expected), colour=six_cols[2], linetype=2) +
  geom_line(data=DR60_79 |> filter(Year < 2020),
            aes(y=Expected), colour=six_cols[2]) +
  scale_y_continuous(n.breaks=3) +
  scale_x_continuous(breaks=c(2015,2020))  +
  theme_davidhood() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank()) 
c3r3 <- ggplot(DR80_plus, aes(x=Year, y=Number)) +
  geom_point() +
  geom_line(aes(y=Expected), colour=six_cols[2], linetype=2) +
  geom_line(data=DR80_plus |> filter(Year < 2020),
            aes(y=Expected), colour=six_cols[2]) +
  scale_y_continuous(n.breaks=4) +
  scale_x_continuous(breaks=c(2015,2020))  +
  theme_davidhood() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank()) 
  
asmr <- read.csv("DMM_Standardised_Death_Rates.csv", skip=1)
names(asmr) <- c("Year", "ASMR")
asmr <- asmr |> 
  filter(!is.na(ASMR)) |> 
  mutate(Year = as.numeric(Year)) |> 
  filter(Year > 2012)
asmrmod <- lm(ASMR ~ Year, asmr |> filter(Year %in% 2013:2019))
asmr$Expected <- asmrmod$coefficients[1] + 
  asmr$Year * asmrmod$coefficients[2]
asmr$percent = 100 * asmr$ASMR/asmr$Expected -100
sum(asmr$percent[asmr$Year %in% 2020:2022])
gasmr <- ggplot(asmr, aes(x=Year, y=ASMR)) +
  geom_line(aes(y=Expected), colour=six_cols[2], linetype=2) +
  geom_line(data=asmr |> filter(Year < 2020),
            aes(y=Expected), colour=six_cols[2]) +
  geom_point() +
  labs(title="Summary: Age Standardised\nMortality Rate") +
  scale_y_continuous(n.breaks=4) +
  scale_x_continuous(breaks=c(2015,2020))+
  theme_davidhood() +
  theme(axis.title.y = element_blank()) 

layout <- "
AABBCCJJJ
DDEEFFJJJ
GGHHIIJJJ
"
c1r1 + c2r1 + c3r1 + c1r2 + c2r2 + c3r2 + c1r3 + c2r3 + c3r3 + gasmr +
  plot_layout(design = layout) +
  plot_annotation(
    title = 'The calculation of approximate -6% excess mortality in NZ from 2020-2022
is based on Age Standardised Mortality Rates used for centuries by actuaries.',
subtitle = "Showing major age groups and age standardised death rates, 2013-2019 baseline",
    caption = 'Source: Inforshare Deaths by Age, Population by Age, Standardised Death Rates'
  )


ggsave(filename="~/Desktop/NZASMR.png",
       height=4.5, width = 8, dpi=300, units = "in", bg = "white")
ggsave(filename="~/Desktop/NZASMR.jpg",
       height=4.5, width = 8, dpi=300, units = "in", bg = "white")
