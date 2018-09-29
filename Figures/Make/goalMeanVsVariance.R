##### Library #####
library(ggplot2); theme_set(theme_bw())
library(data.table)

##### Load Data #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/teamHistory.rds")
df = as.data.table(df)

df_mean_var_h = df[, list(mean = mean(hgoal), variance = var(hgoal)), 
                   by = c("Season", "home")]

df_mean_var_v = df[, list(mean = mean(vgoal), variance = var(vgoal)), 
                   by = c("Season", "visitor")]

names(df_mean_var_h)[2] = "team"
df_mean_var_h$side = "Home"

names(df_mean_var_v)[2] = "team"
df_mean_var_v$side = "Visitor"

df_mean_var = rbind(df_mean_var_h, df_mean_var_v)

p <- ggplot(df_mean_var, aes(x = mean, y = variance)) + geom_point(size = 0.5) + facet_wrap(~ side, scale = "free") + 
  labs(title = "Variance and Mean of the number of goals in a game split by home and visitor goals",
       x = "Mean", y = "Variance") + theme(plot.title = element_text(size = 10),
                                           axis.text.x = element_text(size = 8),
                                           axis.text.y = element_text(size = 8),
                                           axis.title.x = element_text(size = 10),
                                           axis.title.y = element_text(size = 10))
