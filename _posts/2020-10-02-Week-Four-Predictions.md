---
title: "Week 4 Analysis: The Incumbency (Dis)Advantage"
date: 2020-10-02
---

## Week 4 Analysis: The Incumbency (Dis)Advantage
*Friday, October 2, 2020*

This week, I will analyze the concept of incumbency, with a specific focus on whether changes in federal funding can affect electoral support for either the incumbent or challenger (or both) in a presidential election.

### Assumptions & Theoretical Background
The impact of government funding -- and specifically, federal-level funding -- has long been considered influential in American politics. The term "pork barrel" has been used to describe Congressionally-allocated funding targeted at a member's district or some other special interest, as described in [this article](https://www.brookings.edu/articles/the-new-pork-barrel-whats-wrong-with-regulation-today-and-what-reformers-need-to-do-to-get-it-right/) from the Brookings Institution. However, as discussed by [Kriner and Reeves (2012)](https://www.cambridge.org/core/journals/american-political-science-review/article/influence-of-federal-spending-on-presidential-elections/D7E15E901EA52BF92E5986626766224F), this "pork" can also have an impact on presidential elections, particularly in counties where the Congressional members are from the same party as an incumbent president. 

This analysis suggests that incumbents are advantaged because they are able to use public funds to essentially "buy" votes, particularly in areas that tend to swing between the two parties. While this might sound ethically unsound, it is also compatible with the idea that democracies should be responsive to citizens' needs: a legislator (or a president) that directs funds to a certain area are responding to local needs that would otherwise have gone unfunded. More importantly, the pork analysis also implies that the economy-based fundamentals approach of predicting elections is valid, since the ultimate purpose of federal funding is to boost the local economy.

### Does Incumbency Matter in 2020?
However, the COVID-19 pandemic has significantly changed the scope of federal funding in 2020. This year, through the CARES Act and other legislation, the federal government has distributed a large amount of funds to not only state and local governments, but also directly to citizens. This means that even if the data were available, it would not be reasonable to make a prediction about the effect of federal funding on incumbency, since the regression model would have been fitted using data from previous election years, when funding levels were substantially lower. Instead, this week, I will be re-visiting my earlier "fundamentals" model about the economy, with the goal of finding a more definitive answer to the question of incumbency and retrospective voting. 

2020 is a unique year: the COVID-19 pandemic has caused both significant disruption to the economy *and* unprecedented amounts of federal aid being disbursed. The first situation seems to indicate declining support for the incumbent, Trump, while the second seems to indicate stronger support. Do these two effects cancel each other out, or does one of the two have a greater impact on the electorate's support?

### Quantifying the Impact of Incumbency: The Time-for-Change Model

Since there isn't enough data to answer that question, perhaps there's an alternate approach. For instance, Alan Abramowitz's [time-for-change model](https://www.cambridge.org/core/journals/ps-political-science-and-politics/article/will-time-for-change-mean-time-for-trump/6DC38DD5F6346385A7C72C15EA08CA09) suggests that it is difficult for the incumbent party to win a third consecutive term in the White House, as the Democratic Party would have done had Hilary Clinton won the 2016 election. Abramowitz's model is based on just three variables: Q2 GDP growth, Gallup job approval, and an incumbent term: whether the incumbent party has held the presidency for just one term, or more than one term. Since this model was unique in correctly predicting a Trump victory in 2016, it may be informative for 2020 as well.

The model, as described by [PollyVote](https://pollyvote.com/en/components/models/retrospective/fundamentals-plus-models/time-for-change-model/), is as follows:

``(2-Party Vote Share) = Constant + 0.108(Net Approval Rating) + 0.543(Q2 GDP Growth) + 4.313(First-Term Incumbent)``

where the constant is 47.260, and the incumbent value is 1 if there is a first-term incumbent (e.g. in 2020), and 0 if there is not a first-term incumbent in the race (e.g. in 2016). There are two things to note: first, this model was used to predict the 2016 election, and thus does not include the results of that election, and second, Abramowitz has added a "polarization" variable starting in 2012. For purposes of simplicity (since polarization is hard to quantify), I will be ignoring that variable for my model.

When incorporating the 2016 election, the new regression equation is:

``(2-Party Vote Share) = Constant + 0.103(Net Approval Rating) + 1.764(Q2 GDP Growth) + 2.877(First-Term Incumbent)``

where the constant is now slightly lower at 47.176. The adjusted R-squared value for this model is `0.685`, which is good but not ideal. Furthermore, neither the GDP growth nor incumbent coefficients are statistically significant at the 95% confidence level: they have p-values of `0.05683` and `0.09544`, respectively. Here, the high p-values of the coefficients actually don't mean much: the sample size is small (only 18 elections from 1948 to 2016, inclusive), so the possibility of making an inference error is somewhat high. 

The relationships between each of the independent variables (net approval rating, Q2 GDP growth, and first-term incumbency) are visualized below:

![Time-for-Change Visualization](https://yanxifang.github.io/Gov-1347/images/timeforchange.png)

Unfortunately, using this model may not be optimal for 2020, again due to the COVID-19 pandemic. As seen above, the coefficient for second-quarter GDP growth is quite high at `1.764`; the U.S. Bureau of Economic Analysis has [reported](https://www.bea.gov/news/2020/gross-domestic-product-state-2nd-quarter-2020) that the 2020 second-quarter GDP growth is `-31.4%`. This value, by itself, has an impact of `-55.39`; even with an unrealistically high 100% approval rate, the model would predict that Trump has a 2-party vote share of: `47.176 + 0.103(100) + 1.764(-31.4) + 2.877(1) = 4.9634` percent, which is far too low for obvious reasons.

Is Abramowitz's original model (the one used to predict 2016) any better, since it uses a substantially smaller coefficient for Q2 GDP growth? Using the same `-31.4%` value, and the same 100% approval, Trump is predicted to have `47.260 + 0.108(100) + 0.543(-31.4) + 4.313(1) = 45.3228` percent of the popular vote. But, when reducing the approval rating to a more realistic 50%, Trump is expected to receive `39.9228` percent. While a 60-40 split in the 2-party popular vote would likely resemble a landslide (see my [Week 1 blog post](https://yanxifang.github.io/Gov-1347/2020/09/11/Week-One-Predictions.html) for a discussion of the 1972 and 1984 elections), this is actually not a bad prediction because Abramowitz could possibly add a partisanship variable, as he did for 2012; this would likely be in Trump's favor because going beyond 60-40 would be unprecedented.

**As seen above, the time-for-change model is not particularly predictive for 2020. However, it suggests that there is actually an incumbency *dis*advantage for Trump.** Under this model, Trump will bear the weight of the economic downturn caused by COVID-19 related lockdowns. Furthermore, although Trump will benefit from being a first-term incumbent, that benefit is dwarfed by the negative effect of the economy. Nonetheless, it is important to note that the model does not take into account any "pork-barrel" (or general) spending; as discussed earlier, federal spending is likely to be a factor in the 2020 presidential election because it has directly impacted many citizens (i.e. through stimulus checks).

### Model Prediction
Since incumbency is very much a "fundamentals" approach to predicting elections, in the sense that it is centered around the concept of retrospective accountability, I think it's prudent to revisit my [earlier economic models](https://yanxifang.github.io/Gov-1347/2020/09/18/Week-Two-Predictions.html) and compare them to the time-for-change model.

Click [here](https://yanxifang.github.io/Gov-1347) to return to the front page.
