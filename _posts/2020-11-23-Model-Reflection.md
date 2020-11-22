---
title: "Post-Election Model Reflection"
date: "2020-11-23"
---

## Post-Election Model Reflection
*Monday, November 23, 2020*

## Recap: Model & Predictions
In building my predictive model, I considered many of the factors that could potentially influence election results, ranging from demographics to the incumbency advantage. Ultimately, I settled on a model that a) considers state-level polling and economic performance as measured by changes in state nominal income, and b) excluded "safe" states, as defined by a state's voting pattern from 1992 to 2016. As described in my [November 1 blog post](https://yanxifang.github.io/Gov-1347/2020/11/01/Final-Prediction-Model.html), the model equation was as follows...

![Final Prediction Model](https://yanxifang.github.io/Gov-1347/images/final_model.PNG)

...where the variables are:
- **avg_poll**: The average state-level poll results from polls released 45 days or fewer prior to the election. The 2020 data is taken from [FiveThirtyEight](https://github.com/fivethirtyeight/data/tree/master/polls), and I used the non-adjusted polling average.
- **avg_delta_inc**: The average of three different percent changes in state-level total personal income: from the 4th quarter of the year before election year to the 1st quarter of election year, from the 1st to 2nd quarter of election year, and from the 2nd to 3rd quarter of election year. This data is from the [U.S. Bureau of Economic Analysis (BEA)](https://apps.bea.gov/regional/downloadzip.cfm). For 2020, I only used the average of the first two changes mentioned, since third-quarter state-level total personal income for 2020 is not yet available.
- **candidate_pv**: The predicted percent of the popular vote received by the incumbent candidate.

This model resulted in a prediction of `274 EVs` for Trump and `255 EVs` for Biden, with both Maine and Nebraska's electoral votes unalloted due to their unique apportioning systems. This is visualized below:

![Final Prediction Statebins](https://yanxifang.github.io/Gov-1347/images/final_prediction_statebins.png)

## Model Accuracy

## Hypotheses

## Proposed Hypothesis Tests

## Lessons Learned
