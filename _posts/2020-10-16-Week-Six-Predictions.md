---
title: "Week 6 Analysis: The Ground Game, and Demographics"
date: "2020-10-16"
---

## Week 6 Analysis: Ground Game / Demographics
*Friday, October 16, 2020*

## Intro: The Ground Game
The "ground game", or a candidate's campaign, is rooted in the idea that direct contact with voters is likely to increase the chances of electoral success. This is manifested in two ways for U.S. presidential elections: 

- Outreach to "swing" voters (e.g. independents). This can persuade them to prefer the candidate in question, so if the voters actually vote, the candidate should receive a higher vote share.
- Outreach to "reliable" voters (e.g. registered party members). This can persuade them to actually go out and vote, allowing the candidate to receive a higher vote share. 

**However, this explanation of voter behavior, like the explanation for the Air War, is structurally incompatible with the fundamentals model**, simply because it suggests that voters change their mind over time. With that being said, it would be interesting to compare the effectiveness of ground campaigning with the effectiveness of mass media advertising, particularly because both have similar goals and require substantial monetary resources.

## Comparing the Air War & The Ground Game
[Last week](https://yanxifang.github.io/Gov-1347/2020/10/09/Week-Five-Predictions.html), I was unable to find a meaningful impact of advertising. As it turns out, I should have used the logarithm of the ad cost rather than the ad cost itself: advertising only impacts voters at the margin (i.e. a relatively small, but electorally significant, number of voters), so there are declining returns to scale. However, even when using the logarithm of the costs, I was still unable to find a linear regression that shows a clear correlation, either positive or negative, between advertisement spending and the two-party vote share (note: this was for the 2012 campaign, the most recent year for which I have extensive data).

Obviously, without a clear indication of whether advertising has any effect on vote share, it becomes difficult to compare advertising to the ground game. Nonetheless, it should be interesting to see whether there are any correlations between campaign activity and increased vote share. **Again, there is very little data available on ground campaign activity.** This is not surprising, considering that parties may employ the same campaign strategists for different candidates in different years, which potentially makes campaign activity 

<table style="text-align:center"><caption><strong>Placement of Field Offices (2012)</strong></caption>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td colspan="2"><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="2" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td>obama12fo</td><td>romney12fo</td></tr>
<tr><td style="text-align:left"></td><td>(1)</td><td>(2)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">romney12fo</td><td>1.879<sup>***</sup> (0.031)</td><td></td></tr>
<tr><td style="text-align:left">obama12fo</td><td></td><td>0.289<sup>***</sup> (0.005)</td></tr>
<tr><td style="text-align:left">swing</td><td>-0.247<sup>***</sup> (0.058)</td><td>-0.031<sup>***</sup> (0.010)</td></tr>
<tr><td style="text-align:left">core_rep</td><td>-0.392<sup>***</sup> (0.062)</td><td></td></tr>
<tr><td style="text-align:left">core_dem</td><td></td><td>-0.079<sup>***</sup> (0.024)</td></tr>
<tr><td style="text-align:left">battle</td><td>0.325<sup>***</sup> (0.100)</td><td>0.059 (0.039)</td></tr>
<tr><td style="text-align:left">as.factor(state)Arizona</td><td></td><td></td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr></table>

## Demographics
Certain demographic blocs have reliably voted for particular parties: for instance, many Black Americans consistently vote for the Democratic presidential nominee. This week, I will also analyze the 

## Ongoing Model & Revised Prediction for 2020
This week, I also revisited my ongoing model.

Click [here](https://yanxifang.github.io/Gov-1347) to return to the front page.
