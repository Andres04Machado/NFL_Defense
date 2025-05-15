# Necessary libraries
library(ggplot2)
library(ggcorrplot)
library(car)
library(MASS)
library(olsrr)
library(Metrics)

# Reading in our csv files containing or 5 seasons worth of data
season23_df <- read.csv(file = "2023_Advanced_Defensive_Stats_wEXP.csv")
season22_df <- read.csv(file = "2022_Advanced_Defensive_Stats_wEXP.csv")
season21_df <- read.csv(file = "2021_Advanced_Defensive_Stats_wEXP.csv")
season20_df <- read.csv(file = "2020_Advanced_Defensive_Stats_wEXP.csv")
season19_df <- read.csv(file = "2019_Advanced_Defensive_Stats_wEXP.csv")

# Combining the 4 seasons (2019-2022) into one big data frame
complete_df <- rbind(season22_df,season21_df,season20_df,season19_df)

# Let's get rid of the team names as they will cause problems with our analysis
no_teams_df <- complete_df[-c(1)]

# Summary Statistics for our data
summary(no_teams_df) 
#Percentages are read as strings and overall not useful 

# Eliminating the percentage columns
no_teams_no_perc_df <- subset(no_teams_df, select = -c(TD., Bltz., Hrry.,
                                                       QBKD., Prss.))
summary(no_teams_no_perc_df)
attach(no_teams_no_perc_df)

# Making games a categorical variable
no_teams_no_perc_df$G <- factor(G)

# Exploring outliers with boxplots
boxplot(no_teams_no_perc_df)
# Create boxplots with our main useful variable (Continous Variables)
boxplot(no_teams_no_perc_df[, c("Yds", "RUSHYDS")], horizontal = TRUE, 
        xlab = "Values", ylab = "Columns", names = c("Yds", "RUSHYDS"))
boxplot(no_teams_no_perc_df[, c("EXP", "Prss")], horizontal = TRUE, 
        xlab = "Values", ylab = "Columns", names = c("EXP", "Prss"))

# Correlation Matrix
# Create df without games categorical variable
continous_df = no_teams_no_perc_df[-c(1)]
corr_matrix = cor(continous_df)
#print(corr_matrix)

# Creating a heat map to showcase corr matrix
## Rounding the 'r' values to 2 decimal points
corr_matrix <- round(corr_matrix,2) 
ggcorrplot(corr_matrix, type = "upper", lab = TRUE, lab_size = 4) +
  ggtitle('Correlation Matrix Heat Map')

# Partial Regression Plots with our variables of interest
test_model <- lm(PILS ~ EXP + Yds + RUSHYDS + Prss + G,
                 data = no_teams_no_perc_df)
### summary(test_model)
crPlots(test_model)

# Building our max model, with all the possible variables
options(scipen = 20) # Getting rid of scientific notation
# Creating a Yds_squared variable
no_teams_no_perc_df$Yds_squared <- no_teams_no_perc_df$Yds^2

# Fitting max model
max_model <- lm (PILS ~ . + Yds:RUSHYDS + Yds_squared,data = no_teams_no_perc_df)
summary(max_model)

plot(max_model)

# Box Cox transformation
boxCox(max_model)

# Model Selection
## Creating train_set (current dataframe) and test_set (2023 season data)
set.seed(2)
train_set <- no_teams_no_perc_df

final_2023_df <- subset(season23_df, select = -c(Tm,TD., Bltz., Hrry.,
                                                       QBKD., Prss.))
final_2023_df$Yds_squared <- final_2023_df$Yds^2
test_set <- final_2023_df

attach(train_set)
max_model_train <- lm(PILS ~ . + Yds:RUSHYDS + Yds_squared,data = train_set)
#summary(max_model_train)

# Backwards elimination on max model
model_backward_AIC <- ols_step_backward_aic(max_model_train,prem = 0.1 ,details=TRUE)
print(model_backward_AIC)
summary(model_backward_AIC)
plot(model_backward_AIC)

# Forward selection on max model
model_forward_AIC <- ols_step_forward_aic(max_model_train, details=TRUE)
print(model_forward_AIC)
plot(model_forward_AIC)
summary(model_forward_AIC)

# Stepwise selection on max model
model_step_AIC <- ols_step_both_aic(max_model_train, details=T)
print(model_step_AIC)
plot(model_step_AIC)
summary(model_step_AIC)

# FINAL MODEL before diagnostics
final_model <- lm(PILS ~ as.factor(G) + Air + Yds_squared + YAC + Att + Cmp + RUSHYDS + EXP +
                    MTkl + DADOT + TD + Yds:RUSHYDS, data = train_set)
summary(final_model)
plot(final_model)
boxCox(final_model)
attach(train_set)

# Fitting a version with no interaction term for partial regression plots
final_model_no_interact <- lm(PILS ~ as.factor(G) +Air + Yds_squared + YAC + Att
                              + Cmp + RUSHYDS + EXP + MTkl + DADOT, data = train_set)
crPlots(final_model_no_interact)

# Jackknife Residuals
t <- qt(.025,128-11-2, lower.tail = FALSE)
print(t)
print(sort(studres(final_model))) 

# Leverage
leverage <- 24/128
print(leverage)
print(sort(hatvalues(final_model)))

# Cook's Distance
print(sort(cooks.distance(final_model)))

# Residual plot with jack knife
plot(final_model$fitted.values, studres(final_model))
abline(h = 0)

# Shapiro-Wilk Test
shapiro.test(final_model$residuals)

# VIF
ols_coll_diag(final_model) # Not so great
ols_coll_diag(final_model_no_interact) # Better

## Making model with no interaction term and no Att
final_model_no_interact_no_att <-lm(PILS ~ as.factor(G) +Air + Yds_squared + YAC 
                         + Cmp + RUSHYDS + EXP + MTkl + DADOT, data = train_set)
ols_coll_diag(final_model_no_interact_no_att)
  
#### TESTING

# full_df_2 <- train_set
# attach(full_df_2)
# 
# full_df_2$Yds_squared <- (Yds_squared-mean(Yds_squared))/sd(Yds_squared)
# full_df_2$RUSHYDS <- (RUSHYDS-mean(RUSHYDS))/sd(RUSHYDS)
# 
# full_df_2$DADOT <- (DADOT-mean(DADOT))/sd(DADOT)
# full_df_2$YAC <- (YAC-mean(YAC))/sd(YAC)
# 
# full_df_2$Air <- (Air-mean(Air))/sd(Air)
# full_df_2$Att <- (Att-mean(Att))/sd(Att)
# 
# full_df_2$Cmp <- (Cmp-mean(Cmp))/sd(Cmp)
# full_df_2$EXP <- (EXP-mean(EXP))/sd(EXP)
# 
# full_df_2$MTkl <- (MTkl-mean(MTkl))/sd(MTkl)
# 
# final_model_2 <- lm(PILS ~ as.factor(G) + Air + Yds_squared + YAC + Att + Cmp + RUSHYDS + EXP +
#                       MTkl + DADOT + Yds:RUSHYDS, data = full_df_2)
# final_model_2_no_interact <- lm(PILS ~ as.factor(G) + Air + Yds_squared + YAC + Att + Cmp + RUSHYDS + EXP +
#                                   MTkl + DADOT, data = full_df_2)
# ols_coll_diag(final_model_2)
# summary(final_model_2)
# summary(final_model)
# 
# ols_coll_diag(final_model_2_no_interact)
# summary(final_model_2_no_interact)
# summary(final_model_no_interact)
# 
# final_model_3 <- lm(PILS ~ as.factor(G) + Air + Yds_squared + YAC + Cmp + RUSHYDS + EXP +
#                       MTkl + DADOT, data = full_df_2)
# summary(final_model_3)
# ols_coll_diag(final_model_3)
# 
# final_model_4 <- lm(PILS ~ as.factor(G) + Air + Yds_squared + YAC + Att + RUSHYDS + EXP +
#                       MTkl + DADOT, data = full_df_2)
# summary(final_model_4)
# ols_coll_diag(final_model_4)

#### EXPLANATION BELOW
#Above was testing for removing and including interaction term or RUSHYDS or CMP exclusively in the model
#Also tried standardizing to no avail
#Final decision ended up being not having the interaction term to begin with: final_model_no_interact

# Summary for real final model
culminating_model <- final_model_no_interact_no_att
summary(culminating_model)

# Reliability
pred_train <- predict(culminating_model, train_set)
print(sort(pred_train))
mae(train_set$PILS, pred_train)

pred_test <- predict(culminating_model, test_set)
print(sort(pred_test))
mae(test_set$PILS, pred_test)

## While they aren't roughly the same we have to remember that we more observations
## and taking into account other factors such as offense, this could improve drastically.
## Also, they are about 10% apart which is something we can live with as 
## predicting the NFL and what happens on any given Sunday is known to be difficult.
