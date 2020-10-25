---
title: "Week 7 Analysis: Shocks and COVID-19"
date: "2020-10-23"
---

## Week 7 Analysis: Shocks & The Impacts of COVID-19
*Friday, October 23, 2020*

## Intro: Why Shocks?
**Many unpredictable (and often uncontrollable) things can happen in a typical year, but in a U.S. presidential election cycle, the impact of these events becomes more significant.** For instance, according to [Achen and Bartels (2016), Chapter 5](https://www.jstor.org/stable/j.ctvc7770q), something as random as shark attacks can have an impact on voter choice at the polls. Although the theory behind this bizarre example is contested (see [Fowler and Hall, 2018](https://www.journals.uchicago.edu/doi/abs/10.1086/699244)), it does not matter so much in practice. In particular, the COVID-19 pandemic has undoubtedly impacted many Americans either economically or personally (e.g. through infection, hospitalization, or death of a family member or acquaintance), to the extent that no matter what the explanatory mechanism may be, there must be *some* impact on the outcome of the presidential election. Since COVID-19 is a negative shock from any perspective, one would expect decreased vote share for the incumbent, even if voters believe Trump could not have controlled the pandemic.

## Turnout: Reasons for Fluctuations
**This week, I will build off the assumption that COVID-19 has a non-zero impact on voter turnout. But what exactly are the factors that affect turnout?** Some of these are intuitive: areas with high percentages of COVID-19 related deaths should experience higher turnout rates, since voters are likely to express their disapproval of the incumbent. Similarly, areas with large Black or Latinx communities should also have higher turnout, since those groups have evidently experienced higher infection and death rates than the general population. However, some other factors are less clear: for example, in a high-infection/high-death area that has traditionally voted Republican, would there be fewer or more voters? (On one hand, voters may be discouraged by Trump's response to the shock of COVID-19, but on the other hand, they may not be upset enough to vote for a Democrat.) So, I think it makes sense to approach the concept of turnout from a demographics perspective, since different groups are impacted differently (and should, in theory, respond differently) to the "shock" of the COVID-19 pandemic.

## Turnout: Probabilistic Model
In my analysis, I used data from the U.S. CDC on [COVID-19 deaths at the county level](https://data.cdc.gov/NCHS/Provisional-COVID-19-Death-Counts-in-the-United-St/kn79-hsxy). For the first model, I merged this COVID data with county-level popular vote share data for 2000-2016. 

Click [here](https://yanxifang.github.io/Gov-1347) to return to the front page.
