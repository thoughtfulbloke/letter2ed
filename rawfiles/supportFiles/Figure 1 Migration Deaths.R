library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(ggtext)

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
  filter(Year == 2019) |> 
  summarise(.by=AgeN,
            NetMigration = sum(Net))

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
  filter(Year == 2019) |> 
  mutate(AgeN = ifelse(AgeN > 90, 90, AgeN)) |>
  summarise(.by=c(AgeN),
            Deaths = sum(Deaths))
DPEmatched <- DPE |> 
  filter(Year == 2019) |> 
  mutate(AgeN = ifelse(AgeN > 90, 90, AgeN)) |>
  summarise(.by=c(AgeN),
            Population = sum(Population))


combo <- ITM |> 
  inner_join(DPEmatched, by = join_by(AgeN)) |> 
  inner_join(VSDmatched, by = join_by(AgeN)) |> 
  mutate(Deaths = 100 * Deaths/Population,
         `Net Migration` = 100 * NetMigration/Population) |> 
  select(AgeN, Deaths, `Net Migration`) |> 
  gather(key="Series", value="Percent", -AgeN)


############################
source("theme.R")
six_cols <- colorblind_pal()(6)

ggplot(combo, aes(x=AgeN, ymax=Percent, fill=Series))+
  geom_ribbon(ymin=0)+
  theme_davidhood() + 
  theme(legend.position = "top",
        legend.key.size = unit(.9,"line")) +
  scale_fill_manual(values=c("#000000", "#CCCCCCAA"), name="Series:")+
  scale_x_continuous(breaks=c(0,30,60,90),
                     labels=c("under 1","30","60","90+")) +
  labs(title="2019 Deaths vs. Net Migration",
       subtitle="as percentage of resident population",
       y="Percentage", x="Age",
       caption="Source: infoshare.stats.govt.nz: Deaths by age and sex (Annual-Dec)
Estimated Resident Population by Age and Sex (1991+) (Annual-Dec)
Estimated migration by direction, age group and sex,\n12/16-month rule (Annual-Dec)")

ggsave(filename="../rawfiles/md_figures/figure1.tiff",
       height=3.3, width = 3.3, dpi=1200, units = "in", bg = "white")
ggsave(filename="../rawfiles/md_figures/figure1.png",
       height=3.3, width = 3.3, dpi=300, units = "in", bg = "white")
ggsave(filename="../md_figures/figure1.png",
       height=3.3, width = 3.3, dpi=300, units = "in", bg = "white")
