library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(ggtext)
library(patchwork)
library(forcats)

# figure 01a Male death rates by age since 2013
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
         AgeGroup = case_when(AgeN > 79 ~ "80 plus",
                              AgeN > 59 ~ "60 to 79",
                              AgeN > 39 ~ "40 to 59",
                              AgeN > 19 ~ "20 to 39",
                              TRUE ~ "0 to 19"),
         Year = as.numeric(Year)) |> 
  summarise(.by = c(Year,AgeGroup),
            Males=sum(Male),
            Females=sum(Female)) |> 
  filter(Year > 2012)

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
         AgeGroup = case_when(AgeN > 79 ~ "80 plus",
                              AgeN > 59 ~ "60 to 79",
                              AgeN > 39 ~ "40 to 59",
                              AgeN > 19 ~ "20 to 39",
                              TRUE ~ "0 to 19"),
         AnnualPop = as.numeric(MeanPop),
         Year = as.numeric(Year)) |> 
  summarise(.by = c(Year,AgeGroup,Sex),
            Population=sum(AnnualPop, na.rm=TRUE)) |> 
  filter(Year > 2012)

Males <- DPE |> 
  filter(Sex == "Male") |> 
  inner_join(VSD,by = join_by(Year, AgeGroup)) |> 
  mutate(Rate1K = 1000*Males/Population)

six_cols <- colorblind_pal()(6)

ggplot(Males, aes(x=Year, y=Rate1K)) +
  geom_vline(xintercept=c(2015,2020), colour="#FAFAFA")+
  geom_point(size=0.5, colour=six_cols[3]) +
  facet_wrap(~ AgeGroup, ncol=1, scales="free_y") +
  scale_x_continuous(breaks = c(2015,2020)) +
  scale_y_continuous(n.breaks = 3)+
  labs(title = "NZ Male death rates by\nmajor age group\n2013-2023 inclusive",
       y="Annual Death rate per 1000 people in age group") +
  theme_minimal(base_family="Open Sans",
                base_size = 6) +
  theme(
    plot.background = element_rect(fill = "#FAFAFA", colour="#FAFAFA"),
    panel.background = element_rect(fill = "#FFFFFF", colour = "#FFFFFF"),
    panel.spacing.x = unit(9, "points"),
    panel.spacing.y = unit(3, "points"),
    panel.grid = element_blank(),
    strip.background = element_rect(fill= "#FFFFFF", colour="#EFEFEF"),
    strip.text = element_text(margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt")),
    strip.placement = "inside",
    axis.title.y.left = element_text(margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt"))
  )
ggsave(filename="1a_Male_Deathrate.tiff",
       height=5, width = 2, dpi=300, units = "in", bg = "white")

# figure 01b Female death rates by age since 2013
Females <- DPE |> 
  filter(Sex == "Female") |> 
  inner_join(VSD,by = join_by(Year, AgeGroup)) |> 
  mutate(Rate1K = 1000*Females/Population)

ggplot(Females, aes(x=Year, y=Rate1K)) +
  geom_vline(xintercept=c(2015,2020), colour="#FAFAFA")+
  geom_point(size=0.5, colour=six_cols[2]) +
  facet_wrap(~ AgeGroup, ncol=1, scales="free_y") +
  scale_x_continuous(breaks = c(2015,2020)) +
  scale_y_continuous(n.breaks = 3)+
  labs(title = "NZ Female death rates by\nmajor age group\n2013-2023 inclusive",
       y="Annual Death rate per 1000 people in age group") +
  theme_minimal(base_family="Open Sans",
                base_size = 6) +
  theme(
    plot.background = element_rect(fill = "#FAFAFA", colour="#FAFAFA"),
    panel.background = element_rect(fill = "#FFFFFF", colour = "#FFFFFF"),
    panel.spacing.x = unit(9, "points"),
    panel.spacing.y = unit(3, "points"),
    panel.grid = element_blank(),
    strip.background = element_rect(fill= "#FFFFFF", colour="#EFEFEF"),
    strip.text = element_text(margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt")),
    strip.placement = "inside",
    axis.title.y.left = element_text(margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt"))
  )
ggsave(filename="1b_Female_Deathrate.tiff",
       height=5, width = 2, dpi=300, units = "in", bg = "white")
################
rm(list=ls())
# figure 01c Age Structure 2022
autoAge <- paste(0:94,"Years")
autoAge <- c(autoAge,"95 Years and Over")
six_cols <- colorblind_pal()(6)

DPE <- read.csv("DPEpopulation_by_age_sex.csv", skip=1,
                col.names = c("Year","Age","Sex","MeanPop")) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year),
         Age = ifelse(Age == " ", NA_character_,Age)) |> 
  fill(Year,Age) |> 
  filter(Sex %in% c("Male","Female"),
         Age %in% autoAge) |> 
  mutate(AgeN = as.numeric(gsub(" .*","",Age)),
         AnnualPop = as.numeric(MeanPop),
         Year = as.numeric(Year),
         AnnualPop = ifelse(Sex=="Male", -1*AnnualPop, AnnualPop)) |> 
  filter(Year == 2022)

ggplot(DPE,aes(x=AgeN, y=AnnualPop,fill=Sex)) +
  geom_col(width=0.7) +
  geom_hline(yintercept=c(-30000,30000), colour="#FAFAFA", linewidth=0.3)+
  coord_flip()+
  scale_fill_manual(values=six_cols[2:3]) +
  scale_x_continuous(breaks=c(25,50,75, 95),
                     labels=c("25","50","75","95+"))+
  scale_y_continuous(breaks=c(-30000,0,30000),
                     labels=c("30000","0","30000"))+
  theme_minimal(base_family="Open Sans",
                base_size = 6) +
  annotate("text", x=85,y=-22000,label="Male\nPopulation\nStructure",
           colour=six_cols[3], size=2)+
  annotate("text", x=85,y=22000,label="Female\nPopulation\nStructure",
           colour=six_cols[2],size=2)+
  theme(
    legend.position = "None",
    plot.background = element_rect(fill = "#FAFAFA", colour="#FAFAFA"),
    panel.background = element_rect(fill = "#FFFFFF", colour = "#FFFFFF"),
    panel.spacing.x = unit(9, "points"),
    panel.spacing.y = unit(3, "points"),
    panel.grid = element_blank(),
    strip.background = element_rect(fill= "#FFFFFF", colour="#EFEFEF"),
    strip.text = element_text(margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt")),
    strip.placement = "inside",
    axis.title = element_text(margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt"))
  ) +
  labs(title="Standardising by applying the\nsame population structure\nto each year",
       subtitle="in this example, mean population 2022",
       x="Age in 2022", y="Count of age group in year")

ggsave(filename="1c_2022Structure.tiff",
       height=5, width = 2, dpi=300, units = "in", bg = "white")
##########
rm(list=ls())
# 1d Age Standardised Deaths (5 years to 90)
autoAge <- paste(0:94,"Years")
autoAge <- c(autoAge,"95 Years and Over")
six_cols <- colorblind_pal()(6)
DMM <- read.csv("DMMDeathRatesByAgeAndSex.csv", skip=1,
                col.names = c("Year","Age","Male","Female")) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year)) |> 
  fill(Year) |> 
  mutate(Year = as.numeric(Year)) |> 
  filter(!is.na(Year), Year > 2012) |>
  gather(key="Sex", value="Rate", Male:Female)

DPE <- read.csv("DPEpopulation_by_age_sex.csv", skip=1,
                col.names = c("Year","Age","Sex","MeanPop")) |> 
  mutate(Year = ifelse(Year == " ", NA_character_,Year),
         Age = ifelse(Age == " ", NA_character_,Age)) |> 
  fill(Year,Age) |> 
  filter(Sex %in% c("Male","Female"),
         Age %in% autoAge) |> 
  mutate(AgeN = as.numeric(gsub(" .*","",Age)),
         AgeG = floor(AgeN/5)*5,
         AgeG = ifelse(AgeG > 89,90,AgeG),
         AnnualPop = as.numeric(MeanPop),
         Year = as.numeric(Year)) |> 
  filter(Year == 2022) |> 
  summarise(.by=c(Sex,AgeG),
            GroupSize=sum(AnnualPop)) |> 
  mutate(Age = paste0(AgeG,"-",AgeG+4," Years"),
         Age = ifelse(Age == "90-94 Years","90 Years and Over",Age)) |> 
  select(Age,Sex,GroupSize) 


ASM <- DMM |> 
  inner_join(DPE, by = join_by(Age, Sex)) |> 
  mutate(stdth = Rate * GroupSize/1000) |> 
  summarise(.by=Year,
            StandardDeaths = sum(stdth))

ggplot(ASM, aes(x=Year, y=StandardDeaths)) +
  geom_vline(xintercept=c(2015,2020), colour="#FAFAFA")+
  geom_point(size=0.5) +
  scale_x_continuous(breaks = c(2015,2020)) +
  scale_y_continuous(n.breaks = 3)+
  labs(title = "Age Standardised Deaths",
       subtitle="by 2022 (5 year steps then 90+)",
       y="Deaths if population as 2022", x="") +
  theme_minimal(base_family="Open Sans",
                base_size = 6) +
  theme(
    plot.background = element_rect(fill = "#FAFAFA", colour="#FAFAFA"),
    panel.background = element_rect(fill = "#FFFFFF", colour = "#FFFFFF"),
    panel.spacing.x = unit(9, "points"),
    panel.spacing.y = unit(3, "points"),
    panel.grid = element_blank(),
    strip.background = element_rect(fill= "#FFFFFF", colour="#EFEFEF"),
    strip.text = element_text(margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt")),
    strip.placement = "inside",
    axis.title.y.left = element_text(margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt"))
  )
ggsave(filename="1d.tiff",
       height=2, width = 2, dpi=300, units = "in", bg = "white")

ASMR = ASM |> 
  mutate(MR = 1000*StandardDeaths/sum(DPE$GroupSize))

ggplot(ASMR, aes(x=Year, y=MR)) +
  geom_vline(xintercept=c(2015,2020), colour="#FAFAFA")+
  geom_point(size=0.5) +
  scale_x_continuous(breaks = c(2015,2020)) +
  scale_y_continuous(n.breaks = 3)+
  labs(title = "Age Standardised Mortality Rate",
       subtitle="by 2022 (5 year steps then 90+)",
       y="Death rate if population as 2022", x="") +
  theme_minimal(base_family="Open Sans",
                base_size = 6) +
  theme(
    plot.background = element_rect(fill = "#FAFAFA", colour="#FAFAFA"),
    panel.background = element_rect(fill = "#FFFFFF", colour = "#FFFFFF"),
    panel.spacing.x = unit(9, "points"),
    panel.spacing.y = unit(3, "points"),
    panel.grid = element_blank(),
    strip.background = element_rect(fill= "#FFFFFF", colour="#EFEFEF"),
    strip.text = element_text(margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt")),
    strip.placement = "inside",
    axis.title.y.left = element_text(margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt"))
  )
ggsave(filename="1e.tiff",
       height=2, width = 2, dpi=300, units = "in", bg = "white")


