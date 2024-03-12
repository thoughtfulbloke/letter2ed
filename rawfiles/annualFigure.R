



source("Serbia.R")
source("NewZealand.R")
source("Sweden.R")
source("Bulgaria.R")
rm(list=setdiff(ls(), c("BUL", "NZ",
                        "SWE", "SRB")))
library(ggplot2)
library(ggthemes)
library(ggtext)
source("theme.R")
Bmod <- lm(Standth ~ Year, data=BUL |> 
             filter(Year %in% 2013:2019))
BUL$exp <- Bmod$coefficients[1] + 
  Bmod$coefficients[2] * BUL$Year
Cexcess = round(sum(100 * BUL$Standth[21:23] / 
                   BUL$exp[21:23]-100),2)
Rexcess = round(sum(BUL$Standth[21:23]) - sum(BUL$exp[21:23]),0)
BUL$Country = paste0(BUL$Country,"<P><P>Cummulative excess <span style='color:", six_cols[3],"'>",
                     "2020 to 2022</span> ",
                     Cexcess, "% (",Rexcess," people)")
NZmod <- lm(Standth ~ Year, data=NZ |> 
          filter(Year %in% 2013:2019))
NZ$exp <- NZmod$coefficients[1] + 
  NZmod$coefficients[2] * NZ$Year
Cexcess = round(sum(100 * NZ$Standth[21:23] / 
                      NZ$exp[21:23]-100),2)
Rexcess = round(sum(NZ$Standth[21:23]) - sum(NZ$exp[21:23]),0)
NZ$Country = paste0(NZ$Country,"<P><P>Cummulative excess <span style='color:", six_cols[3],"'>",
                    "2020 to 2022</span> ",
                    Cexcess, "% (",Rexcess," people)")
SEmod <- lm(Standth ~ Year, data=SWE |> 
             filter(Year %in% 2013:2019))
SWE$exp <- SEmod$coefficients[1] + 
  SEmod$coefficients[2] * SWE$Year
Cexcess = round(sum(100 * SWE$Standth[21:23] / 
                      SWE$exp[21:23]-100),2)
Rexcess = round(sum(SWE$Standth[21:23]) - sum(SWE$exp[21:23]),0)
SWE$Country = paste0(SWE$Country,"<P><P>Cummulative excess <span style='color:", six_cols[3],"'>",
                     "2020 to 2022</span> ",
                     Cexcess, "% (",Rexcess," people)")
RSmod <- lm(Standth ~ Year, data=SRB |> 
              filter(Year %in% 2013:2019))
SRB$exp <- RSmod$coefficients[1] + 
  RSmod$coefficients[2] * SRB$Year
Cexcess = round(sum(100 * SRB$Standth[21:23] / 
                      SRB$exp[21:23]-100),2)
Rexcess = round(sum(SRB$Standth[21:23]) - sum(SRB$exp[21:23]),0)
SRB$Country = paste0(SRB$Country,"<P><P>Cummulative excess <span style='color:", six_cols[3],"'>",
                     "2020 to 2022</span> ",
                     Cexcess, "% (",Rexcess," people)")
figdat <- bind_rows(BUL,NZ,SRB,SWE) |> 
  filter(Year > 2010)

vertical <- figdat |> 
  summarise(.by=Country,
            minact = min(Standth),
            maxact = max(Standth),
            minexp = min(Standth),
            maxexp = max(Standth)) |> 
  mutate(lowpoint = ifelse(minact < minexp,minact,minexp),
         highpoint = ifelse(maxact > maxexp,maxact,maxexp),
         localrange = highpoint - lowpoint,
         facettop = max(localrange)+lowpoint,
         Year=2013)

ggplot(figdat, aes(x=Year, y=Standth)) +
  geom_blank(data=vertical,aes(y=facettop))+
  geom_vline(xintercept = 2019.5, colour="#EEEEEE") +
  geom_line(data=figdat,
            aes(y=exp), colour=six_cols[2], linetype=2)+
  geom_line(data=figdat |> filter(Year %in% 2013:2019),
            aes(y=exp), colour=six_cols[2])+
  geom_point(data=figdat[(figdat$Year<2020 | figdat$Year>2022),]) +
  geom_point(data=figdat[(figdat$Year>2019 &  figdat$Year<2023),], colour=six_cols[3]) + 
  theme_davidhood() +
  theme(strip.text = element_markdown(),
        plot.subtitle = element_markdown())+
  facet_wrap(~ Country, ncol=2, scales="free_y") +
  labs(title="Pandemic deaths if every countries population in each year was the same as NZ in 2022 Q2",
       subtitle=paste0("Matching death rates by age between countries, by age standardised on NZ population as at 2022 Quarter 2, vs <span style='color:", six_cols[2],"'>2013-19</span> trend"),
       y="Deaths in NZ 2022 terms",
       caption="Sources: Europe pre-2021 EuroStat, 
       all else National Statistical Authorities: BUL infostat.nsi.bg, NZL infoshare.stats.govt.nz, SRB data.stat.gov.rs, SWE scb.se/en/")
ggsave(filename="~/Desktop/FourCountry.png",
       height=4.5, width = 8, dpi=300, units = "in", bg = "white")
ggsave(filename="~/Desktop/FourCountry.jpg",
       height=4.5, width = 8, dpi=300, units = "in", bg = "white")
