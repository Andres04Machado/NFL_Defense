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

Among the variables of interest were `PILS`, `RUSHYDS`, net yards gained passing (`Yds`), expected Points contributed by the entire defense (`EXP`), and the number of games played (`G`) as a categorical variable where each team had their own games variable per season. We chose G as a categorical variable because the NFL changed the total games in a season for all teams in the middle of our chosen data years. By categorizing the seasons by the games played, we hoped to gain some insight into how the additional game played impacted the teams. These metrics were selected due to their widespread use in the NFL for assessing defensive performance. For example, `EXP` served as a valuable indicator of a defense's ability to contribute points to a game. A positive `EXP` suggested defensive prowess, while a negative `EXP` indicated defensive vulnerabilities.

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

## 3. EDA (Exploratory Data Analysis)
One thing we changed when we imported the data into R was to remove the features with percentages (ex: `Bltz%`). This is because for each of those features we have an equivalent non-percentage feature. So, to avoid the multicollinearity headache ahead of time, we decided to scrap the features with percentages.

Then, we wanted to check out the summary statistics for any anomalies:

<img width="468" alt="image" src="https://github.com/user-attachments/assets/e667a2bc-2db2-4832-add8-6dc93b3ca84c" />

As we can see, all of the features are within normal ranges for their particular stat. Most had very small ranges such as `G`, `PILS`, and `Sk`. Others had quite large ranges like `Yds`, `RUSHYDS`, `Air`, and `YAC`. We believe these features with bigger ranges (more variance) could be most useful when fitting the regression model. This is futher supported by the box plots of all the variables:

<img width="468" alt="image" src="https://github.com/user-attachments/assets/c36fa107-3e3e-4054-9a65-faa6d6e57138" />

### **CORRELATION HEATMAP GOES HERE**

To get a better picture of how our numerical variables of interest looked like, we created box plot pairs for them:

Showcasing box plots for `RUSHYDS` and `Yds`:

<img width="468" alt="image" src="https://github.com/user-attachments/assets/5169f921-2bd5-4cf0-bcae-1002b369c1a6" />

Showcasing box plots for `EXP` and `PRSS`:

<img width="330" alt="image" src="https://github.com/user-attachments/assets/3d32b9c3-1298-476a-90fa-4ff0e118035d" />

These boxplots show us that there may be some outliers we need to deal with.

To further investigate our variables of interest, we decided to create partial regression plots of our numerical variables. This also gives us a preview of the eventual multiple linear regression model we are going to fit:

<img width="350" alt="image" src="https://github.com/user-attachments/assets/ebda4bf0-db43-4aeb-9d84-46dac72d0f8a" />

Based on these partial regression plots, it seems that our main variables of interest, except maybe `Yds`, have a very strong linear relationship because the line of best-fit and smooth-curve lines are almost perfectly overlapping.

## 4. Model Selection
For this project we decided to use multiple linear regression as our model of choice. We had tremendous familiarity with its methods and it has very high interpretability. Since regular season success (place in standings) is what we are trying to predict, our dependent variable will be `PILS`. Before we proceeded with the model selection methods, we decided to fit a model with all the the features, all the interaction terms and relevant transformations that we used. The interaction term we decided to include was one between RUSHYDS and YDS to explore the relationship between a pass dominant opposing team and a rush dominant opposing team to see if that affects standings. Also, we squared Yds to improve its linear relationship with PILS. We tried other transformations for variables such as RUSHYDS, Air, and MTkl to no avail therefore, they remained the same. Below is a summary of the maximum model:
<img width="343" alt="image" src="https://github.com/user-attachments/assets/7ff2fbab-b92e-4874-88d1-12b4bc6917e8" />

We wanted to highlight why `Prss` is NA for its coefficient, standard error, $t$ value, and P-value: Since `Prss` is formulation hurries + knockdowns + all sack plays and we already have `Sk` and `Hrry`, this led us to conclude that there was such high multicollinearity with those variables leading to R not calculating its necessary parameters.

Our "fully loaded" model had a $R^2_{\text{adj}}$ of 63.68% which is quite mediocre considering we haven't standardized any of the features or optimized the model. We then ran backwards elimination, forward selection, and stepwise selection on our model. We used AIC as our metric and surprisingly, all three methods gave us the same following variables:

<img width="127" alt="image" src="https://github.com/user-attachments/assets/b7d4a7a8-80b2-4203-b60b-d29587256deb" />

*Make some commentary about how some variables of interest didn't show up but included them anyway*

We then fit the model with the optimal variables and observed the residual plot and Q-Q residual plot (normality plot):

<img width="203" alt="image" src="https://github.com/user-attachments/assets/43818268-fc1b-42c8-9598-ce68b533a37b" /><img width="203" alt="image" src="https://github.com/user-attachments/assets/24104fcf-df1a-4041-99c9-558a63de004d" />

The residual plot looks quite good but the Q-Q residual plot is showing us that the normality assumption required for linear regression may be violated. We further investigated this by checking out the suggested Box-Cox transformation plot of our dependent variable `PILS`:

<img width="305" alt="image" src="https://github.com/user-attachments/assets/bf0a495b-bc8f-488f-8b76-0c21c0933f87" />

Since the $\lambda$ value for this plot is quite close to one, we wanted to check the Shapiro-Wilk normality test to ensure normality:

<img width="293" alt="image" src="https://github.com/user-attachments/assets/0089543b-4b64-419d-b462-baf38517bee2" />

The null hypothesis of this test is that the data tested is normally distributed. Looking at our p-value, we see that with a significance level of 5% we fail to reject the null hypothesis. With this in mind we decided to keep `PILS` as it is.

## 5. Model Diagnostics
We wanted to check for outliers and multicollinearity in our variables. These two problems plauge most multiple linear regression models which can throw off model accuracy
### Outlier Detection

