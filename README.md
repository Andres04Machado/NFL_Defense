# Multiple Linear Regression Group Project: Does Defense Win Championships?
![istockphoto-516776669-612x612](https://github.com/user-attachments/assets/5cef1dd2-eb8e-48d9-be1e-96924eb823ea)

![Language](https://img.shields.io/badge/language-R-blue.svg)
![Last Updated](https://img.shields.io/badge/last%20updated-May%202025-brightgreen)
![Status](https://img.shields.io/badge/status-completed-green)
## Authors: Andres Machado, Sean Murray, and Sergei White
*This repository contains the documentation, code, and plots of the group project completed by Andres, Sergei and Sean in the Spring 2024 semester for the class: Statistical Methods 3. Special thanks to Pro Football Reference for all the necessary data for this project*

# Research Question:
**How do specific defense statistics correlate with NFL teams' placements in the regular season standings?**

## 1. Motivation
“Offense wins games. Defense wins championships” - Bear Bryant. Any team can click on offense on any given Sunday and become insurmountable on that day. However, what we gathered from Coach Bryant’s quote was what makes a team truly dominant week in and week out is their defense. This age-old wisdom echoes across the sports world, reminding us of the pivotal role defense plays in achieving ultimate success. As avid football enthusiasts, we're intrigued by Bryant's insight and its implications. Our curiosity leads us to ponder: How do specific defense statistics correlate with NFL teams' placements in the regular season standings? While we acknowledge the importance of offense, the enduring belief in the significance of defense prompted us to delve deeper into its correlation with team standings. It's a starting point-a way to unravel the mysteries behind team performance and success. By analyzing key defensive metrics, we hoped to uncover patterns that could offer valuable insights for players, GMs, and team owners alike. That in turn, would lead to impact on players, their families, their communities, the communities of the teams, etc. This research isn’t just about football winningness; it's about making informed decisions and shaping the future of the game. While our focus was on the regular season, this project marks just the beginning of a journey toward understanding what makes a consistently winning team. We decided on an approach that dives into the advanced statistics for all 32 teams in the NFL for the past five seasons. Simply looking at a defensive ranking and correlating that with place in league standings was not good enough for us. By modeling specific statistics, rather than trusting experts’ rankings, we hoped to better highlight the relationship between defense and winning.

## 2. Data Description
The source of our dataset was www.pro-football-reference.com. Pro football reference is a well known statistics hub for all the football statistics one could need, from the basic to the most advanced statistics.

We started by looking at seasonal data, specifically the 2019 season to 2023 season, to have a reasonable size to use in our analysis. We found what we were looking for in one table, Advanced Defense Statistics, but some things were missing such as `PILS` (Place In League Standings), and `RUSHYDS `(Rushing yards allowed by defense). These stats were in other tables around the website so after some quick sorting and manual input, we had all 5 tables for our 5 seasons. Each team’s season was an observation in our data. However, in order to test our models accuracy on real data, we decided to remove the most recent season, 2023, and see how our model with the 4 remaining seasons would predict the league standings of that 2023 season.

Among the variables of interest were `PILS`, `RUSHYDS`, net yards gained passing (`Yds`), `EXP` (Expected Points contributed by the entire defense), and the number of games played (`G`) as a categorical variable where each team had their own games variable per season. We chose G as a categorical variable because the NFL changed the total games in a season for all teams in the middle of our chosen data years. By categorizing the seasons by the games played, we hoped to gain some insight into how the additional game played impacted the teams. These metrics were selected due to their widespread use in the NFL for assessing defensive performance. For example, `EXP` served as a valuable indicator of a defense's ability to contribute points to a game. A positive `EXP` suggested defensive prowess, while a negative `EXP` indicated defensive vulnerabilities.

Below is a description of all the variables in our dataset:
- `G` -- Games played
- `Att` -- Passes attempted by the opposition
- `Cmp` -- Passes completed by opposition
- `Yds` -- Yards gained by opposition via passing. Sack yardage is deducted from this total
- `TD` -- Passing Touchdowns by the opposition
- `RUSHYDS` – Rushing yards allowed by defense
- `DADOT` -- Average depth of target when targeted as a defender, whether completed or not. Minimum 25 targets/16 game pace.
- `Air` -- Total air yards on completions
- `YAC` -- Yards after catch on completions
- `Bltz` -- Times brought on a blitz of the QB
- `Bltz%` -- Percent of blitzes per dropback
- `Hrry` -- QB hurries (QB threw the ball earlier than intended or chased out of the pocket)
- `Hrry%` -- Percent of QB hurries per dropback
- `QBKD` -- QB knockdowns (QB hit the ground after the throw)
- `QBKD%` -- Percent of knockdowns per pass attempt
- `Sk` -- Sacks (official since 1982, based on play-by-play, game film and other research since 1960)
- `Prss` -- QB pressures (hurries + knockdowns + all sack plays (half and full for players, just full sacks for teams))
- `Prss%` -- Percent of QB pressures (hurries + knockdowns + all sack plays (half and full for players, just full sacks for teams)) per dropback
- `MTkl` -- Missed tackles
- `EXP` -- Expected Points contributed by entire defense
- `PILS` -- Place in League Standings

## 3 EDA (Exploratory Data Analysis)
Since we’re measuring defense’s impact on wins, we expected the following variables to be most useful (listed in order of predicted usefulness):EXP - net expected points contributed by the defense, YDS - passing yards allowed by the opposition minus yards gained from sacks, RUSHYDS - total rushing yards allowed by the opposition, PRSS - total amount of QB pressures (hurries + knockdowns + all sack plays), and G - games played (categorical).




