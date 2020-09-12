---
title: "Week 1 Analysis: Historical Data, 1948-2016"
date: 2020-09-11
---
## Week 1 Analysis: Historical Data, 1948-2016
*Friday, September 11, 2020*

This week, I am analyzing historical election results from 1948 to 2016. I will first explore the national-level results before shifting to results from individual states. Both are important: while national-level results ultimately determine the winner, the Electoral College system also makes it possible for a candidate who has won key "swing" states to win nationally without receiving an overall majority.

### National-Level Data
To start, I will use the two-party popular vote (PV) share in past elections. As shown below, there have been many fluctuations in the PV share between the two major parties, suggesting that presidential elections in the United States have been quite competitive, at least for the past 70 years. 

![Two-Party Presidential Popular Vote Share (1948-2016)](https://yanxifang.github.io/Gov-1347/images/PV_national_historical.png)

While this trend may seem intuitive given that the country has had both Democratic and Republican presidents in the recent past, the very fact that elections are competitive does have profound consequences. For example, the Enos and Hersh (2017) piece about closeness indicates that the closer that campaign operatives (and campaigns more generally) think an election will be, the more likely that they will change tactics and/or make stronger efforts to appeal to malleable voters. This, of course, affects policies and other candidate actions, which would in turn change the validity of existing predictions.

Another way that closeness matters is with voters themselves: as described in the Westwood (2020) reading about probabilistic forecasts, a sizeable number of voters are strategic and will vote only if they believe their vote will make a difference. Since voter turnout in the United States is quite low (according to the Pew Research Center, [only 56% in the 2016 presidential election](https://www.pewresearch.org/fact-tank/2018/05/21/u-s-voter-turnout-trails-most-developed-countries/)), the electoral map could look very different if citizens who rarely vote (or have never voted) start to vote regularly in presidential or other federal-level elections. In other words, if closeness is actually a significant motivator for voters, the current two-party vote share pattern could change radically. Again, these changes would disrupt the existing models and predictions.

However, it is important to note that the PV data has a flaw: because of the Electoral College, receiving a majority of votes does not imply victory in the election. Furthermore, the popular vote percentages are not always accurate indications of closeness because electoral votes, which depend on state-level election results, are ultimately the deciding factor in determining the winner of a presidential election, *not* the popular vote. To mitigate this issue, I used electoral vote data from the [National Archives](https://www.archives.gov/electoral-college/results) to calculate the percent of two-party electoral votes received by candidates for the same time period, 1948-2016. As shown below, the actual (i.e. electoral) closeness is less compelling, with multiple elections that feature very large differences between the percent of electoral votes received by each candidate.

![Two-Party Presidential Electoral Vote Share (1948-2016)](https://yanxifang.github.io/Gov-1347/images/EV_national_historical.png)

Combining some online research with my existing knowledge, here are the contexts for the two biggest "electoral landslides" shown in the graphic. Note that in each case, the popular vote percentages are significantly closer than the electoral percentages.

**1984: Ronald Reagan vs. Walter Mondale; EV: 525-13**

In the 1984 presidential election, incumbent President Ronald Reagan attracted many traditionally Democratic voter groups, including 18-24 year-old voters, Roman Catholics, and many union households. Combining this support with his strong personal popularity, Reagan defeated Democratic nominee Walter Mondale, who had picked Geraldine Ferraro, the first woman on a major party presidential ticket, as his running mate. Additionally, at the Democratic National Convention earlier that year, Mondale had acknowledged his plan to raise taxes, providing a key contrast against Reagan, whose handling of the economy was the strongest factor that attracted voters to him. While the electoral vote was 525 to 13, the popular vote was approximately 59 to 41 percent.
(Sources: [*New York Times*](https://www.nytimes.com/1984/11/07/politics/reagan-wins-by-a-landslide-sweeping-at-least-48-states-gop-gains.html), [*National Archives*](https://www.archives.gov/electoral-college/1984))

**1972: Richard Nixon vs. George McGovern; EV: 520-17**

In the 1972 presidential election, incumbent President Richard Nixon promised to replace the unpopular Vietnam War draft with an all-volunteer force, and to gradually reduce the number of active U.S. troops. This weakened the impact of Democratic nominee George McGovern's main policy of immediately ending the war. Further reducing his chances of electoral success, McGovern was also plagued by the revelation that his running mate, Sen. Thomas Eagleton, had undergone shock therapy for depression. Although Nixon would soon be embroiled in the Watergate Scandal, he won 520 electoral votes and more than 60 percent of the popular vote, compared to McGovern's 17 electoral votes and 37.5 percent.
(Sources: [*Politico*](https://www.politico.com/story/2018/11/07/this-day-in-politics-november-7-963516), [*National Archives*](https://www.archives.gov/electoral-college/1972))

My conclusion here is that while elections aren't actually as close as they may appear to be, the popular vote data is nonetheless relevant. In particular, the polls and forecasts available to the general public (e.g. through the media) typically includes only popular vote percentages, not Electoral College vote projections. Intuitively, this should mean that electoral closeness simply isn't on the public's minds, implying that popular vote closeness is still important - at least when thinking about impacts on voter turnout.

### State-Level Data

After showing that electoral results are considerably less close than the popular vote, I will now turn my attention to state-level data. State data is more interesting, particularly for swing states that tend to fluctuate between supporting a Democratic and a Republican presidential candidate. If a candidate successfully captures the majority of the votes in multiple such states, they can easily achieve an electoral landslide. As seen in 1972 and 1984, even a 60-40 national popular vote can deliver such a landslide.

There are several ways to identify swing states, using just state-level two-party PV data. One approach is calculating the PV margins at the state level, or the percentage gap between votes received by the two parties. This is helpful because the smaller that the state-level margins are, the easier it is for the state to switch between supporting the Democratic and the Republican candidates. However, this only provides a limited analysis: for example, certain states may have consistently close margins but never cross over to preferring the other party. The other logical approach is to analyze state-level margins, but with a specific focus on the change between two consecutive election years. This method should be more helpful, in the sense that it inherently evaluates continuity and change over time, rather than one-off results.

I have selected this second approach. I define the "swing margin" of a certain presidential election as the change in the two-party vote balance compared to the previous presidential election. Mathematically, this means that I first calculate the percent of votes won by the Republican candidate (the number of votes received, divided by the total number of two-party votes), and then, from this value, I subtract the percent of votes won by the Republican candidate in the previous election four years earlier. If the resulting value is positive, then the percentage of Republican presidential votes has increased compared to the previous election. Such a state will be visualized in red, indicating that it has become more Republican (and less Democratic). Meanwhile, if the resulting value is negative, then the percentage of Republican votes has decreased - and the percentage of Democratic votes has increased. This will be shown in blue, indicating that it has become more Democratic, relative to the previous election. Below is a visualization of popular-vote swing margins for the period of 1980-2016.

![State-Level Popular Vote Swing Margins (1980-2016)](https://yanxifang.github.io/Gov-1347/images/PV_states_historical.png)

From an initial inspection, Texas and Utah seem to be significant swing states: Texas became "more Republican" in 1980, 1984, and 2000 relative to the previous elections (i.e. 1976, 1980, and 1996 respectively) before becoming "more Democratic" in 1988, 1992, and 2008, while Utah has fluctuated from red to blue and back again throughout the entire period of 1980-2016. States like Idaho, Montana, Wyoming, and the two Dakotas also appeared to fluctuate back and forth, according to this map. However, from personal knowledge, these states haven't been traditionally Democratic at all. I checked my map with the map of state-level PV winners generated in class (below), and came to the realization that the concept of "swing margin" is limited: it only indicates *changes in the two-party vote share* between the Democratic and Republican candidates, **not** *whether a party won* as a result of those changes. This can result in a misleading image of Texas and Utah (among other states) being battlegrounds where a Democratic presidential candidate could easily succeed, when in fact Republican candidates have always won those states for at least the past 40 years. 

Still, there are some tangible results when comparing both visuals: both California and New Mexico, for instance, shifted toward the Democratic candidate in 1988 and 1992, and evidently, those second shifts in 1992 were enough to propel the two states from Republican-voting to Democratic-voting ones.

![State-Level Popular Vote Winners (1980-2016)](https://yanxifang.github.io/Gov-1347/images/PV_win_states_historical.png)

Finally, I looked briefly into the slightly misleading nature of the swing margins. I looked into the 1996 and 2004 elections, both of which have lightly-shaded maps (i.e. small swing margins), as examples. In both of these low swing margin cases, the incumbent won re-election: Clinton in 1996, and the younger Bush in 2004. This means that swing margins have at least some value; they successfully show that small changes in the two-party, state-level balance will also have small impacts on the winner.

As a conclusion: when I thought about the reasons why only a small percent of voters changed their mind about the incumbent, I remembered that there are many confounding factors, such as the economy or the U.S. going into war. Thus, rather than blindly speculating without using data, I will leave the 1996 and 2004 swing-margin maps below as something to think about throughout the semester.

![State-Level Swing Margins, 1996](https://yanxifang.github.io/Gov-1347/images/1996_swing_margins.png)

![State-Level Swing Margins, 2004](https://yanxifang.github.io/Gov-1347/images/2004_swing_margins.png)

Click [here](https://yanxifang.github.io/Gov-1347/) to return to the front page.
