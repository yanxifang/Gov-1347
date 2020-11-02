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

## Intro: Safe States
**My model will actually *not* include all 50 states**, because there are states that are either so solidly Democratic (e.g. California, Massachusetts, New York) or so solidly Republican (e.g. Alaska, North Dakota, Wyoming), to the extent that their inclusion may even distort the rest of my model. 

**I define these states by looking at their historical voting data since 1992**, which is immediately after the consecutive Republican landslides of the 1980s. If a state has voted consistently for one party from 1992 to 2016 (7 elections), then I will exclude those states from consideration. However, I did remove Texas from the list of "solidly Republican" states in response to recent media coverage (see [New York Times](https://www.nytimes.com/2020/10/29/us/politics/texas-battleground-state.html) and [Time](https://time.com/5904873/texas-blue-biden-trump/), both 10/29/2020).

Below is a visualization of these states, with Nebraska and Maine also removed due to the presence of a more complicated system for allocating Electoral College votes:

![Safe States, 1992-2016](https://yanxifang.github.io/Gov-1347/images/safe_states_1992_2016.png)

When putting everything together, these "safe" states already provide **192** electoral votes for Biden, and **59** electoral votes for Trump. This is not so surprising given the large populations of the West Coast and the Northeast, both of which lean heavily Democratic.

**After designating 25 states (plus Washington, D.C.) as safe states for either party, this leaves only 25 states to consider in my model.**

## Model Description & Justification
Based on my analysis in previous weeks, **I found that polling data was the most convincing information to use. While there is an obvious disadvantage caused by the sparse state-level polls, it is one of the most observable factors out of the ones I learned about.** For instance, advertisement spending and campaign ground operations are both likely to be kept secret until post-election for strategic reasons, while the size of federal grant funding (a potential source of incumbency advantage), as well as the potential impact of an unprecedented shock (e.g. COVID-19), are difficult to fully capture. Meanwhile, the other easily observable factor, economic data, has been adversely disrupted in 2020, mainly by a 31.4% decline in real GDP for the second quarter.

However, those findings were based on all 50 states (plus DC), but now, only 25 states are in consideration. This justifies revisiting each of the factors that I've considered so far:

- **Historical Data**: I've already accounted for this, with the "safe" state assumption and the resulting 25-state model.
- **Economy**: State-level unemployment was originally a poor predictor, but I found additional data from the [U.S. Bureau of Economic Analysis (BEA)](https://apps.bea.gov/regional/downloadzip.cfm), now focusing on quarterly state-level personal income level (similar to GDP, but state-level). In order to account for differences in the absolute size of each state economy, I used the percentage change in income instead. *This variable actually had a significant impact when combined with the polling model, greatly improving the R-squared value!*
- **Polling**: I continue to rely on state-level polling due to the high historical correlation, despite the limitations of cost and scarcity of data.
- **Air War / Ground Campaign**: I decided not to consider mass-media advertising or ground-level campaign activities. The data for this election cycle is scarce (for obvious strategic reasons), and potentially unreliable. Furthermore, there is only sparse data for the past several elections, making it difficult to generate a model.
- **Shocks**: In theory, the effects of shocks, particularly the COVID-19 pandemic, should be already reflected in the polling data. Furthermore, even with COVID-19 cases and death data, I would still need to make an arbitrary determination about the size of the COVID-19 effect, which is not so mathematically sound.
- **Laws & Administration**: Given that virtually all states and territories have changed their election laws to permit greater flexibility amid the COVID-19 pandemic, the effect of changes would again require an arbitrary determination.

## Model Formula / Coefficients and Justifications
After considering these factors, I decided to stick to a simpler approach, using only **historical data**, **the economy**, and **polling**. Again, only 25 states will be considered in the model (with the remaining considered either solidly Democratic or solidly Republican). These 25 states are:

| Arizona | Arkansas | Colorado | Florida | Georgia |
| Indiana | Iowa | Kentucky | Louisiana | Maine |
| Michigan | Missouri | Montana | Nebraska | Nevada |
| New Hampshire | New Mexico | North Carolina | Ohio | Pennsylvania |
| Tennessee | Texas | Virginia | West Virginia | Wisconsin |

These are my considerations and justifications for using the other two variables:

In terms of the economy, I was quite disappointed earlier this semester that the state-level unemployment turned out to be a poor predictor of election outcomes. Since economic conditions do vary across the 50 states, implying that voters in different geographical locations are likely to have different perceptions of the economy, I ruled out using a national model. **Instead, I used a dataset from the U.S. Bureau of Economic Analysis that included quarterly state-level total personal income, an indicator somewhat similar to GDP. This is useful because it is a direct measure of income received by individuals.** There are two challenges. First, states obviously vary in size and thus have different absolute amounts of income. I mitigated this issue by using percentage changes instead, which should not be an issue because the "declining returns to scale" principle is not applicable here. Second, relying on one quarter is usually not a good practice, so instead, I decided to rely on four quarters (a fully year) to form my model: the last quarter of the year before election year, and the first three quarters of the election year in question. I then calculated the three changes in income level (4th to 1st, 1st to 2nd, 2nd to 3rd), in percentages relative to the new income level (i.e. with the later-period income being the denominator). The average of these three percentages was used in my model, and while it did not create a meaningful model individually (producing an abysmal R-squared value of around `0.02`), it increased the polling model's R-squared value by around `0.12` when added.

For the polling, I used the **historical presidential state-level poll averages data from Week 3. Again, my cut-off date was 45 days before the election**, since that was the median on the historical dataset. Polling averages constitute a very valuable determinant of the actual election outcome, because of the "wisdom of the crowd" and the greater accuracy that one can expect when many predictions are put together (and because of the many other reasons described in my [Week 3 post](https://yanxifang.github.io/Gov-1347/2020/09/25/Week-Three-Predictions.html)). By itself, the polling produced a much more meaningful model than the economic data, with a R-squared value of around `0.73`. This was enhanced significantly by adding the economic model, leading to a final value of `0.85`.

**For both of these variables, I was also bound by constraints in making my determination**. For instance, the BEA has not compiled/published the majority of the 2020 economic data, and I felt that the state-level personal income was the best indicator available (and even then, it is only available up until 2020Q2, which meant that I had one fewer quarter to base my 2020 calculations upon). Furthermore, as previously mentioned, there was not much data on media/advertising spending, while estimating the impacts of COVID-19 would require an arbitrary decision as to the number of deaths required to induce a notable decline in the incumbent's popular vote share. 

With the considerations and justifications addressed, here is my model:

![Final Prediction Model](https://yanxifang.github.io/Gov-1347/images/final_model.PNG)

As mentioned above, the variables are as follows:
- **avg_poll**: The average state-level poll results from polls released 45 days or fewer prior to the election. The 2020 data is taken from [FiveThirtyEight](https://github.com/fivethirtyeight/data/tree/master/polls), and I used the non-adjusted polling average.
- **avg_delta_inc**: The average of three different percent changes in state-level total personal income: from the 4th quarter of the year before election year to the 1st quarter of election year, from the 1st to 2nd quarter of election year, and from the 2nd to 3rd quarter of election year. This data is from the [U.S. Bureau of Economic Analysis (BEA)](https://apps.bea.gov/regional/downloadzip.cfm). For 2020, I only used the average of the first two changes mentioned, since third-quarter state-level total personal income for 2020 is not yet available.
- **candidate_pv**: The predicted percent of the popular vote received by the incumbent candidate.

## Model Prediction
The model above predicts the following outcomes for 2020: `215 EVs` for Trump, and `63 EVs` for Biden. This *excludes* Nebraska and Maine, since they have non-traditional methods of apportioning electoral votes (my model is not sophisticated enough to account for these deviations).

However, even when excluding Nebraska and Maine and just adding those initial outcomes to the `59` and `192` EVs already received from the "safe state" analysis, the final results are:

| Candidate | Electoral Votes |
| --- | --- |
| Biden (D) | 255 |
| Trump (R) | 274 |
| Unallocated (ME) | 4 |
| Unallocated (NE) | 5 |
| Total Possible | 538 |

This indicates a *very* narrow victory for Trump, which is surprising because the model is heavily based on polls, which, for the most part, predict a strong Biden victory. Below is the map of these results:

![Final Prediction Map](https://yanxifang.github.io/Gov-1347/images/final_prediction_map.png)

As shown above, Trump is predicted to prevail in the battleground states of Ohio, Pennsylvania, Florida, Arizona, Georgia, Iowa, and North Carolina. However, Biden is successful in Nevada, Minnesota, Wisconsin, Michigan, and New Hampshire.

## Model Validation: In-Sample and Out-of-Sample
The in-sample fit of my model is quite good, with a R-squared value of `0.8512`. This indicates a high degree of explanatory value for the historical data, which range from 1972 to 2016 for the polls, covering a span of 12 elections (and at least 25 data points for each election, since 25 states are considered). However, the mean-squared error (MSE) is `2.3601`, which is somewhat large considering that many states have predicted vote shares for Trump that are close to 50 percent.

In leave-one-out out-of-sample validation, I decided to leave out 2016. This was for a single practical, significant reason: many polls incorrectly predicted the outcome of the 2016 election (heavily favoring Hilary Clinton), and since my model is heavily dependent on polls, perhaps 2016 was a fluke that either contributed positively or negatively toward my model. As it turns out, the R-squared value dropped slightly to `0.8151`, with significant changes to the model: the constant is now `4.38310` (higher than before), and the poll coefficient is now `0.94073` with the income change coefficient being `0.77324` (both lower than before). The median and mean of the residuals were `0.5155` and `0.5424` respectively, which is not too bad since the 2020 predictions do not have many states that are within 0.5% of 50%.

## Uncertainty and Predictive Intervals
There is great uncertainty surrounding this model. These are the predictive intervals for the states that are closest to a 50% popular vote share for Trump:
| State | Predicted | Lower Bound | Upper Bound | EVs | Predicted Winner
| --- | --- | --- | --- | --- |
| Michigan | 49.04610 | 48.49331 | 49.59888 | 16 | D |
| Nevada | 49.97832 | 49.31287 | 50.64398 | 6 | D |
| Pennsylvania | 50.39226 | 49.88968 | 50.89483 | 20 | R |
| Arizona | 50.42192 | 50.00182 | 50.84202 | 11 | R |
| Florida | 50.38381 | 50.06392 | 50.70369 | 29 | R |
| North Carolina | 50.63261 | 50.36750 | 50.89771 | 15 | R |

## Conclusion

Click [here](https://yanxifang.github.io/Gov-1347) to return to the front page.
