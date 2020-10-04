#####------------------------------------------------------#
##### Week 4: Exploring and Understanding Incumbency
#####------------------------------------------------------#

library(tidyverse)
library(ggplot2)
library(gridExtra)

#####------------------------------------------------------#
##### Read data ####
#####------------------------------------------------------#

popvote_df       <- read_csv("popvote_1948-2016.csv")
pvstate_df       <- read_csv("popvote_bystate_1948-2016.csv")
popvote_state_df       <- read_csv("popvote_bystate_1948-2016.csv")
economy_df       <- read_csv("econ.csv")
approval_df      <- read_csv("approval_gallup_1941-2020.csv")
pollstate_df     <- read_csv("pollavg_bystate_1968-2016.csv")
fedgrants_df     <- read_csv("fedgrants_bystate_1988-2008.csv")
fedgrants_cty_df <- read_csv("fedgrants_bycounty_1988-2008.csv")
local_orig_df <- read_csv("local.csv")

#####------------------------------------------------------#
#####  Time-for-change model ####
#####------------------------------------------------------#

# time-for-change model
tfc_df <- popvote_df %>%
  filter(incumbent_party) %>%
  select(year, candidate, party, pv, pv2p, incumbent) %>%
  inner_join(
    approval_df %>% 
      group_by(year, president) %>% 
      slice(1) %>% 
      mutate(net_approve=approve-disapprove) %>%
      select(year, incumbent_pres=president, net_approve, poll_enddate),
    by="year"
  ) %>%
  inner_join(
    economy_df %>%
      filter(quarter == 2) %>%
      select(GDP_growth_qt, year),
    by="year"
  )
lm_tfc <- lm(pv2p ~ GDP_growth_qt+incumbent+net_approve, data=tfc_df)
summary(lm_tfc)

# visualize tfc model
tfc_plot1 <- tfc_df %>%
  ggplot(aes(x=GDP_growth_qt, y=pv2p, label=year)) + 
  geom_smooth(method="lm", formula = y ~ x) +
  geom_text(aes(label = year)) +
  geom_point(aes(color = party)) +
  scale_color_manual(name="party",
                     values=c("cornflowerblue","firebrick2"),
                     labels=c("D","R")) +
  xlab("2nd Quarter GDP Growth") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2Q GDP Growth") +
  theme_bw()
tfc_plot2 <- tfc_df %>%
  ggplot(aes(x=incumbent, y=pv2p, label=year)) + 
  geom_smooth(method="lm", formula = y ~ x) +
  geom_text(aes(label = year)) +
  geom_point(aes(color = party)) +
  scale_color_manual(name="party",
                     values=c("cornflowerblue","firebrick2"),
                     labels=c("D","R")) +
  xlab("Incumbent Status") +
  ylab("Share of 2-Party Vote") +
  ggtitle("Incumbency") +
  theme_bw()
tfc_plot3 <- tfc_df %>%
  ggplot(aes(x=net_approve, y=pv2p, label=year)) + 
  geom_smooth(method="lm", formula = y ~ x) +
  geom_text(aes(label = year)) +
  geom_point(aes(color = party)) +
  scale_color_manual(name="party",
                     values=c("cornflowerblue","firebrick2"),
                     labels=c("D","R")) +
  xlab("Net Approval Rating") +
  ylab("Share of 2-Party Vote") +
  ggtitle("Approval Rating") +
  theme_bw()
limits <- c(40,65)
breaks <- seq(limits[1],limits[2],by=5)
tfc_1_common <- tfc_plot1 +
  scale_y_continuous(limits=limits,breaks=breaks)
tfc_2_common <- tfc_plot2 +
  scale_y_continuous(limits=limits,breaks=breaks)
tfc_3_common <- tfc_plot3 +
  scale_y_continuous(limits=limits,breaks=breaks)
tfc_1_common <- ggplot_gtable(ggplot_build(tfc_1_common))
tfc_2_common <- ggplot_gtable(ggplot_build(tfc_2_common))
tfc_3_common <- ggplot_gtable(ggplot_build(tfc_3_common))
tfc_2_common$heights <- tfc_1_common$heights
tfc_3_common$heights <- tfc_1_common$heights
grid.arrange(tfc_plot1, tfc_plot2, tfc_plot3, nrow=1)
grid.arrange(tfc_1_common, tfc_2_common, tfc_3_common, nrow=1)
ggsave("timeforchange.png",
              arrangeGrob(tfc_1_common,tfc_2_common,tfc_3_common,ncol=3),
              height=4,width=12)

#####------------------------------------------------------#
#####  Revisiting the Economic Model from Week 2 ####
#####------------------------------------------------------#

# national-level: GDP
# merge data
econ_gdp2q <- popvote_df %>% 
  filter(incumbent_party == TRUE) %>%
  select(year, winner, pv2p) %>%
  left_join(economy_df %>% filter(quarter == 2))
# fit a model
lm_econ_gdp <- lm(pv2p ~ GDP_growth_qt, data = econ_gdp2q)
summary(lm_econ_gdp)
# scatterplot and line
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

# national-level: unemployment
# merge data
econ_ue2q <- popvote_df %>% 
  filter(incumbent_party == TRUE) %>%
  select(year, winner, pv2p) %>%
  left_join(economy_df %>% filter(quarter == 2))
# initial model fit
lm_econ_ue2q <- lm(pv2p ~ unemployment, data = econ_ue2q)
summary(lm_econ_ue2q)

# state-level: unemployment
# find out why there are more than 50 state codes
length(unique(local_orig_df$`FIPS Code`)) #there are 53, to be exact
unique(local_orig_df$`State and area`)
# remove New York City and Los Angeles areas
local_second_df <- filter(local_orig_df, `FIPS Code` !="037")
local_df <- filter(local_second_df, `FIPS Code` !="51000")
length(unique(local_df$`FIPS Code`))
unique(local_df$`State and area`) #now cleaned up, only 50 states plus DC
# prepare data for merge
# select election years only
local_df <- local_df %>% 
  mutate(year = Year) %>%
  filter(year == 1976 | year == 1980 | year == 1984 |
           year == 1988 | year == 1992 | year == 1996 |
           year == 2000 | year == 2004 | year == 2008 |
           year == 2012 | year == 2016 | year == 2020)
# 2020 data only available up to May
local_df <- local_df %>% 
  filter(Month <= "05") %>%
  mutate(state = `State and area`)
# remove extra/repeated columns
local_df <- local_df %>% 
  select(!`State and area`) %>%
  select(!(`Year`))
# sort by state
local_df <- local_df %>%
  arrange(state)
# calculate change in UE from Jan to May
local_df <- local_df %>%
  mutate(local_delta_ue = 
           `Unemployed_prce`-lag(`Unemployed_prce`,n=4L)) %>%
  filter(Month == "05")
# merge data
econ_local <- popvote_state_df %>%
  left_join(local_df)
econ_local <- popvote_df %>%
  filter(incumbent_party == TRUE & year >= 1976) %>%
  select(year, winner, party) %>%
  left_join(econ_local)
# modify data
econ_local <- econ_local %>%
  mutate(incumb_pv2p = ifelse(party == "republican", R_pv2p, D_pv2p))
# fit a model (revised for Week 4)
lm_econ_local <- lm(incumb_pv2p ~ local_delta_ue, data = econ_local)
summary(lm_econ_local)
lm_econ_local_b <- lm(incumb_pv2p ~ local_delta_ue + state,
                      data=econ_local)
summary(lm_econ_local_b) # terrible model
# further modifications (new for Week 4)
econ_local <- econ_local %>%
  mutate(quarter = 2)
economy_df <- economy_df %>%
  select(year,quarter,GDP_growth_qt,RDI_growth)
econ_local <- econ_local %>%
  left_join(economy_df, by=c("year","quarter"))
# fit a model (new for Week 4)
lm_econ_local_c <- lm(incumb_pv2p ~
                        local_delta_ue + GDP_growth_qt + state,
                      data=econ_local)
summary(lm_econ_local_c)
lm_econ_local_d <- lm(incumb_pv2p ~
                        local_delta_ue + RDI_growth + state,
                      data=econ_local)
summary(lm_econ_local_d)
lm_econ_local_e <- lm(incumb_pv2p ~
                        GDP_growth_qt + RDI_growth,
                      data=econ_local)
summary(lm_econ_local_e)
# these models are still terrible fits!