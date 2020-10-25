#### Ground Game ####
#### Gov 1347: Election Analytics / Fall 2020

library(tidyverse)
library(ggplot2)
library(cowplot)
library(scales)
library(geofacet)
library(gridExtra)
library(knitr)
library(stargazer)
library(usmap)
library(rgdal)
library(statebins)
library(stringr)

#####------------------------------------------------------#
##### Read and merge data ####
#####------------------------------------------------------#

covid_county <- read_csv("Provisional_COVID-19_Death_Counts_in_the_United_States_by_County.csv")
demog_county <- read_csv("demog_county_1990-2018.csv")
popvote_cty  <- read_csv("popvote_bycounty_2000-2016.csv")

#####------------------------------------------------------#
##### Blog Content: Shocks ####
#####------------------------------------------------------#

# merge and modify data
covid_county$fips_char <- as.character(covid_county$`FIPS County Code`)
covid_county$fips_county <- substr(covid_county$fips_char,
                                   nchar(covid_county$fips_char)-2,
                                   nchar(covid_county$fips_char))
covid_county$state <- covid_county$State
covid_county$deaths=covid_county$`Deaths involving COVID-19`
covid_county$all_deaths=covid_county$`Deaths from All Causes`
covid_county$diff_deaths=covid_county$all_deaths-covid_county$deaths
covid_county$prop_deaths=covid_county$deaths/covid_county$all_deaths

popvote_cty$fips_char <- as.character(popvote_cty$fips)
popvote_cty$fips_county <- substr(popvote_cty$fips_char,
                                   nchar(popvote_cty$fips_char)-2,
                                   nchar(popvote_cty$fips_char))


# COVID visualization
covid_county %>%
  plot_usmap(regions="counties", values="Deaths involving COVID-19") +
  scale_fill_continuous(name="Deaths from COVID-19",label=scales::comma) +
  theme(legend.position = "right")

covid_county$fips=covid_county$`FIPS County Code`
covid_county$deaths=covid_county$`Deaths involving COVID-19`
covid_county$all_deaths=covid_county$`Deaths from All Causes`
covid_county$diff_deaths=covid_county$all_deaths-covid_county$deaths
covid_county$prop_deaths=covid_county$deaths/covid_county$all_deaths

plot_usmap(data = covid_county, regions = "counties", values = "deaths") + 
  scale_fill_gradient(low = "yellow2", high = "red", name = "Number of COVID Deaths",
                      na.value = "gray") +
  theme_void()

plot_usmap(data = covid_county, regions = "counties", values = "prop_deaths") + 
  scale_fill_gradient(low = "yellow2", high = "red", name = "Proportion of COVID Deaths to All Deaths",
                      na.value = "gray80") +
  theme(legend.position="right") +
  ggtitle("Proportion of COVID-19 Deaths, by County",
          subtitle="US CDC Data, Updated as of 10/21/2020") +
  theme_void()
ggsave("covid_19_deaths.png", height = 4, width = 8)


# popular-vote data modifications
popvote_cty <- popvote_cty %>%
  select(!c(state,fips,fips_char)) %>%
  rename(state=state_abb)
popvote_cty_w <- popvote_cty %>%
  spread(year, D_win_margin)
covid_popvote <- popvote_cty_w %>%
  left_join(covid_county, by=c("state","fips_county"))
covid_popvote <- covid_popvote %>%
  select(c(state,county,fips_county,"2000","2004","2008","2012","2016",
           deaths,all_deaths,diff_deaths,prop_deaths))
covid_popvote <- covid_popvote %>%
  rename(d_marg_2000="2000",d_marg_2004="2004",
         d_marg_2008="2008",d_marg_2012="2012",
         d_marg_2016="2016")
covid_popvote <- covid_popvote %>%
  mutate(d_pv_2000 = ifelse(d_marg_2000<0,0.5*(100+d_marg_2000),
                         0.5*(100-d_marg_2000)+d_marg_2000)) %>%
  mutate(d_pv_2004 = ifelse(d_marg_2004<0,0.5*(100+d_marg_2004),
                         0.5*(100-d_marg_2004)+d_marg_2004)) %>%
  mutate(d_pv_2008 = ifelse(d_marg_2008<0,0.5*(100+d_marg_2008),
                         0.5*(100-d_marg_2008)+d_marg_2008)) %>%
  mutate(d_pv_2012 = ifelse(d_marg_2012<0,0.5*(100+d_marg_2012),
                         0.5*(100-d_marg_2012)+d_marg_2012)) %>%
  mutate(d_pv_2016 = ifelse(d_marg_2016<0,0.5*(100+d_marg_2016),
                         0.5*(100-d_marg_2016)+d_marg_2016))
covid_popvote <- covid_popvote %>%
  mutate(avg_d_pv = 0.20*(d_pv_2000+d_pv_2004+d_pv_2008+
                            d_pv_2012+d_pv_2016))

# demographics data modifications
demog_recent <- demog_county %>%
  filter(year==2000|year==2004|year==2008|year==2012|year==2016)
demog_popvote <- demog_recent %>%
  left_join(popvote_cty, by=c("state","year","fips_county"))
all_covid <- demog_popvote %>%
  left_join(covid_county, by=c("state","fips_county"))
all_covid <- all_covid %>%
  mutate(d_pv = ifelse(D_win_margin<0,0.5*(100+D_win_margin),
                            0.5*(100-D_win_margin)+D_win_margin))
all_covid <- all_covid %>%
  mutate(d_pv_pct = d_pv*0.01)
all_covid <- all_covid %>%
  mutate(d_votes = d_pv*total)

# turnout data model, with unmodified demographics values
demog_2020 <- demog_county %>%
  filter(year==2018)

county_d_lm_1 <- lm(d_pv ~ Asian+Black+Hispanic+Indigenous+
                    Female+age20+age3045+age4565, all_covid)
summary(county_d_lm_1)

predict(county_d_lm_1, newdata=demog_2020) +
  (0.711544-0.355772)*demog_2020$Black +
  (0.223336-0.111668)*demog_2020$Hispanic

HB_orig <- data.frame(pred = predict(county_d_lm_1, newdata = demog_2020),
                      state = demog_2020$state, county = demog_2020$fips_county)
HB_new  <- data.frame(pred = predict(county_d_lm_1, newdata = demog_2020) +
                       (0.711544-0.355772)*demog_2020$Black +
                       (0.223336-0.111668)*demog_2020$Hispanic,
                      state = demog_2020$state, county = demog_2020$fips_county)

county_d_lm_2 <- lm(d_pv ~ Asian+Black+Hispanic+Indigenous+Female, all_covid)
summary(county_d_lm_2)

# turnout data model, using changes in demographics values
all_covid <- all_covid %>%
  unite("state_fips",state,fips_county,sep="_",remove=F)
demog_change <- all_covid %>%
  group_by(state_fips) %>%
  mutate(Asian_change = Asian - lag(Asian, order_by = year),
         Black_change = Black - lag(Black, order_by = year),
         Hispanic_change = Hispanic - lag(Hispanic, order_by = year),
         Indigenous_change = Indigenous - lag(Indigenous, order_by = year),
         White_change = White - lag(White, order_by = year),
         Female_change = Female - lag(Female, order_by = year),
         Male_change = Male - lag(Male, order_by = year),
         age20_change = age20 - lag(age20, order_by = year),
         age3045_change = age3045 - lag(age3045, order_by = year),
         age4565_change = age4565 - lag(age4565, order_by = year),
         age65_change = age65 - lag(age65, order_by = year)
  ) %>%
  filter(year==2004|year==2008|year==2012|year==2016)

county_d_lm_3 <- lm(d_pv ~ Asian_change+Black_change+
                           Hispanic_change+Indigenous_change+
                           Female_change+age20_change+
                           age3045_change+age4565_change, 
                    demog_change)
summary(county_d_lm_3)

county_d_lm_4 <- lm(d_pv ~ Asian_change+Black_change+
                      Hispanic_change+Indigenous_change+
                      Female_change,demog_change)
summary(county_d_lm_4)

county_d_lm_5 <- lm(d_pv ~ Asian_change+Asian_change*Asian+
                      Black_change+Black_change*Black+
                      Hispanic_change+Hispanic_change*Hispanic+
                      Indigenous_change+Indigenous_change*Indigenous+
                      Female_change+Female_change*Female+
                      age20_change+age20_change*age20+
                      age3045_change+age3045_change*age3045+
                      age4565_change+age4565_change*age4565, 
                    demog_change)
summary(county_d_lm_5)

demog_county <- demog_county %>%
  unite("state_fips",state,fips_county,sep="_",remove=F)
demog_2020_change <- demog_county %>%
  filter(year %in% c(2016, 2018)) %>%
  group_by(state_fips) %>%
  mutate(Asian_change = Asian - lag(Asian, order_by = year),
         Black_change = Black - lag(Black, order_by = year),
         Hispanic_change = Hispanic - lag(Hispanic, order_by = year),
         Indigenous_change = Indigenous - lag(Indigenous, order_by = year),
         White_change = White - lag(White, order_by = year),
         Female_change = Female - lag(Female, order_by = year),
         Male_change = Male - lag(Male, order_by = year),
         age20_change = age20 - lag(age20, order_by = year),
         age3045_change = age3045 - lag(age3045, order_by = year),
         age4565_change = age4565 - lag(age4565, order_by = year),
         age65_change = age65 - lag(age65, order_by = year)) %>%
  filter(year==2018)

predict(county_d_lm_5, newdata=demog_2020_change) +
  (0.756114-0.378057)*demog_2020_change$Black +
  (0.585452-0.292726)*demog_2020_change$Black_change +
  (0.615220-0.307610)*demog_2020_change$Hispanic +
  (-5.649422+2.824711)*demog_2020_change$Hispanic_change

HB_orig_2 <- data.frame(pred = predict(county_d_lm_5, newdata = demog_2020_change),
                      state = demog_2020_change$state, 
                      county = demog_2020_change$fips_county)
HB_new_2  <- data.frame(pred = predict(county_d_lm_5, newdata = demog_2020_change) +
                        (0.756114-0.378057)*demog_2020_change$Black +
                        (0.585452-0.292726)*demog_2020_change$Black_change +
                        (0.615220-0.307610)*demog_2020_change$Hispanic +
                        (-5.649422+2.824711)*demog_2020_change$Hispanic_change,
                      state = demog_2020_change$state,
                      county = demog_2020_change$fips_county)

HB_orig_2 <- HB_orig_2 %>%
  rename(fips_county = county) %>%
  left_join(covid_county,by=c("state","fips_county"))

HB_new_2 <- HB_new_2 %>%
  rename(fips_county = county) %>%
  left_join(covid_county,by=c("state","fips_county"))

HB_orig_2 <- HB_orig_2 %>%
  mutate(winner=ifelse(pred<50,"republican","democrat"))

HB_new_2 <- HB_new_2 %>%
  mutate(winner=ifelse(pred<50,"republican","democrat"))

table(HB_orig_2$winner)
table(HB_new_2$winner)

HB_orig_2_map <- HB_orig_2 %>%
  select(winner,state,fips) %>%
  mutate(fips=as.character(fips)) %>%
  mutate(winner=as.character(winner)) %>%
  mutate(state=as.character(state))


plot_usmap(data=HB_orig_2_map,regions="counties",values="winner") +
  scale_fill_gradient(low="firebrick2",high="cornflowerblue",na.value="gray")+
  theme(void)
                      
                      
                      = c("cornflowerblue", "firebrick2"), 
                    name = "state PV winner") +
  theme(legend.position = "none") +
  theme_void()



plot_usmap(data = HB_orig_2, regions = "counties", values = "deaths") + 
  scale_fill_gradient(low = "yellow2", high = "red", name = "Number of COVID Deaths",
                      na.value = "gray") +
  theme_void()
