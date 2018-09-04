##### Library #####
library(data.table)

##### Load data #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/tennisHistory.rds")
df = as.data.table(df)

df$player_same_tourn = df$tourney_name == df$player_prior_tourney_name

df$same_tourn = (df$tourney_name == df$opp_prior_tourney_name) & (df$tourney_name == df$player_prior_tourney_name)

df$player_rest = as.numeric(difftime(df$Date, df$player_prior_Date, "days"))/(60*60*24)
df$opp_rest = as.numeric(difftime(df$Date, df$opp_prior_Date, "days"))/(60*60*24)

##### Executed statements #####
saveRDS(df, "/Users/chloelepert/Documents/masters_paper/data-processing/Data/tennisHistoryProcess.rds")
