##### Library #####
library(data.table)

##### Load data #####
setwd("/Users/chloelepert/Documents/masters_paper/data-processing/Raw-Data/atp-matches-dataset")
files <- (Sys.glob("*.csv"))

out_m <- list()
for(i in files) {
  add = as.data.table(fread(i))
  out_m[[length(out_m) + 1]] <- add
}

df = rbindlist(out_m, fill = TRUE)[, 1:49]
df = df[is.na(minutes) == FALSE]

df = df[, c("tourney_name", "winner_id", "loser_id", "tourney_date", "surface", 
            "winner_seed", "winner_rank", "winner_rank_points", "loser_rank", 
            "loser_rank_points", "best_of", "round", "minutes")]

##### Process Variables #####

df$Date = as.Date(paste(substr(df$tourney_date, 1, 4), substr(df$tourney_date, 5, 6),
                substr(df$tourney_date, 7, 8), sep = "-"))

df$winner_id = as.factor(df$winner_id)
df$loser_id = as.factor(df$loser_id)

##### Get player histories #####

df_win = df[, c("tourney_name", "winner_id", "Date", "surface", "best_of", 
                "round", "minutes")]
df_win$outcome = "Win"
names(df_win)[2] = "Player"

df_los = df[, c("tourney_name", "loser_id", "Date", "surface", "best_of", 
                "round", "minutes")]
df_los$outcome = "Lose"
names(df_los)[2] = "Player"

df_hist = rbind(df_win, df_los)

df_hist[, date_order := rank(Date, ties.method = "first"), by = "Player"]

##### Get prior match
df_prior = df_hist
df_prior$date_order = df_prior$date_order - 1

names(df_prior) = paste("prior_", names(df_prior), sep = "")

df_hist = merge(df_hist, df_prior, by.x = c("date_order", "Player"), 
by.y = c("prior_date_order", "prior_Player"))

df_prior_info = df_hist[, c("Player", "Date", "round", "prior_round", "prior_minutes",
                            "prior_outcome", "prior_tourney_name", "prior_surface",
                            "prior_best_of")]

df_prior_info_w = df_prior_info
names(df_prior_info_w) = paste("w_", names(df_prior_info_w), sep = "")
df_prior_info_l = df_prior_info
names(df_prior_info_l) = paste("l_", names(df_prior_info_l), sep = "")

df = merge(df, df_prior_info_w, by.x = c("Date", "winner_id", "round"), by.y = c("w_Date", "w_Player", "w_round"))
df = merge(df, df_prior_info_l, by.x = c("Date", "loser_id", "round"), by.y = c("l_Date", "l_Player", "l_round"))

df$winner_won = 1
df$loser_won = 0

saveRDS(df, "/Users/chloelepert/Documents/masters_paper/data-processing/Data/tennisHistory.rds")

