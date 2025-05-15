## Plots Folder

This is the folder where you can observe all of the plots used in the principal README file of the repository. To help understande where to go here is the structure:

- `Box_Cox_Trans_Plot.png`: Output of the boxcox function found on line 73 of the R Script
- `Box_Plots_all_vars.png`: Box Plots for all 23 features. Code is found on line 36 of the R Script
- `Box_Plots_Prss_EXP.png`: Box Plots for `Prss` and `EXP` features. Code is found on lines 40-41 of the R Script
- `Box_Plots_RUSHYDS_Yds.png`: Box Plots for `RUSHYDS` and `Yds` features. Code is found on lines 38-39 of the R Script
- `Cook's_Distances`: Calculated Cook's Distances for all 128 observations used for outlier detection. Code is found on line 131 of the R Script
- `Correlation_Heatmap.png`: Pearson's Correlation Coefficient heatmap for all 23 features. Code is found on lines 45-53 of the R Script
- `Final_Model_Summary.png`: Output of the summary function used on the final MLR model used. Code is found on line 197 of the R Script
- `Final_Vars.png`: Output of all three model selection processes (backwards elim., forward selection, and stepwise selection) for which variables to choose. Code is found on lines 89-105 of the R Script
- `Initial_VIF.png`: VIF values of the model's features after model selection processes. Code is found on line 141 of the R Script
- `Jackknife_Residuals.png`: Jackknife residual (studentized residual) values for all 128 observations used for outlier detection. Code is found on lines 120-123 of the R Script
- `Leverage_Outliers.png`: Leverage values for all 128 observations used for outlier detection. Code is found on lines 125-128 of the R Script
- `Max_Model_Summary.png`: Output of the summary function used on the MLR model with all of features. Code is found on line 68 of the R Script
- `Normality_Plot_final_model.png`: Q-Q residual plot (normality plot) of the final model used to test the normality assumption. Code is found on line 197 of the R Script
- `Part_Reg_Plot_5vars.png`: Partial regression plots for the 5 variables of interest. Code is found on line 59 of the R Script
- `Residual_Plot_final_model.png`: Residual vs fitted values plot to see if homoscedasticity is violated in the final model. Code is found on line 197 of the R Script
- `Shapiro-Wilk_Test.png`: Shapiro-Wilk hypothesis test for normality output used to further investigate normality assumption. Code is found on line 138 of the R Script
- `Summary_Stats.png`: Summary statistics for all of the features (minus the percentage ones). Code is found on line 29 of the R Script
- `VIF_no_interact.png`: VIF values of the model's features after removing the interaction term between `RUSHYDS` and `Yds`. Code is found on line 142 of the R Script
- `VIF_no_interact_no_att.png`: VIF values of the model's features after removing the interaction term between `RUSHYDS` and `Yds` and also the `Att` feature. Code is found on line 147 of the R Script
