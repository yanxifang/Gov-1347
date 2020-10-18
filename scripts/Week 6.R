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

#####------------------------------------------------------#
##### Read and merge data ####
#####------------------------------------------------------#

demogr_df   <- read_csv("demographic_1990-2018.csv")
turnout_df  <- read_csv("turnout_1980-2016.csv")
popvote_df  <- read_csv("popvote_bystate_1948-2016.csv")
fo_dems     <- read_csv("fieldoffice_2004-2012_dems.csv")
fo_2012     <- read_csv("fieldoffice_2012_bycounty.csv")
fo_2012_16  <- read_csv("fieldoffice_2012-2016_byaddress.csv")
evstate_df  <- read_csv("Electoral_College.csv")
popvote_df  <- read_csv("popvote_bystate_1948-2016.csv")

#####------------------------------------------------------#
##### Blog Content: Revisiting the Air War ####
#####------------------------------------------------------#

# merge and modify data: ads
ad_campaign <- read_csv("Data from Previous Weeks/ad_campaigns_2000-2012.csv")
ad_creative <- read_csv("Data from Previous Weeks/ad_creative_2000-2012.csv")
evstate_abbrev_df <- evstate_df %>%
  rename(state_full=state) %>%
  rename(state=state_abbrev)
ad_campaign <- ad_campaign %>%
  left_join(evstate_abbrev_df, by="state")
ad_campaign <- ad_campaign %>%
  rename(state_abbrev=state) %>%
  rename(state=state_full) %>%
  rename(year=cycle)
ad_campaign <- ad_campaign %>%
  left_join(popvote_df, by=c("state","year"))
ad_campaign_04 <- ad_campaign %>%
  filter(year==2004)
ad_campaign_08 <- ad_campaign %>%
  filter(year==2008)
ad_campaign_12 <- ad_campaign %>%
  filter(year==2012)

# 2012 campaign: ads
ad_2012_r <- ad_campaign_12 %>%
  filter(party == "republican") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost))
ad_2012_d <- ad_campaign_12 %>%
  filter(party == "democrat") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost))
pvstate_2012 <- popvote_df %>%
  filter(year==2012) %>%
  left_join(evstate_df,by="state")
ad_2012_r <- ad_2012_r %>%
  left_join(pvstate_2012,by="state")
ad_2012_d <- ad_2012_d %>%
  left_join(pvstate_2012,by="state")
ad_2012_r <- ad_2012_r %>%
  filter(state!="Missouri") %>% # an error with log cost in MO
  filter(state!="Total")        # total (across US) is not a state
ad_2012_r <- ad_2012_r %>%
  mutate(log_cost=log(total_cost))
ad_2012_d <- ad_2012_d %>%
  mutate(log_cost=log(total_cost))
summary(lm(R_pv2p ~ log_cost, data=ad_2012_r))
summary(lm(D_pv2p ~ log_cost, data=ad_2012_d))
  # terrible fits, with negative and near-zero R^2 values
  # perhaps because the cost includes pre-primary ads

# narrower approach, based on the limited nature of 2020 data
ad_2012_close <- ad_campaign_12 %>%
  filter(between(air_date,as.Date("2012-04-09"),as.Date("2012-11-06")))
  # April 9 is the first available date of 2020 data
  # November 6, 2012 was the date of the presidential election
ad_2012_close_r <- ad_2012_close %>%
  filter(party == "republican") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost)) %>%
  mutate(log_cost=log(total_cost))
ad_2012_close_d <- ad_2012_close %>%
  filter(party == "democrat") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost)) %>%
  mutate(log_cost=log(total_cost))
ad_2012_close_r <- ad_2012_close_r %>%
  left_join(pvstate_2012,by="state")
ad_2012_close_d <- ad_2012_close_d %>%
  left_join(pvstate_2012,by="state")
ad_2012_close_r <- ad_2012_close_r %>%
  filter(state!="Missouri") %>% # an error with log cost in MO
  filter(state!="Total")        # total (across US) is not a state
summary(lm(R_pv2p ~ log_cost, data=ad_2012_close_r))
summary(lm(D_pv2p ~ log_cost, data=ad_2012_close_d))
  # still terrible fits

# targeted approach, based on two facts
# 1. Obama was the incumbent, so all D ads can be counted
# 2. Romney only received enough delegates on May 29, 2012
# no need to re-do D regression; same as before
# new R regression below:
ad_2012_targ_r <- ad_campaign_12 %>%
  filter(party == "republican") %>%
  filter(between(air_date,as.Date("2012-05-29"),as.Date("2012-11-06"))) %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost)) %>%
  mutate(log_cost=log(total_cost))
ad_2012_targ_r <- ad_2012_targ_r %>%
  left_join(pvstate_2012,by="state")
ad_2012_targ_r <- ad_2012_targ_r %>%
  filter(state!="Missouri") %>% # an error with log cost in MO
  filter(state!="Total")        # total (across US) is not a state
summary(lm(R_pv2p ~ log_cost, data=ad_2012_targ_r))
  # unfortunately, still very little explanatory value

ad_2012_targ_r %>%
  ggplot(aes(x=log_cost,y=R_pv2p,label=state)) +
  geom_smooth(method="lm", formula = y ~ x, color="firebrick2") +
  geom_text(aes(label = state)) +
  xlab("Spending on Advertisements") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2012 Republican Advertising Spending") +
  theme_bw()
ad_2012_d %>%
  ggplot(aes(x=log_cost,y=D_pv2p,label=state)) +
  geom_smooth(method="lm", formula = y ~ x, color="cornflowerblue") +
  geom_text(aes(label = state)) +
  xlab("Spending on Advertisements") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2012 Democratic Advertising Spending") +
  theme_bw()


#####------------------------------------------------------#
##### Blog Content: The Ground Game ####
#####------------------------------------------------------#

# placement model
lm_obama_a <-  lm(obama12fo ~ romney12fo +
                  swing + core_rep + battle +
                  as.factor(state), fo_2012)
summary(lm_obama_a)
lm_romney_a <- lm(romney12fo ~ obama12fo +
                  swing + core_dem + battle +
                  as.factor(state), fo_2012)
summary(lm_romney_a)
stargazer(lm_obama_a, lm_romney_a, header=FALSE, type='html', no.space = TRUE,
          column.sep.width = "3pt", font.size = "scriptsize", single.row = TRUE,
          keep = c(1:6, 56:60), omit.table.layout = "sn",
          title = "Placement of Field Offices (2012)")

# mobilization/persuasion model
effect_vote <- lm(dempct_change ~ dummy_fo_change +
               battle + dummy_fo_change:battle + 
               as.factor(state) + as.factor(year), fo_dems)
summary(effect_vote)
effect_vote_b <- lm(dempct_change ~ dummy_fo_change +
                    battle + as.factor(year), fo_dems)
summary(effect_vote_b)
stargazer(effect_vote_b, header=FALSE, type='html', no.space = TRUE,
          column.sep.width = "3pt", font.size = "scriptsize", single.row = TRUE,
          keep = c(1:10), omit.table.layout = "sn",
          title = "Effects of Democratic Field Offices, 2004-2012")


#####------------------------------------------------------#
##### Blog Content: Demographic Model ####
#####------------------------------------------------------#

# "safe" states for Ds and Rs
# Democrats
safe_st_d <- popvote_df %>%
  filter(year>=1960) %>%
  select(state,year,D_pv2p) %>%
  spread(year,D_pv2p)
safe_st_d <- safe_st_d %>%
  rename(d_1960=2, d_1964=3, d_1968=4, d_1972=5, d_1976=6,
         d_1980=7, d_1984=8, d_1988=9, d_1992=10, d_1996=11,
         d_2000=12, d_2004=13, d_2008=14, d_2012=15, d_2016=16)
safe_st_d <- safe_st_d %>%
  mutate(safe_all=ifelse(
          d_1960>50 & d_1964>50 & d_1968>50 & d_1972>50 & d_1976>50 &
          d_1980>50 & d_1984>50 & d_1988>50 & d_1992>50 & d_1996>50 &
          d_2000>50 & d_2004>50 & d_2008>50 & d_2012>50 & d_2016>50,
          "Yes","No"))
table(safe_st_d$safe_all)
safe_st_d <- safe_st_d %>%
  mutate(safe_rec=ifelse(
          d_1980>50 & d_1984>50 & d_1988>50 & d_1992>50 & d_1996>50 &
          d_2000>50 & d_2004>50 & d_2008>50 & d_2012>50 & d_2016>50,
          "Yes","No"))
safe_st_d <- safe_st_d %>%
  mutate(safe_v_rec=ifelse(
          d_2000>50 & d_2004>50 & d_2008>50 & d_2012>50 & d_2016>50,
          "Yes","No"))

d_safe_states_20 <- safe_st_d %>%
  filter(safe_v_rec=="Yes")
unique(d_safe_states_20$state)

d_safe_states_40 <- safe_st_d %>%
  filter(safe_rec=="Yes")
unique(d_safe_states_40$state)
# safe D states/areas: DC, MN
# these can be excluded from the demographics analysis

# Republicans
safe_st_r <- popvote_df %>%
  filter(year>=1960) %>%
  select(state,year,R_pv2p) %>%
  spread(year,R_pv2p)
safe_st_r <- safe_st_r %>%
  rename(r_1960=2, r_1964=3, r_1968=4, r_1972=5, r_1976=6,
         r_1980=7, r_1984=8, r_1988=9, r_1992=10, r_1996=11,
         r_2000=12, r_2004=13, r_2008=14, r_2012=15, r_2016=16)
safe_st_r <- safe_st_r %>%
  mutate(safe_all=ifelse(
          r_1960>50 & r_1964>50 & r_1968>50 & r_1972>50 & r_1976>50 &
          r_1980>50 & r_1984>50 & r_1988>50 & r_1992>50 & r_1996>50 &
          r_2000>50 & r_2004>50 & r_2008>50 & r_2012>50 & r_2016>50,
          "Yes","No"))
table(safe_st_r$safe_all)
safe_st_r <- safe_st_r %>%
  mutate(safe_rec=ifelse(
          r_1980>50 & r_1984>50 & r_1988>50 & r_1992>50 & r_1996>50 &
          r_2000>50 & r_2004>50 & r_2008>50 & r_2012>50 & r_2016>50,
          "Yes","No"))
safe_st_r <- safe_st_r %>%
  mutate(safe_v_rec=ifelse(
          r_2000>50 & r_2004>50 & r_2008>50 & r_2012>50 & r_2016>50,
          "Yes","No"))

r_safe_states_20 <- safe_st_r %>%
  filter(safe_v_rec=="Yes")
unique(r_safe_states_20$state)

r_safe_states_40 <- safe_st_r %>%
  filter(safe_rec=="Yes")
unique(r_safe_states_40$state)
# safe R states: AL, AK, ID, KS, MS, NE, ND, OK, SC, SD, TX, UT, WY
# these can be excluded from the demographics analysis

# mapping the safe states
r_safety <- r_safe_states_40 %>%
  filter(safe_rec=="Yes") %>%
  select(state)
r_safety$safe="R"
safety_map <- evstate_df %>%
  left_join(r_safety,by="state")
safety_map[9,4]="D"
safety_map[24,4]="D"
states_map <- usmap::us_map()
plot_usmap(data=safety_map,regions="states",values="safe",
           labels=TRUE)+
  scale_fill_manual(values = c("cornflowerblue","firebrick2"),
                    name="Party",
                    label=c("Democratic","Republican","Neither")) +
  theme_void() +
  labs(title = "Safe States, 1980-2016",
       subtitle = "These states voted for the same party for all presidential elections during this period.")
ggsave("safe_states_historical.png", height = 4, width = 8)


# demographic data: merge and modify
evstate_df <- evstate_df %>%
  rename(state=state_full)
popvote_st_df <- popvote_df %>%
  left_join(evstate_df, by="state")
popvote_st_df <- popvote_st_df %>%
  rename(state_full=state) %>%
  rename(state=state_abbrev)
demogr_st_df <- demogr_df %>%
  right_join(popvote_st_df, by=c("year","state"))
demogr_st_df <- demogr_st_df %>%
  rename(total_popul=total.x) %>%
  rename(total_votes=total.y)
demogr_st_df <- demogr_st_df %>%
  mutate(winner=ifelse(R_pv2p>D_pv2p,"R","D")) %>%
  mutate(win_pv2p=ifelse(winner=="R",R_pv2p,D_pv2p))
demogr_st_df <- demogr_st_df %>%
  filter(year>=1992)
demogr_st_df <- demogr_st_df %>%
  filter(state!="AL" | state!="AK" | state!="ID" | state!="KS" |
         state!="MS" | state!="NE" | state!="ND" | state!="OK" |
         state!="SC" | state!="SD" | state!="TX" | state!="UT" |
         state!="WY" | state!="DC" | state!="MN")
demogr_R <- demogr_st_df %>%
  filter(winner=="R")
demogr_D <- demogr_st_df %>%
  filter(winner=="D")

# overall regressions: Democrats
lm_demogr_all_D <- lm(D_pv2p ~ Asian + Black + Hispanic + Indigenous +
                        Female + age20 + age3045 + age4565 + state,
                        data = demogr_st_df)
                # note the exclusion of three "dummy variables": White, Male, Age65
                # (these three were the last ones listed in their respective categories)
summary(lm_demogr_all_D)
        # none of the age coefficients are statistically significant
        # the race/ethnicity coefficients are also not stat. signif., except Indigenous
lm_demogr_gender_D <- lm(D_pv2p ~ Female + state, data = demogr_st_df)
summary(lm_demogr_gender_D)

# overall regressions: Republicans
lm_demogr_all_R <- lm(R_pv2p ~ Asian + Black + Hispanic + Indigenous +
                        Female + age20 + age3045 + age4565 + state,
                      data = demogr_st_df)
summary(lm_demogr_all_R)
        # none of the age coefficients are statistically significant
        # the race/ethnicity coefficients are also not stat. signif., except Indigenous
lm_demogr_gender_R <- lm(R_pv2p ~ Female + state, data = demogr_st_df)
summary(lm_demogr_gender_R)

# regress Democratic demographics
lm_demogr_D <- lm(win_pv2p ~ Asian + Black + Hispanic + Indigenous +
                    Female + age20 + age3045 + age4565 + state, data=demogr_D)
summary(lm_demogr_D)

# regress Republican demographics
lm_demogr_R <- lm(win_pv2p ~ Asian + Black + Hispanic + Indigenous +
                    Female + age20 + age3045 + age4565 + state, data=demogr_R)
summary(lm_demogr_R)

stargazer(lm_demogr_D, lm_demogr_R, header=FALSE, type='html', no.space = TRUE,
          column.sep.width = "3pt", font.size = "scriptsize", single.row = TRUE,
          keep = c(1:8, 44:50), omit.table.layout = "sn",
          title = "Demographics and Election Outcomes (1992-2016)")

# regress without state variable
lm_demogr_D_nostate <- lm(win_pv2p ~ Asian + Black + Hispanic + Indigenous +
                            Female + age20 + age3045 + age4565, data=demogr_D)
summary(lm_demogr_D_nostate)
lm_demogr_R_nostate <- lm(win_pv2p ~ Asian + Black + Hispanic + Indigenous +
                            Female + age20 + age3045 + age4565, data=demogr_R)
summary(lm_demogr_R_nostate)
stargazer(lm_demogr_D_nostate, lm_demogr_R_nostate, header=FALSE, type='html', no.space = TRUE,
          column.sep.width = "3pt", font.size = "scriptsize", single.row = TRUE,
          keep = c(1:20), omit.table.layout = "sn",
          title = "Demographics and Election Outcomes (1992-2016)")
