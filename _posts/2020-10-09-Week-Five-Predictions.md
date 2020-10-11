---
title: "Week 5 Analysis: Evaluating the Role of Advertising"
date: "2020-10-09"
---

## Week 5 Analysis: Productive Investment or Marketing Ploy? Evaluating the Role of Advertising
*Friday, October 9, 2020*

Advertising has sometimes been cited as important for a candidate's success in U.S. presidential elections. A few that I've seen prior to taking Gov 1347 include the ["Morning in America" ad](https://www.nytimes.com/2016/05/08/business/the-ad-that-helped-reagan-sell-good-times-to-an-uncertain-nation.html) (Reagan, 1984), the ["Daisy" ad](https://www.smithsonianmag.com/history/how-daisy-ad-changed-everything-about-political-advertising-180958741/) (Johnson, 1964), and the [infamous Willie Horton ad](https://www.nytimes.com/2018/12/03/us/politics/bush-willie-horton.html) (Bush, 1988). This week, I will analyze the impact of advertising on outcomes, and then add "advertising spending" as one of the predictors in my ongoing model for 2020.

## Assumptions & Theoretical Background
The impact of campaign advertisements - typically aired on television or radio - has been explored in existing literature as being limited in usefulness. For example, [Gerber et al. (2011)](https://www.jstor.org/stable/41480831?seq=1) show in a randomized field experiment that TV ads have large and statistically significant results on voter preferences, but that these effects disspiate rapidly, in as little as 1-2 weeks. This explanation would be comparable to (and compatible with) a fundamentals model, since it suggests that while voter preferences may fluctuate over the course of the election cycle, the net effect of advertising is negligible and voters ultimately prefer the candidate they would have originally chosen. However, this model is somewhat flawed because it is centered around a gubernatorial race in Texas, and specifically, a Republican incumbent facing a challenger in the primary; in such a scenario, potential voters already have a preference for the party, and in a partisan environment, it is not unreasonable for them to be ambigious about the candidate as long as the party is the same, irrespective of advertising.

I personally believe that advertising has some impact, and this is also the conclusion of [Huber and Arceneaux (2007)](https://www.jstor.org/stable/4620110?seq=1). They found, in a natural experiment covering non-battleground state areas that overlapped with battleground state TV broadcast markets, that voters do not receive new information through ads. Rather, ads persuade voters to change their minds due to the content of ads, which may be misleading, particularly in more recent years. 

When including advertising as a variable in my model, **a key assumption is that there are differences between campaigns.** This is not always the case: for example, fundamentals-only models are based on the assumption that only the existence - not the activities - of a campaign matters, since campaign efforts on both sides will balance out over the course of the months leading up to the election; if ad spending does have an effect, then the two campaign efforts cannot be the same.

## Visualizing the Data: Size of Advertising Campaigns
Something interesting to analyze is the size of advertising campaigns, as measured by cost. If advertising is as important as it is often considered to be, then candidates from the party that is not currently in office should be spending more on advertisements than their opponent, in the hope that the advertisements will convince voters to switch their vote. Although data is only available for the 2000, 2004, 2008, and 2012 elections, there are still many data entries to consider, since advertising is done at the local level. Below, I have created histograms showing the number of advertising campaigns by size (dollar amount) and party.

![2008 and 2012 Ad Campaign Sizes](https://yanxifang.github.io/Gov-1347/images/ad_campaign_size_2008_2012.png)

From an initial inspection of these histograms, **it appears that campaigns do, in fact, view advertising as a way to sway voters.** It appears that my hypothesis about the out-of-power party is correct: in 2012, when Romney ran against incumbent Obama, Republicans generally bought more ads in each cost category than Democrats (and ran several high-dollar ads too), but in 2008, when Bush was term-limited and McCain was the Republican candidate, the Democrats bought more ads than Republicans (and also ran several high-dollar ads that were not reciprocated). If parties spend more when they are not in power, this may also suggest that advertising is viewed as an antidote to the incumbency advantage.

A argument *against* this conclusion is that the data includes pre-primary ads as well: when a party has an incumbent who is seeking re-election to the presidency, they do not need to waste resources on primary ads, while the opposing parties does. However, this argument is not supported by the data - while this scenario applies to the Democratic Party in 2012 (with Obama as the "pre-decided" nominee), this does not apply to 2008. In 2008, the Democrats were not the incumbent party in the White House, but McCain was not the clear successor to Bush, either, so according to this theory, both parties should have spent similar amounts. Instead, the data shows that Democratic spending was higher. The theory is also countered by the 2000 election cycle, where Republicans purchased more advertisements even though Gore was not necessarily the "pre-decided" nominee (he did get very strong support, though).

Below are the corresponding histograms for the 2000 and 2004 election cycles. It's worth noting that there weren't *any* advertising campaigns costing more than $1 million in either year - perhaps TV stations started to charge more, or the candidates decided to sign larger, longer-term agreements at once?

![2000 and 2004 Ad Campaign Sizes](https://yanxifang.github.io/Gov-1347/images/ad_campaign_size_2000_2004.png)

**As a summary, these two visualizations show that ads do matter - or at the very least, campaigns believe that they matter.** However, advertisements on television and radio are not the only method of persuasive messaging employed by campaigns, particularly in today's age of social media (which is an alternative channel for messaging) and online streaming (which implies that TV/radio ads now fewer people and a narrower demographic).

## Partial 2020 Ads Data
For obvious reasons, there is only limited data available for the 2020 election. Rather than tallying advertisement spending by dollar amount per campaign, the 2020 data (`ads_2020.csv`) measures spending by the number of airings for each candidate, broken up into two time periods: April 9 through September 27, and September 5 through September 27. While limited in details, this data is good enough in terms of being up-to-date: as discussed in my previous posts, a prediction should be made in advance, so if ad spending is used in a prediction model, then the information about October spending shouldn't need to be available.



## Ongoing Model & Revised Prediction for 2020
My previous model was outlined in [Week 3](https://yanxifang.github.io/Gov-1347/2020/09/25/Week-Three-Predictions.html), and was solely based on polling:

| Weight | Variable | Coefficient | R-Squared| Notes |
| --- | --- | --- | --- | --- |
| 0.5632 | Constant | 3.2889 |  | *Recent* Polls (<45 Days) |
|  | Poll Prediction of PV | 1.0060 | 0.8346 | |
| 0.4368 | Constant | 8.3623 |  | *Older* Polls (>45 Days) |
|  | Poll Prediction of PV | 0.9059 | 0.6473 | |


Click [here](https://yanxifang.github.io/Gov-1347) to return to the front page.
