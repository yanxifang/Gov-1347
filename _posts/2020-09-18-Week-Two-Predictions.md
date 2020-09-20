---
title: "Week 2 Analysis: Economic Data, 1948-2016"
date: 2020-09-18
---
## Week 2 Analysis: Economic Data, 1948-2016
*Friday, September 18, 2020*

This week, I am analyzing the impact of economic conditions on election results. I will mainly use GDP and unemployment data as two proxies for prevailing economic conditions at the national level, and state-level unemployment data as a proxy for more localized economic factors.

### Assumptions and Theoretical Background
**Using economic data to predict elections is rooted in the assumption of "pocketbook voting", where voters make decisions based on their evaluations of the economy.** If voters do not actually consider the economy as they enter the voting booth, this analysis wouldn't be meaningful at all. Fortunately, there is much literature about the role of the economy in U.S. presidential elections. For example, [Achen and Bartels (2017)](https://www.jstor.org/stable/j.ctvc7770q) observe that while voters tend to respond to economic changes, the incumbent president generally has little control over the economy. Moreover, they argue that voters hold unrealistic time horizons, unreasonably discount economic performance in the earlier part of an incumbent's term, and have difficulty distinguishing the economic changes that occur between different leaders. This argument is similar to that expressed by [Healy and Lenz (2014)](https://www.jstor.org/stable/24363467) about election-year economics and the potential of adversely selecting a president that is good at economic manipulation.

To test these two theories, I will analyze the relationship between short-term GDP (and unemployment) data and election outcomes, and **explore an alternate theory: that voters are concerned both about the short-term economy and their personal economic prospects.** I will use state-level unemployment data as a proxy for "personal economic prospects"; after all, if the unemployment rate in a hypothetical area is very high, it is likely that a voter or their immediate family will be impacted. Before performing the analysis, my prediction is that state-level data is a better predictor than the short-term economy as measured by either GDP or unemployment.

### National Level GDP Data
The logical place to start is with national-level GDP. GDP is [often used](https://www.stlouisfed.org/open-vault/2019/march/what-is-gdp-why-important) as an indicator of an economy's overall size and health, and when compared to previous periods, GDP can tell whether the economy is expanding or contracting. Under the "pocketbook voting" assumption, voters will respond negatively to an incumbent seeking re-election (or a candidate from the term-limited incumbent's party) if GDP growth is poor.

I will be using **changes in second-quarter GDP** and the **national-level 2-party vote share** as the two variables in my analysis. I am using national-level vote share data because GDP is an inherently national measure. I am focusing specifically on the second-quarter of each election year because of (a) the Achen and Bartels model, (b) the value of early predictions, and (c) the unavailability of third-quarter data. First, as stated earlier, Achen and Bartels argue that voters hold unique time horizons and significantly discount the earlier economic performance of an incumbent. I agree with this assumption. According to the Pew Research Center, [only 36% of registered voters](https://www.pewresearch.org/politics/2020/06/02/in-changing-u-s-electorate-race-and-education-remain-stark-dividing-lines/) have a 4-year college degree. This means that the majority of registered voters (and thus the "average" voter) may have difficulty comprehending the many different types of economic reporting that come from the media, and it is likely that this group will remember only the latest reporting (i.e. second-quarter GDP results). Additionally, at least for 2020, second-quarter GDP data is [released by the Bureau of Economic Analysis](https://www.bea.gov/news/schedule/full) on July 30, while third-quarter data is unavailable until October 29, just a few days before the election. This means that second-quarter GDP is the most up-to-date information that is available, since last-minute forecasts are minimally useful (for example, a forecast of rainy weather is not useful if the first time you see the forecast is after you left your umbrella at home).

Below are the results of my analysis. Notably, **there is not a strong relationship between changes in second-quarter GDP and the national-level 2-party vote share**. The regression equation is:
```
(Nat'l 2-Party Vote Share) = 49.449 + 2.969 * (Change in Second-Quarter GDP)
```

### National Level Unemployment Data

### State Level Unemployment Data

### Implications & Conclusions
Economic analysis is limited because **only the first- and second-quarter GDP and unemployment rates of an election year can be used.** Although historical data is available for past election years, the current election year's third-quarter GDP will not be released until [October 29](https://www.bea.gov/news/schedule), which is just a few days before the election. 

**A significant assumption in this analysis is that a party's non-incumbent nominee will implement similar policies as their predecessor when the party seeks a third consecutive term. This is likely to become a factor in elections beyond 2020.** While this hasn't been the case for any of the [7 times](https://thehill.com/blogs/pundits-blog/presidential-campaign/238812-is-it-that-hard-for-a-party-to-hold-the-white-house) between 1948 and 2016 when the incumbent party had the opportunity to hold office for more than two consecutive terms (or for the 2 cases - Truman in 1952 and Johnson in 1968 - where the incumbent was eligible to run for re-election but chose not to), this is likely to become a factor in the future. Specifically, Donald Trump's economic policy has been unorthodox (and a more traditional Republican candidate is likely to propose substantially different policies), while elements of the Democratic Party are calling for unprecedented levels of government intervention and involvement in the economy (a significant departure from Joe Biden's more traditional proposals).
