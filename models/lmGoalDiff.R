##### Library #####
library(stargazer)
library(ggplot2); theme_set(theme_bw())

##### Load data #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/teamHistoryProcessed.rds")
df = df$df

##### Goal difference #####
df$goal_diff = sqrt(df$hgoal) - sqrt(df$vgoal)

p <- ggplot(df, aes(x = goal_diff)) + geom_histogram(binwidth = 0.5, color = "darkgrey", fill = "grey") + 
  stat_function(fun = function(x) dnorm(x, mean = mean(df$goal_diff), sd = sd(df$goal_diff)) * nrow(df) /2,
                color = "darkred", size = 0.5) +
  labs(title = "Distribution of square root goal difference overlayed with distribution\nunder the assumption that the goal difference is normally distributed",
       x = "Square Root Goal difference", y = NULL) +
  theme(plot.title = element_text(size = 10), axis.text.x = element_text(size = 8),
        axis.text.y = element_text(size = 8), axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10))

##### Model #####
lm_diff = lm(goal_diff ~ h_rest + v_rest + h_att_str + h_def_weak + v_att_str + 
               v_def_weak + h_load + v_load, data = df)
