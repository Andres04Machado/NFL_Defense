# Multiple Linear Regression Group Project: Does Defense Win Championships?

![Football Defense](https://github.com/user-attachments/assets/5cef1dd2-eb8e-48d9-be1e-96924eb823ea)

![Language](https://img.shields.io/badge/language-R-blue.svg)  
![Last Updated](https://img.shields.io/badge/last%20updated-May%202025-brightgreen)  
![Status](https://img.shields.io/badge/status-completed-green)

**Authors**: Andres Machado, Sean Murray, Sergei White  
*Spring 2024 | Statistical Methods 3*  
*Data source: Pro Football Reference*
## 📚 Table of Contents
- [Research Question](#research-question)
- [1. Motivation](#1-motivation)
- [2. Data Description](#2-data-description)
- [3. EDA](#3-eda-exploratory-data-analysis)
- [4. Model Selection](#4-model-selection)
- [5. Model Diagnostics](#5-model-diagnostics)
- [6. Results Summary](#6-results-summary)
- [7. Conclusion](#7-conclusion)
- [8. Future Work](#8-future-work)

To see R script visit the [code](https://github.com/Andres04Machado/NFL_Defense/tree/main/code) folder. To see the individual plots that are shown below visit the [plots](https://github.com/Andres04Machado/NFL_Defense/tree/main/plots) folder.

# Research Question:
**How do specific defense statistics correlate with NFL teams' final standings in the regular season standings?**

## 1. Motivation
“Offense wins games. Defense wins championships” - Bear Bryant. Any team can click on offense on any given Sunday and become insurmountable on that day. However, what we gathered from Coach Bryant’s quote was what makes a team truly dominant week in and week out is their defense. This age-old wisdom echoes across the sports world, reminding us of the pivotal role defense plays in achieving ultimate success. As avid football enthusiasts, we're intrigued by Bryant's insight and its implications. Our curiosity leads us to ponder: How do specific defense statistics correlate with NFL teams' placements in the regular season standings? While we acknowledge the importance of offense, the enduring belief in the significance of defense prompted us to delve deeper into its correlation with team standings. It's a starting point—a way to unravel the mysteries behind team performance and success. By analyzing key defensive metrics, we hoped to uncover patterns that could offer valuable insights for players, GMs, and team owners alike. That in turn, would lead to an impact on players, their families, their communities, the communities of the teams, etc. This research isn’t just about football winningness; it's about making informed decisions and shaping the future of the game. While our focus was on the regular season, this project marks just the beginning of a journey toward understanding what makes a consistently winning team. We decided on an approach that dives into the advanced statistics for all 32 teams in the NFL for the past five seasons. Simply looking at a defensive ranking and correlating that with place in league standings was not good enough for us. By modeling specific statistics, rather than trusting experts’ rankings, we hoped to better highlight the relationship between defense and winning.

## 2. Data Description
The source of our dataset was www.pro-football-reference.com. Pro Football Reference is a known statistics hub for all the football statistics one could need, from the basic to the most advanced statistics.

We started by looking at seasonal data, specifically the 2019 season to 2023 season, to have a reasonable size to use in our analysis. We found what we were looking for in one table, Advanced Defense Statistics, but some things were missing such as `PILS` (Place In League Standings), and `RUSHYDS`(Rushing yards allowed by defense). These stats were in other tables around the website so after some quick sorting and manual input, we had all 5 tables for our 5 seasons. Each team’s season was an observation in our data. However, in order to test our models’ accuracy on real data, we decided to remove the most recent season, 2023, and see how our model with the 4 remaining seasons would predict the league standings of that 2023 season.

Among the variables of interest were `PILS`, `RUSHYDS`, net yards gained passing (`Yds`), expected Points contributed by the entire defense (`EXP`), and the number of games played (`G`) as a categorical variable where each team had their own games variable per season. These metrics were selected due to their widespread use in the NFL for assessing defensive performance. For example, `EXP` served as a valuable indicator of a defense's ability to contribute points to a game. A positive `EXP` suggested defensive prowess, while a negative `EXP` indicated defensive vulnerabilities.

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

The dimensions of our seasonal data (2019-2022) is 128 rows (teams) by 23 columns (features).
## 3. EDA
One thing we changed when we imported the data into R was to remove the features with percentages (ex: `Bltz%`). This is because for each of those features, we have an equivalent non-percentage feature. So, to avoid the multicollinearity headache ahead of time, we decided to scrap the features with percentages.

Then, we wanted to check out the summary statistics for any anomalies:

<img width="796" alt="Summary_Stats" src="https://github.com/user-attachments/assets/fe678c11-5897-44ee-995d-2894b9f64713" />

As we can see, all of the features are within normal ranges for their particular stat. Most had very small ranges such as `G`, `PILS`, and `Sk`. Others had quite large ranges like `Yds`, `RUSHYDS`, `Air`, and `YAC`. We believe these features with bigger ranges (more variance) could be most useful when fitting the regression model. This is further supported by the box plots of all the variables:

![Box_Plots_all_vars](https://github.com/user-attachments/assets/25ab45c2-7868-49d5-867e-668e64d50fed)

Next, we explored a Pearson's correlation coefficient ($r$) matrix in the form of a heatmap. This is especially crucial since we will be doing multiple linear regression.

![Correlation_Heatmap](https://github.com/user-attachments/assets/564ad62b-0ff5-4da1-bcb7-feb9df1d98b8)

As we can see, there are only a couple of $r$ values that are a bit concerning:
- `Att` and `Cmp` have $r = 0.87$. This makes perfect sense since the more pass attempts a team has, the more completions they tend to have.
- `Prss` and `Hrry` have $r = 0.74$. This also makes sense since `Hrry` is part of the formula that calculates `Prss`.
- `Prss` and `Sk` have $r = 0.61$. This also makes sense since `Sk` is part of the formula that calculates `Prss`.

There are some other collinearity contenders, but overall, pretty promising results. Later on, we will use VIF to look into this further.

To get a better picture of how our numerical variables of interest looked, we created box plot pairs for them:

Showcasing box plots for `RUSHYDS` and `Yds`:

![Box_Plots_RUSHYDS_Yds](https://github.com/user-attachments/assets/c3111c66-069a-4330-bb7d-14f0155d53d2)

Showcasing box plots for `EXP` and `PRSS`:

![Box_Plots_Prss_EXP](https://github.com/user-attachments/assets/b5eaeeba-a43d-4b5d-811b-fc0ead21cacc)

These boxplots show us that there may be some outliers that we need to deal with.

To further investigate our variables of interest, we decided to create partial regression plots of our numerical variables. This also gives us a preview of the eventual multiple linear regression model that we are going to fit:

![Part_Reg_Plot_5vars](https://github.com/user-attachments/assets/665c7a85-1298-46d9-a59f-576a4ad1917e)

Based on these partial regression plots, it seems that our main variables of interest, except maybe `Yds`, have a very strong linear relationship because the line of best fit and smooth-curve lines are almost perfectly overlapping.

## 4. Model Selection
For this project, we decided to use multiple linear regression as our model of choice. We had tremendous familiarity with its methods, and it has very high interpretability. Since regular season success (place in standings) is what we are trying to predict, our dependent variable will be `PILS`. Before we proceeded with the model selection methods, we decided to fit a model with all the features, all the interaction terms, and relevant transformations that we used. The interaction term we decided to include was one between `RUSHYDS` and `Yds` to explore the relationship between a pass-dominant opposing team and a rush-dominant opposing team to see if that affects standings. Also, we squared `Yds` to improve its linear relationship with `PILS`. We tried other transformations for variables such as `RUSHYDS`, `Air`, and `MTkl` to no avail; therefore, they remained the same. Below is a summary of the maximum model:

<img width="628" alt="Max_Model_Summary" src="https://github.com/user-attachments/assets/020bb8bc-dd1e-4ff4-8740-8ce4b7dada1d" />

We wanted to highlight why `Prss` is NA for its coefficient, standard error, $t$ value, and P-value: Since `Prss` is formulation hurries + knockdowns + all sack plays and we already have `Sk` and `Hrry`, this led us to conclude that there was such high multicollinearity with those variables leading to R not calculating its necessary parameters.

Our "fully loaded" model had a $R^2_{\text{adj}}$ of 63.49% which is quite mediocre considering we haven't standardized any of the features or optimized the model. We then ran backwards elimination, forward selection, and stepwise selection on our model. We used AIC as our metric and surprisingly, all three methods gave us the same following variables as the most optimal:

<img width="106" alt="Final_Vars" src="https://github.com/user-attachments/assets/5853148a-0392-4196-9555-8b67f4542c7a" />

Looking at our variables, we see the `TD` and `G` are missing. This is interesting as we hypothesized all variables of interest would have an impact on the final model. Interestingly, the transformation of `Yds` and interaction term did make it. Since we are still interested in how all five variables of interest affect `PILS`, we made the executive decision to keep the variables in the optimal model. This makes the list of final variables moving on become:

- `Att`
- `Cmp`
- `G`
- `TD`
- `RUSHYDS`
- `DADOT`
- `Air`
- `YAC`
- `MTkl`
- `EXP`
- `Yds_squared`
- `RUSHYDS:Yds`

We then fit the model with the optimal variables and observed the residual plot and Q-Q residual plot (normality plot):

![Residual_Plot_final_model](https://github.com/user-attachments/assets/775ca074-570c-44e5-8788-5035e6cef52b)

![Normality_Plot_final_model](https://github.com/user-attachments/assets/b94fbbf8-d0f1-493a-97b6-49624b9c72cb)

The residual plot looks quite good, but the Q-Q residual plot is showing us that the normality assumption required for linear regression may be violated. We further investigated this by checking out the suggested Box-Cox transformation plot of our dependent variable `PILS`:

![Box_Cox_Trans_Plot](https://github.com/user-attachments/assets/f4280d5d-24b3-41e1-93bf-dcf9d8986e51)

Since the $\lambda$ value for this plot is quite close to one, we wanted to check the Shapiro-Wilk normality test to ensure normality:

<img width="302" alt="Shapiro-Wilk_Test" src="https://github.com/user-attachments/assets/d08ea031-06ac-46ac-affb-4f0918e68c0d" />

The null hypothesis of this test is that the data tested is normally distributed. Looking at our p-value, we see that with a significance level of 5% we fail to reject the null hypothesis, meaning our data is normally distributed. With this in mind, we decided to keep `PILS` as it is.

## 5. Model Diagnostics
We wanted to check for outliers and multicollinearity in our variables. These two problems plague most multiple linear regression models, which can throw off model accuracy.
### Outlier Detection
With the amount of data that we have, it would be unwise to remove any observations. However, since the model we are using is very volatile when outliers are involved, we decided it would be best to still check for outliers anyway. We are using three methods for outlier detection:

1. **Leverage**: Measure of the extremity of an observation with respect to the independent variable.
2. **Jackknife Residuals (External Studentized Residual)**: Measure of the extremity of an observation with respect to the predicted values.
3. **Cook's Distance**: Measure of the influence of a point (or how much the estimates change when an observation is deleted).

If we see the same observation keep popping up as an outlier for each method, we will look into removing it.

#### Leverage
Leverage Threshold: If an individual leverage value for an individual observation ($h_i$) satisfies the following inequality, $h_i > \frac{2(k+1)}{n}$ (where $k$ is the number of features in a model and $n$ is the number of observations in our dataset), then it is considered an outlier. Here is what we found as the $h_i$ values in all of our data:

<img width="791" alt="Leverage_Outliers" src="https://github.com/user-attachments/assets/b90a5950-e497-41b7-b977-5dfd1e453b5d" />

We found that 5 observations satisfy the inequality: 25, 40, 51, 70, and 102. They were bigger than our threshold value of 0.203125. This means, according to their $h_i$ values, that they are potential outliers.

#### Jackknife Residuals
Jackknife residuals are calculated by removing the $i^{\text{th}}$ observation and reffiting the regression model. We then calculate the residual as so:

$r_{-i} = \frac{\hat{E}_i}{s{-i} \sqrt{1 - h_i}}$ where $\hat{E}_i = y_i - \hat{y}_i$

The threshold that an individual jackknife residual for an individual observation $r_{-i}$ has to satisfy in order to be considered an outlier is:
$|r_{-i}| > t_{0.975, \text{df} = n-k-2}$

Here is what we found as the $r_{-i}$ values in all our data:

<img width="767" alt="Jackknife_Residuals" src="https://github.com/user-attachments/assets/5ce2a4cb-b03f-4a57-8702-f7ac4ffa94a0" />

We found 6 potential outliers in our observations that satisfy the inequality: 4, 33, 39, 70, 118, 128. They were bigger than the $t$ critical value of 1.980808. Observation 70 has shown up twice now, making it really compelling to get rid of. After viewing the data, observation 70 is the 2020 Seattle Seahawks, who placed 7th in league standings and 15th in defense. We are really unsure how they are an outlier in all of this. We assume it is because of the specific features we picked that it stands out as an outlier. Anyhow, we plan on keeping observation.

#### Cook's Distance
The Cook's distance measures the extent to which estimates of regression coefficients change when an observation is deleted. They are calculated by the following:

$d_i = (\frac{1}{k+1})(\frac{h_i}{1-{h_i}})r_i^2$ where $r_i = \frac{\hat{E}_i}{s\sqrt{1 - h_i}}$ is a studentized residual.

The general threshold most use for an individual Cook's distance for an individual observation $d_i$ has to satisfy in order to be considered an outlier is: $d_i > 1$

Here is what we found as the $d_i$ values in all our data:

<img width="717" alt="Cook's_Distances" src="https://github.com/user-attachments/assets/0c99dbf3-aa39-4f63-abdd-3d7b98beb6ad" />

As we can see, even observation 70 didn't even come close to the threshold. All the Cook's distances are well below 1 and lead us to conclude that we will not be removing any outliers.

### Multicollinearity Analysis
We checked collinearity with the correlation heatmap previously. Now, we will use the Variance Inflation Factor (VIF) to test for multicollinearity. Here is its formulation:

$\text{VIF} = \frac{1}{1 - R^2}$

$R^2$ in this context is the coefficient of determination for regressing the $i^{th}$ independent variable on the remaining ones. Any VIF values above 10 could indicate some multicollinearity with a particular group of variables. The reason we want to avoid multicollinearity is to make sure our features aren't adding any redundant information; rather, we want them to explain something new about our dependent variable. Here is what our VIF values looked like for our current optimal model:

<img width="327" alt="Initial_VIF" src="https://github.com/user-attachments/assets/57370aaf-ade3-44b8-baf3-d6c0bfba7e2e" />

As we can see, we have some concerning VIF numbers with regard to the interaction term and its counterparts. We initially added this interaction term as a means of testing its behavior, but even in the max model's summary, it didn't provide any meaningful information, nor was it statistically significant. Therefore, we decided to cut it and recalculate the VIF values:

<img width="324" alt="VIF_no_interact" src="https://github.com/user-attachments/assets/ce5ef0a5-a01d-4e99-913f-e72d371123fa" />

Now, all we had was one VIF value above 10 which pertained to `Cmp`. If you recall from the correlation heatmap, `Cmp` and `Att` had quite a high $r$ value of 0.87. We figured that was what was making `Cmp`'s value so high. Therefore, we decided to cut `Att` and recalculate the VIF values:

<img width="378" alt="VIF_no_interact_or_att" src="https://github.com/user-attachments/assets/0a812502-840f-4189-963d-f4d3fdf2cd1a" />

With these VIF values, we felt comfortable that our model was as optimal as it gets. There was further testing done that included other combinations of features, standardization, and the whole works. In the end, we settled on the above features for our final model, which we thought was the most interpretable and reasonable at the time. One may interpret it differently or keep certain variables around; in the end, we were happy with our decisions.

## 6. Results Summary
Here is our final culminating model summary:

<img width="554" alt="Final_Model_Summary" src="https://github.com/user-attachments/assets/2f2b9a1b-ea95-4118-940c-bcf1b151a2dd" />

The final model reached an $R^2_{\text{adj}}$ value of 54.07%, which is a bit of a dip from the max model's value of 63.49%. This may suggest that even though our model is primed for predictions, the linearity we once thought existed in the task at hand didn't exist. Looking at some of those p-values for our predictors, we can see that the number of games played that season (`G`), expected points contributed by the entire defense (`EXP`), missed tackles by defenders (`MTkl`), and the number of touchdowns scored by the opposition (`TD`) are not significant in predicting place in league standings. We thought the number of games might give more valuable insight, but alas, it was not significant in predicting standings. We see that `RUSHYDS`, `Yds_squared`, `Air`, and `YAC` are among the significant variables in predicting league standings. We can conclude that rushing and passing stats say more about a team's defensive performance than the number of touchdowns scored against them, which is surprising to say the least.

## 7. Conclusion
Back to our research question, how do specific defense statistics correlate with NFL teams' placements in the regular season standings? Well, as it turns out, Bear Bryant was mostly correct. Even though football has a great deal of randomness or luck baked into it as a sport, there is a significant relationship between our specific defense predictors and a team’s placement in the regular season league standings. The playoff structure of the NFL rewards teams who place highly in the regular season with home-field advantages and first-round byes.

To measure the effectiveness of our entire model, we used MAE, which is the mean absolute error. MAE represents the average error of the predictions we are making, so if MAE = 3 for the dataset, then on average, the predictions are 3 rankings off. The training set was for the 2019-2022 seasons, and that had an MAE of roughly 4.98. The testing set, which was only the 2023 season, had an MAE of 5.48. Although these two MAEs are not roughly the same, with more observations and the addition of offensive statistics, it could improve dramatically, but that wasn’t the objective of this particular project. 

In the future, our categorical variable Games would be a variable that we might see make a change. Just as the change in 2021 to go from 16 to 17 games for the regular season. A change might be made to go to 18 games played per team for the regular season. This would create a necessity for dummy variables that measure games played from seasons that had 16, 17, or 18.

This project showed that trying to predict the future is difficult. It brought new insight as to how sports analysts go about their day-to-day jobs. Whether it was coding the entire project in R, manually inputting information into the datasets, or creating this report, the objective that was set out we met through collaboration and had a good time doing it.

## 8. Future Work

Future work should focus on expanding the dataset to include more diverse and recent observations, improving model robustness and generalizability. Additional features could be engineered to capture latent factors influencing the response variable, potentially boosting predictive accuracy. Implementing advanced modeling techniques like ensemble methods or regularization approaches could further optimize performance and address multicollinearity issues. Finally, integrating domain knowledge and conducting sensitivity analyses would enhance model interpretability and reliability.






