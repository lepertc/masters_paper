##### Library #####
library(ggplot2); theme_set(theme_bw())
library(data.table)
library(tidyr)
library(stargazer)

##### Executed Statements #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/teamHistoryProcessed.rds")

t = as.data.table(table(df$h_rest, df$v_rest))
t = spread(t, V2, N)

stargazer(t, summary = FALSE, title = "Distribution of rest time (days) for home and away teams")

t2 = as.data.table(table(df$h_rest_bin, df$v_rest_bin))
t2 = spread(t2, V2, N)

stargazer(t2, summary = FALSE, title = "Distribution of rest time for home and away teams")

# Needs some fiddling to label columns and rows

# Similar rest count

t = as.data.table(table(df$df_home$Team_rest, df$df_home$Opp_rest))
t$same_rest = t$V1 == t$V2
t$one_rest = abs(as.numeric(t$V1) - as.numeric(t$V2)) < 2
t$two_rest = abs(as.numeric(t$V1) - as.numeric(t$V2)) < 3

t_same = t[, list(num_games = sum(N)), by = same_rest]
t_one = t[, list(num_games = sum(N)), by = one_rest]
t_two = t[, list(num_games = sum(N)), by = two_rest]

