---
title: "Week 3 Analysis: Polling Data"
date: 2020-09-25
---

## Week 3 Analysis: Polling Data
*Friday, September 25, 2020*

This week, I will analyze polling data to determine if they are good indicators of the outcomes of presidential elections. 

### Assumptions and Theoretical Background
The 1936 *Literary Digest* poll was perhaps one of the earliest well-known examples of [American polling failures](https://ebookcentral-proquest-com.ezp-prod1.hul.harvard.edu/lib/harvard-ebooks/detail.action?docID=6270706). Although the poll gathered an impressive 2.3 million responses, it incorrectly predicted a landslide victory for Republican challenger Alf Landon, estimating that he would carry 33 states and 370 electoral votes. Instead, incumbent Franklin Roosevelt enjoyed an overwhelming landslide, capturing 523 (out of 531) electoral votes and every state except Maine and Vermont.

**Polls are rarely, if ever, perfect. Nonetheless, they can be informative.** As statistician Francis Galton [observed](https://www.nature.com/articles/075450a0) at a livestock exhibition in 1907, having a large sample of people allows individual-level prediction errors to be cancelled out, thus approximating a normal distribution and providing a prediction that is close to the true value - in Galton's case, the weight of an animal. This concept can be applied to polls: the more people that are surveyed about their preferences, the more likely that the poll is to make an accurate prediction about the winner of the election. The idea of poll aggregation also follows the same line of reasoning: with more polls from a variety of sources, errors in individual polls can cancel each other out, and should hypothetically provide a close prediction of the election outcome.

This, of course, leaves much to be desired. The media generally reports on individual polls as they are released, so which polls should we (the public) trust? 

### Poll Quality
Polls vary in quality based on their sample size and method of sampling, while pollsters vary in quality based on their past polls and their tendency to be more favorable to one of the two major political parties. However, how much do polls vary in quality? Do polls generally under- or over-state the expected vote share of either the Democratic or Republican parties?

To answer these questions, I used individual poll data from the 2016 presidential election (`poll_2016.csv`). Combining the data with [pollster ratings](https://github.com/fivethirtyeight/data/tree/master/pollster-ratings) from [FiveThirtyEight](https://fivethirtyeight.com/), a popular aggregator of political (and other) polls, I analyzed the residual vote shares of the polls, as defined by `residual = actual - predicted`. This means that a positive residual represents an under-prediction of support (i.e. the poll predicted less support than actually received), while a negative residual represents an over-prediction of support (i.e. the poll predicted more support than actually received). I also separated the predicted votes for Clinton and Trump to see if there is a considerable difference in accurately predicting the vote share between the two major parties.

![Poll Residuals by Party, Based on FiveThirtyEight Poll Grade](https://yanxifang.github.io/Gov-1347/images/resid_twoparty.png)

There are several interesting observations here. First, **the different "grades" of pollsters, as assigned by FiveThirtyEight, do not seem to show major differences in prediction accuracy**. This is surprising because the FiveThirtyEight website [outlines](https://projects.fivethirtyeight.com/pollster-ratings/) a complex series of quantitative steps taken to assign a letter grade to a pollster. While this graph is limited by the fact that it covers only one presidential election (2016), and does not consider the timeframes of polls (averaging polls with equal weight instead), it still raises the question of whether there are significant quality differences between different pollsters. Second, the **polls are much more consistent for the Democratic candidate**: the average residuals are between `0` and `+5` percentage points for all grades of pollsters, compared to `0` and `+10` percentage points for the Republican candidate. This could perhaps indicate an overall bias in polls against the Republican candidate, which would be consistent with two scenarios: (a) the number of Democratic-leaning pollsters is higher than the number of Republican-leaning pollsters, and/or (b) Republican voters have a higher rate of non-response to polls. The latter explanation would seem to validate the concept of the ["silent majority"](https://www.npr.org/2016/01/22/463884201/trump-champions-the-silent-majority-but-what-does-that-mean-in-2016), originally championed by Richard Nixon in 1969 but re-iterated by Trump during his 2016 campaign. The final observation is more of a fluke: at least in 2016, the pollsters with a grade of "C" actually predicted, on average, the election outcomes very closely. While individual predictions in the "C" category have a large range, the fact that they balanced each other out (and have symmetric-looking first/third quartiles) is interesting because of the striking parallel to Galton's observations in 1907.

### State-Level Polls
Ultimately, national-level polls are only interesting in the sense that they provide an approximate indication of the level of support that each of the two major-party candidates have. Due to the setup of the Electoral College, these **national-level polls are generally not informative about whether a candidate will capture enough electoral votes for an actual victory**; an examination of state-by-state predictions is required. So, the next question is: are state-level polls accurate?

As it turns out, the **state-level polls, on average, have been quite accurate.** From 1972 to 2016, across all 50 states (and the District of Columbia), the poll prediction has been the most accurate indicator of the state-level election outcome. Surprisingly, the date of the polls 

![State Poll Predictions versus Received Vote Share, 1972-2016](https://yanxifang.github.io/Gov-1347/images/state_polls_by_party.png)

![Democratic versus Republican State Polls, 1972-2016](https://yanxifang.github.io/Gov-1347/images/state_poll_twoparty.png)

### Implications and Conclusions
