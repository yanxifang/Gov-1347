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
Nationally, the semi-final electoral vote count is 306 to 232, compared to my prediction of 255 and 274. **While there is a seemingly large discrepancy of `51 EVs` for Biden, it was the result of incorrectly predicting the outcome in *just three states***: Georgia, Nevada, and Pennsylvania. These states have 11, 16, and 20 electoral votes respectively, accounting for 47 EVs; the remaining 4 EVs come from the states of Maine and Nebraska, for which my model did not generate predictions. 

Looking more specifically at these three states, the differences are somewhat large, considering that the predicted values are so close to 50 percent. Note that my model predicted the Republican Party's share of the *total* vote, *not* the 2-party voteshare, so the values listed under `actual` in the table below will differ slightly from the `pv2p` values in the common class dataset.

| State | Predicted (R) | Actual (R) | Difference |
| --- | --- | --- | --- |
| Arizona | 50.42192 | 48.940088 | 1.4818342 |
| Georgia | 51.62904 | 49.236990 | 2.3920496 |
| Pennsylvania | 50.39226 | 48.865881 | 1.5263749 |

More generally, when considering all 25 states for which my model predicted a percentage of the popular vote, my root mean squared error (RMSE) was `8.748868`, which is slightly worse than the class average of `6.81`. The state-level errors (i.e. differences in vote share, as calculated by *Predicted* minus *Actual*) are visualized below:

![Final Prediction Errors](https://yanxifang.github.io/Gov-1347/images/final_prediction_residuals_color.png)

From this "residual" plot, I made the following conclusions:

- **6 states had more than a 2 percentage-point difference between the predicted and actual vote share.** Two were Republican-voting states, and four were Democratic-voting. These states, in descending order (highest to lowest error), are: Arkansas, New Mexico, Colorado, Tennessee, Georgia, and Nevada.
- An examination of the underlying data shows that **Arkansas** was the state with the greatest error: my model under-predicted Trump's vote share by more than 4.6 percentage points. This is surprising because I had expected my model to over-predict Trump's vote share in general.
- **Overall, my model under-predicted for more Democratic states than it over-predicted for Republican states.** This was not unexpected: as explained when I initially laid out the model, the economic data is flawed because it reflects an increase in income for the most recent period (2020:Q2), despite the fact that many Americans are out of work due to COVID-19. Since rational voters would reward incumbents for good economic performance, this overly-optimistic snapshot of the economy would have "helped" Trump when making the predictions.

Below is a geographic visualization of the errors:

![Final Prediction Accuracy](https://yanxifang.github.io/Gov-1347/images/final_prediction_accuracy.png)

Some takeaways from this visualization (and a careful inspection of the underlying data):

- As shown in green, **my assumptions about "safe states" were correct**: all of the 25 states (plus DC) that my model designated as "safe states" remained as such, meaning that they now have consistently voted for the same party for a total of 8 elections, from 1992 to 2020. While others have noted (in class) that 45 states remained safe between the 2016 and 2020 election, I believe that going back further in time is more rigorous approach.
- **There are no evident patterns in my errors.** For instance, while I under-predicted the winning party's voteshare in *both* solidly-blue states (e.g. New Mexico, Colorado) and solidly-red states (e.g. Arkansas, Tennessee), similarly "safe" states like Virginia, West Virginia, and Kentucky had much smaller margins of under- or over-prediction. Similarly, while I (correctly) predicted that both Wisconsin and Michigan would vote Democratic, my model under-predicted the Republican vote share in one state and over-predicted in the other, again showing the lack of a pattern in the errors.

## Hypotheses
**There are two distinct categories for hypothesizing about my model's errors: one focused on the model components that I used, and one focused on potential components that I omitted from the model.** Both are important for explaining why my model was ultimately inaccurate overall (i.e. predicting a Trump victory by a slim EV margin), and for explaining why my model had such large errors in what should be easy-to-predict states like Arkansas, Tennessee, Colorado, and New Mexico.

I will first address the two model components that were used in the model: the economic data (changes in the state-level gross income, as tabulated by the U.S. BEA), and the polling averages (data from FiveThirtyEight). As mentioned in developing the model, these two sources of data had a R-squared value of more than `0.85`, which reflects a high explanatory value for understanding the fluctuations in state-level outcomes for elections between 1972 and 2016, inclusive. However, there are a few potential issues with these two independent variables, some of which I explained when introducing the model. They are:

- **Unavailability of more recent economic data for 2020.** When I made the model, the most recent state-level economic data available from the Bureau of Economic Analysis (BEA) was for 2020:Q2, which ended June 30, 2020. During Q2, the government's stimulus spending (in response to the COVID-19 pandemic) was at its peak: there was substantial funding directed at state governments, while many individuals received $1200 stimulus checks and $600/week unemployment benefit supplements. Due to these unprecedented levels of spending, the state-level gross income rose considerably between 2020:Q1 and 2020:Q2, reflecting a marked improvement in economic conditions despite the fact that many people were unemployed amid the COVID-19 lockdowns and downturn. This gap between the data and voters' perception of the economy is likely to lead to errors, particularly because my model uses the change in state-level gross income as a proxy for the economy.
- **Issues with COVID stimulus when using state-level gross income as a proxy for the economy.** Perhaps the state-level gross income is not such a good proxy for overall economic conditions at the state-level, as it may induce some type of an omitted variable bias. In particular, my thought is that states that were poorer pre-COVID are likely to have received proportionally more government stimulus, because a) there is an income cap on the $1200 stimulus checks, and b) the $600 unemployment supplement only reached the unemployed, who are relatively less educated and poorer than higher-educated individuals who were able to transition to remote work (and thus remain employed). This meant that the state-level economy of poorer states, as portrayed by the 2020:Q2 data, was far more optimistic than the reality -- especially due to the fact that by election day, both of those stimulus channels had dried up for voters. In other words, because I used state-level gross income as a proxy for the economy, the model could have had different errors for poorer versus richer states.
- **Trump-specific unreliability of polls.** The other major component of my model was the average of polls gathered at various points prior to the election. As evidenced by the fact that the 2020 polls predicted a wide-margin Biden victory (as well as a 2016 Clinton victory), polls *on average* seem to perform poorly in estimating Trump's voteshare. Among other factors, such inaccuracies could have been caused by the widely-discussed phenomenon of the "shy Trump voter", where individuals who ultimate vote for Trump are skeptical about pollsters and are less likely to respond truthfully - or at all. If there is such an inaccuracy in polling that specifically impacts Trump (and no other presidential candidate), then my model will necessarily have errors: out of the many elections (1972-2016) that my model was based on, only one (i.e. 2016) would have had such a different relationship between polls and election outcomes.
- **General lack of polls (or accurate polls) in certain states.** As we've discussed in class, polling is an expensive endeavor. Since polling results are only interesting in battleground or swing states, where the election outcome actually has a potential to matter on the national stage, it is likely that pollsters have little incentive to conduct multiple polls, or thorough polls, in states that are most likely going to vote for one of the two parties. This results in less-accurate polls, or very few polls at all, in certain states. While my model partially accounted for this phenomenon by designating 24 states (plus DC) as "safe" states, there are still 26 remaining states, and the vast majority of these 26 already lean one way or the other. I believe that this "safe state" lack of polling hypothesis applies for most of my highest-error states: Arkansas and Tennessee are solidly Republican, while Colorado and New Mexico are solidly Democratic.

Obviously, there are many other variables - beyond the economy and polling averages - that could partially explain the state-level election outcomes. My hypotheses for these other, "out-of-model" variables are:

- **Failure to consider messaging, policy platforms, and demographics.** For instance, as many pundits have pointed out, Biden's weakness in Florida was likely caused by the Republican Party's relentless efforts to describe him as a trojan horse for socialism, which alienated Cuban and Venezuelan voters and inspired them to vote for Trump instead. My model, which only includes state-level polling and a measure of the economy, clearly fails to explicitly consider the role of messaging and policy platforms. Instead, the only acknowledgement that my model gives to the fact that Trump and Biden have very different policy positions on critical issues is through polling: theoretically, if one candidate's policies are viewed as bad, then polls should reflect a lower level of support. This is very much an imperfect way of measuring policy stances - and how different voter demographics may respond to such policy stances differently.
- **COVID-19 has non-quantifiable impacts that go beyond polls and economic conditions.** I am particularly referring to the substantial loss of human life caused by the COVID-19 pandemic. This is not reflected in economic data (and certainly not in the state-level nominal income data, which actually increased despite the many deaths), and may not even be reflected in polling: distraught individuals and families suffering from stress or the loss of a loved one are expected to be less likely to respond to a political poll. In other words, I hypothesize that deaths or hospitalizations from COVID-19 are variables that my model omitted, and that if they were included, there would be a negative correlation between deaths/hospitalizations and Trump's voteshare, since he is the incumbent and is presumably held responsible for his handling of the situation.

## Proposed Hypothesis Tests
For my "in-model" hypotheses, I would perform the following tests (in theory):
- **Unavailability of more recent economic data:** wait until the BEA releases Q3 data for 2020, which will likely take place in the coming months. Since federal spending from the CARES Act has been severely curtailed in the 2-3 months leading up to Election Day (e.g. the expiration of the $600 unemployment supplement), this should be reflected in the level of state-level gross income that I use. With the Q3 data, I would re-run the model to find new predicted values; since I had used data up to Q3 for all the past election years in generating the model, I would expect that using 2020:Q3 data would greatly reduce the size of my errors. If the errors are, in fact, reduced overall, then it would prove my hypothesis that the Q2 economic data was an inaccurate representation of the economic conditions that voters faced on Election Day (or slightly earlier, if voting by mail). However, if the errors are similar or even larger in magnitude, that would imply that the state-level gross income is not a good proxy for economic conditions in the context of 2020 and the COVID-19 pandemic.
- **COVID stimulus and different impacts based on state wealth:** 


## Lessons Learned / What To Do Differently
If I were to create a model again, I would take a number of steps to change my model:
- **

Click [here](https://yanxifang.github.io/Gov-1347) to return to the front page.
