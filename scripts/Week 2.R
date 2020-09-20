#### Economy ####
#### Gov 1347: Election Analysis (2020)
#### TFs: Soubhik Barari, Sun Young Park

####----------------------------------------------------------#
#### Pre-amble ####
####----------------------------------------------------------#

## install via `install.packages("name")`
library(tidyverse)
library(ggplot2)

## set working directory here
setwd("~")

####----------------------------------------------------------#
#### The relationship between economy and PV ####
####----------------------------------------------------------#

economy_df <- read_csv("econ.csv") 
popvote_df <- read_csv("popvote_1948-2016.csv") 

dat <- popvote_df %>% 
  filter(incumbent_party == TRUE) %>%
  select(year, winner, pv2p) %>%
  left_join(economy_df %>% filter(quarter == 2))

## scatterplot + line
dat %>%
  ggplot(aes(x=GDP_growth_qt, y=pv2p,
             label=year)) + 
  geom_text() +
  geom_smooth(method="lm", formula = y ~ x) +
  geom_hline(yintercept=50, lty=2) +
  geom_vline(xintercept=0.01, lty=2) + # median
  xlab("Second quarter GDP growth") +
  ylab("Incumbent party's national popular voteshare") +
  theme_bw()

## fit a model
lm_econ <- lm(pv2p ~ GDP_growth_qt, data = dat)
summary(lm_econ)

dat %>%
  ggplot(aes(x=GDP_growth_qt, y=pv2p,
             label=year)) + 
    geom_text(size = 8) +
    geom_smooth(method="lm", formula = y ~ x) +
    geom_hline(yintercept=50, lty=2) +
    geom_vline(xintercept=0.01, lty=2) + # median
    xlab("Q2 GDP growth (X)") +
    ylab("Incumbent party PV (Y)") +
    theme_bw() +
    ggtitle("Y = 49.44 + 2.969 * X") + 
    theme(axis.text = element_text(size = 20),
          axis.title = element_text(size = 24),
          plot.title = element_text(size = 32))

## model fit 
summary(lm_econ)$r.squared
plot(dat$year, dat$pv2p, type="1",
     main="true Y (line), predicted Y (dot) for each year")
points(dat$year, predict(lm_econ, dat))
hist(lm_econ$model$pv2p - lm_econ$fitted.values,
     main="histogram of true Y - predicted Y")

## model testing: leave-one-out
outsamp_mod  <- lm(pv2p ~ GDP_growth_qt, dat[dat$year != 2016,])
outsamp_pred <- predict(outsamp_mod, dat[dat$year == 2016,])
outsamp_true <- dat$pv2p[dat$year == 2016] 

## model testing: cross-validation (one run)
years_outsamp <- sample(dat$year, 8)
mod <- lm(pv2p ~ GDP_growth_qt,
          dat[!(dat$year %in% years_outsamp),])
outsamp_pred <- predict(mod,
                        newdata = dat[dat$year %in% years_outsamp,])
mean(outsamp_pred - dat$pv2p[dat$year %in% years_outsamp])
  
## model testing: cross-validation (1000 runs)
outsamp_errors <- sapply(1:1000, function(i){
  years_outsamp <- sample(dat$year, 8)
  outsamp_mod <- lm(pv2p ~ GDP_growth_qt,
                    dat[!(dat$year %in% years_samp),])
  outsamp_pred <- predict(outsamp_mod,
                          newdata = dat[dat$year %in% years_outsamp,])
  outsamp_true <- dat$pv2p[dat$year %in% years_outsamp]
  mean(outsamp_pred - outsamp_true)
})

hist(outsamp_errors,
     xlab = "",
     main = "mean out-of-sample residual\n(1000 runs of cross-validation)")

## prediction for 2020
GDP_new <- economy_df %>%
    subset(year == 2020 & quarter == 2) %>%
    select(GDP_growth_qt)

predict(lm_econ, GDP_new)

#TODO: predict uncertainty
  
## extrapolation?
##   replication of: https://nyti.ms/3jWdfjp

economy_df %>%
  subset(quarter == 2 & !is.na(GDP_growth1)) %>%
  ggplot(aes(x=year, y=GDP_growth1,
             fill = (GDP_growth1 > 0))) +
  geom_col() +
  xlab("Year") +
  ylab("GDP Growth (Second Quarter)") +
  ggtitle("The percentage decrease in G.D.P. is by far the biggest on record.") +
  theme_bw() +
  theme(legend.position="none",
        plot.title = element_text(size = 12,
                                  hjust = 0.5,
                                  face="bold"))

####----------------------------------------------------------#
#### Code and graphics for the blog ####
#### Note: this can be run separately from everything above ####
####----------------------------------------------------------#

## install via `install.packages("name")`
library(tidyverse)
library(ggplot2)

## read data
economy_df <- read_csv("econ.csv") 
popvote_df <- read_csv("popvote_1948-2016.csv") 
local_orig_df <- read_csv("local.csv")
popvote_state_df <- read_csv("popvote_bystate_1948-2016.csv")

### gdp ###
## merge data
econ_gdp2q <- popvote_df %>% 
  filter(incumbent_party == TRUE) %>%
  select(year, winner, pv2p) %>%
  left_join(economy_df %>% filter(quarter == 2))

## fit a model
lm_econ_gdp <- lm(pv2p ~ GDP_growth_qt, data = econ_gdp2q)
summary(lm_econ_gdp)

## scatterplot and line
econ_gdp2q %>%
  ggplot(aes(x=GDP_growth_qt, y=pv2p,
             label=year)) + 
  geom_text(size=4) +
  geom_smooth(method="lm", formula = y ~ x) +
  geom_hline(yintercept=50, lty=2) +
  geom_vline(xintercept=0.0001, lty=2) + # median
  xlab("Second-Quarter GDP growth") +
  ylab("Incumbent Party Share of the 2-Party Nat'l Pop. Vote") +
  theme_bw() +
  ggtitle("Second-Quarter GDP Growth vs Nat'l Pop. Vote",
    subtitle="Y = 49.449 + 2.969 * X") +
  theme(axis.text = element_text(size = 8),
        axis.title = element_text(size = 10),
        plot.title = element_text(size = 16))
ggsave("PV_natl_gdp.png", height = 4, width = 8)

## model fit
summary(lm_econ_gdp)$r.squared

  #plot(econ_all$year, econ_all$pv2p, type="l",
     #main="true Y (line), predicted Y (dot) for each year")
  #points(dat$year, predict(lm_econ, dat))

hist(lm_econ_gdp$model$pv2p - lm_econ_gdp$fitted.values,
     main="Histogram of Residuals",
     xlab="Residual (true Y - predicted Y)")

## model testing
#leave-one-out validation
outsamp_gdp_mod <- lm(pv2p ~ GDP_growth_qt, 
                      econ_gdp2q[econ_gdp2q$year != 2016,])
outsamp_gdp_pred <- predict(outsamp_gdp_mod,
                            econ_gdp2q[econ_gdp2q$year == 2016,])
outsamp_gdp_true <- econ_gdp2q$pv2p[econ_gdp2q$year == 2016]
outsamp_gdp_pred - outsamp_gdp_true

#cross-validation
outsamp_gdp_errors <- sapply(1:1000, function(i){
    years_outsamp_gdp <- sample(econ_gdp2q$year, 8)
    outsamp_gdp_mod <- lm(pv2p ~ GDP_growth_qt,
                      econ_gdp2q[!(econ_gdp2q$year %in% years_outsamp_gdp),])
    outsamp_gdp_pred <- predict(outsamp_gdp_mod,
                            newdata = econ_gdp2q
                            [econ_gdp2q$year %in% years_outsamp_gdp,])
    outsamp_gdp_true <- econ_gdp2q$pv2p[econ_gdp2q$year %in% years_outsamp_gdp]
    mean(outsamp_gdp_pred - outsamp_gdp_true)
})
hist(outsamp_gdp_errors)
mean(abs(outsamp_gdp_errors))

## prediction
gdp_new <- economy_df %>%
  subset(year == 2020 & quarter == 2) %>%
  select(GDP_growth_qt)
predict(lm_econ_gdp, gdp_new)

### unemployment ###
## merge data
econ_ue2q <- popvote_df %>% 
  filter(incumbent_party == TRUE) %>%
  select(year, winner, pv2p) %>%
  left_join(economy_df %>% filter(quarter == 2))

## initial model fit
lm_econ_ue2q <- lm(pv2p ~ unemployment, data = econ_ue2q)
summary(lm_econ_ue2q) # a very poor fit!

## modify data: averaging the Q1 and Q2 unemployment rates
econ_ue_1q2q <- popvote_df %>% 
  filter(incumbent_party == TRUE) %>%
  select(year, winner, pv2p) %>%
  left_join(economy_df %>% filter(quarter <= 2))

econ_ue_1q2q <- econ_ue_1q2q %>%
  mutate(ave_ue = 0.5*(unemployment+lag(unemployment,n=1L)))

econ_ue_1q2q <- econ_ue_1q2q %>%
  filter(quarter == 2) # filter out inaccurate values in the Q1 rows

## second model fit
lm_econ_ue_ave <- lm(pv2p ~ ave_ue, data = econ_ue_1q2q)
summary(lm_econ_ue_ave) # not much better!

## modify data: new column for the change in UE between Q1 and Q2
econ_ue_1q2q <- popvote_df %>% 
  filter(incumbent_party == TRUE) %>%
  select(year, winner, pv2p) %>%
  left_join(economy_df %>% filter(quarter <= 2))

econ_ue_1q2q <- econ_ue_1q2q %>%
  mutate(delta_ue = unemployment-lag(unemployment,n=1L))

econ_ue_1q2q <- econ_ue_1q2q %>%
  filter(quarter == 2) # filter out inaccurate values in the Q1 rows

## second model fit
lm_econ_ue_delta <- lm(pv2p ~ delta_ue, data = econ_ue_1q2q)
summary(lm_econ_ue_delta) # still not very useful!

## scatterplot and line
econ_ue_1q2q %>%
  ggplot(aes(x=delta_ue, y=pv2p,
             label=year)) + 
  geom_text(size=4) +
  geom_smooth(method="lm", formula = y ~ x) +
  geom_hline(yintercept=50, lty=2) +
  geom_vline(xintercept=0.0001, lty=2) + # median
  xlab("Second-Quarter Change in Unemployment") +
  ylab("Incumbent Party Share of the 2-Party Nat'l Pop. Vote") +
  theme_bw() +
  ggtitle("Second-Quarter Change in Unemployment vs Nat'l Pop. Vote",
          subtitle = "Y = 52.023 - 8.733 * X") +
  theme(axis.text = element_text(size = 8),
        axis.title = element_text(size = 10),
        plot.title = element_text(size = 16))
ggsave("PV_natl_delta_ue.png", height = 4, width = 8)

## model fit
summary(lm_econ_ue_delta)$r.squared
#plot residuals
hist(lm_econ_ue_delta$model$pv2p - lm_econ_ue_delta$fitted.values,
     main="Histogram of Residuals",
     xlab="Residual (true Y - predicted Y)")

## model testing
#leave-one-out validation
outsamp_ue_mod <- lm(pv2p ~ delta_ue, 
                     econ_ue_1q2q[econ_ue_1q2q$year != 2016,])
outsamp_ue_pred <- predict(outsamp_ue_mod,
                           econ_ue_1q2q[econ_ue_1q2q$year == 2016,])
outsamp_ue_true <- econ_ue_1q2q$pv2p[econ_ue_1q2q$year == 2016]
outsamp_ue_pred - outsamp_ue_true

#cross-validation
outsamp_ue_errors <- sapply(1:1000, function(i){
  years_outsamp_ue <- sample(econ_ue_1q2q$year, 8)
  outsamp_ue_mod <- lm(pv2p ~ delta_ue,
                       econ_ue_1q2q[!(econ_ue_1q2q$year %in% years_outsamp_ue),])
  outsamp_ue_pred <- predict(outsamp_ue_mod,
                              newdata = 
                               econ_ue_1q2q[econ_ue_1q2q$year %in% years_outsamp_ue,])
  outsamp_ue_true <- econ_ue_1q2q$pv2p[econ_ue_1q2q$year %in% years_outsamp_ue]
  mean(outsamp_ue_pred - outsamp_ue_true)
})
hist(outsamp_ue_errors)
mean(abs(outsamp_ue_errors))

## prediction
ue_new <- economy_df %>%
  subset(year == 2020 & quarter <= 2) %>%
  select(unemployment, quarter)
ue_new <- ue_new %>%
  mutate(delta_ue = unemployment-lag(unemployment,n=1L))
ue_new <- ue_new %>%
  filter(quarter == 2) # filter out inaccurate values in the Q1 row
predict(lm_econ_ue_delta, ue_new) # not so useful!

### state-level data: unemployment analysis ###

## find out why there are more than 50 state codes
length(unique(local_orig_df$`FIPS Code`)) #there are 53, to be exact
unique(local_orig_df$`State and area`)
## remove New York City and Los Angeles areas
local_second_df <- filter(local_orig_df, `FIPS Code` !="037")
local_df <- filter(local_second_df, `FIPS Code` !="51000")
length(unique(local_df$`FIPS Code`))
unique(local_df$`State and area`) #now cleaned up, only 50 states plus DC

## prepare data for merge
local_df <- local_df %>% # select election years only
  mutate(year = Year) %>%
  filter(year == 1976 | year == 1980 | year == 1984 |
         year == 1988 | year == 1992 | year == 1996 |
         year == 2000 | year == 2004 | year == 2008 |
         year == 2012 | year == 2016 | year == 2020)

local_df <- local_df %>% # 2020 data only available up to May
  filter(Month <= "05") %>%
  mutate(state = `State and area`)

local_df <- local_df %>% # remove extra/repeated columns
  select(!`State and area`) %>%
  select(!(`Year`))

local_df <- local_df %>% # sort by state
  arrange(state)

local_df <- local_df %>% # calculate average ue across 5 months
  mutate(local_ave_ue = 0.2*
           ((`Unemployed_prce`)+lag(`Unemployed_prce`,n=1L)+
              lag(`Unemployed_prce`,n=2L)+
              lag(`Unemployed_prce`,n=3L)+
              lag(`Unemployed_prce`,n=4L))) %>%
  filter(Month == "05") # select only the accurate data

## merge data
econ_local <- popvote_state_df %>%
  left_join(local_df)
econ_local <- popvote_df %>%
  filter(incumbent_party == TRUE & year >= 1976) %>%
  select(year, winner, party) %>%
  left_join(econ_local)

## modify data
econ_local <- econ_local %>%
  mutate(incumb_pv2p = ifelse(party == "republican", R_pv2p, D_pv2p))

## fit a model
lm_econ_local <- lm(incumb_pv2p ~ local_ave_ue, data = econ_local)
summary(lm_econ_local)

## scatterplot and line
econ_local %>%
  ggplot(aes(x=local_ave_ue, y=incumb_pv2p)) + 
  geom_smooth(method="lm", formula = y ~ x) +
  geom_hline(yintercept=50, lty=2) +
  geom_vline(xintercept=0.0001, lty=2) + # median
  xlab("Average Unemployment Rate (Jan-May of Election Year)") +
  ylab("Incumbent Party Share of the 2-Party State Pop. Vote") +
  theme_bw() +
  ggtitle("Average Unemployment Rate vs State Pop. Vote",
          subtitle="Y = 48.395 + 0.361 * X") +
  theme(axis.text = element_text(size = 8),
        axis.title = element_text(size = 10),
        plot.title = element_text(size = 16))
ggsave("PV_loc_ue.png", height = 4, width = 8)

## model fit
summary(lm_econ_local)$r.squared #terrible fit!


