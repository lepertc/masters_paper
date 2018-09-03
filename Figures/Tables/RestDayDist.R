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
