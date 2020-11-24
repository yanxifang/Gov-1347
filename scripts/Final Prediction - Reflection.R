#### FINAL ELECTION PREDICTION ####
#### Gov 1347: Election Analysis (2020)
#### Yanxi Fang, Harvard College Class of 2023

####----------------------------------------------------------#
#### Load packages and datasets ####
####----------------------------------------------------------#

## load packages
library(tidyverse)
library(knitr)
library(stargazer)
library(usmap)
library(rgdal)
library(cowplot)
library(statebins)

## set working directory
setwd("D:/Users/Yanxi Fang/Files/Fall 2020/Gov 1347/Blog Post Work/Week 11 - Reflection/Data from Previous Weeks")

## read in datasets
fedgrants_cty <- read_csv("fedgrants_bycounty_1988-2008.csv")
fedgrants_st  <- read_csv("fedgrants_bystate_1988-2008.csv")
poll_avg_df   <- read_csv("pollavg_1968-2016.csv")
poll_avg_st   <- read_csv("pollavg_bystate_1968-2016.csv")
popvote_df    <- read_csv("popvote_1948-2016.csv")
popvote_st_df <- read_csv("popvote_bystate_1948-2016.csv")
turnout_df    <- read_csv("turnout_1980-2016.csv")
vep_df        <- read_csv("vep_1980-2016.csv")
polls_2016    <- read_csv("polls_2016.csv")
polls_2020_old<- read_csv("polls_2020_old.csv")
polls_2020_new<- read_csv("polls_2020.csv")
local_econ_df <- read_csv("local.csv")
natl_econ_df  <- read_csv("econ.csv")
ev_allocation <- read_csv("ev_allocations.csv")
electoral_col <- read_csv("Electoral_College.csv")
elect_vote    <- read_csv("electoralvote_1948-2016.csv")
demographic_st<- read_csv("demographic_1990-2018.csv")
demographic_ct<- read_csv("demog_county_1990-2018.csv")
gallup_approv <- read_csv("approval_gallup_1941-2020.csv")
gdp_st_qtrly  <- read_csv("SQINC1__ALL_AREAS_1948_2020.csv")

####----------------------------------------------------------#
#### Which states to exclude from the model? ####
####----------------------------------------------------------#
# Some states are either solidly blue or red
# It's not particularly useful to consider those states in the model
# There were 3 consecutive Republican landslides (1980, 1984, 1988)
# So, it makes sense to start looking at state consistency from 1992 to 2016

safe_st_d <- popvote_st_df %>%
  filter(year>=1992) %>%
  select(state,year,D_pv2p) %>%
  spread(year,D_pv2p)

safe_st_r <- popvote_st_df %>%
  filter(year>=1992) %>%
  select(state,year,R_pv2p) %>%
  spread(year,R_pv2p)

safe_st_d <- safe_st_d %>%
  rename(d_1992=2, d_1996=3, d_2000=4, d_2004=5, d_2008=6, d_2012=7, d_2016=8) %>%
  mutate(safe_all_d=ifelse(d_1992>50 & d_1996>50 & d_2000>50 & d_2004>50 
                         & d_2008>50 & d_2012>50 & d_2016>50, "Yes","No"))

safe_st_r <- safe_st_r %>%
  rename(r_1992=2, r_1996=3, r_2000=4, r_2004=5, r_2008=6, r_2012=7, r_2016=8) %>%
  mutate(safe_all_r=ifelse(r_1992>50 & r_1996>50 & r_2000>50 & r_2004>50 
                         & r_2008>50 & r_2012>50 & r_2016>50, "Yes","No"))

all_safe_states <- safe_st_d %>%
  full_join(safe_st_r,by="state")

all_safe_states <- all_safe_states %>%
  filter(safe_all_d=="Yes" | safe_all_r=="Yes") %>%
  mutate(safe=ifelse(safe_all_d=="Yes","D","R")) %>%
  filter(state!="Texas" & state!="Nebraska" & state!="Maine") 
    # rationale for removing these states is included in the blog post

plot_usmap(data=all_safe_states,regions="states",values="safe",labels=TRUE)+
  scale_fill_manual(values = c("cornflowerblue","firebrick2"),
                    name="Party",
                    label=c("Democratic","Republican","Neither")) +
  theme_void() +
  labs(title = "Safe States, 1992-2016",
       subtitle = "These states* voted for the same party for all presidential elections during this period.",
       caption = "*Three states removed: Texas, Nebraska, and Maine.")
ggsave("safe_states_1992_2016.png", height = 6, width = 12)

all_safe_states <- all_safe_states %>%
  left_join(ev_allocation, by="state")

all_safe_states %>%
  group_by(safe) %>%
  summarize(ev = sum(ev_alloted))

unique(all_safe_states$state)

####----------------------------------------------------------#
#### The Fundamentals: Economic Conditions ####
####----------------------------------------------------------#

popvote_st_df <- popvote_st_df %>%
  arrange(state,year) %>%
  mutate(delta_D_pv2p = D_pv2p-lag(D_pv2p)) %>%
  mutate(delta_R_pv2p = R_pv2p-lag(R_pv2p))

all_safe_states_2col <- all_safe_states %>%
  select(state,safe)

local_econ_25 <- local_econ_df %>%
  rename(state=`State and area`) %>%
  filter(state!="Los Angeles County" & state!="New York city") %>%
  left_join(all_safe_states_2col, by="state")

local_econ_25 <- local_econ_25 %>%
  filter(is.na(safe))
unique(local_econ_25$state)

local_econ_25 <- local_econ_25 %>%
  rename(year="Year") %>%
  left_join(popvote_st_df, by=c("state","year"))

local_econ_25 <- local_econ_25 %>%
  filter(year == 1976 | year == 1980 | year == 1984 |
         year == 1988 | year == 1992 | year == 1996 |
         year == 2000 | year == 2004 | year == 2008 |
         year == 2012 | year == 2016 | year == 2020) %>%
  filter(Month <= "10") %>%
  arrange(state)

local_econ_25 <- popvote_df %>%
  filter(incumbent_party == TRUE & year >= 1976) %>%
  select(year, winner, party) %>%
  left_join(local_econ_25)

local_econ_25 <- local_econ_25 %>%
  mutate(incumb_pv2p = ifelse(party == "republican", R_pv2p, D_pv2p)) %>%
  mutate(incumb_delta_pv2p = ifelse(party == "republican", delta_R_pv2p, delta_D_pv2p))

lm_econ_local <- lm(incumb_pv2p ~ Unemployed_prce + state + Month,
                    data = local_econ_25)
summary(lm_econ_local)

lm_econ_local2 <- lm(incumb_delta_pv2p ~ Unemployed_prce + state + Month,
                     data=local_econ_25)
summary(lm_econ_local2)

local_econ_25_ave <- local_econ_25 %>% #average ue across 10 months
  mutate(local_ave_ue = 0.1*
           ((`Unemployed_prce`)+lag(`Unemployed_prce`,n=1L)+
              lag(`Unemployed_prce`,n=2L)+
              lag(`Unemployed_prce`,n=3L)+
              lag(`Unemployed_prce`,n=4L)+
              lag(`Unemployed_prce`,n=5L)+
              lag(`Unemployed_prce`,n=6L)+
              lag(`Unemployed_prce`,n=7L)+
              lag(`Unemployed_prce`,n=8L)+
              lag(`Unemployed_prce`,n=9L))) %>%
  filter(Month == "10")

lm_econ_local3 <- lm(incumb_delta_pv2p ~ local_ave_ue + state,
                     data=local_econ_25_ave)
summary(lm_econ_local3)

local_econ_25_ave %>%
  ggplot(aes(x=local_ave_ue, y=incumb_delta_pv2p)) + 
  geom_point() +
  geom_smooth(method="lm", formula = y ~ x) +
  geom_hline(yintercept=0, lty=2) +
  geom_vline(xintercept=0.0001, lty=2) + # median
  xlab("Average State Unemployment Rate (10 Months, Up to October of Election Year)") +
  ylab("Change in Incumbent Party Share of the 2-Party State Pop. Vote") +
  theme_bw() +
  ggtitle("Avg. State Unemployment Rate vs Change in State Pop. Vote",
          subtitle="Y = -3.4147 - 0.1352 * X") +
  theme(axis.text = element_text(size = 8),
        axis.title = element_text(size = 10),
        plot.title = element_text(size = 16))

# clearly, the unemployment-based, local-level economic model has failed again
# the coefficient doesn't make sense, and the model fit is very poor/non-existent
# so, it is time to use another proxy for modeling the economy

# new economic data: quarterly personal income, by state
# this should better capture the economy from a voter's perspective
# source: U.S. Bureau of Economic Analysis
# links: https://apps.bea.gov/regional/downloadzip.cfm
# and: https://apps.bea.gov/regional/docs/DataAvailability.cfm

gdp_st_qtrly <- gdp_st_qtrly %>%
  filter(LineCode==1) %>%
  rename(state=GeoName)

gdp_st_qtrly <- gdp_st_qtrly[-c(1,53:60),] # remove non-states
gdp_st_qtrly$state <- as.character(gdp_st_qtrly$state)
gdp_st_qtrly <- gdp_st_qtrly[-c(2,12),] # remove AK, HI due to astericks

gdp_st_qtrly <- gdp_st_qtrly %>%
  left_join(all_safe_states_2col,by="state") %>%
  filter(is.na(safe))
unique(gdp_st_qtrly$state)
  
gdp_st_qtrly <- gdp_st_qtrly %>%
  gather(quarter,st_personal_inc,`1948:Q1`:`2020:Q2`)

gdp_st_qtrly <- gdp_st_qtrly %>%
  separate(quarter,c("year","qtr"),sep=":")
  
gdp_st_qtrly <- gdp_st_qtrly %>%
  select(state,year,qtr,st_personal_inc) %>%
  arrange(state)

gdp_st_qtrly <- gdp_st_qtrly %>%
  mutate(last_qtr_inc = lag(`st_personal_inc`))

gdp_st_qtrly$st_personal_inc <- as.numeric(gdp_st_qtrly$st_personal_inc)
gdp_st_qtrly$last_qtr_inc <- as.numeric(gdp_st_qtrly$last_qtr_inc)
gdp_st_qtrly <- gdp_st_qtrly %>%
  mutate(delta_inc = 100*(st_personal_inc - last_qtr_inc)/(st_personal_inc))

gdp_st_qtrly_allyrs <- gdp_st_qtrly
  
gdp_st_qtrly <- gdp_st_qtrly %>%
  filter(year == 1952 | year == 1956 | year == 1960 |
         year == 1964 | year == 1968 | year == 1972 |
         year == 1976 | year == 1980 | year == 1984 |
         year == 1988 | year == 1992 | year == 1996 |
         year == 2000 | year == 2004 | year == 2008 |
         year == 2012 | year == 2016 | year == 2020) %>%
  filter(qtr == "Q1" | qtr == "Q2")

gdp_st_qtrly$year <- as.numeric(gdp_st_qtrly$year)
popvote_st_df$year <- as.numeric(popvote_st_df$year)
gdp_st_qtrly <- gdp_st_qtrly %>%
  left_join(popvote_st_df, by=c("year","state"))

gdp_st_qtrly <- popvote_df %>%
  filter(incumbent_party == TRUE & year >= 1952) %>%
  select(year, winner, party) %>%
  left_join(gdp_st_qtrly)

gdp_st_qtrly <- gdp_st_qtrly %>%
  mutate(incumb_pv2p = ifelse(party == "republican", R_pv2p, D_pv2p)) %>%
  mutate(incumb_delta_pv2p = ifelse(party == "republican", delta_R_pv2p, delta_D_pv2p))

gdp_st_q2_only <- gdp_st_qtrly %>%
  filter(qtr=="Q2")

lm_econ_local4 <- lm(incumb_pv2p ~ delta_inc + state, 
                    data = gdp_st_q2_only)
summary(lm_econ_local4)

gdp_st_both_qs <- gdp_st_qtrly %>%
  mutate(avg_delta_inc = 0.5*(delta_inc+lag(delta_inc))) %>%
  filter(qtr=="Q2")

lm_econ_local5 <- lm(incumb_pv2p ~ avg_delta_inc + state,
                      data = gdp_st_both_qs)
summary(lm_econ_local5)

gdp_st_qtrly_allyrs$year <- as.numeric(gdp_st_qtrly_allyrs$year)
gdp_st_qtrly_allyrs <- gdp_st_qtrly_allyrs %>%
  left_join(popvote_st_df, by=c("year","state"))

gdp_st_qtrly_allyrs <- gdp_st_qtrly_allyrs %>%
  mutate(delta_inc_lag2 = lag(delta_inc)) %>%
  filter(qtr!="Q4")

gdp_st_qtrly_allyrs <- popvote_df %>%
  filter(incumbent_party == TRUE & year >= 1952) %>%
  select(year, winner, party) %>%
  left_join(gdp_st_qtrly_allyrs)

gdp_st_qtrly_allyrs <- gdp_st_qtrly_allyrs %>%
  mutate(incumb_pv2p = ifelse(party == "republican", R_pv2p, D_pv2p)) %>%
  mutate(incumb_delta_pv2p = ifelse(party == "republican", delta_R_pv2p, delta_D_pv2p))

gdp_st_qtrly_allyrs <- gdp_st_qtrly_allyrs %>%
  mutate(avg_delta_inc = (1/3)*(delta_inc_lag2+lag(delta_inc_lag2,n=1L)+lag(delta_inc_lag2,n=2L)))

gdp_st_3qtrs <- gdp_st_qtrly_allyrs %>%
  filter(qtr=="Q3")

lm_econ_local6 <- lm(incumb_pv2p ~ avg_delta_inc + state,
                     data = gdp_st_3qtrs)
summary(lm_econ_local6)

lm_econ_local7 <- lm(incumb_pv2p ~ avg_delta_inc, data=gdp_st_3qtrs)
summary(lm_econ_local7)

gdp_st_3qtrs %>%
  ggplot(aes(x=avg_delta_inc, y=incumb_pv2p)) + 
  geom_point() +
  geom_smooth(method="lm", formula = y ~ x) +
  geom_hline(yintercept=50, lty=2) +
  geom_vline(xintercept=0.0001, lty=2) + # median
  xlab("Average Percent Change in Quarterly State Income (3 Qtrs, Up to Q2 of Election Year)") +
  ylab("Incumbent Party Share of the 2-Party State Pop. Vote") +
  theme_bw() +
  ggtitle("Avg. Pct. Change in State Income vs State Pop. Vote",
          subtitle="Y = 49.3458 + 1.2335 * X") +
  theme(axis.text = element_text(size = 8),
        axis.title = element_text(size = 10),
        plot.title = element_text(size = 16))

lm_econ_local_final <- lm_econ_local7
# R-squared value: 0.02351
# coefficients: 48.6270, avg_delta_inc 1.6168
# stat. signif: <2e-16                 0.000888
# compares pv2p with 3-quarter avg change in state gdp

####----------------------------------------------------------#
#### Polling Data: Revisited ####
####----------------------------------------------------------#

popvote_st_df$D_pv <- 100*popvote_st_df$D/popvote_st_df$total
popvote_st_df$R_pv <- 100*popvote_st_df$R/popvote_st_df$total
poll_avg_st <- inner_join(poll_avg_st, popvote_st_df, by=c("year","state"))
poll_avg_st <- poll_avg_st %>%
  mutate(candidate_pv = ifelse(party=="democrat",D_pv,R_pv))

lm_poll_st_all <- lm(candidate_pv ~ avg_poll, data=poll_avg_st)
summary(lm_poll_st_all)

poll_avg_st_25 <- poll_avg_st %>%
  left_join(all_safe_states_2col,by="state") %>%
  filter(is.na(safe))

lm_poll_st_25 <- lm(candidate_pv ~ avg_poll, data=poll_avg_st_25)
summary(lm_poll_st_25)

summary(poll_avg_st_25$days_left) # median is 45 days before the election

poll_avg_st_25_shortterm <- poll_avg_st_25 %>%
  filter(days_left <= 45)
poll_avg_st_25_longterm <- poll_avg_st_25 %>%
  filter(days_left > 45)

lm_poll_st_25st <- lm(candidate_pv ~ avg_poll, data=poll_avg_st_25_shortterm)
summary(lm_poll_st_25st) # R-squared 0.7297
# coefficients: 6.509054, avg_poll 0.930512, both statistically significant
# compares pv (not pv2p) with average polling data

lm_poll_st_25lt <- lm(candidate_pv ~ avg_poll, data=poll_avg_st_25_longterm)
summary(lm_poll_st_25lt) # R-squared 0.5353

####----------------------------------------------------------#
#### Incumbency & Economy, with Polls ####
####----------------------------------------------------------#

poll_avg_st_25_incumb <- poll_avg_st_25 %>%
  left_join(popvote_df, by=c("year","party"))
lm_poll_st_incumb <- lm(candidate_pv ~ avg_poll + incumbent, data=poll_avg_st_25_incumb)
summary(lm_poll_st_incumb)

poll_avg_st_25_incumb_st <- poll_avg_st_25_incumb %>%
  filter(days_left <= 45)
poll_avg_st_25_incumb_lt <- poll_avg_st_25_incumb %>%
  filter(days_left > 45)

lm_poll_st_incumb_st <- lm(candidate_pv ~ avg_poll + incumbent, data=poll_avg_st_25_incumb_st)
summary(lm_poll_st_incumb_st) # R-squared 0.7309
lm_poll_st_incumb_lt <- lm(candidate_pv ~ avg_poll + incumbent, data=poll_avg_st_25_incumb_lt)
summary(lm_poll_st_incumb_lt) # R-squared 0.5360

gdp_st_3qtrs_merge <- gdp_st_3qtrs %>%
  select(year,party,state,st_personal_inc,last_qtr_inc,delta_inc,delta_inc_lag2,avg_delta_inc)
poll_avg_st_plusecon <- poll_avg_st_25_incumb %>%
  left_join(gdp_st_3qtrs_merge, by=c("year","party","state"))
lm_poll_st_econ <- lm(candidate_pv ~ avg_poll + avg_delta_inc, data=poll_avg_st_plusecon)
summary(lm_poll_st_econ) # R-squared 0.7312, with stat. signif. coefficient for avg_delta_inc

poll_avg_st_plusecon_short <- poll_avg_st_25_incumb_st %>%
  left_join(gdp_st_3qtrs_merge, by=c("year","party","state"))
lm_poll_st_econ_short <- lm(candidate_pv ~ avg_poll + avg_delta_inc, 
                            data=poll_avg_st_plusecon_short)
summary(lm_poll_st_econ_short) # substantially better R-squared, 0.8511

lm_poll_econ_local_final <- lm_poll_st_econ_short
summary(lm_poll_econ_local_final)
# R-squared value: 0.8511
# coefficients: 2.60154, avg_poll 0.97304, avg_delta_inc 0.93051
# all three of these values are highly statistically significant
# compares pv (not pv2p) with average short-range (<45 day) poll
#                          and 3-quarter avg change in state gdp

####----------------------------------------------------------#
#### Predicting with this model... ####
####----------------------------------------------------------#

# 2020 poll data
# latest data (as of 11/01/2020) from FiveThirtyEight
# https://github.com/fivethirtyeight/data/tree/master/polls
poll_2020 <- read.csv("presidential_poll_averages_2020.csv")

poll_2020$election_date <- as.Date("11/3/2020","%m/%d/%Y")
poll_2020$date <- as.Date(poll_2020$modeldate,"%m/%d/%Y")
poll_2020$days_left <- as.numeric(difftime(poll_2020$election_date,
                                           poll_2020$date,units=c("days")))
summary(poll_2020$days_left)
poll_2020 <- poll_2020 %>%
  left_join(all_safe_states_2col,by="state") %>%
  filter(is.na(safe))

poll_2020 <- poll_2020 %>%
  mutate(incumbent = ifelse(candidate_name=="Donald Trump","yes","no"))

poll_2020 <- poll_2020 %>%
  filter(incumbent=="yes")
summary(poll_2020$days_left)

poll_2020_45days <- poll_2020 %>%
  filter(days_left <= 45) %>%
  select(state,modeldate,pct_estimate,pct_trend_adjusted,days_left)
poll_2020_short <- poll_2020 %>%
  filter(days_left <= 112) %>%
  select(state,modeldate,pct_estimate,pct_trend_adjusted,days_left)

poll_2020_45days <- poll_2020_45days %>%
  select(state,modeldate,pct_estimate) %>%
  spread(modeldate,pct_estimate)
poll_2020_45days <- poll_2020_45days %>%
  transmute(state,avg_poll_45d=rowMeans(select(.,-state)))

poll_2020_short <- poll_2020_short %>%
  select(state,modeldate,pct_estimate) %>%
  spread(modeldate,pct_estimate)
poll_2020_short <- poll_2020_short %>%
  transmute(state,avg_poll_short=rowMeans(select(.,-state)))

# 2020 economic data
gdp_st_qtrly  <- read_csv("SQINC1__ALL_AREAS_1948_2020.csv")

gdp_st_qtrly <- gdp_st_qtrly %>%
  filter(LineCode==1) %>%
  rename(state=GeoName)

gdp_st_qtrly <- gdp_st_qtrly[-c(1,53:60),] # remove non-states
gdp_st_qtrly$state <- as.character(gdp_st_qtrly$state)
gdp_st_qtrly <- gdp_st_qtrly[-c(2,12),] # remove AK, HI due to astericks

gdp_st_qtrly <- gdp_st_qtrly %>%
  left_join(all_safe_states_2col,by="state") %>%
  filter(is.na(safe))
unique(gdp_st_qtrly$state)

gdp_st_qtrly <- gdp_st_qtrly %>%
  gather(quarter,st_personal_inc,`1948:Q1`:`2020:Q2`)

gdp_st_qtrly <- gdp_st_qtrly %>%
  separate(quarter,c("year","qtr"),sep=":")

gdp_st_qtrly <- gdp_st_qtrly %>%
  select(state,year,qtr,st_personal_inc) %>%
  arrange(state)

gdp_st_qtrly <- gdp_st_qtrly %>%
  mutate(last_qtr_inc = lag(`st_personal_inc`)) %>%
  mutate(two_qtr_inc = lag(`st_personal_inc`,n=2L)) %>%
  mutate(three_qtr_inc = lag(`st_personal_inc`,n=3L))

gdp_st_qtrly$st_personal_inc <- as.numeric(gdp_st_qtrly$st_personal_inc)
gdp_st_qtrly$last_qtr_inc <- as.numeric(gdp_st_qtrly$last_qtr_inc)
gdp_st_qtrly$two_qtr_inc <- as.numeric(gdp_st_qtrly$two_qtr_inc)
gdp_st_qtrly$three_qtr_inc <- as.numeric(gdp_st_qtrly$three_qtr_inc)
gdp_st_qtrly <- gdp_st_qtrly %>%
  mutate(avg_delta_inc_2 = 100*
           (0.5*(st_personal_inc-last_qtr_inc)/(st_personal_inc) +
           0.5*(last_qtr_inc-two_qtr_inc)/(last_qtr_inc))) %>%
  mutate(avg_delta_inc_3 = 100*
           ((st_personal_inc-last_qtr_inc)/(3*st_personal_inc) +
            (last_qtr_inc-two_qtr_inc)/(3*last_qtr_inc)) +
            (two_qtr_inc-three_qtr_inc)/(3*two_qtr_inc))

econ_2020 <- gdp_st_qtrly %>%
  filter(year==2020 & qtr=="Q2") %>%
  select(state,avg_delta_inc_2,avg_delta_inc_3)

# merging the two 2020 datasets
poll_econ_2020a <- poll_2020_45days %>%
  left_join(econ_2020, by="state")

poll_econ_2020a[11,3] <- poll_econ_2020a[10,3]
poll_econ_2020a[12,3] <- poll_econ_2020a[10,3]
poll_econ_2020a[11,4] <- poll_econ_2020a[10,4]
poll_econ_2020a[12,4] <- poll_econ_2020a[10,4]
poll_econ_2020a[17,3] <- poll_econ_2020a[19,3]
poll_econ_2020a[17,4] <- poll_econ_2020a[19,3]
poll_econ_2020a[18,3] <- poll_econ_2020a[19,4]
poll_econ_2020a[18,4] <- poll_econ_2020a[19,4]
poll_econ_2020a <- poll_econ_2020a[-c(10),]
poll_econ_2020a <- poll_econ_2020a[-c(15),]
poll_econ_2020a <- poll_econ_2020a[-c(17),]
poll_econ_2020a <- poll_econ_2020a %>%
  rename(avg_poll = avg_poll_45d) %>%
  rename(avg_delta_inc = avg_delta_inc_2)
poll_econ_2020a$avg_poll <- as.numeric(poll_econ_2020a$avg_poll)
poll_econ_2020a$avg_delta_inc <- as.numeric(poll_econ_2020a$avg_delta_inc)

pred_grid_a <- data.frame(avg_poll = poll_econ_2020a$avg_poll,
                           avg_delta_inc = poll_econ_2020a$avg_delta_inc)
pred_grid_a$pred <- predict(lm_poll_econ_local_final,
                            new=pred_grid_a)
pred_grid_a_fit <- predict(lm_poll_econ_local_final, 
                            new=pred_grid_a, interval = "confidence")
pred_grid_a_fit <- data.frame(pred_grid_a_fit)
pred_grid_a_fit <- pred_grid_a_fit %>%
  rename(pred = fit)
pred_grid_a <- pred_grid_a %>%
  left_join(pred_grid_a_fit, by="pred")
poll_econ_2020a <- poll_econ_2020a %>%
  left_join(pred_grid_a, by=c("avg_poll","avg_delta_inc"))

summary(lm_poll_econ_local_final)
stargazer(lm_poll_econ_local_final, header=FALSE, no.space = TRUE,
          column.sep.width = "3pt", font.size = "scriptsize", single.row = TRUE,
          title = "Final Prediction Model (Economy and Polling)")

poll_econ_2020a <- poll_econ_2020a %>%
  left_join(ev_allocation, by="state")
poll_econ_2020a <- poll_econ_2020a %>%
  mutate(trump_ev = ifelse(pred>=50,ev_alloted,0)) %>%
  mutate(biden_ev = ifelse(trump_ev>0,0,ev_alloted))
sum(poll_econ_2020a$trump_ev,na.rm=T)
sum(poll_econ_2020a$biden_ev,na.rm=T)

poll_econ_2020a <- poll_econ_2020a %>%
  mutate(winner=ifelse(trump_ev>0,"R","D"))

final_map <- ev_allocation %>%
  left_join(all_safe_states, by=c("state","ev_alloted")) %>%
  select(state,ev_alloted,safe) %>%
  rename(winner = safe)
final_map <- final_map %>%
  left_join(poll_econ_2020a, by=c("state","ev_alloted"))
final_map <- final_map %>%
  mutate(ev_winner = ifelse(is.na(winner.x),winner.y,winner.x))

plot_usmap(data=final_map,regions="states",values="ev_winner",labels=TRUE)+
  scale_fill_manual(values = c("cornflowerblue","firebrick2"),
                    name="Party",
                    label=c("Democratic","Republican","N/A")) +
  theme_void() +
  labs(title = "2020 Election Prediction",
       subtitle = "Trump: 274 EVs, Biden: 255 EVs, Unalloted: 9 EVs",
       caption = "*Maine and Nebraska excluded due to unique systems of apportioning EVs.")
ggsave("final_prediction_map.png", height = 6, width = 12)

####----------------------------------------------------------#
#### In- and Out-of-Sample Model Validation ####
####----------------------------------------------------------#

# in sample
summary(lm_poll_econ_local_final)$r.squared
mse <- mean((lm_poll_econ_local_final$model$candidate_pv -
               lm_poll_econ_local_final$fitted.values)^2)
sqrt(mse)

# out of sample: leave-one-out (2016)
outsamp_mod <- lm(candidate_pv ~ avg_poll + avg_delta_inc,
                  poll_avg_st_plusecon_short[
                    poll_avg_st_plusecon_short$year!=2016,])
summary(outsamp_mod)
outsamp_pred <- predict(outsamp_mod, 
                        poll_avg_st_plusecon_short[
                        poll_avg_st_plusecon_short$year==2016,])
outsamp_true <- poll_avg_st_plusecon_short$candidate_pv[
                        poll_avg_st_plusecon_short$year==2016]
outsamp_resid <- outsamp_pred - outsamp_true
summary(outsamp_resid)

poll_avg_st_plusecon_short <- poll_avg_st_25_incumb_st %>%
  left_join(gdp_st_3qtrs_merge, by=c("year","party","state"))
lm_poll_st_econ_short <- lm(candidate_pv ~ avg_poll + avg_delta_inc, 
                            data=poll_avg_st_plusecon_short)
summary(lm_poll_st_econ_short) # substantially better R-squared, 0.8511

# out of sample: cross-validation
final_dataset <- poll_avg_st_plusecon_short
final_dataset_narm <- final_dataset %>%
  filter(!(is.na(st_personal_inc)))

outsamp_errors <- sapply(1:1000,function(i){
    years_outsamp <- sample(final_dataset_narm$year,6)
    outsamp_mod <- lm(candidate_pv ~ avg_poll + avg_delta_inc,
                    final_dataset_narm[!(final_dataset_narm$year %in% years_outsamp),])
    outsamp_pred <- predict(outsamp_mod,
                            newdata=final_dataset_narm[
                            final_dataset_narm$year %in% years_outsamp,])
    outsamp_true <- final_dataset_narm$candidate_pv[
                    final_dataset_narm$year %in% years_outsamp]
    mean(outsamp_pred - outsamp_true)
})

hist(outsamp_errors)
mean(abs(outsamp_errors))

####----------------------------------------------------------#
#### MSE with 2020 Data, as of Sunday, November 15, 2020 ####
####----------------------------------------------------------#

results <- read_csv("results2020.csv")
results$state <- results$`Geographic Name`
results$dem <- results$`Joseph R. Biden Jr.`
results$rep <- results$`Donald J. Trump`
results <- results %>%
  select(state,`Total Vote`,dem,rep)
final_predictions <- poll_econ_2020a %>%
  select(state,pred,lwr,upr,winner)
comparison <- final_predictions %>%
  left_join(results, by="state")

comparison$`Total Vote`<- as.numeric(comparison$`Total Vote`)
comparison$dem<- as.numeric(comparison$dem)
comparison$rep<- as.numeric(comparison$rep)

comparison <- comparison %>%
  mutate(act = 100*rep/(`Total Vote`)) %>%
  mutate(diff = pred-act) %>%
  mutate(diffsq = (diff)^2)

rmse <- sqrt(sum(comparison$diffsq,na.rm=T))
rmse

####----------------------------------------------------------#
#### statebins ####
####----------------------------------------------------------#
final_map[20,13]<-"Z"
final_map[28,13]<-"Z"
final_map %>%
  ggplot(aes(state=state,fill=ev_winner)) +
  geom_statebins() +
  scale_fill_manual(values = c("cornflowerblue","firebrick2","grey50"),
                    name="Party",
                    label=c("Democratic","Republican","Unalloted")) +
  theme_void() +
  labs(title = "2020 Election Prediction",
       subtitle = "Trump 274, Biden 255, Unalloted 9",
       caption = "*Maine and Nebraska excluded due to unique systems of apportioning EVs.")
ggsave("final_prediction_statebins.png", height = 4, width = 6)

####----------------------------------------------------------#
#### Reflection ####
####----------------------------------------------------------#
all_results_state <- read.csv("popvote_bystate_1948-2020.csv")
all_results_2020 <- all_results_state %>%
  filter(year==2020)

# visuals
comparison_map <- final_map %>%
  select(state,pred,ev_winner) %>%
  left_join(comparison, by=c("state","pred")) %>%
  rename(pred_winner=ev_winner) %>%
  select(state,pred,pred_winner,`Total Vote`,dem,rep,act,diff)

comparison_map <- comparison_map %>%
  left_join(all_results_2020,by="state")

comparison_map <- comparison_map %>%
  mutate(act_winner = ifelse(R_pv2p>0.5,"R","D")) %>%
  mutate(R_pv = 100*R/total) %>%
  select(state,pred,pred_winner,total,D,R,act_winner,R_pv) %>%
  mutate(diff=pred-R_pv)

comparison_map <- comparison_map %>%
  mutate(diff_all=ifelse(is.na(diff),"NA",diff))

comparison_map[20,10]<-"0"
comparison_map[28,10]<-"0"

comparison_map$diff_all <- as.numeric(comparison_map$diff_all)

comparison_map %>%
  ggplot(aes(state=state,fill=diff_all)) +
  geom_statebins() +
  scale_fill_gradient2(low="firebrick3",
                       mid="white",
                       high="royalblue3",
                       midpoint=0,
                       na.value="springgreen4",
                       name="Difference in Vote Share") +
  theme_void() +
  labs(title = "2020 Election - Prediction Model Accuracy",
       subtitle = "RMSE for 25 States: 1.749774\nGreen States: Accurate Outcome, No Numerical Prediction",
       caption = "*Maine and Nebraska excluded due to unique systems of apportioning EVs.") +
  theme(plot.subtitle=element_text(hjust=0))
ggsave("final_prediction_accuracy.png", height = 4, width = 6)

comparison_map %>%
  mutate(group=ifelse(diff<0,"R","D")) %>%
  ggplot(aes(diff,fill=group)) +
  geom_histogram() +
  scale_fill_manual(values=c("cornflowerblue","firebrick2")) +
  labs(title="Errors") +
  xlab("Percentage-Point Diff. in R Voteshare (Pred-Act)")
ggsave("final_prediction_residuals_color.png", height = 4, width = 6)

# numerical calculations
econ_2020b <- econ_2020 %>%
  mutate(year="2020") %>%
  select(state,avg_delta_inc_2,year) %>%
  rename(avg_delta_inc=avg_delta_inc_2)
econ_2020b$year <- as.character(econ_2020b$year)
gdp_st_3qtrs_merge$year <- as.character(gdp_st_3qtrs_merge$year)

all_econ_data <- gdp_st_3qtrs_merge %>%
  full_join(econ_2020b)

all_results_state <- all_results_state %>%
  left_join(gdp_st_3qtrs_merge, by=c("year","state"))
