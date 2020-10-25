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

**In my model, I will assume that both Black and Latinx voters will turn out at double their usual rate.** As previously mentioned, all major media outlets have reported that these two groups have suffered disproportionately more from COVID-19 due to a mixture of greater exposure and more pre-existing adverse health conditions. For my baseline (non-surge) model, I ended up using a regression with the change in all of the demographic variables, as well as interaction terms to account for the relative size of the change.



<table style="text-align:center"><caption><strong>Demographics: Baseline Model</strong></caption>
<tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="1" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td>d_pv (Democratic Popular Voteshare)</td></tr>
<tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Asian_change</td><td>5.417<sup>***</sup> (0.578)</td></tr>
<tr><td style="text-align:left">Asian</td><td>0.895<sup>***</sup> (0.037)</td></tr>
<tr><td style="text-align:left">Black_change</td><td>0.293 (0.300)</td></tr>
<tr><td style="text-align:left">Black</td><td>0.378<sup>***</sup> (0.008)</td></tr>
<tr><td style="text-align:left">Hispanic_change</td><td>-2.825<sup>***</sup> (0.213)</td></tr>
<tr><td style="text-align:left">Hispanic</td><td>0.308<sup>***</sup> (0.012)</td></tr>
<tr><td style="text-align:left">Indigenous_change</td><td>-3.343<sup>***</sup> (0.678)</td></tr>
<tr><td style="text-align:left">Indigenous</td><td>0.378<sup>***</sup> (0.018)</td></tr>
<tr><td style="text-align:left">Female_change</td><td>-3.325<sup>*</sup> (1.756)</td></tr>
<tr><td style="text-align:left">Female</td><td>0.744<sup>***</sup> (0.045)</td></tr>
<tr><td style="text-align:left">age20_change</td><td>-0.150 (0.455)</td></tr>
<tr><td style="text-align:left">age20</td><td>-0.622<sup>***</sup> (0.060)</td></tr>
<tr><td style="text-align:left">age3045_change</td><td>0.747 (0.802)</td></tr>
<tr><td style="text-align:left">age3045</td><td>-0.668<sup>***</sup> (0.069)</td></tr>
<tr><td style="text-align:left">age4565_change</td><td>3.855<sup>***</sup> (0.616)</td></tr>
<tr><td style="text-align:left">age4565</td><td>-1.500<sup>***</sup> (0.090)</td></tr>
<tr><td style="text-align:left">Asian_change:Asian</td><td>-0.155<sup>***</sup> (0.026)</td></tr>
<tr><td style="text-align:left">Black_change:Black</td><td>-0.016<sup>*</sup> (0.009)</td></tr>
<tr><td style="text-align:left">Hispanic_change:Hispanic</td><td>-0.027<sup>***</sup> (0.007)</td></tr>
<tr><td style="text-align:left">Indigenous_change:Indigenous</td><td>0.087<sup>***</sup> (0.019)</td></tr>
<tr><td style="text-align:left">Female_change:Female</td><td>0.030 (0.037)</td></tr>
<tr><td style="text-align:left">age20_change:age20</td><td>0.046<sup>***</sup> (0.016)</td></tr>
<tr><td style="text-align:left">age3045_change:age3045</td><td>-0.013 (0.019)</td></tr>
<tr><td style="text-align:left">age4565_change:age4565</td><td>0.015 (0.019)</td></tr>
<tr><td style="text-align:left">Constant</td><td>69.419<sup>***</sup> (6.665)</td></tr>
<tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr></table>

Click [here](https://yanxifang.github.io/Gov-1347) to return to the front page.
