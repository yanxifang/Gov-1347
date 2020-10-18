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

Obviously, without a clear indication of whether advertising has any effect on vote share, it becomes difficult to compare advertising to the ground game. Nonetheless, it should be interesting to see whether there are any correlations between campaign activity and increased vote share. **Again, there is very little data available on ground campaign activity.** This is not surprising, considering that parties may employ the same campaign strategists for different candidates in different years, which potentially makes campaign activity a secret of some sort.

Using data from the 2012 campaign cycle (the only year for which complete county-level data is available), I developed models for field office placement by both the Obama and Romney campaigns. As shown below, **there appears to be a "matching" effect, as well as more campaign offices in battleground counties (but not swing ones).** There are a few drawbacks to this model of placement: for instance, while the model accounts for state-to-state differences, it does not account for population (perhaps a higher-population county is more likely to have an office), nor does it account for the fact that campaign office activities are not restricted to one county and could have been placed at a location where volunteers or staffers can reach nearby counties as well.

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

The more interesting model would be one that describes the impact (if any) of field offices on voter turnout or voter persuasion. In this case, only Democratic Party data is available, from 2004 to 2012. 

## Demographics
Certain demographic blocs have reliably voted for particular parties: for instance, many Black Americans consistently vote for the Democratic presidential nominee. If this is the case on a broad/national-level scale, then it might make more sense to focus on the fundamentals models, rather than assuming that voter preferences can be changed.

First, I looked at states that reliably voted for certain parties. I should exclude these "solid" states from the demographics analysis, because the consistency of those states may lead to an underestimation of the impact that demographics have on election results. **Defining "reliably voting" as having voted for the presidential candidate from the same party every election cycle since 1980, I found 15 states/areas that are "solidly Republican" (13) and "solidly Democratic" (2).** These states are:

- **Republican:** Alabama, Alaska, Idaho, Kansas, Mississippi, Nebraska, North Dakota, Oklahoma, South Carolina, South Dakota, Texas, Utah, Wyoming
- **Democratic:** Minnesota, Washington D.C.

![Safe States, 1980-2016](https://yanxifang.github.io/Gov-1347/images/safe_states_historical.png)

An initial glance at this list does raise some suspicion about the validity of this model: in particular, states like Massachusetts, California, Rhode Island, and Vermont are today considered to be solidly Democratic states. However, this is easily explained by Reagan's landslide in 1984, when he won all states/areas except Minnesota and D.C.

After excluding these states, I analyzed demographic data, which only included binary variables for race/ethnicity, gender, and age. I first performed regressions on the overall data without regard to whether the party in question won or lost the election, and found that although the R-squared value was high (0.7543), neither the race/ethnicity nor age variables had statistically significant coefficients. Then, I split up the data into two party-specific sets: one for all the elections won by Democrats, and a corresponding one for Republicans. The regressions on these had lower R-squared values (0.6384 and 0.5564, respectively), but still, the overwhelming majority of the demographic variables did not have statistically significant coefficients. Below are the results of my regressions (note: (1) is the Democratic regression, and (2) is the Republican one).

<table style="text-align:center"><caption><strong>Demographics and Election Outcomes (1992-2016)</strong></caption>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td colspan="2"><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="2" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td colspan="2">win_pv2p</td></tr>
<tr><td style="text-align:left"></td><td>(1)</td><td>(2)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Asian</td><td>-0.265 (0.467)</td><td>2.488 (1.952)</td></tr>
<tr><td style="text-align:left">Black</td><td>-0.408 (0.469)</td><td>-0.750 (0.889)</td></tr>
<tr><td style="text-align:left">Hispanic</td><td>0.123 (0.242)</td><td>-0.611 (0.463)</td></tr>
<tr><td style="text-align:left">Indigenous</td><td>-4.851 (3.364)</td><td>1.133 (4.804)</td></tr>
<tr><td style="text-align:left">Female</td><td>2.437<sup>*</sup> (1.417)</td><td>-8.402<sup>***</sup> (2.140)</td></tr>
<tr><td style="text-align:left">age20</td><td>-0.724 (0.835)</td><td>-2.014 (1.861)</td></tr>
<tr><td style="text-align:left">age3045</td><td></td><td></td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr></table>

**However, the above analysis assumes that demographic blocs vote differently across states, which may not be true.** Instead, demographic blocs may exhibit the same behavior nationally. When excluding the `state` variable in the multivariate linear regression, the R-squared values suffer drastically (dropping to 0.3265 and 0.3891, respectively), but the demographics coefficients become much better, statistically speaking -- at least for the Democratic regression. Below is the corresponding table:

<table style="text-align:center"><caption><strong>Demographics and Election Outcomes (1992-2016)</strong></caption>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td colspan="2"><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="2" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td colspan="2">win_pv2p</td></tr>
<tr><td style="text-align:left"></td><td>(1)</td><td>(2)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Asian</td><td>0.218<sup>***</sup> (0.030)</td><td>-2.294<sup>***</sup> (0.526)</td></tr>
<tr><td style="text-align:left">Black</td><td>-0.237<sup>***</sup> (0.063)</td><td>0.093 (0.067)</td></tr>
<tr><td style="text-align:left">Hispanic</td><td>0.176<sup>***</sup> (0.048)</td><td>-0.025 (0.073)</td></tr>
<tr><td style="text-align:left">Indigenous</td><td>-0.949<sup>***</sup> (0.299)</td><td>-0.618<sup>*</sup> (0.333)</td></tr>
<tr><td style="text-align:left">Female</td><td>4.527<sup>***</sup> (0.689)</td><td>-2.820<sup>**</sup> (1.079)</td></tr>
<tr><td style="text-align:left">age20</td><td>1.168<sup>**</sup> (0.472)</td><td>1.246<sup>**</sup> (0.576)</td></tr>
<tr><td style="text-align:left">age3045</td><td></td><td></td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr></table>

Click [here](https://yanxifang.github.io/Gov-1347) to return to the front page.
