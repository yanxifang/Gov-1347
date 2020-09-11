#### Introduction ####
#### Gov 1347: Election Analysis (2020)
#### TFs: Soubhik Barari, Sun Young Park

####----------------------------------------------------------#
#### Pre-amble ####
####----------------------------------------------------------#

## install via `install.packages("name")`
library(tidyverse)
library(ggplot2)
library(usmap)

## set working directory here
# setwd("~")

####----------------------------------------------------------#
#### Read and clean pres pop vote ####
####----------------------------------------------------------#

## read
popvote_df <- read_csv("popvote_1948-2016.csv")

## subset
popvote_df %>% 
  filter(year == 2016) %>% 
  select(party, candidate, pv2p)

## format
(popvote_wide_df <- popvote_df %>%
  select(year, party, pv2p) %>%
  spread(party, pv2p))

## modify
(popvote_wide_df <- popvote_wide_df %>% 
  mutate(winner = case_when(democrat > republican ~ "D",
                            TRUE ~ "R")))

## summarise
popvote_wide_df %>% 
  group_by(winner) %>%
  summarise(races = n())

####----------------------------------------------------------#
#### Visualize trends in national pres pop vote ####
####----------------------------------------------------------#

## example: histogram
ggplot(popvote_df, aes(x = pv2p)) + 
    geom_histogram()

## example: barplot (+ custom colors)
ggplot(popvote_df, aes(x = year, y = pv2p, fill = party)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = c("blue", "red")) 

## my bar plot for the blog
ggplot(popvote_df, aes(x = year, y = pv2p, fill = party)) +
    geom_bar(stat = "identity") +
    geom_hline(yintercept = 50, size = 1.2) +
    scale_fill_manual(values = c("cornflowerblue","firebrick2")) +
    labs(title = "Two-Party Popular Vote Percentages, 1948-2016",
         x = "Year", y = "% of Two-Party Popular Vote")
ggsave("PV_national_historical.png", height = 4, width = 8)

## example: lineplot (+ custom colors + nicer theme)
ggplot(popvote_df, aes(x = year, y = pv2p, colour = party)) +
    geom_line() +
    scale_color_manual(values = c("blue", "red")) + 
    theme_bw()

## BAD plot: 
## dark background, "too much ink", no legend, small font, 
ggplot(popvote_df, aes(x = year, y = pv2p, colour = party)) +
    geom_line(stat = "identity") + 
    theme_dark() +
    theme(legend.position = "none", axis.title = element_text(size = 5))

## GOOD plot:
## high contrast, "minimal ink", legend, detailed x-ticks, larger font
ggplot(popvote_df, aes(x = year, y = pv2p, colour = party)) +
    geom_line(stat = "identity") + 
    scale_x_continuous(breaks = seq(1948, 2016, 4)) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45))

## EXCELLENT plot:
## "pretty" customized theme
my_pretty_theme <- theme_bw() + 
    theme(panel.border = element_blank(),
          plot.title   = element_text(size = 15, hjust = 0.5), 
          axis.text.x  = element_text(angle = 45, hjust = 1),
          axis.text    = element_text(size = 12),
          strip.text   = element_text(size = 18),
          axis.line    = element_line(colour = "black"),
          legend.position = "top",
          legend.text = element_text(size = 12))

ggplot(popvote_df, aes(x = year, y = pv2p, colour = party)) +
    geom_line(stat = "identity") +
    scale_color_manual(values = c("blue", "red"), name = "") +
    xlab("") + ## no need to label an obvious axis
    ylab("popular vote %") +
    ggtitle("Presidential Vote Share (1948-2016)") + 
    scale_x_continuous(breaks = seq(from = 1948, to = 2016, by = 4)) +
    my_pretty_theme

## saves last displayed plot (not used)
## ggsave("PV_national_historical.png", height = 4, width = 8)

####----------------------------------------------------------#
#### For the blog: Visualize trends in national electoral vote ####
####----------------------------------------------------------#

## read in electoral vote
electvote_df <- read_csv("electoralvote_1948-2016.csv")

####----------------------------------------------------------#
#### Note: this is the source of the above electoral vote data ####
#### https://www.archives.gov/electoral-college/results
####----------------------------------------------------------#

## format
(electvote_wide_df <- electvote_df %>%
    select(year, party, ev) %>%
    spread(party, ev))

## rename column to avoid conflicting column names
colnames(electvote_wide_df)
names(electvote_wide_df)[names(electvote_wide_df)
                         == "democrat"] <- "democrat_ev"
names(electvote_wide_df)[names(electvote_wide_df)
                         == "republican"] <- "republican_ev"

## merge with pop vote data
pop_and_electvote_df <- popvote_wide_df %>%
    left_join(electvote_wide_df, by = "year")

## rename pop vote winner column
colnames(pop_and_electvote_df)
names(pop_and_electvote_df)[names(pop_and_electvote_df)
                         == "winner"] <- "pop_winner"

## modify: add column for electoral winner
(pop_and_electvote_df <- pop_and_electvote_df %>% 
    mutate(ev_winner = case_when(democrat_ev > republican_ev ~ "D",
                              TRUE ~ "R")))

## summarise and compare
## popular vote winner
pop_and_electvote_df %>% 
  group_by(pop_winner) %>%
  summarise(races = n())
## electoral (and actual) winner
pop_and_electvote_df %>% 
  group_by(ev_winner) %>%
  summarise(races = n())

## modify further: calculate percentages of electoral votes
(pop_and_electvote_df <- pop_and_electvote_df %>% 
    mutate(ev_percent_dem = 
             100*democrat_ev / (democrat_ev + republican_ev)))

(pop_and_electvote_df <- pop_and_electvote_df %>% 
    mutate(ev_percent_rep = 
             100*republican_ev / (democrat_ev + republican_ev)))

## convert back to long data set, for just ev
(ev_long_df <- pop_and_electvote_df %>%
    select(year, ev_percent_dem, ev_percent_rep) %>%
    gather(party, ev, ev_percent_dem:ev_percent_rep))

## sort ev data by year
ev_df <- ev_long_df[order(ev_long_df$year),]

## graphic
ggplot(ev_df, aes(x = year, y = ev, fill = party)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = 50, size = 1.2) +
  scale_fill_manual(labels = c("democrat", "republican"),
                    values = c("cornflowerblue","firebrick2")) +
  labs(title = "Two-Party Electoral Vote Percentages, 1948-2016",
       x = "Year", y = "% of Two-Party Electoral Vote")
ggsave("EV_national_historical.png", height = 4, width = 8)


####----------------------------------------------------------#
#### State-by-state map of pres pop votes ####
####----------------------------------------------------------#

## read in state pop vote
pvstate_df <- read_csv("popvote_bystate_1948-2016.csv")
pvstate_df$full <- pvstate_df$state

## shapefile of states from `usmap` library
## note: `usmap` merges this internally, but other packages may not!
states_map <- usmap::us_map()
unique(states_map$abbr)

## map: GOP pv2p (`plot_usmap` is wrapper function of `ggplot`)
plot_usmap(data = pvstate_df, regions = "states", values = "R_pv2p") + 
  scale_fill_gradient(low = "white", high = "red", name = "GOP two-party voteshare") +
  theme_void()

## map: wins
pv_win_map <- pvstate_df %>%
    filter(year == 2000) %>%
    mutate(winner = ifelse(R > D, "republican", "democrat"))

plot_usmap(data = pv_win_map, regions = "states", values = "winner") +
    scale_fill_manual(values = c("blue", "red"), name = "state PV winner") +
    theme_void()

## map: win-margins
pv_margins_map <- pvstate_df %>%
    filter(year == 2000) %>%
    mutate(win_margin = (R_pv2p-D_pv2p))

plot_usmap(data = pv_margins_map, regions = "states", values = "win_margin") +
    scale_fill_gradient2(
      high = "red", 
      # mid = scales::muted("purple"), ##TODO: purple or white better?
      mid = "white",
      low = "blue", 
      breaks = c(-50,-25,0,25,50), 
      limits = c(-50,50),
      name = "win margin"
    ) +
    theme_void()

## map grid
pv_map_grid <- pvstate_df %>%
  filter(year >= 1980) %>%
  mutate(winner = ifelse(R > D, "republican", "democrat"))

plot_usmap(data = pv_map_grid, regions = "states", values = "winner", color = "white") +
  facet_wrap(facets = year ~.) + ## specify a grid by year
  scale_fill_manual(values = c("blue", "red"), name = "PV winner") +
  theme_void() +
  theme(strip.text = element_text(size = 12),
        aspect.ratio=1)

## for blog: modified win-margin / "swing" map
## this map calculates election-to-election changes in win margins
pv_swing_map_init <- pvstate_df %>%
    filter(year >= 1976) %>%
    mutate(swing_margin =
          100*(((R_pv2p) / (R_pv2p+D_pv2p)) 
          - (((lag(R_pv2p,n=1L)) /
               (lag(R_pv2p,n=1L) + lag(D_pv2p,n=1L))))))

# remove 1976 data due to inaccuracies with using lag()
pv_swing_map <- pv_swing_map_init %>%
    filter(year >= 1980)

## map grid for blog
plot_usmap(data = pv_swing_map, regions = "states", values = "swing_margin") +
  scale_fill_gradient2(
    high = "red3", 
    mid = "white",
    low = "navyblue", 
    breaks = c(-15,-7.5,0,7.5,15), 
    limits = c(-20,20),
    name = "swing margin"
  ) +
  facet_wrap(facets = year ~.) +
  theme_void() +
  theme(strip.text = element_text(size = 12),
        aspect.ratio = 1) +
  labs(title = "Popular Vote Swing Margins by State, 1980-2016")

ggsave("PV_states_historical.png", height = 3, width = 10)

## individual year: 1996
pv_swing_map_96 <- pv_swing_map %>%
  filter(year == 1996)

plot_usmap(data = pv_swing_map_96, regions = "states", 
           labels = "true", values = "swing_margin") +
  scale_fill_gradient2(
    high = "red3", 
    mid = "white",
    low = "navyblue", 
    breaks = c(-15,-7.5,0,7.5,15), 
    limits = c(-20,20),
    name = "swing margin"
  ) +
  theme_void() +
  labs(title = "1996 Popular Vote Swing Margins by State")

ggsave("1996_swing_margins.png", height = 4, width = 8)

## individual year: 2004
pv_swing_map_04 <- pv_swing_map %>%
  filter(year == 2004)

plot_usmap(data = pv_swing_map_04, regions = "states",
           labels = "true", values = "swing_margin") +
  scale_fill_gradient2(
    high = "red3", 
    mid = "white",
    low = "navyblue", 
    breaks = c(-15,-7.5,0,7.5,15), 
    limits = c(-20,20),
    name = "swing margin"
  ) +
  theme_void() +
  labs(title = "2004 Popular Vote Swing Margins by State")

ggsave("2004_swing_margins.png", height = 4, width = 8)


####----------------------------------------------------------#
#### Extra: FiveThirtyEight replication in ggplot2 ####
#### https://projects.fivethirtyeight.com/swing-states-2020-election/
####----------------------------------------------------------#

pvstate_df$vote_margin <- pvstate_df$R_pv2p - pvstate_df$D_pv2p

pvstate_df %>% 
  ## subset data
  filter(state %in% c("Arizona","Georgia","Texas")) %>%
  filter(year >= 2000) %>%
  ## pipe into ggplot()
  ggplot(aes(x=year, y=vote_margin, color=vote_margin)) + 
  ## specify a grid by state
  facet_wrap(. ~ state) + 
  ## add plot elements
  geom_hline(yintercept=0,color="gray") +
  geom_line(size=2) + 
  geom_point(size=6) +
  ## specify scale colors
  scale_colour_gradient(low = "blue", high = "red") +
  scale_fill_gradient(low = "blue", high = "red") +
  ## specify titles, labels
  xlab("") +
  ylab("Republican vote-share margin") + 
  ggtitle("Swing states that moved sharply to the left in 2016") +
  ## switch position of x-axis and y-axis
  coord_flip() +
  ## make x-axis (year) run from top to bottom
  scale_x_reverse(breaks=unique(pvstate_df$year)) +
  theme_minimal() + 
  theme(panel.border    = element_blank(),
        plot.title      = element_text(size = 20, hjust = 0.5, face="bold"), 
        legend.position = "none",
        axis.title      = element_text(size=18),
        axis.text.x     = element_text(angle = 45, hjust = 1),
        axis.text       = element_text(size = 18),
        strip.text      = element_text(size = 18, face = "bold"))

