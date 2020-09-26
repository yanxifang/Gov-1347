#### Polling ####
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
#### Quantitatively describing the polls ####
#### - How do polls fluctuate across state, time, and year?
####----------------------------------------------------------#

poll_df <- read_csv("pollavg_1968-2016.csv")

####------- 2016 poll average across time ------ ####

poll_df %>%
  filter(year == 2016) %>%
  ggplot(aes(x = poll_date, y = avg_support, colour = party)) +
    geom_point(size = 1) +
    geom_line() +
    scale_x_date(date_labels = "%b, %Y") +
    scale_color_manual(values = c("blue","red"), name = "") +
    ylab("polling approval average on date") + xlab("") +
    theme_classic()

## DNC & RNC bump in 2016:

poll_df %>%
  filter(year == 2016) %>%
  ggplot(aes(x = poll_date, y = avg_support, colour = party)) +
    geom_rect(xmin=as.Date("2016-07-18"), xmax=as.Date("2016-07-21"), ymin=0, ymax=41, alpha=0.1, colour=NA, fill="grey") +
    annotate("text", x=as.Date("2016-07-15"), y=37.8, label="RNC", size=4) +
    geom_rect(xmin=as.Date("2016-07-25"), xmax=as.Date("2016-07-28"), ymin=42, ymax=100, alpha=0.1, colour=NA, fill="grey") +
    annotate("text", x=as.Date("2016-08-02"), y=47, label="DNC", size=4) +

    geom_point(size = 1) +
    geom_line() +

    scale_x_date(date_labels = "%b, %Y") +
    scale_color_manual(values = c("blue","red"), name = "") +
    ylab("polling approval average on date") + xlab("") +
    theme_classic()

## 'Game-changers' in 2016:

poll_df %>%
  filter(year == 2016) %>%
  ggplot(aes(x = poll_date, y = avg_support, colour = party)) +
    geom_rect(xmin=as.Date("2016-07-18"), xmax=as.Date("2016-07-21"), ymin=0, ymax=41, alpha=0.1, colour=NA, fill="grey") +
    annotate("text", x=as.Date("2016-07-15"), y=37.8, label="RNC", size=4) +
    geom_rect(xmin=as.Date("2016-07-25"), xmax=as.Date("2016-07-28"), ymin=42, ymax=100, alpha=0.1, colour=NA, fill="grey") +
    annotate("text", x=as.Date("2016-08-02"), y=47, label="DNC", size=4) +
  
    geom_point(size = 1) +
    geom_line() +
  
    geom_segment(x=as.Date("2016-04-19"), xend=as.Date("2016-04-19"),y=0,yend=41, lty=2, color="grey", alpha=0.4) +
    annotate("text", x=as.Date("2016-04-05"), y=38, label="Trump wins\nNY primary", size=3) +
    geom_segment(x=as.Date("2016-04-26"), xend=as.Date("2016-04-26"), y=0, yend=41, lty=2, color="grey", alpha=0.4) +
    annotate("text", x=as.Date("2016-05-02"), y=39, label="...and CT,DE,\nMD,PA,RI", size=3) +

    geom_segment(x=as.Date("2016-09-26"), xend=as.Date("2016-09-26"),y=43,yend=100, lty=2, color="grey", alpha=0.4) +
      annotate("text", x=as.Date("2016-09-26"), y=45.7, label="First debate\n'won' by Hillary", size=3) +
    geom_segment(x=as.Date("2016-10-06"), xend=as.Date("2016-10-06"),y=0,yend=40.2, lty=2, color="grey", alpha=0.4) +
      annotate("text", x=as.Date("2016-10-06"), y=39, label="Billy Bush tape", size=3) +
    geom_segment(x=as.Date("2016-10-28"), xend=as.Date("2016-10-28"),y=46,yend=100, lty=2, color="grey", alpha=0.4) +
        annotate("text", x=as.Date("2016-10-28"), y=48, label="Comey annonunces\ninvestigation\nof new emails", size=3) +
      scale_x_date(date_labels = "%b, %Y") +
    scale_color_manual(values = c("blue","red"), name = "") +
    ylab("polling approval average on date") + xlab("") +
    theme_classic()

## 'Game-changers' in 2016 that weren't poll-changers:

poll_df %>%
    filter(year == 2016) %>%
    ggplot(aes(x = poll_date, y = avg_support, colour = party)) +
    geom_rect(xmin=as.Date("2016-07-18"), xmax=as.Date("2016-07-21"), ymin=0, ymax=41, alpha=0.1, colour=NA, fill="grey") +
    annotate("text", x=as.Date("2016-07-15"), y=37.8, label="RNC", size=4) +
    geom_rect(xmin=as.Date("2016-07-25"), xmax=as.Date("2016-07-28"), ymin=42, ymax=100, alpha=0.1, colour=NA, fill="grey") +
    annotate("text", x=as.Date("2016-08-02"), y=47, label="DNC", size=4) +
    
    geom_point(size = 1) +
    geom_line() +
    
    geom_segment(x=as.Date("2016-04-19"), xend=as.Date("2016-04-19"),y=0,yend=41, lty=2, color="grey", alpha=0.4) +
    annotate("text", x=as.Date("2016-04-05"), y=38, label="Trump wins\nNY primary", size=3) +
    geom_segment(x=as.Date("2016-04-26"), xend=as.Date("2016-04-26"), y=0, yend=41, lty=2, color="grey", alpha=0.4) +
    annotate("text", x=as.Date("2016-05-02"), y=39, label="...and CT,DE,\nMD,PA,RI", size=3) +
    geom_segment(x=as.Date("2016-05-26"), xend=as.Date("2016-05-26"), y=0, yend=43.3, lty=2, color="grey", alpha=0.4) +
    annotate("text", x=as.Date("2016-05-26"), y=41, label="Trump secures\nnomination\n(?)", size=3) +
    geom_segment(x=as.Date("2016-07-05"), xend=as.Date("2016-07-05"),y=43.2,yend=100, lty=2, color="grey", alpha=0.4) +
    annotate("text", x=as.Date("2016-07-01"), y=45.7, label="Comey vindicates\nHillary's emails\n(?)", size=3) +
    geom_segment(x=as.Date("2016-09-26"), xend=as.Date("2016-09-26"),y=43,yend=100, lty=2, color="grey", alpha=0.4) +
    annotate("text", x=as.Date("2016-09-26"), y=45.7, label="First debate\n'won' by Hillary", size=3) +
    geom_segment(x=as.Date("2016-10-06"), xend=as.Date("2016-10-06"),y=0,yend=40.2, lty=2, color="grey", alpha=0.4) +
    annotate("text", x=as.Date("2016-10-06"), y=39, label="Billy Bush tape", size=3) +
    geom_segment(x=as.Date("2016-10-28"), xend=as.Date("2016-10-28"),y=46,yend=100, lty=2, color="grey", alpha=0.4) +
    annotate("text", x=as.Date("2016-10-28"), y=48, label="Comey annonunces\ninvestigation\nof new emails", size=3) +
    scale_x_date(date_labels = "%b, %Y") +
    scale_color_manual(values = c("blue","red"), name = "") +
    ylab("polling approval average on date") + xlab("") +
    theme_classic()

####------- 1988 poll average across time ------ ####

## 'Game-changers and bumps in the 1988 campaigns:

poll_df %>%
    filter(year == 1988) %>%
    ggplot(aes(x = poll_date, y = avg_support, colour = party)) +
    geom_rect(xmin=as.Date("1988-07-18"), xmax=as.Date("1988-07-21"), ymin=47, ymax=100, alpha=0.1, colour=NA, fill="grey") +
    annotate("text", x=as.Date("1988-07-17"), y=50, label="DNC", size=4) +
    geom_rect(xmin=as.Date("1988-08-15"), xmax=as.Date("1988-08-18"), ymin=0, ymax=44, alpha=0.1, colour=NA, fill="grey") +
    annotate("text", x=as.Date("1988-08-18"), y=40, label="RNC", size=4) +
    
    geom_point(size = 1) +
    geom_line() + 
    
    geom_segment(x=as.Date("1988-09-13"), xend=as.Date("1988-09-13"),y=49,yend=100, lty=2, color="grey", alpha=0.4) +
    annotate("text", x=as.Date("1988-09-13"), y=52, label="Tank gaffe\n(?)", size=4) +
    annotate("text", x=as.Date("1988-09-21"), y=57, label="Willie Horton ad\n(?)", size=4) +
    geom_segment(x=as.Date("1988-09-21"), xend=as.Date("1988-09-21"),y=49,yend=100, lty=2, color="grey", alpha=0.4) +
    annotate("text", x=as.Date("1988-10-15"), y=64, label="First debate\n(death\npenalty\ngaffe)", size=3) +
    geom_segment(x=as.Date("1988-10-15"), xend=as.Date("1988-10-15"),y=49,yend=100, lty=2, color="grey", alpha=0.4) +
    scale_x_date(date_labels = "%b, %Y") +
    scale_color_manual(values = c("blue","red"), name = "") +
    ylab("polling approval average on date") + xlab("") +
    theme_classic()

####----------------------------------------------------------#
#### Describing the relationship between polls and election outcomes ####
#### - How early can the polls predict election results?
####----------------------------------------------------------#

## Does the November poll predict the election?

popvote_df <- read_csv("popvote_1948-2016.csv")

pollnov_df <- poll_df %>%
  group_by(year, party) %>%
  top_n(1, poll_date)

pollnov_vote_margin_df <- pollnov_df %>%
  left_join(popvote_df, by = c("year"="year", "party"="party")) %>%
  group_by(year) %>% arrange(-winner) %>% 
  summarise(pv2p_margin=first(pv2p)-last(pv2p), 
            pv2p_winner=first(pv2p),
            poll_margin=first(avg_support)-last(avg_support))

# Correlation between November poll margin and two-party PV margin is:

cor(pollnov_vote_margin_df$pv2p_margin, pollnov_vote_margin_df$poll_margin) # 0.87

pollnov_vote_margin_df %>%
  ggplot(aes(x=poll_margin, y=pv2p_margin,
             label=year)) + 
    geom_text() +
    xlim(c(-5, 25)) + ylim(c(-5, 25)) +
    geom_abline(slope=1, lty=2) +
    geom_vline(xintercept=0, alpha=0.2) + 
    geom_hline(yintercept=0, alpha=0.2) +
    xlab("winner's polling margin in November") +
    ylab("winner's two-party voteshare margin") +
    theme_bw()

## What about the earliest polls at the start of the race?
# Does the January poll predict the election? Do we know the result by then?

polljan_vote_margin_df <- poll_df %>% 
  group_by(year, party) %>%
  top_n(-1, poll_date) %>% ## this is all that changes from the last codeblock
  left_join(popvote_df, by = c("year"="year", "party"="party")) %>%
  group_by(year) %>% arrange(-winner) %>% 
  summarise(pv2p_margin=first(pv2p)-last(pv2p), 
            pv2p_winner=first(pv2p),
            poll_margin=first(avg_support)-last(avg_support))

polljan_vote_margin_df %>%
  ggplot(aes(x=poll_margin, y=pv2p_margin, label=year)) + 
    geom_text() +
    xlim(c(-5, 40)) + ylim(c(-5, 40)) +
    geom_abline(slope=1, lty=2) +
    geom_vline(xintercept=0, alpha=0.2) + 
    geom_hline(yintercept=0, alpha=0.2) +
    xlab("winner's polling margin in January") +
    ylab("winner's two-party voteshare margin") +
    theme_bw()#

####----------------------------------------------------------#
#### Code for Blog Post ####
#### - Can be run independently
####----------------------------------------------------------#

## install via `install.packages("name")`
library(tidyverse)
library(ggplot2)
library(gridExtra)
library(lubridate)
library(usmap)

## read in data
poll_df <- read_csv("pollavg_1968-2016.csv")
poll_st_df <- read_csv("pollavg_bystate_1968-2016.csv")
poll_2016 <- read_csv("polls_2016.csv")
poll_2020 <- read_csv("polls_2020.csv")
popvote_df <- read_csv("popvote_1948-2016.csv")
popvote_st_df <- read_csv("popvote_bystate_1948-2016.csv")
poll_rtgs <- read_csv("pollster_ratings_538.csv")
ev_allocations <- read_csv("ev_allocations.csv")

#### Extension 1: Pollster Quality ####
## - Data from FiveThirtyEight
## - https://github.com/fivethirtyeight/data/tree/master/pollster-ratings

#rename column for merge
poll_rtgs$pollster <- poll_rtgs$Pollster
#merge FiveThirtyEight ratings with 2016 polls
poll_rtgs_2016 <- inner_join(poll_2016, poll_rtgs, by="pollster")
#rename column for merge
poll_rtgs_2016$year <- poll_rtgs_2016$cycle
#separate state and national level polls
poll_rtgs_2016_natl <- poll_rtgs_2016 %>%
  filter(state=="U.S.")
poll_rtgs_2016_st <- poll_rtgs_2016 %>%
  filter(!(state=="U.S."))

## national level poll quality
#find election outcome
popvote_2016 <- popvote_df %>%
  filter(year==2016) %>%
  select(year,candidate,pv)
print(popvote_2016)
#add election outcome to polling data
poll_rtgs_2016_natl$R_pv <- popvote_2016$pv[2]
poll_rtgs_2016_natl$D_pv <- popvote_2016$pv[1]
#residuals
poll_rtgs_2016_natl <- poll_rtgs_2016_natl %>%
  mutate(R_resid=R_pv-rawpoll_trump) %>%
  mutate(D_resid=D_pv-rawpoll_clinton)

#plot residuals by FiveThirtyEight grade
table(poll_rtgs_2016_natl$`538 Grade`)
grade_order <- ordered(poll_rtgs_2016_natl$`538 Grade`,
                       levels=c("A+","A","A-","A/B","B+","B",
                                "B-","B/C","C+","C","C/D","D-"))
d_resid_plot <- poll_rtgs_2016_natl %>%
  ggplot(aes(x=grade_order, y=D_resid)) + 
  geom_boxplot() +
  xlab("FiveThirtyEight Grade") +
  ylab("Democratic Residual") +
  ggtitle("Democratic") +
  geom_hline(yintercept=0.0001,lty=2,col="red") +
  theme_bw()
r_resid_plot <- poll_rtgs_2016_natl %>%
  ggplot(aes(x=grade_order, y=R_resid)) + 
  geom_boxplot() +
  xlab("FiveThirtyEight Grade") +
  ylab("Republican Residual") +
  ggtitle("Republican") +
  geom_hline(yintercept=0.0001,lty=2,col="red") +
  theme_bw()
limits <- c(-10,20)
breaks <- seq(limits[1],limits[2],by=5)
d_resid_common <- d_resid_plot +
  scale_y_continuous(limits=limits,breaks=breaks)
r_resid_common <- r_resid_plot +
  scale_y_continuous(limits=limits,breaks=breaks)
d_resid_common <- ggplot_gtable(ggplot_build(d_resid_common))
r_resid_common <- ggplot_gtable(ggplot_build(r_resid_common))
r_resid_common$heights <- d_resid_common$heights
grid.arrange(d_resid_common,r_resid_common,ncol=2)
ggsave("resid_twoparty.png",arrangeGrob(d_resid_common,r_resid_common,ncol=2),
       height=4,width=8)
  

#### Extension 2: State-Level Polls ####
#re-format and merge data
popvote_st_df$D_pv <- 100*popvote_st_df$D/popvote_st_df$total
popvote_st_df$R_pv <- 100*popvote_st_df$R/popvote_st_df$total
poll_st_all <- inner_join(poll_st_df, popvote_st_df, by=c("year","state"))
poll_st_all <- poll_st_all %>%
  mutate(candidate_pv = ifelse(party=="democrat",D_pv,R_pv))

##initial exploration: specific years
#2016 polls
poll_st_2016 <- poll_st_all %>%
  filter(year == 2016)
lm_poll_st_2016_1 <- lm(candidate_pv ~ avg_poll + state + days_left, data=poll_st_2016)
summary(lm_poll_st_2016_1) #not bad, but "days_left" is not statistically significant
lm_poll_st_2016_2 <- lm(candidate_pv ~ avg_poll + state, data=poll_st_2016)
summary(lm_poll_st_2016_2) #"days_left" seems not to matter at all!
lm_poll_st_2016_3 <- lm(candidate_pv ~ avg_poll + days_left, data=poll_st_2016)
summary(lm_poll_st_2016_3) #"days_left" not statistically significant, again
lm_poll_st_2016_4 <- lm(candidate_pv ~ avg_poll, data=poll_st_2016)
summary(lm_poll_st_2016_4) #perhaps no need to adjust for state, either

#1972 polls
poll_st_1972 <- poll_st_all %>%
  filter(year == 1972)
lm_poll_st_1972 <- lm(candidate_pv ~ avg_poll, data=poll_st_1972)
summary(lm_poll_st_1972) #not all 50 states are represented here

##more general exploration: entire dataset
#all polls and elections, 1972-2016
lm_poll_st_all_1 <- lm(candidate_pv ~ avg_poll, data=poll_st_all)
summary(lm_poll_st_all_1) #slightly worse R^2 value than 1972 and 2016 individually
lm_poll_st_all_2 <- lm(candidate_pv ~ avg_poll + state, data=poll_st_all)
summary(lm_poll_st_all_2) #not much improvement!
lm_poll_st_all_3 <- lm(candidate_pv ~ avg_poll + days_left, data=poll_st_all)
summary(lm_poll_st_all_3) #"days_left" has a statistically significant coefficient,
                          # but the coefficient is tiny/negligible at 0.0020706!
lm_poll_st_all_4 <- lm(candidate_pv ~ avg_poll + weeks_left,
                       data=poll_st_all) #alternative measure of proximity to election
summary(poll_st_all$weeks_left) #highest value of weeks_left is 51
summary(lm_poll_st_all_4) #the coefficient for the proximity measure is still very small
                          #with a max. of 51 weeks, +0.75 is the maximum impact of that variable
lm_poll_st_final <- lm(candidate_pv ~ avg_poll, data=poll_st_all) #final model for state
poll_st_all %>% #graph
  ggplot(aes(x=avg_poll, y=candidate_pv)) + 
  geom_point(aes(color = party)) +
  scale_color_manual(name="party",
                     values=c("cornflowerblue","firebrick2"),
                     labels=c("Democrat","Republican")) +
  geom_smooth(method="lm", color="black", size=1, formula = y ~ x) +
  geom_abline(slope=1,intercept=0,color="black",lty=2,size=0.75) +
  xlab("State-Level Poll Prediction") +
  ylab("Candidate's Received Vote Share") +
  ggtitle("State Poll Predictions vs. Actual Vote Share",
          subtitle="U.S. Presidential Elections, 1972-2016") +
  theme_bw()
ggsave("state_polls_by_party.png",height=4,width=8)

#by party
poll_st_rep <- poll_st_all %>%
  filter(party=="republican")
lm_poll_st_rep <- lm(candidate_pv ~ avg_poll, data=poll_st_rep)
summary(lm_poll_st_rep)
poll_st_dem <- poll_st_all %>%
  filter(party=="democrat")
lm_poll_st_dem <- lm(candidate_pv ~ avg_poll, data=poll_st_dem)
summary(lm_poll_st_dem)
#plot side by side
rep_plot <- poll_st_rep %>%
  ggplot(aes(x=avg_poll,y=candidate_pv)) +
  geom_point(color = "firebrick2") +
  geom_smooth(method="lm", color="black", size=1, formula = y ~ x) +
  geom_abline(slope=1,intercept=0,color="black",lty=2,size=1) +
  xlab("State-Level Poll Prediction") +
  ylab("Candidate's Received Vote Share") +
  ggtitle("Republican State Poll Predictions vs. Actual Vote Share",
          subtitle="U.S. Presidential Elections, 1972-2016") +
  theme_bw() +
  theme(plot.title=element_text(size=10),
        plot.subtitle=element_text(size=8))
dem_plot <- poll_st_dem %>%
  ggplot(aes(x=avg_poll,y=candidate_pv)) +
  geom_point(color = "cornflowerblue") +
  geom_smooth(method="lm", color="black", size=1, formula = y ~ x) +
  geom_abline(slope=1,intercept=0,color="black",lty=2,size=1) +
  xlab("State-Level Poll Prediction") +
  ylab("Candidate's Received Vote Share") +
  ggtitle("Democratic State Poll Predictions vs. Actual Vote Share",
          subtitle="U.S. Presidential Elections, 1972-2016") +
  theme_bw() +
  theme(plot.title=element_text(size=10),
        plot.subtitle=element_text(size=8))
limits <- c(0,80)
breaks <- seq(limits[1],limits[2],by=20)
d_stpoll_common <- dem_plot +
  scale_y_continuous(limits=limits,breaks=breaks)
r_stpoll_common <- rep_plot +
  scale_y_continuous(limits=limits,breaks=breaks)
d_stpoll_common <- ggplot_gtable(ggplot_build(d_stpoll_common))
r_stpoll_common <- ggplot_gtable(ggplot_build(r_stpoll_common))
r_stpoll_common$heights <- d_stpoll_common$heights
grid.arrange(d_stpoll_common,r_stpoll_common,ncol=2)
ggsave("state_poll_twoparty.png",arrangeGrob(d_stpoll_common,r_stpoll_common,ncol=2),
       height=4,width=8)

##specific exploration: measures of proximity to the election
#all state polls 1972-2016, separated based on proximity to election
summary(poll_st_all$days_left)
median(poll_st_all$days_left) #45 days is the cutoff
                              #half the polls are within 45 days
                              #other half: beyond 45 days
poll_st_farout <- poll_st_all %>%
  filter(days_left > 45)
poll_st_close <- poll_st_all %>%
  filter(days_left <= 45)
#regress: with and without the proximity variable
lm_poll_st_farout <- lm(candidate_pv ~ avg_poll, data=poll_st_farout)
summary(lm_poll_st_farout)
lm_poll_st_close <- lm(candidate_pv ~ avg_poll, data=poll_st_close)
summary(lm_poll_st_close) #much better R-squared value, use for plot
lm_poll_st_farout_2 <- lm(candidate_pv ~ avg_poll + weeks_left,
                          data=poll_st_farout)
summary(lm_poll_st_farout_2)
lm_poll_st_close_2 <- lm(candidate_pv ~ avg_poll + weeks_left,
                         data=poll_st_close)
summary(lm_poll_st_close_2) #the weeks_left variable doesn't seem to make much of an impact!
#plot: close-proximity state polls
poll_st_close %>% #graph
  ggplot(aes(x=avg_poll, y=candidate_pv)) + 
  geom_point(aes(color = party)) +
  scale_color_manual(name="party",
                     values=c("cornflowerblue","firebrick2"),
                     labels=c("Democrat","Republican")) +
  geom_smooth(method="lm", color="black", size=1, formula = y ~ x) +
  geom_abline(slope=1,intercept=0,color="black",lty=2,size=0.75) +
  xlab("State-Level Poll Prediction") +
  ylab("Candidate's Received Vote Share") +
  ggtitle("Close-Proximity State Poll Predictions vs. Actual Vote Share",
          subtitle="U.S. Presidential Elections, 1972-2016") +
  theme_bw()

##prediction for 2020
#convert dates into number of days until November 2020 election
poll_2020$election_date <- as.Date("11/3/2020","%m/%d/%Y")
poll_2020$date <- as.Date(poll_2020$modeldate,"%m/%d/%Y")
poll_2020$days_left <- as.numeric(difftime(poll_2020$election_date,
                                           poll_2020$date,units=c("days")))
summary(poll_2020$days_left)
summary(poll_st_all$days_left) #compare to historical data
#subset into 2 separate datasets
poll_2020_farout <- poll_2020 %>%
  filter(days_left > 169) #169 days is the median in the poll_2020 dataset
poll_2020_close <- poll_2020 %>%
  filter(days_left <= 169)
#group by state to find average
poll_2020_st_farout <- group_by(poll_2020_farout, state, candidate_name) %>%
  summarize(avg_poll=mean(pct_estimate))
poll_2020_st_close <- group_by(poll_2020_close, state, candidate_name) %>%
  summarize(avg_poll=mean(pct_estimate))
#understand a discrepancy
length(unique(poll_2020$state)) #only 42 states
length(unique(poll_2020_farout$state)) #39 states
length(unique(poll_2020_close$state)) #42 states
#create new columns
poll_2020_st_farout$prediction_2020 <-
  predict(lm_poll_st_farout,newdata=poll_2020_st_farout)
poll_2020_st_close$prediction_2020 <-
  predict(lm_poll_st_close,newdata=poll_2020_st_close)
#rename columns for merge
poll_2020_st_close <- poll_2020_st_close %>%
  mutate(close_pred = prediction_2020)
poll_2020_st_farout <- poll_2020_st_farout %>%
  mutate(far_pred = prediction_2020)
poll_2020_st_close <- poll_2020_st_close %>%
  mutate(close_poll = avg_poll) %>%
  select(state,candidate_name,close_pred,close_poll)
poll_2020_st_farout <- poll_2020_st_farout %>%
  mutate(far_poll = avg_poll) %>%
  select(state,candidate_name,far_pred,far_poll)
#merge
poll_2020_st_both <- poll_2020_st_farout %>%
  left_join(poll_2020_st_close,by=c("state","candidate_name"))
#calculate weights
#a bit unscientific: weights are based on the 
    #relative R-squared of the two regressions
close <- summary(lm_poll_st_close)$r.squared
farout <- summary(lm_poll_st_farout)$r.squared
close_wt <- close/(close+farout) #weight of the close polls
far_wt <- farout/(close+farout) #weight of the far-out polls
#apply weight
poll_2020_st_both <- poll_2020_st_both %>%
  mutate(pred = (close_wt)*(close_pred) +
           (far_wt)*(far_pred))
#convert from long to wide
poll_2020_st_wide <- poll_2020_st_both %>%
  select(state,candidate_name,pred) %>%
  spread(key=candidate_name,value=pred)
head(poll_2020_st_wide, 3) #check to ensure correct conversion
poll_2020_st_wide$winner <- ifelse(
  poll_2020_st_wide$`Donald Trump`>
  poll_2020_st_wide$`Joseph R. Biden Jr.`,
  "R","D")
#merge with dataset containing the number of electoral votes alloted to each state
#source: https://www.archives.gov/electoral-college/allocation
poll_2020_st_wide <- poll_2020_st_wide %>%
  right_join(ev_allocations,by="state")
#tally EVs won by each candidate
poll_2020_st_wide <- poll_2020_st_wide %>%
  mutate(d_ev = ifelse(winner=="D",ev_alloted,0)) %>%
  mutate(r_ev = ifelse(winner=="R",ev_alloted,0))
biden_ev <- sum(poll_2020_st_wide$d_ev,na.rm=T)
trump_ev <- sum(poll_2020_st_wide$r_ev,na.rm=T)
poll_2020_st_wide$d_ev[52]=biden_ev
poll_2020_st_wide$r_ev[52]=trump_ev
#map state-level victories
states_map <- usmap::us_map()
unique(states_map$abbr)
plot_usmap(data = poll_2020_st_wide, regions = "states", values = "winner",
           labels = TRUE) + 
  scale_fill_manual(values=c(`D`="cornflowerblue",
                             `R`="firebrick2",`NA`="white"),
                    labels=c("Biden (301 EV)","Trump (154 EV)","No Data (83 EV)")) +
  guides(fill=guide_legend(title="Predicted Winner")) +
  theme_void() +
  labs(title="2020 Presidential Election Predictions",
       subtitle="Based on State-Level Polling")
ggsave("poll_predicted_winner.png", height = 4, width = 8)
