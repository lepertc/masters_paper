##### Library #####
library(ggplot2); theme_set(theme_bw())
library(data.table)
library(tidyr)

##### Executed Statements #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/teamHistoryProcessed.rds")

df_h = df[, list(h_att_str = mean(h_att_str), h_def_weak = mean(h_def_weak)), by = c("home", "Season")]
df_v = df[, list(v_att_str = mean(v_att_str), v_def_weak = mean(v_def_weak)), by = c("visitor", "Season")]
names(df_h) = c("Team", "Season", "Attacking Strength", "Defensive Weakness")
names(df_v) = c("Team", "Season", "Attacking Strength", "Defensive Weakness")
df_h$type = "Home"
df_v$type = "Visitor"

df = rbind(df_h, df_v)
df_s = gather(df, "Attribute", "Value", -Team, -Season, - type)

p <- ggplot(df_s, aes(x = Value)) + geom_density() + facet_wrap(type ~ Attribute) +
  labs(y = NULL, x = NULL,
       title = "Distribution of attacking strength and defensive weakness for home and away teams")
