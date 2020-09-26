---
title: "Week 3 Analysis: Polling Data"
date: 2020-09-25
---

## Week 3 Analysis: Polling Data
*Friday, September 25, 2020*

This week, I will analyze polling data to determine if they are good indicators of the outcomes of presidential elections. 

### Assumptions and Theoretical Background

### Poll Quality
Polls vary in quality based on their sample size and method of sampling, while pollsters vary in quality based on their past polls and their tendency to be more favorable to one of the two major political parties. However, how much do polls vary in quality? Do polls generally under- or over-state the expected vote share of either the Democratic or Republican parties?

To answer these questions, I used individual poll data from the 2016 presidential election (`poll_2016.csv`). Combining the data with [pollster ratings](https://github.com/fivethirtyeight/data/tree/master/pollster-ratings) from [FiveThirtyEight](https://fivethirtyeight.com/), a popular aggregator of political (and other) polls, I analyzed the residual vote shares of the polls, as defined by `residual = actual - predicted`. This means that a positive residual I also separated the predicted votes for Clinton and Trump to see if there is a considerable difference in accurately predicting the vote share between the two major parties.

![Poll Residuals by Party, Based on FiveThirtyEight Poll Grade](https://yanxifang.github.io/Gov-1347/images/resid_twoparty.png)

There are several interesting observations here. First, there seem to be **relatively few, and relatively minor, differences in prediction accuracy between the different "grades" of pollsters as assigned by FiveThirtyEight**. This is surprising because the FiveThirtyEight website [outlines](https://projects.fivethirtyeight.com/pollster-ratings/) a complex series of quantitative steps taken to assign a letter grade to a pollster. While this graph is limited by the fact that it covers only one presidential election (2016), and does not consider the timeframes of polls (averaging polls with equal weight instead), it still raises the question of whether there are significant quality differences between different pollsters. Second, the **polls are much more consistent for the Democratic candidate**: the average residuals are between `0` and `+5` percentage points for all grades of pollsters, compared to `0` and `+10` percentage points for the Republican candidate. This could perhaps indicate an overall bias in polls against the Republican candidate, which would be consistent with two scenarios: (a) the number of Democratic-leaning pollsters is higher than the number of Republican-leaning pollsters, and/or (b) Republican voters have a higher rate of non-response to polls. The latter explanation would seem to validate the concept of the ["silent majority"](https://www.npr.org/2016/01/22/463884201/trump-champions-the-silent-majority-but-what-does-that-mean-in-2016), originally championed by Richard Nixon in 1969 but re-iterated by Trump during his 2016 campaign. The final observation is 

### State-Level Polls

### Implications and Conclusions
