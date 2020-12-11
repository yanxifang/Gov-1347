
#### GOV 1347:   Testing an Election Narrative ####
#### Cindy McCain & Biden's Victory in Arizona ####

####----------------------------------------------------------#
#### Load packages and datasets ####
####----------------------------------------------------------#

## load packages
library(tidyverse)
library(usmap)
library(gridExtra)

## set working directory
setwd("D:/Users/Yanxi Fang/Files/Fall 2020/Gov 1347/Blog Post Work/Week 13 - Narrative")

####----------------------------------------------------------#
#### Polls in Arizona ####
####----------------------------------------------------------#

## read in poll dataset, and modify data
natl_polls  <- read_csv("president_polls.csv")
    # national poll data from FiveThirtyEight
    # https://projects.fivethirtyeight.com/polls-page/president_polls.csv

## biden
az_polls_biden <- natl_polls %>%
  filter(state=="Arizona") %>%
  filter(candidate_name=="Joseph R. Biden Jr.")
az_polls_biden <- az_polls_biden %>%
  group_by(end_date) %>%
  summarize(poll=mean(pct))
az_polls_biden$end_date <- as.Date(az_polls_biden$end_date,"%m/%d/%y")
az_polls_biden <- az_polls_biden %>%
  filter(end_date>"2020-06-05")

## trump
az_polls_trump <- natl_polls %>%
  filter(state=="Arizona") %>%
  filter(candidate_name=="Donald Trump")
az_polls_trump <- az_polls_trump %>%
  group_by(end_date) %>%
  summarize(poll=mean(pct))
az_polls_trump$end_date <- as.Date(az_polls_trump$end_date,"%m/%d/%y")
az_polls_trump <- az_polls_trump %>%
  filter(end_date>"2020-06-05")

## visualization: poll averages in AZ
az_polls_biden %>%
  ggplot(aes(x = end_date, y = poll)) +
  geom_point(color = "black", size = 1.5) +
  geom_line(color = "cornflowerblue", size = 1) +
  geom_vline(xintercept = as.Date("2020-09-22"), color = "firebrick2", size = 1) +
  annotate("text", x=as.Date("2020-09-13"), y=55, label="Cindy McCain\n Endorses Biden", size=3) +
  scale_x_date(date_labels = "%b, %Y") +
  ylab("Poll Results for Biden's Popular Voteshare") + xlab("") +
  ggtitle("Poll Averages for Biden in Arizona") +
  theme_classic()
ggsave("az_polls_biden.png",height=4,width=8)

az_polls_trump %>%
  ggplot(aes(x = end_date, y = poll)) +
  geom_point(color = "black", size = 1.5) +
  geom_line(color = "firebrick2", size = 1) +
  geom_vline(xintercept = as.Date("2020-09-22"), color = "cornflowerblue", size = 1) +
  annotate("text", x=as.Date("2020-09-13"), y=55, label="Cindy McCain\n Endorses Biden", size=3) +
  scale_x_date(date_labels = "%b, %Y") +
  ylab("Poll Results for Trump's Popular Voteshare") + xlab("") +
  ggtitle("Poll Averages for Trump in Arizona") +
  theme_classic()
ggsave("az_polls_trump.png",height=4,width=8)

## both
az_polls_biden$candidate = "Biden"
az_polls_biden <- az_polls_biden %>%
  unite(date_candidate, end_date, candidate, remove=T)
az_polls_trump$candidate = "Trump"
az_polls_trump <- az_polls_trump %>%
  unite(date_candidate, end_date, candidate, remove=T)
az_polls_all <- az_polls_biden %>%
  full_join(az_polls_trump,by=c("date_candidate","poll"))
az_polls_all <- az_polls_all %>%
  separate(date_candidate, c("date", "candidate"), sep="_", remove=T)
az_polls_all <- az_polls_all %>%
  spread(candidate, poll)
az_polls_all$date <- as.Date(az_polls_all$date)

az_polls_all %>%
  ggplot(aes(x = date)) +
  geom_line(aes(y = Biden), color = "cornflowerblue", size = 1) +
  geom_point(aes(y = Biden), color = "black", size = 1) +
  geom_line(aes(y = Trump), color = "firebrick2", size = 1) +
  geom_point(aes(y = Trump), color = "black", size = 1) +
  geom_vline(xintercept = as.Date("2020-09-22"), color = "black", size = 1) +
  annotate("text", x=as.Date("2020-09-09"), y=55, label="Cindy McCain\n Endorses Biden", size=3) +
  scale_x_date(date_labels = "%b, %Y") +
  ylab("Poll Results: Popular Voteshare") + xlab("") +
  ggtitle("Poll Averages for Biden & Trump in Arizona") +
  theme_classic()
ggsave("az_polls_all.png",height=4,width=8)

####----------------------------------------------------------#
#### Demographics in Arizona ####
####----------------------------------------------------------#

## read in demographics dataset, and modify data
az_demog15 <- read_csv("ACS_B02001_2015.csv")
az_demog19 <- read_csv("ACS_B02001_2019.csv")
    # County-Level Demographics Data from the American Community Survey (ACS)
    # 2 datasets: 5-year demographics, estimated in 2019 and 2015 respectively
    # 2019 is the most recent available dataset
    # So, 2015 is the comparable dataset when looking at the 2016 election
    # https://data.census.gov/cedsci/table?q=United%20States%20Race%20and%20Ethnicity&g=0400000US04,04.050000&tid=ACSDT5Y2019.B02001&moe=false&hidePreview=true

az_demog15 <- az_demog15 %>%
  separate("Geographic Area Name",c("county","state"),sep=",",remove = T)
az_demog15 <- az_demog15 %>%
  mutate(white = 100*`Estimate!!Total!!White alone` / `Estimate!!Total`) %>%
  mutate(black = 100*`Estimate!!Total!!Black or African American alone` / `Estimate!!Total`) %>%
  mutate(native = 100*`Estimate!!Total!!American Indian and Alaska Native alone` / `Estimate!!Total`) %>%
  mutate(asian = 100*`Estimate!!Total!!Asian alone` / `Estimate!!Total`) %>%
  mutate(pacisl = 100*`Estimate!!Total!!Native Hawaiian and Other Pacific Islander alone` / `Estimate!!Total`) %>%
  mutate(OtherMulti = 100*(`Estimate!!Total!!Some other race alone` +
                             `Estimate!!Total!!Two or more races` +
                             `Estimate!!Total!!Two or more races!!Two races including Some other race` +
                             `Estimate!!Total!!Two or more races!!Two races excluding Some other race, and three or more races`) /
                           `Estimate!!Total`)
az_demog15 <- az_demog15 %>%
  filter(county != "Arizona") %>%
  filter(county != "United States") %>%
  select(county, white, black, native, asian, pacisl, OtherMulti)

az_demog19 <- az_demog19 %>%
  separate("Geographic Area Name",c("county","state"),sep=",",remove = T)
az_demog19 <- az_demog19 %>%
  mutate(white = 100*`Estimate!!Total:!!White alone` / `Estimate!!Total:`) %>%
  mutate(black = 100*`Estimate!!Total:!!Black or African American alone` / `Estimate!!Total:`) %>%
  mutate(native = 100*`Estimate!!Total:!!American Indian and Alaska Native alone` / `Estimate!!Total:`) %>%
  mutate(asian = 100*`Estimate!!Total:!!Asian alone` / `Estimate!!Total:`) %>%
  mutate(pacisl = 100*`Estimate!!Total:!!Native Hawaiian and Other Pacific Islander alone` / `Estimate!!Total:`) %>%
  mutate(OtherMulti = 100*(`Estimate!!Total:!!Some other race alone` +
                             `Estimate!!Total:!!Two or more races:` +
                             `Estimate!!Total:!!Two or more races:!!Two races including Some other race` +
                             `Estimate!!Total:!!Two or more races:!!Two races excluding Some other race, and three or more races`) /
                           `Estimate!!Total:`)
az_demog19 <- az_demog19 %>%
  filter(county != "Arizona") %>%
  filter(county != "United States") %>%
  select(county, white, black, native, asian, pacisl, OtherMulti)

## demographic changes, 2016 to 2020 elections
az_demog_2020elxn <- az_demog15 %>%
  left_join(az_demog19, by = "county")

az_demog_2020elxn <- az_demog_2020elxn %>%
  mutate(d_white = 100*(white.y - white.x)/(white.x)) %>%
  mutate(d_black = 100*(black.y - black.x)/(black.x)) %>%
  mutate(d_native = 100*(native.y - native.x)/(native.x)) %>%
  mutate(d_asian = 100*(asian.y - asian.x)/(asian.x)) %>%
  mutate(d_pacisl = 100*(pacisl.y - pacisl.x)/(pacisl.x)) %>%
  mutate(d_other = 100*(OtherMulti.y - OtherMulti.x)/(OtherMulti.x))

az_demog_2020elxn <- az_demog_2020elxn %>%
  select(county, white.y, black.y, native.y, asian.y, pacisl.y, OtherMulti.y,
         d_white, d_black, d_native, d_asian, d_pacisl, d_other)

## read in election outcomes dataset
az_votes_cty <- read_csv("az_election_by_county.csv")
    # manually-inputted data from AZ Secretary of State Website
    # 2016 data: https://apps.azsos.gov/election/2016/General/Official%20Signed%20State%20Canvass.pdf
    # 2020 data: https://azsos.gov/sites/default/files/2020_General_State_Canvass.pdf
    # general link: https://azsos.gov/elections/voter-registration-historical-election-data/historical-election-results-information

az_demog_votes <- az_demog_2020elxn %>%
  left_join(az_votes_cty, by = "county")

## additional data modifications
az_demog_votes <- az_demog_votes %>%
  mutate(dem = 100*`biden 2020`/`total cast 2020`) %>%
  mutate(rep = 100*`trump 2020`/`total cast 2020`) %>%
  mutate(dem_lag = 100*`clinton 2016`/`total cast 2016`) %>%
  mutate(rep_lag = 100*`trump 2016`/`total cast 2016`) %>%
  mutate(d_dem = 100*(dem-dem_lag)/(dem_lag)) %>%
  mutate(d_rep = 100*(rep-rep_lag)/(rep_lag))

summary(lm(dem ~ native.y, data = az_demog_votes))
summary(lm(d_dem ~ d_native, data = az_demog_votes))
az_demog_votes_minus1 <- az_demog_votes %>%
  filter(county != "Santa Cruz County")
summary(lm(d_dem ~ d_native, data = az_demog_votes_minus1))
az_demog_votes %>%
  ggplot(aes(x = native.y, y = dem, label = county)) + 
  geom_point(size = 2) +
  geom_text(size = 2) +
  geom_smooth(method="lm", formula = y ~ x) +
  xlab("% Indigenous/Native American Population") +
  ylab("Biden's 2020 Voteshare") +
  geom_hline(yintercept=50, lty=2) +
  theme_bw() +
  ggtitle("Indigenous Population vs Democratic Voteshare",
          subtitle="Y = 39.4828 + 0.2586 * X")
ggsave("az_indigenous_nominal.png",height=4,width=8)
az_demog_votes %>%
  ggplot(aes(x = d_native, y = d_dem, label = county)) + 
  geom_point(size = 2) +
  geom_text(size = 2) +
  geom_smooth(method="lm", formula = y ~ x) +
  xlab("% Change in Indigenous/Native American Population, 2016-2020") +
  ylab("% Change in D Candidate Voteshare, 2016-2020") +
  geom_hline(yintercept=0, lty=2) +
  theme_bw() +
  ggtitle("Indigenous Population vs Democratic Voteshare",
          subtitle="Y = 8.9525 - 0.0587 * X")
ggsave("az_indigenous_change.png",height=4,width=8)

demographic_a <- az_demog_votes %>%
  ggplot(aes(x = native.y, y = dem, label = county)) + 
  geom_point(size = 2) +
  geom_text(size = 2) +
  geom_smooth(method="lm", formula = y ~ x) +
  xlab("% Indigenous/Native American Population") +
  ylab("Biden's 2020 Voteshare") +
  geom_hline(yintercept=50, lty=2) +
  theme_bw() +
  ggtitle("Indigenous Population vs Democratic Voteshare",
          subtitle="Y = 39.4828 + 0.2586 * X")
demographic_b <- az_demog_votes %>%
  ggplot(aes(x = d_native, y = d_dem, label = county)) + 
  geom_point(size = 2) +
  geom_text(size = 2) +
  geom_smooth(method="lm", formula = y ~ x) +
  xlab("% Change in Indigenous/Native American Population, 2016-2020") +
  ylab("% Change in D Candidate Voteshare, 2016-2020") +
  geom_hline(yintercept=0, lty=2) +
  theme_bw() +
  ggtitle("Indigenous Population vs Democratic Voteshare",
          subtitle="Y = 8.9525 - 0.0587 * X")
grid.arrange(demographic_a, demographic_b, nrow = 1)
ggsave("az_indigenous_charts.png",arrangeGrob(demographic_a, demographic_b),height=8,width=4)

## indigenous / native counties
az_demog_native <- az_demog_votes %>%
  filter(native.y >= 20)

az_demog_votes <- az_demog_votes %>%
  mutate(fips = fips(state = "Arizona", county = county))

plot_usmap(data = az_demog_votes, "counties", include = "AZ", 
             labels = "true", values = "native.y", color = "orange", label_color = "red", size = 1.5) +
  scale_fill_gradient(low = "#56B1F7", high = "#132B43", name = "% Indigenous / Native American") +
  theme_void() +
  labs(title = "Arizona Indigenous / Native American Population")
ggsave("az_indigenous_population.png", height = 4, width = 8)

plot_usmap(data = az_demog_votes, "counties", include = "AZ", 
           labels = "true", values = "dem", color = "orange", label_color = "red", size = 1.5) +
  scale_fill_gradient(low = "#56B1F7", high = "#132B43", name = "% Votes for Biden") +
  theme_void() +
  labs(title = "Arizona 2020 Election Results by County")
ggsave("az_biden_votes_county.png", height = 4, width = 8)

indigenous <- plot_usmap(data = az_demog_votes, "counties", include = "AZ", 
                         labels = "true", values = "native.y", color = "orange", label_color = "red", size = 1.5) +
                scale_fill_gradient(low = "#56B1F7", high = "#132B43", name = "% Indigenous / Native American") +
                theme_void() +
                labs(title = "Arizona Indigenous / Native American Population")
result_2020 <- plot_usmap(data = az_demog_votes, "counties", include = "AZ", 
                           labels = "true", values = "dem", color = "orange", label_color = "red", size = 1.5) +
                  scale_fill_gradient(low = "#56B1F7", high = "#132B43", name = "% Votes for Biden") +
                  theme_void() +
                  labs(title = "Arizona 2020 Election Results by County")
grid.arrange(indigenous, result_2020)
ggsave("az_indigenous_biden.png",arrangeGrob(indigenous, result_2020),height=6,width=6)

result_delta <- plot_usmap(data = az_demog_votes, "counties", include = "AZ", 
                          labels = "true", values = "d_dem", color = "orange", label_color = "red", size = 1.5) +
  scale_fill_gradient(low = "#56B1F7", high = "#132B43", name = "% Change in D Voteshare") +
  theme_void() +
  labs(title = "Arizona: Changes in Democratic Voteshare from 2016 to 2020")
grid.arrange(indigenous, result_delta)
ggsave("az_indigenous_delta_d.png",arrangeGrob(indigenous, result_delta),height=6,width=6)

####----------------------------------------------------------#
#### COVID Cases in Arizona ####
####----------------------------------------------------------#

## read in poll dataset, and modify data
az_covid  <- read_csv("arizona-history.csv")
    # AZ cases data from The COVID Tracking Project
    # https://covidtracking.com/data/state/arizona

## cumulative cases over time
az_covid$date <- as.Date(az_covid$date)
az_covid <- az_covid %>%
  filter(date<=as.Date("2020-11-03"))
az_covid %>%
  ggplot(aes(x = date, y = positive)) +
  geom_point(color = "black", size = 0.5) +
  geom_line(color = "firebrick2", size = 1) +
  geom_vline(xintercept = as.Date("2020-09-22"), color = "cornflowerblue", size = 1) +
  annotate("text", x=as.Date("2020-09-08"), y=250000, label="Cindy McCain\n Endorses Biden", size=3) +
  geom_vline(xintercept = as.Date("2020-11-03"), color = "cornflowerblue", size = 1) +
  annotate("text", x=as.Date("2020-10-29"), y=215000, label="Election\n Day", size=3) +
  scale_x_date(date_labels = "%b, %Y") +
  ylab("# of COVID Positive Cases") + xlab("") +
  ggtitle("Arizona COVID Positive Cases Over Time (Cumulative)") +
  theme_classic()
ggsave("az_covid_cases.png",height=4,width=8)

