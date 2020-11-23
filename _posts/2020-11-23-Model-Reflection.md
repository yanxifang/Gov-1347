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

This model resulted in a prediction of `274 EVs` for Trump and `255 EVs` for Biden, with both Maine and Nebraska's electoral votes unalloted due to their unique apportioning systems. The model only predicted both the outcome and vote share for 25 states; to account for the concept of "safe states", the model only provides a binary outcome for the remaining 25 states (plus DC). This is visualized below:

![Final Prediction Statebins](https://yanxifang.github.io/Gov-1347/images/final_prediction_statebins.png)

## Model Accuracy
**Nationally, the semi-final electoral vote count is 306 to 232, compared to my prediction of 255 and 274.** While this is a seemingly large discrepancy of `51 EVs` for Biden, it was the result of incorrectly predicting the outcome in *just three states*: Georgia, Nevada, and Pennsylvania. These states have 11, 16, and 20 electoral votes respectively, accounting for 47 EVs; the remaining 4 EVs come from the states of Maine and Nebraska, for which my model did not generate predictions. 

Looking more specifically at these three states, the differences are somewhat large, considering that the predicted values are so close to 50 percent. Note that my model predicted the Republican Party's share of the *total* vote, *not* the 2-party voteshare, so the values listed under `actual` in the table below will differ slightly from the `pv2p` values in the common class dataset.

| State | Predicted (R) | Actual (R) | Difference |
| --- | --- | --- | --- |
| Arizona | 50.42192 | 48.940088 | 1.4818342 |
| Georgia | 51.62904 | 49.236990 | 2.3920496 |
| Pennsylvania | 50.39226 | 48.865881 | 1.5263749 |

More generally, when considering all 25 states for which my model predicted a percentage of the popular vote, my root mean squared error (RMSE) was `1.749774`. The state-level differences in vote share (i.e. `Predicted` minus `Actual`) are visualized below:

![Final Prediction Accuracy](https://yanxifang.github.io/Gov-1347/images/final_prediction_accuracy.png)

Some takeaways from this visualization (and a careful inspection of the underlying data):

- The states with the greatest absolute-value difference between the predicted and actual vote share, in descending order, are: **Arkansas, New Mexico, Colorado, Tennessee, Georgia, and Nevada.** Each of these states had more than a 2 percentage-point difference between the predicted and actual vote share values.
- **Arkansas** was the state with the greatest discrepancy: my model under-predicted Trump's vote share by more than 4.6 percentage points. This is surprising because I had expected my model to over-predict Trump's vote share in general.
- **Overall, my model under-predicted for more Democratic states than it over-predicted for Republican states.** This was actually expected: as explained when I initially laid out the model, the economic data is flawed because it reflects an increase in income for the most recent period (2020-Q2), despite the fact that many Americans are out of work due to COVID-19. This overly-optimistic snapshot of the economy would have "helped" Trump when making the predictions.
- As shown in green, **my assumptions about "safe states" were correct**: all of the 25 states (plus DC) that my model designated as "safe states" remained as such, meaning that they now have consistently voted for the same party for a total of 8 elections, from 1992 to 2020.

## Hypotheses
**My hypotheses for the model's errors can be sorted into two distinct categories**: hypotheses about the model components that I used, and hypotheses about potential components that I omitted from the model.

I will first address the two model components that were used in the model: the economic data (changes in the state-level gross income, as tabulated by the U.S. BEA), and the polling averages (data from FiveThirtyEight). As mentioned in developing the model, these two sources of data had a R-squared value of more than `0.85`, which reflects a high explanatory value for understanding the fluctuations in state-level outcomes for elections between 1972 and 2016, inclusive. However, there are a few potential issues with these two independent variables, some of which I explained when introducing the model. They are:

- **Unavailability of more recent economic data for 2020.** 
- **Continuing unreliability of polls in measuring the level of support for Trump, specifically.**
- **

Obviously, there are many other variables - beyond the economy and polling averages - that partially explain the state-level election outcomes.

## Proposed Hypothesis Tests

## Lessons Learned

Click [here](https://yanxifang.github.io/Gov-1347) to return to the front page.
