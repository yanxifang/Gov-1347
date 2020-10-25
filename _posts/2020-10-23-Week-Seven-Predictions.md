---
title: "Week 7 Analysis: Shocks and COVID-19"
date: "2020-10-23"
---

## Week 7 Analysis: Shocks & The Impacts of COVID-19
*Friday, October 23, 2020*

## Intro: Why Shocks?
**Many unpredictable (and often uncontrollable) things can happen in a typical year, but in a U.S. presidential election cycle, the impact of these events becomes more significant.** For instance, according to [Achen and Bartels (2016), Chapter 5](https://www.jstor.org/stable/j.ctvc7770q), something as random as shark attacks can have an impact on voter choice at the polls. Although the theory behind this bizarre example is contested (see [Fowler and Hall, 2018](https://www.journals.uchicago.edu/doi/abs/10.1086/699244)), it does not matter so much in practice.

In particular, the COVID-19 pandemic has undoubtedly impacted many Americans either economically (e.g. unemployment) or personally (e.g. through infection, hospitalization, or death of a family member or acquaintance), to the extent that no matter what the explanatory mechanism may be, there must be *some* impact on the outcome of the presidential election. Since COVID-19 is a negative shock from any perspective, one would expect decreased vote share for the incumbent, even if voters believe Trump could not have controlled the pandemic.

## Turnout: Reasons for Fluctuations
**This week, I will build off the assumption that COVID-19 has a non-zero impact on voter turnout. But what exactly are the factors that affect turnout?** Some of these are intuitive: areas with high percentages of COVID-19 related deaths should experience higher turnout rates, since voters are likely to express their disapproval of the incumbent. Similarly, areas with large Black or Latinx communities should also have higher turnout, since those groups have evidently experienced higher infection and death rates than the general population. 

However, some other factors are less clear: for example, in a high-infection/high-death area that has traditionally voted Republican, would there be fewer or more voters? In this case, highly partisan voters may actually have a higher turnout rate in order to support (maybe "defend") Trump, but at the same time, it is possible that more-moderate Republican voters may be discouraged by Trump's response to the shock of COVID-19, but not upset enough to vote for a Democrat, thus depressing turnout. So, I think it makes sense to approach the concept of turnout from a demographics perspective, since different groups are impacted differently (and should, in theory, respond differently) to the "shock" of the COVID-19 pandemic.

## Visualizing COVID-19 Data by County
First, to get a sense of COVID-19's impact on the United States at the county level, I plotted the CDC data on a map, showing the proportion of deaths in each county that are caused by COVID-19. As seen below, it is quite alarming that in some parts of the country, COVID-19 accounts for more than 30% of the county's total deaths.

![COVID-19 Deaths](https://yanxifang.github.io/Gov-1347/images/covid_19_deaths.png)

It is also interesting to note that for a very substantial number of counties (and a very large area, by geographical size), there is no official data from the CDC. This is because the CDC only tracks counties with more than 10 COVID-related deaths, which might be too high of a bar when looking at counties with smaller populations. So, in this sense, the data is limited and may not be able to determine state-wide winners.

## Model: Demographic Surges in Response to Shocks
I was originally hoping to build a probabilistic model for this week. However, from my understanding, the total number of eligible voters in each county is required for the probability calculation, and I was unable to find this information. Instead, all I have in the dataset are the total number of votes cast in each of the presidential elections during 2000-2016, which is not particularly useful because the idea of shocks impacting turnout is centered around the idea that the total number of votes cast will either increase or decrease.

Instead, I will build on my demographics findings from last week to model surges, and specifically, surges caused by the COVID-19 pandemic. In my analysis, I used data from the U.S. CDC on [COVID-19 deaths at the county level](https://data.cdc.gov/NCHS/Provisional-COVID-19-Death-Counts-in-the-United-St/kn79-hsxy), which I then merged with county-level popular vote share data for 2000-2016, as well as data for county-level demographics (age groups, gender, and race/ethnicity). Having learned about shocks this week, I am more confident about the theroetical underpinnings of assigning arbitary numbers to model surge effects than I was last week.

**In my model, I will assume that both Black and Latinx voters will turn out at double their usual rate.** As previously mentioned, all major media outlets have reported that these two groups have suffered disproportionately more from COVID-19 due to a mixture of greater exposure and more pre-existing adverse health conditions. For my baseline (non-surge) model, I ended up using a regression with the change in all of the demographic variables, as well as interaction terms to account for the relative size of the change. This regression had an R-squared value of `0.3749`, which is not ideal but not too terrible.

From there, I plugged in the data for my assumption (doubled Black and doubled Latinx turnout), and created a new data frame. However, I was unable to plot the data with the `usmap` package for some reason (the error: `Error in match.arg(regions): 'arg' must be NULL or a character vector`). Unfortunately, except for the R code, I have nothing to show for my efforts: the data only includes the predicted popular vote percentage received by Democrats by county, making it hard to translate into an actual prediction due to the lack of a denominator (i.e. since turnout is expected to change between 2016 and 2020) and missing information for many counties.

After creating this model, I also came to the realization that I had used last week's strategy too much: I assumed a pooled model where each county had one set of parameters, when according to my own assumptions, COVID-19 should have county-dependent impacts on voter turnout because each county has experienced different death rates. **Note: I will be updating this page after the deadline when I come up with a more appropriate model.**

**Update:** I have resolved the error with the map, and created an updated demographic prediction model that now has a R-squared value of `0.48`. However, when plotting the results, the findings are intuitively incorrect (for instance, Massachusetts shows up as going fully Republican, which is *very* unlikely), and I am still confused as to where the data error occurred. This is the map I'm referring to:
![Predicted Results Based on Double Black and Hispanic Turnout](https://yanxifang.github.io/Gov-1347/images/pred_winner_double_turnout.png)

## Updated Conclusion
It is very likely that I made an error in merging or calculating the demographic data. However, even with the faulty data, the increased turnout from Black and Latinx Americans has a substantial implication for the 2020 election: many more counties switched from Republican to Democratic (from 52 to 290 counties in the faulty data, out of ~1,100 counties). This is not surprising at all: both groups have long been perceived to vote overwhelmingly Democratic, so a surge in turnout among these groups (i.e. in response to the very negative shock of COVID-19) would necessarily imply that more counties will become Democratic for the 2020 election.

Of course, there are still many other factors I could have considered. A main challenge I encountered this week was thinking about COVID-19 deaths in relation to the turnout rate of each demographic group. For instance, if Black Americans are dying at a higher proportion than their representation in a certain community, and I only have the total number of deaths in that community, then how would this be factored into a model in which death is a variable? Another challenge is that there are many counties for which the CDC does not provide data. Should I assume normal turnout rates in those counties, or increased turnout as well (in which case, the number of deaths wouldn't be a variable any more)? I hope to have at least one of these addressed by next week, when I make my final prediction for the election.

Click [here](https://yanxifang.github.io/Gov-1347) to return to the front page.
