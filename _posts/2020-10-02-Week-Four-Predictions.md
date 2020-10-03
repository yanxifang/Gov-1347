---
title: "Week 4 Analysis: The Incumbency (Dis)Advantage"
date: 2020-10-02
---

## Week 4 Analysis: The Incumbency (Dis)Advantage
*Friday, October 2, 2020*

This week, I will analyze the concept of incumbency, with a specific focus on whether changes in federal funding can affect electoral support for either the incumbent or challenger (or both) in a presidential election.

### Assumptions & Theoretical Background
The impact of government funding -- and specifically, federal-level funding -- has long been considered influential in American politics. The term "pork barrel" has been used to describe Congressionally-allocated funding targeted at a member's district or some other special interest, as described in [this article](https://www.brookings.edu/articles/the-new-pork-barrel-whats-wrong-with-regulation-today-and-what-reformers-need-to-do-to-get-it-right/) from the Brookings Institution. However, as discussed by [Kriner and Reeves (2012)](https://www.cambridge.org/core/journals/american-political-science-review/article/influence-of-federal-spending-on-presidential-elections/D7E15E901EA52BF92E5986626766224F), this "pork" can also have an impact on presidential elections, particularly in counties where the Congressional members are from the same party as an incumbent president. In addition to implying that incumbents are advantaged because of their ability to spend, this analysis suggests that there is some basis to the economy-based fundamentals approach of predicting elections, since the purpose of federal funding is to boost the local economy.

However, the COVID-19 pandemic has significantly changed the scope of federal funding in 2020. This year, through the CARES Act and other legislation, the federal government has distributed a large amount of funds to not only state and local governments, but also directly to citizens. This means that even if the data were available, it would not be reasonable to make a prediction about the effect of federal funding on incumbency, since the regression model would have been fitted using data from previous election years, when funding levels were substantially lower. Instead, this week, I will be re-visiting my earlier "fundamentals" model about the economy, with the goal of finding a more definitive answer to the question of incumbency and retrospective voting.

### Does Incumbency Matter in 2020? (& The Time-for-Change Model)
2020 is a unique year: the COVID-19 pandemic has caused both significant disruption to the economy *and* unprecedented amounts of federal aid being disbursed. The first situation seems to indicate declining support for the incumbent, Trump, while the second seems to indicate stronger support. Do these two effects cancel each other out, or does one of the two have a greater impact on the electorate's support?

Since there isn't enough data to answer that question, perhaps there's an alternate approach. For instance, Alan Abramowitz's [time-for-change model](https://www.cambridge.org/core/journals/ps-political-science-and-politics/article/will-time-for-change-mean-time-for-trump/6DC38DD5F6346385A7C72C15EA08CA09) suggests that it is difficult for the incumbent party to win a third consecutive term in the White House, as the Democratic Party would have done had Hilary Clinton won the 2016 election. Abramowitz's model is based on just three variables: Q2 GDP growth, Gallup job approval, and an incumbent term: whether the incumbent party has held the presidency for just one term, or more than one term. Since this model was unique in correctly predicting a Trump victory in 2016, it may be informative for 2020 as well.

The model, as described by [PollyVote](https://pollyvote.com/en/components/models/retrospective/fundamentals-plus-models/time-for-change-model/), is as follows:

``(2-Party Vote Share) = Constant + 0.108(Net Approval Rating) + 0.543(Q2 GDP Growth) + 4.313(First-Term Incumbent)``

where the value is 1 if there is a first-term incumbent (e.g. in 2020), and 0 if there is not a first-term incumbent in the race (e.g. in 2016).

### Model Prediction
Since much of the discussion about incumbency has centered around the concept of retrospective accountability, and since federal funding is tied to voters' perception of the economy (at least at the local level), I think it's prudent to revisit my [earlier economic models](https://yanxifang.github.io/Gov-1347/2020/09/18/Week-Two-Predictions.html) and try to incorporate incumbency as an additional variable.
