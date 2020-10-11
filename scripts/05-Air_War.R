#### Air War ####
#### Gov 1347: Election Analysis (2020)
#### TFs: Soubhik Barari, Sun Young Park

library(tidyverse)
library(ggplot2)
library(cowplot)  ## easier to customize grids of plots
library(scales)   ## more options for scales (e.g. formatting y axis to be $)
library(geofacet) ## map-shaped grid of ggplots

#####------------------------------------------------------#
##### Read and merge data ####
#####------------------------------------------------------#

pvstate_df   <- read_csv("popvote_bystate_1948-2016.csv")
ad_creative  <- read_csv("ad_creative_2000-2012.csv")
ad_campaigns <- read_csv("ad_campaigns_2000-2012.csv")

#####------------------------------------------------------#
##### Visualization gallery ####
#####------------------------------------------------------#

## Tone and Political Ads
ad_campaigns %>%
  left_join(ad_creative) %>%
  group_by(cycle, party) %>% mutate(tot_n=n()) %>% ungroup() %>%
  group_by(cycle, party, ad_tone) %>% summarise(pct=n()*100/first(tot_n)) %>%
  filter(!is.na(ad_tone)) %>%
  ggplot(aes(x = cycle, y = pct, fill = ad_tone, group = party)) +
  geom_bar(stat = "identity") +
  scale_x_continuous(breaks = seq(2000, 2012, 4)) +
  ggtitle("Campaign Ads Aired By Tone") +
  scale_fill_manual(values = c("red","orange","gray","darkgreen","white"), name = "tone") +
  xlab("") + ylab("%") +
  facet_wrap(~ party) + theme_minimal() +
  theme(axis.title = element_text(size=20),
        axis.text = element_text(size=15),
        strip.text.x = element_text(size = 20))

## The Purpose of Political Ads
ad_campaigns %>%
  left_join(ad_creative) %>%
  group_by(cycle, party) %>% mutate(tot_n=n()) %>% ungroup() %>%
  group_by(cycle, party, ad_purpose) %>% summarise(pct=n()*100/first(tot_n)) %>%
  filter(!is.na(ad_purpose)) %>%
  bind_rows( ##2016 raw data not public yet! This was entered manually
    data.frame(cycle = 2016, ad_purpose = "personal", party = "democrat", pct = 67),
    data.frame(cycle = 2016, ad_purpose = "policy", party = "democrat", pct = 12),
    data.frame(cycle = 2016, ad_purpose = "both", party = "democrat", pct = 21),
    data.frame(cycle = 2016, ad_purpose = "personal", party = "republican", pct = 11),
    data.frame(cycle = 2016, ad_purpose = "policy", party = "republican", pct = 71),
    data.frame(cycle = 2016, ad_purpose = "both", party = "republican", pct = 18)
  ) %>%
  ggplot(aes(x = cycle, y = pct, fill = ad_purpose, group = party)) +
  geom_bar(stat = "identity") +
  scale_x_continuous(breaks = seq(2000, 2016, 4)) +
  # ggtitle("Campaign Ads Aired By Purpose") +
  scale_fill_manual(values = c("grey","red","darkgreen","black","white"), name = "purpose") +
  xlab("") + ylab("%") +
  facet_wrap(~ party) + theme_minimal() +
  theme(axis.title = element_text(size=20),
        axis.text = element_text(size=15),
        strip.text.x = element_text(size = 20))


## The Elections and Their Issues
top_issues <- ad_campaigns %>% 
  left_join(ad_creative) %>%
  filter(!grepl("None|Other", ad_issue)) %>%
  group_by(cycle, ad_issue) %>% summarise(n=n()) %>% top_n(5, n)

### making each plot in a grid to have its own x-axis (issue name)
### is tricky with `facet_wrap`, so we use this package `cowplot`
### which allows us to take a list of separate plots and grid them together
plist <- lapply(c(2000,2004,2008,2012), function(c) {
  top_issues %>% filter(cycle == c) %>% 
    ggplot(aes(x = reorder(ad_issue, n), y = n)) +
    geom_bar(stat = "identity") + coord_flip() + theme_bw() +
    xlab("") + ylab("number ads aired") + ggtitle(paste("Top 5 Ad\nIssues in",c))
  
})
cowplot::plot_grid(plotlist = plist, nrow = 2, ncol = 2, align = "hv")


## Campaign Ads Aired By Issue and Party: 2000
party_issues2000 <- ad_campaigns %>%
  filter(cycle == 2000) %>%
  left_join(ad_creative) %>%
  filter(ad_issue != "None") %>%
  ## this `group_by` is to get our denominator
  group_by(ad_issue) %>% mutate(tot_n=n()) %>% ungroup() %>%
  ## this one is get numerator and calculate % by party
  group_by(ad_issue, party) %>% summarise(p_n=n()*100/first(tot_n)) %>% ungroup() %>%
  ## finally, this one so we can sort the issue names
  ## by D% of issue ad-share instead of alphabetically
  group_by(ad_issue) %>% mutate(Dp_n = ifelse(first(party) == "democrat", first(p_n), 0))

ggplot(party_issues2000, aes(x = reorder(ad_issue, Dp_n), y = p_n, fill = party)) + 
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("blue", "red")) +
  ylab("% of ads on topic from each party") + xlab("issue") + 
  # ggtitle("Campaign Ads Aired by Topic in 2000") +
  coord_flip() + 
  theme_bw()


## Campaign Ads Aired By Issue and Party: 2012
party_issues2012 <- ad_campaigns %>%
  filter(cycle == 2012) %>%
  left_join(ad_creative) %>%
  filter(ad_issue != "None") %>%
  group_by(cycle, ad_issue) %>% mutate(tot_n=n()) %>% ungroup() %>%
  group_by(cycle, ad_issue, party) %>% summarise(p_n=n()*100/first(tot_n)) %>% ungroup() %>%
  group_by(cycle, ad_issue) %>% mutate(Dp_n = ifelse(first(party) == "democrat", first(p_n), 0))

ggplot(party_issues2012, aes(x = reorder(ad_issue, Dp_n), y = p_n, fill = party)) + 
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("blue", "red")) +
  ylab("% of ads on topic from each party") + xlab("issue") +
  # ggtitle("Campaign Ads Aired by Topic in 2012") +
  coord_flip() + 
  theme_bw()


## When to Buy Ads? 
ad_campaigns %>%
  mutate(year = as.numeric(substr(air_date, 1, 4))) %>%
  mutate(month = as.numeric(substr(air_date, 6, 7))) %>%
  filter(year %in% c(2000, 2004, 2008, 2012), month > 7) %>%
  group_by(cycle, air_date, party) %>%
  summarise(total_cost = sum(total_cost)) %>%
  ggplot(aes(x=air_date, y=total_cost, color=party)) +
  # scale_x_date(date_labels = "%b, %Y") +
  scale_y_continuous(labels = dollar_format()) +
  scale_color_manual(values = c("blue","red"), name = "") +
  geom_line() + geom_point(size=0.5) +
  facet_wrap(cycle ~ ., scales="free") +
  xlab("") + ylab("ad spend") +
  theme_bw() +
  theme(axis.title = element_text(size=20),
        axis.text = element_text(size=11),
        strip.text.x = element_text(size = 20))


## Tone in Political Ads
ad_campaigns %>%
  left_join(ad_creative) %>%
  filter(ad_tone %in% c("attack", "promote")) %>%
  mutate(year = as.numeric(substr(air_date, 1, 4))) %>%
  mutate(month = as.numeric(substr(air_date, 6, 7))) %>%
  filter(year %in% c(2000, 2004, 2008, 2012), month > 7) %>%
  group_by(cycle, air_date, ad_tone) %>%
  summarise(total_cost = sum(n_stations)) %>%
  group_by(cycle, air_date) %>%
  mutate(total_cost = total_cost/sum(total_cost)) %>%
  ungroup() %>%
  ggplot(aes(x=air_date, y=total_cost, fill=ad_tone, color=ad_tone)) +
  # scale_x_date(date_labels = "%b") +
  scale_fill_manual(values = c("purple","green"), name = "ad tone") +
  scale_color_manual(values = c("purple","green"), name = "ad tone") +
  geom_bar(stat = "identity") +
  facet_wrap(cycle ~ ., scales="free") +
  xlab("") + ylab("% of ads bought on day") +
  theme_bw() +
  theme(axis.title = element_text(size=20),
        axis.text = element_text(size=10),
        strip.text.x = element_text(size = 20))


## The State-level Air War in 2008 (Obama vs. McCain)
ad_campaigns %>%
  mutate(year = as.numeric(substr(air_date, 1, 4))) %>%
  mutate(month = as.numeric(substr(air_date, 6, 7))) %>%
  mutate(state = state.name[match(state, state.abb)]) %>%
  filter(cycle == 2008) %>%
  left_join(pvstate_df %>% filter(year == 2008) %>% select(-year), by="state") %>%
  mutate(winner=ifelse(D_pv2p > R_pv2p, "democrat", "republican")) %>%
  group_by(cycle, state, air_date, party, winner) %>%
  summarise(total_cost = sum(total_cost)) %>%
  filter(!is.na(state)) %>%
  # ggplot(aes(x=air_date, y=log(total_cost+1), color=party)) +
  ggplot(aes(x=party, y=total_cost, fill=party)) +
  geom_bar(stat="identity") +
  geom_rect(aes(fill=winner), xmin=-Inf, xmax=Inf, ymin=46.3*10^6, ymax=52*10^6) +
  facet_geo(~ state, scales="free_x") +
  scale_fill_manual(values = c("blue", "red")) +
  scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6)) +
  xlab("") + ylab("ad spend") +
  theme_bw() +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

#####------------------------------------------------------#
##### Blog Content ####
#####------------------------------------------------------#

# load packages
library(tidyverse)
library(ggplot2)
library(cowplot)  ## easier to customize grids of plots
library(scales)   ## more options for scales (e.g. formatting y axis to be $)
library(geofacet) ## map-shaped grid of ggplots
library(gridExtra)

# read and merge data
pvstate_df   <- read_csv("popvote_bystate_1948-2016.csv")
ad_creative  <- read_csv("ad_creative_2000-2012.csv")
ad_campaigns <- read_csv("ad_campaigns_2000-2012.csv")
states_ev <- read_csv("Electoral_College.csv")
ad_all <- ad_creative %>%
  left_join(ad_campaigns, by=c("cycle","party","creative"))

# modify data
states_ev <- states_ev %>%
  rename(state = state_abbrev)
ad_all <- ad_all %>%
  left_join(states_ev, by="state")
pvstate_df <- pvstate_df %>%
  rename(state_full = state) %>%
  mutate(cycle = year)
ad_all <- ad_all %>%
  left_join(pvstate_df, by=c("cycle","state_full"))
ad_all <- ad_all %>%
  mutate(party_pv2p = ifelse(party=="democrat",D_pv2p,R_pv2p))
ad_2012 <- ad_all %>%
  filter(cycle==2012)
ad_2008 <- ad_all %>%
  filter(cycle==2008)
ad_2004 <- ad_all %>%
  filter(cycle==2004)
ad_2000 <- ad_all %>%
  filter(cycle==2000)

# graphics: ad campaign sizes
summary(ad_2012$total_cost)
ad_2012_a <- ad_2012 %>%
  filter(total_cost<100000) %>%
  ggplot(aes(total_cost,fill=party)) +
  geom_histogram() +
  scale_fill_manual(values=c("cornflowerblue","firebrick2")) +
  ggtitle("2012 Low Cost Ads (<$100,000)") +
  labs(x="Cost of Ad Campaign",y="Frequency")
ad_2012_b <- ad_2012 %>%
  filter(between(total_cost,100000,500000)) %>%
  ggplot(aes(total_cost,fill=party)) +
  geom_histogram() +
  scale_fill_manual(values=c("cornflowerblue","firebrick2")) +
  ggtitle("2012 Medium Cost Ads ($100K to $500K)") +
  labs(x="Cost of Ad Campaign",y="Frequency")
ad_2012_c <- ad_2012 %>%
  filter(total_cost>=1000000) %>%
  ggplot(aes(total_cost,fill=party)) +
  geom_histogram() +
  scale_fill_manual(values=c("cornflowerblue","firebrick2")) +
  ggtitle("2012 High Cost Ads (>$1,000,000)") +
  labs(x="Cost of Ad Campaign",y="Frequency")
grid.arrange(ad_2012_a,ad_2012_b,ad_2012_c,ncol=3)

ad_2008_a <- ad_2008 %>%
  filter(total_cost<100000) %>%
  ggplot(aes(total_cost,fill=party)) +
  geom_histogram() +
  scale_fill_manual(values=c("cornflowerblue","firebrick2")) +
  ggtitle("2008 Low Cost Ads (<$100,000)") +
  labs(x="Cost of Ad Campaign",y="Frequency")
ad_2008_b <- ad_2008 %>%
  filter(between(total_cost,100000,500000)) %>%
  ggplot(aes(total_cost,fill=party)) +
  geom_histogram() +
  scale_fill_manual(values=c("cornflowerblue","firebrick2")) +
  ggtitle("2008 Medium Cost Ads ($100K to $500K)") +
  labs(x="Cost of Ad Campaign",y="Frequency")
ad_2008_c <- ad_2008 %>%
  filter(total_cost>=1000000) %>%
  ggplot(aes(total_cost,fill=party)) +
  geom_histogram() +
  scale_fill_manual(values=c("cornflowerblue","firebrick2")) +
  ggtitle("2008 High Cost Ads (>$1,000,000)") +
  labs(x="Cost of Ad Campaign",y="Frequency")
grid.arrange(ad_2008_a,ad_2008_b,ad_2008_c,ncol=3)

ad_2004_a <- ad_2004 %>%
  filter(total_cost<100000) %>%
  ggplot(aes(total_cost,fill=party)) +
  geom_histogram() +
  scale_fill_manual(values=c("cornflowerblue","firebrick2")) +
  ggtitle("2004 Low Cost Ads (<$100,000)") +
  labs(x="Cost of Ad Campaign",y="Frequency")
ad_2004_b <- ad_2004 %>%
  filter(between(total_cost,100000,500000)) %>%
  ggplot(aes(total_cost,fill=party)) +
  geom_histogram() +
  scale_fill_manual(values=c("cornflowerblue","firebrick2")) +
  ggtitle("2004 Medium Cost Ads ($100K to $500K)") +
  labs(x="Cost of Ad Campaign",y="Frequency")
grid.arrange(ad_2004_a,ad_2004_b,ncol=2)

ad_2000_a <- ad_2000 %>%
  filter(total_cost<100000) %>%
  ggplot(aes(total_cost,fill=party)) +
  geom_histogram() +
  scale_fill_manual(values=c("cornflowerblue","firebrick2")) +
  ggtitle("2000 Low Cost Ads (<$100,000)") +
  labs(x="Cost of Ad Campaign",y="Frequency")
ad_2000_b <- ad_2000 %>%
  filter(between(total_cost,100000,500000)) %>%
  ggplot(aes(total_cost,fill=party)) +
  geom_histogram() +
  scale_fill_manual(values=c("cornflowerblue","firebrick2")) +
  ggtitle("2000 Medium Cost Ads ($100K to $500K)") +
  labs(x="Cost of Ad Campaign",y="Frequency")
grid.arrange(ad_2000_a,ad_2000_b,ncol=2)

grid.arrange(ad_2012_a,ad_2012_b,ad_2012_c,
             ad_2008_a,ad_2008_b,ad_2008_c,ncol=3)
ggsave("ad_campaign_size_2008_2012.png",
       arrangeGrob(ad_2012_a,ad_2012_b,ad_2012_c,
                   ad_2008_a,ad_2008_b,ad_2008_c,ncol=3),
       height=8,width=12)
grid.arrange(ad_2004_a,ad_2004_b,ad_2000_a,ad_2000_b,ncol=2)
ggsave("ad_campaign_size_2000_2004.png",
       arrangeGrob(ad_2004_a,ad_2004_b,ad_2000_a,ad_2000_b,ncol=2),
       height=8,width=8)

# a relationship between ad spending and pv2p?
# 2008 regression
ad_2008_early <- ad_2008 %>%
  filter(between(air_date,as.Date("2008-04-09"),as.Date("2008-09-27"))) %>%
  select(state,party,party_pv2p,total_cost)
ad_2008_early_r <- ad_2008_early %>%
  filter(party == "republican") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost))
ad_2008_early_d <- ad_2008_early %>%
  filter(party == "democrat") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost))

ad_2008_late <- ad_2008 %>%
  filter(between(air_date,as.Date("2008-09-05"),as.Date("2008-09-27")))
ad_2008_late_r <- ad_2008_late %>%
  filter(party == "republican") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost))
ad_2008_late_d <- ad_2008_late %>%
  filter(party == "democrat") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost))

pvstate_2008 <- pvstate_df %>%
  filter(year==2008) %>%
  left_join(states_ev,by="state_full")

ad_2008_early_r <- ad_2008_early_r %>%
  left_join(pvstate_2008,by="state") %>%
  mutate(early_cost = total_cost)
ad_2008_late_r <- ad_2008_late_r %>%
  left_join(pvstate_2008,by="state") %>%
  mutate(late_cost = total_cost)
ad_2008_early_r <- ad_2008_early_r %>%
  select(state,year,early_cost,R_pv2p)
ad_2008_late_r <- ad_2008_late_r %>%
  select(state,year,late_cost,R_pv2p)
ad_2008_overall_r <- ad_2008_early_r %>%
  left_join(ad_2008_late_r, by=c("state","year")) %>%
  mutate(adjusted_cost = ifelse(is.na(late_cost),early_cost,
                                0.5*(early_cost+late_cost)))
summary(lm(R_pv2p.x ~ adjusted_cost, data=ad_2008_overall_r))
r_2008_overall <- ad_2008_overall_r %>%
  ggplot(aes(x=adjusted_cost,y=R_pv2p.x,label=state)) +
  geom_smooth(method="lm", formula = y ~ x, color="firebrick2") +
  geom_text(aes(label = state)) +
  xlab("Adjusted Spending on Advertising") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2008 Republican Advertising Spending (OVERALL)") +
  theme_bw()
summary(lm(R_pv2p.x ~ late_cost, data=ad_2008_overall_r))
r_2008_late <- ad_2008_overall_r %>%
  ggplot(aes(x=late_cost,y=R_pv2p.x,label=state)) +
  geom_smooth(method="lm", formula = y ~ x, color="firebrick2") +
  geom_text(aes(label = state)) +
  xlab("Spending on Late Advertising") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2008 Republican Advertising Spending (LATE)") +
  theme_bw()

ad_2008_early_d <- ad_2008_early_d %>%
  left_join(pvstate_2008,by="state") %>%
  mutate(early_cost = total_cost)
ad_2008_late_d <- ad_2008_late_d %>%
  left_join(pvstate_2008,by="state") %>%
  mutate(late_cost = total_cost)
ad_2008_early_d <- ad_2008_early_d %>%
  select(state,year,early_cost,D_pv2p)
ad_2008_late_d <- ad_2008_late_d %>%
  select(state,year,late_cost,D_pv2p)
ad_2008_overall_d <- ad_2008_early_d %>%
  left_join(ad_2008_late_d, by=c("state","year")) %>%
  mutate(adjusted_cost = ifelse(is.na(late_cost),early_cost,
                                0.5*(early_cost+late_cost)))
summary(lm(D_pv2p.x ~ adjusted_cost, data=ad_2008_overall_d))
d_2008_overall <- ad_2008_overall_d %>%
  ggplot(aes(x=adjusted_cost,y=D_pv2p.x,label=state)) +
  geom_smooth(method="lm", formula = y ~ x, color="cornflowerblue") +
  geom_text(aes(label = state)) +
  xlab("Adjusted Spending on Advertising") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2008 Democratic Advertising Spending (OVERALL)") +
  theme_bw()
summary(lm(D_pv2p.x ~ late_cost, data=ad_2008_overall_d))
d_2008_late <- ad_2008_overall_d %>%
  ggplot(aes(x=late_cost,y=D_pv2p.x,label=state)) +
  geom_smooth(method="lm", formula = y ~ x, color="cornflowerblue") +
  geom_text(aes(label = state)) +
  xlab("Spending on Late Advertising") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2008 Democratic Advertising Spending (LATE)") +
  theme_bw()
limits <- c(35,65)
breaks <- seq(limits[1],limits[2],by=5)
r_2008_1_common <- r_2008_overall +
  scale_y_continuous(limits=limits,breaks=breaks)
r_2008_2_common <- r_2008_late +
  scale_y_continuous(limits=limits,breaks=breaks)
d_2008_1_common <- d_2008_overall +
  scale_y_continuous(limits=limits,breaks=breaks)
d_2008_2_common <- d_2008_late +
  scale_y_continuous(limits=limits,breaks=breaks)
r_2008_1_common <- ggplot_gtable(ggplot_build(r_2008_1_common))
r_2008_2_common <- ggplot_gtable(ggplot_build(r_2008_2_common))
d_2008_1_common <- ggplot_gtable(ggplot_build(d_2008_1_common))
d_2008_2_common <- ggplot_gtable(ggplot_build(d_2008_2_common))
r_2008_2_common$heights <- r_2008_1_common$heights
d_2008_1_common$heights <- r_2008_1_common$heights
d_2008_2_common$heights <- r_2008_1_common$heights
grid.arrange(r_2008_1_common, r_2008_2_common,
             d_2008_1_common, d_2008_2_common, ncol=2)
ggsave("ads_pv2p_2008.png",
       arrangeGrob(r_2008_1_common, r_2008_2_common,
                   d_2008_1_common, d_2008_2_common, ncol=2),
       height=8,width=12)

# 2012 regression
ad_2012_early <- ad_2012 %>%
  filter(between(air_date,as.Date("2012-04-09"),as.Date("2012-09-27"))) %>%
  select(state,party,party_pv2p,total_cost)
ad_2012_early_r <- ad_2012_early %>%
  filter(party == "republican") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost))
ad_2012_early_d <- ad_2012_early %>%
  filter(party == "democrat") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost))

ad_2012_late <- ad_2012 %>%
  filter(between(air_date,as.Date("2012-09-05"),as.Date("2012-09-27")))
ad_2012_late_r <- ad_2012_late %>%
  filter(party == "republican") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost))
ad_2012_late_d <- ad_2012_late %>%
  filter(party == "democrat") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost))

pvstate_2012 <- pvstate_df %>%
  filter(year==2012) %>%
  left_join(states_ev,by="state_full")

ad_2012_early_r <- ad_2012_early_r %>%
  left_join(pvstate_2012,by="state") %>%
  mutate(early_cost = total_cost)
ad_2012_late_r <- ad_2012_late_r %>%
  left_join(pvstate_2012,by="state") %>%
  mutate(late_cost = total_cost)
ad_2012_early_r <- ad_2012_early_r %>%
  select(state,year,early_cost,R_pv2p)
ad_2012_late_r <- ad_2012_late_r %>%
  select(state,year,late_cost,R_pv2p)
ad_2012_overall_r <- ad_2012_early_r %>%
  left_join(ad_2012_late_r, by=c("state","year")) %>%
  mutate(adjusted_cost = ifelse(is.na(late_cost),early_cost,
                                0.5*(early_cost+late_cost)))
summary(lm(R_pv2p.x ~ adjusted_cost, data=ad_2012_overall_r))
r_2012_overall <- ad_2012_overall_r %>%
  ggplot(aes(x=adjusted_cost,y=R_pv2p.x,label=state)) +
  geom_smooth(method="lm", formula = y ~ x, color="firebrick2") +
  geom_text(aes(label = state)) +
  xlab("Adjusted Spending on Advertising") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2012 Republican Advertising Spending (OVERALL)") +
  theme_bw()
summary(lm(R_pv2p.x ~ late_cost, data=ad_2012_overall_r))
r_2012_late <- ad_2012_overall_r %>%
  ggplot(aes(x=late_cost,y=R_pv2p.x,label=state)) +
  geom_smooth(method="lm", formula = y ~ x, color="firebrick2") +
  geom_text(aes(label = state)) +
  xlab("Spending on Late Advertising") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2012 Republican Advertising Spending (LATE)") +
  theme_bw()

ad_2012_early_d <- ad_2012_early_d %>%
  left_join(pvstate_2012,by="state") %>%
  mutate(early_cost = total_cost)
ad_2012_late_d <- ad_2012_late_d %>%
  left_join(pvstate_2012,by="state") %>%
  mutate(late_cost = total_cost)
ad_2012_early_d <- ad_2012_early_d %>%
  select(state,year,early_cost,D_pv2p)
ad_2012_late_d <- ad_2012_late_d %>%
  select(state,year,late_cost,D_pv2p)
ad_2012_overall_d <- ad_2012_early_d %>%
  left_join(ad_2012_late_d, by=c("state","year")) %>%
  mutate(adjusted_cost = ifelse(is.na(late_cost),early_cost,
                                0.5*(early_cost+late_cost)))
summary(lm(D_pv2p.x ~ adjusted_cost, data=ad_2012_overall_d))
d_2012_overall <- ad_2012_overall_d %>%
  ggplot(aes(x=adjusted_cost,y=D_pv2p.x,label=state)) +
  geom_smooth(method="lm", formula = y ~ x, color="cornflowerblue") +
  geom_text(aes(label = state)) +
  xlab("Adjusted Spending on Advertising") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2012 Democratic Advertising Spending (OVERALL)") +
  theme_bw()
summary(lm(D_pv2p.x ~ late_cost, data=ad_2012_overall_d))
d_2012_late <- ad_2012_overall_d %>%
  ggplot(aes(x=late_cost,y=D_pv2p.x,label=state)) +
  geom_smooth(method="lm", formula = y ~ x, color="cornflowerblue") +
  geom_text(aes(label = state)) +
  xlab("Spending on Late Advertising") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2012 Democratic Advertising Spending (LATE)") +
  theme_bw()
limits <- c(35,65)
breaks <- seq(limits[1],limits[2],by=5)
r_2012_1_common <- r_2012_overall +
  scale_y_continuous(limits=limits,breaks=breaks)
r_2012_2_common <- r_2012_late +
  scale_y_continuous(limits=limits,breaks=breaks)
d_2012_1_common <- d_2012_overall +
  scale_y_continuous(limits=limits,breaks=breaks)
d_2012_2_common <- d_2012_late +
  scale_y_continuous(limits=limits,breaks=breaks)
r_2012_1_common <- ggplot_gtable(ggplot_build(r_2012_1_common))
r_2012_2_common <- ggplot_gtable(ggplot_build(r_2012_2_common))
d_2012_1_common <- ggplot_gtable(ggplot_build(d_2012_1_common))
d_2012_2_common <- ggplot_gtable(ggplot_build(d_2012_2_common))
r_2012_2_common$heights <- r_2012_1_common$heights
d_2012_1_common$heights <- r_2012_1_common$heights
d_2012_2_common$heights <- r_2012_1_common$heights
grid.arrange(r_2012_1_common, r_2012_2_common,
             d_2012_1_common, d_2012_2_common, ncol=2)
ggsave("ads_pv2p_2012.png",
       arrangeGrob(r_2012_1_common, r_2012_2_common,
                   d_2012_1_common, d_2012_2_common, ncol=2),
       height=8,width=12)

# 2004 regression
ad_2004_early <- ad_2004 %>%
  filter(between(air_date,as.Date("2004-04-09"),as.Date("2004-09-27"))) %>%
  select(state,party,party_pv2p,total_cost)
ad_2004_early_r <- ad_2004_early %>%
  filter(party == "republican") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost))
ad_2004_early_d <- ad_2004_early %>%
  filter(party == "democrat") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost))

ad_2004_late <- ad_2004 %>%
  filter(between(air_date,as.Date("2004-09-05"),as.Date("2004-09-27")))
ad_2004_late_r <- ad_2004_late %>%
  filter(party == "republican") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost))
ad_2004_late_d <- ad_2004_late %>%
  filter(party == "democrat") %>%
  group_by(state) %>%
  summarize(total_cost = sum(total_cost))

pvstate_2004 <- pvstate_df %>%
  filter(year==2004) %>%
  left_join(states_ev,by="state_full")

ad_2004_early_r <- ad_2004_early_r %>%
  left_join(pvstate_2004,by="state") %>%
  mutate(early_cost = total_cost)
ad_2004_late_r <- ad_2004_late_r %>%
  left_join(pvstate_2004,by="state") %>%
  mutate(late_cost = total_cost)
ad_2004_early_r <- ad_2004_early_r %>%
  select(state,year,early_cost,R_pv2p)
ad_2004_late_r <- ad_2004_late_r %>%
  select(state,year,late_cost,R_pv2p)
ad_2004_overall_r <- ad_2004_early_r %>%
  left_join(ad_2004_late_r, by=c("state","year")) %>%
  mutate(adjusted_cost = ifelse(is.na(late_cost),early_cost,
                                0.5*(early_cost+late_cost)))
summary(lm(R_pv2p.x ~ adjusted_cost, data=ad_2004_overall_r))
r_2004_overall <- ad_2004_overall_r %>%
  ggplot(aes(x=adjusted_cost,y=R_pv2p.x,label=state)) +
  geom_smooth(method="lm", formula = y ~ x, color="firebrick2") +
  geom_text(aes(label = state)) +
  xlab("Adjusted Spending on Advertising") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2004 Republican Advertising Spending (OVERALL)") +
  theme_bw()
summary(lm(R_pv2p.x ~ late_cost, data=ad_2004_overall_r))
r_2004_late <- ad_2004_overall_r %>%
  ggplot(aes(x=late_cost,y=R_pv2p.x,label=state)) +
  geom_smooth(method="lm", formula = y ~ x, color="firebrick2") +
  geom_text(aes(label = state)) +
  xlab("Spending on Late Advertising") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2004 Republican Advertising Spending (LATE)") +
  theme_bw()

ad_2004_early_d <- ad_2004_early_d %>%
  left_join(pvstate_2004,by="state") %>%
  mutate(early_cost = total_cost)
ad_2004_late_d <- ad_2004_late_d %>%
  left_join(pvstate_2004,by="state") %>%
  mutate(late_cost = total_cost)
ad_2004_early_d <- ad_2004_early_d %>%
  select(state,year,early_cost,D_pv2p)
ad_2004_late_d <- ad_2004_late_d %>%
  select(state,year,late_cost,D_pv2p)
ad_2004_overall_d <- ad_2004_early_d %>%
  left_join(ad_2004_late_d, by=c("state","year")) %>%
  mutate(adjusted_cost = ifelse(is.na(late_cost),early_cost,
                                0.5*(early_cost+late_cost)))
summary(lm(D_pv2p.x ~ adjusted_cost, data=ad_2004_overall_d))
d_2004_overall <- ad_2004_overall_d %>%
  ggplot(aes(x=adjusted_cost,y=D_pv2p.x,label=state)) +
  geom_smooth(method="lm", formula = y ~ x, color="cornflowerblue") +
  geom_text(aes(label = state)) +
  xlab("Adjusted Spending on Advertising") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2004 Democratic Advertising Spending (OVERALL)") +
  theme_bw()
summary(lm(D_pv2p.x ~ late_cost, data=ad_2004_overall_d))
d_2004_late <- ad_2004_overall_d %>%
  ggplot(aes(x=late_cost,y=D_pv2p.x,label=state)) +
  geom_smooth(method="lm", formula = y ~ x, color="cornflowerblue") +
  geom_text(aes(label = state)) +
  xlab("Spending on Late Advertising") +
  ylab("Share of 2-Party Vote") +
  ggtitle("2004 Democratic Advertising Spending (LATE)") +
  theme_bw()
limits <- c(35,65)
breaks <- seq(limits[1],limits[2],by=5)
r_2004_1_common <- r_2004_overall +
  scale_y_continuous(limits=limits,breaks=breaks)
r_2004_2_common <- r_2004_late +
  scale_y_continuous(limits=limits,breaks=breaks)
d_2004_1_common <- d_2004_overall +
  scale_y_continuous(limits=limits,breaks=breaks)
d_2004_2_common <- d_2004_late +
  scale_y_continuous(limits=limits,breaks=breaks)
r_2004_1_common <- ggplot_gtable(ggplot_build(r_2004_1_common))
r_2004_2_common <- ggplot_gtable(ggplot_build(r_2004_2_common))
d_2004_1_common <- ggplot_gtable(ggplot_build(d_2004_1_common))
d_2004_2_common <- ggplot_gtable(ggplot_build(d_2004_2_common))
r_2004_2_common$heights <- r_2004_1_common$heights
d_2004_1_common$heights <- r_2004_1_common$heights
d_2004_2_common$heights <- r_2004_1_common$heights
grid.arrange(r_2004_1_common, r_2004_2_common,
             d_2004_1_common, d_2004_2_common, ncol=2)
ggsave("ads_pv2p_2004.png",
       arrangeGrob(r_2004_1_common, r_2004_2_common,
                   d_2004_1_common, d_2004_2_common, ncol=2),
       height=8,width=12)

# read, merge, modify additional data
pollavg_st_df   <- read_csv("pollavg_bystate_1968-2016.csv")
poll_2020_df <- read_csv("polls_2020.csv")
poll_2020_df$election_date <- as.Date("11/3/2020","%m/%d/%Y")
poll_2020_df$date <- as.Date(poll_2020_df$end_date,"%m/%d/%y")
poll_2020_df$days_left <- as.numeric(difftime(poll_2020_df$election_date,
                                           poll_2020_df$date,units=c("days")))

# revise polls-only model with new data
poll_2020_d <- poll_2020_df %>%
  filter(candidate_name=="Joseph R. Biden Jr.")
poll_2020_r <- poll_2020_df %>%
  filter(candidate_name=="Donald Trump")
summary(poll_2020_d$days_left) #D median is 134
poll_2020_d_early <- poll_2020_d %>%
  filter(days_left>134)
poll_2020_d_close <- poll_2020_d %>%
  filter(days_left<=134)
summary(poll_2020_r$days_left) #R median is 252
poll_2020_r_early <- poll_2020_r %>%
  filter(days_left>252)
poll_2020_r_close <- poll_2020_r %>%
  filter(days_left<=252)

poll_2020_d_early <- poll_2020_d_early %>%
  group_by(state) %>%
  summarize(poll_pct = mean(pct))
poll_2020_d_close <- poll_2020_d_close %>%
  group_by(state) %>%
  summarize(poll_pct = mean(pct))
poll_2020_d_early[16,1]="Maine"
poll_2020_d_early[16,2]=0.5*(58+49)
poll_2020_d_early[25,1]="Nebraska"
poll_2020_d_close[25,1]="Nebraska"
poll_2020_d_close[25,2]=0.5*(46+51)

states_ev <- states_ev %>%
  rename(state_abbrev = state) %>%
  rename(state = state_full)

poll_2020_d_early <- poll_2020_d_early %>%
  left_join(states_ev,by="state")
poll_2020_d_close <- poll_2020_d_close %>%
  left_join(states_ev,by="state")

poll_2020_r_early <- poll_2020_r_early %>%
  group_by(state) %>%
  summarize(poll_pct = mean(pct))
poll_2020_r_close <- poll_2020_r_close %>%
  group_by(state) %>%
  summarize(poll_pct = mean(pct))
poll_2020_r_close[28,1]="Nebraska"
poll_2020_r_close[28,2]=0.5*(48+43.5)
poll_2020_r_early <- poll_2020_r_early %>%
  left_join(states_ev,by="state")
poll_2020_r_close <- poll_2020_r_close %>%
  left_join(states_ev,by="state")

poll_2020_d_early <- poll_2020_d_early %>%
  mutate(prediction = 0.4368*(8.3623+0.9059*poll_pct))
poll_2020_r_early <- poll_2020_r_early %>%
  mutate(prediction = 0.4368*(8.3623+0.9059*poll_pct))
poll_2020_d_close <- poll_2020_d_close %>%
  mutate(prediction = 0.5632*(3.2889+1.0060*poll_pct))
poll_2020_r_close <- poll_2020_r_close %>%
  mutate(prediction = 0.5632*(3.2889+1.0060*poll_pct))

poll_2020_d_all <- poll_2020_d_early %>%
  select(state,poll_pct,ev_alloted,prediction) %>%
  left_join(poll_2020_d_close,by=c("state","ev_alloted"))
poll_2020_d_all <- poll_2020_d_all %>%
  mutate(poll_pred = prediction.x + prediction.y)
poll_2020_r_all <- poll_2020_r_early %>%
  select(state,poll_pct,ev_alloted,prediction) %>%
  left_join(poll_2020_r_close,by=c("state","ev_alloted"))
poll_2020_r_all <- poll_2020_r_all %>%
  mutate(poll_pred = prediction.x + prediction.y)

poll_2020_d_all <- poll_2020_d_all %>%
  mutate(winner = ifelse(poll_pred>50,"yes","no")) %>%
  mutate(d_ev = ifelse(winner=="yes",ev_alloted,0))
poll_2020_r_all <- poll_2020_r_all %>%
  mutate(winner = ifelse(poll_pred>50,"yes","no")) %>%
  mutate(r_ev = ifelse(winner=="yes",ev_alloted,0))
biden_ev <- sum(poll_2020_d_all$d_ev,na.rm=T)
trump_ev <- sum(poll_2020_r_all$r_ev,na.rm=T)
