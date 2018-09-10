##### Library #####
library(data.table)

##### Load Data #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/teamHistory.rds")

# Number of rest days
df$h_rest = as.numeric(difftime(df$Date, df$h_date_prior, units = "days"))
df$v_rest = as.numeric(difftime(df$Date, df$v_date_prior, units = "days"))

# Restrict to games with a previous game within 8 days
df = df[h_rest <= 8 & v_rest <= 8]

# Rest as binary variable
df$h_rest_bin = df$h_rest > 5
df$v_rest_bin = df$v_rest > 5

df$outcome = "Tie"
df$outcome[df$hgoal > df$vgoal] = "Home Win"
df$outcome[df$hgoal < df$vgoal] = "Visitor Win"
df$outcome = factor(df$outcome, levels = c("Visitor Win", "Tie", "Home Win"))

##### Name variables #####
df_home = df
df_vis = df

names(df_home) = gsub("h_", "Team_", names(df_home))
names(df_home) = gsub("v_", "Opp_", names(df_home))

names(df_vis) = gsub("v_", "Team_", names(df_vis))
names(df_vis) = gsub("h_", "Opp_", names(df_vis))

saveRDS(list(df = df, df_home = df_home, df_vis = df_vis), "~/Documents/masters_paper/data-processing/Data/teamHistoryProcessed.rds")
