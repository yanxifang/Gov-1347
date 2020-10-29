---
title: "Final Prediction Model for 2020"
date: "2020-11-01"
---

## Final Prediction Model for the 2020 U.S. Presidential Election
*Sunday, November 1, 2020*

## Intro: The Factors
Over the past few months, I've studied many of the factors that potentially affect election results, ranging from the economy to shocks, to demographics and the incumbency advantage. Along the way, I created many models looking at those factors individually, which included:

- Historical Election Results
- State of the Economy, and Other Fundamentals
- Polling Data
- Incumbency (Dis)advantage
- Air War / Media Spending
- Ground Game / Campaign Efforts
- Shocks, and the COVID-19 Pandemic
- Laws and Administration

Today, I will be putting everything together to create a single model - and one prediction - for the outcome of the 2020 U.S. presidential election.

## Model Description & Justification
Based on my analysis in previous weeks, **I found that polling data was the most convincing information to use. While there is an obvious disadvantage caused by the sparse state-level polls, it is one of the most observable factors out of the ones I learned about.** For instance, advertisement spending and campaign ground operations are both likely to be kept secret until post-election for strategic reasons, while the size of federal grant funding (a potential source of incumbency advantage), as well as the potential impact of an unprecedented shock (e.g. COVID-19), are difficult to fully capture. Meanwhile, the other easily observable factor, economic data, has been adversely disrupted in 2020, mainly by a 31.4% decline in real GDP for the second quarter.

**My model will actually *not* include all 50 states**, because there are states that are either so solidly Democratic (e.g. California, Massachusetts, New York) or so solidly Republican (e.g. Alaska, North Dakota, Wyoming), to the extent that their inclusion may even distort the rest of my model. I define these states by looking at their historical voting data since 1992, which is immediately after the consecutive Republican landslides of the 1980s. If a state has voted consistently for one party from 1992 to 2016 (7 elections), then I will exclude those states from consideration. However, I did remove Texas from the list of "solidly Republican" states in response to recent media coverage (see [New York Times, 10/29/2020](https://www.nytimes.com/2020/10/29/us/politics/texas-battleground-state.html)).


## Model Formula

## Coefficients, Weights, and Justifications

## Model Validation: In-Sample and Out-of-Sample

## Uncertainty and Predictive Intervals

## Graphics

Click [here](https://yanxifang.github.io/Gov-1347) to return to the front page.
