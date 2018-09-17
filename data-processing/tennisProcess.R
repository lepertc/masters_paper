##### Library #####
library(data.table)

##### Load data #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/tennisHistory.rds")
df = as.data.table(df)

df$player_same_tourn = df$tourney_name == df$player_prior_tourney_name

df$same_tourn = (df$tourney_name == df$opp_prior_tourney_name) & (df$tourney_name == df$player_prior_tourney_name)

df$player_rest = as.numeric(difftime(df$Date, df$player_prior_Date, "days"))/(60*60*24)
df$opp_rest = as.numeric(difftime(df$Date, df$opp_prior_Date, "days"))/(60*60*24)

df$player_rank_points[is.na(df$player_rank_points)] = 0
df$opp_rank_points[is.na(df$opp_rank_points)] = 0
df$delta_minutes = df$player_prior_minutes - df$opp_prior_minutes
df$delta_rank_pts = df$player_rank_points - df$opp_rank_points
df$mean_rank_pts = (df$player_rank_points + df$opp_rank_points)/2
df$delta_set = df$player_prior_set - df$opp_prior_set
df$delta_game = df$player_prior_game - df$opp_prior_game

df = df[is.na(df$delta_game) == FALSE,  ]
##### Executed statements #####
saveRDS(df, "/Users/chloelepert/Documents/masters_paper/data-processing/Data/tennisHistoryProcess.rds")
