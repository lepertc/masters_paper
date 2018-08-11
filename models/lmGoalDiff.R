##### Library #####
library(stargazer)
library(ggplot2); theme_set(theme_bw())

##### Load data #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/teamHistoryProcessed.rds")

##### Goal difference #####
df$goal_diff = df$hgoal - df$vgoal
ggplot(df, aes(x = goal_diff)) + geom_histogram(binwidth = 1, color = "black", fill = "grey") + 
  stat_function(fun = function(x) dnorm(x, mean = mean(df$goal_diff), sd = sd(df$goal_diff)) * nrow(df),
                color = "darkred", size = 1) +
  labs(title = "Distribution of goal difference overlayed with distribution under \n the assumption that the goal difference is normally distributed",
       x = "Goal difference", y = "Count")

##### Model #####
lm_diff = lm(goal_diff ~ h_rest + v_rest + h_att_str + h_def_weak + v_att_str + 
               v_def_weak + h_load + v_load, data = df)

stargazer(lm_diff, no.space = TRUE, title = "Linear model for the difference in goals scored")
