##### Library #####
library(data.table)
library(stringr)

##### Load data #####
setwd("/Users/chloelepert/Documents/masters_paper/data-processing/Raw-Data/atp-matches-dataset")
files <- (Sys.glob("*.csv"))

out_m <- list()
for(i in files) {
  add = as.data.table(fread(i))
  out_m[[length(out_m) + 1]] <- add
}

df = rbindlist(out_m, fill = TRUE)[, 1:49]
df = df[is.na(minutes) == FALSE & round != "RR"]

df$match_id = 1:nrow(df)
df = df[, c("tourney_name", "winner_id", "loser_id", "tourney_date", "surface", 
            "winner_seed", "loser_seed", "winner_rank", "winner_rank_points", "loser_rank", 
            "loser_rank_points", "best_of", "round", "minutes", "score", "match_id")]

nrow(unique(df[, c("winner_id", "round", "tourney_date")]))

##### Process Variables #####
df$round_num = 0
df$round_num[df$round == "R128"] = 1
df$round_num[df$round == "R64"] = 2
df$round_num[df$round == "R32"] = 3
df$round_num[df$round == "R16"] = 4
df$round_num[df$round == "QF"] = 5
df$round_num[df$round == "SF"] = 6
df$round_num[df$round == "F"] = 7

df$Date = as.Date(paste(substr(df$tourney_date, 1, 4), substr(df$tourney_date, 5, 6),
                substr(df$tourney_date, 7, 8), sep = "-"))

df$winner_id = as.factor(df$winner_id)
df$loser_id = as.factor(df$loser_id)

df$retired = grepl("RET", df$score)
df$tie_break = 1 + 2*as.numeric(str_extract(str_extract(df$score, "\\([0-9]{1,2}\\)"), "[0-9]{1,2}"))

df$score = gsub("\\([0-9]{1,2}\\)", "", df$score)
df$score = gsub(" RET", "", df$score)
df$score = gsub(" DEF", "", df$score)

df$game = strsplit(df$score, " |-")
df$set = as.numeric(str_count(df$score, "-"))

out = c()
for(i in df$game){
  out[length(out) + 1] = sum(as.numeric(i), na.rm = TRUE)
}

df$game = out
df$tie_break[is.na(df$tie_break)] = 0

df$game = df$game + df$tie_break

##### Get player histories #####
df_win = df[, c("tourney_name", "winner_id", "Date", "surface", "best_of", 
                "round", "minutes", "game", "set", "retired", "match_id",
                "round_num")]
df_win$outcome = "Win"
names(df_win)[2] = "Player"

df_los = df[, c("tourney_name", "loser_id", "Date", "surface", "best_of", 
                "round", "minutes", "game", "set", "retired", "match_id",
                "round_num")]
df_los$outcome = "Lose"
names(df_los)[2] = "Player"

df_hist = rbind(df_win, df_los)

##### Get prior match
df_prior = df_hist
df_prior$round_num = df_prior$round_num + 1

names(df_prior) = paste("prior_", names(df_prior), sep = "")

df_hist = merge(df_hist, df_prior, by.x = c("Date", "round_num", "Player"), 
                by.y = c("prior_Date", "prior_round_num", "prior_Player"))

df_prior_info = df_hist[, c("Player", "Date", "round", "prior_round", "prior_minutes",
                            "prior_outcome", "prior_tourney_name", "prior_surface", "match_id",
                            "prior_best_of", "prior_game", "prior_set", "prior_retired", "outcome")]

df_prior_info_w = df_prior_info[outcome == "Win"]
names(df_prior_info_w) = paste("w_", names(df_prior_info_w), sep = "")
df_prior_info_l = df_prior_info[outcome == "Lose"]
names(df_prior_info_l) = paste("l_", names(df_prior_info_l), sep = "")

df = merge(df, df_prior_info_w, by.x = c("match_id"), by.y = c("w_match_id"))
df = merge(df, df_prior_info_l, by.x = c("match_id"), by.y = c("l_match_id"))

x = as.data.frame(table(df$Date, df$winner_id, df$round))

##### One row per player-match #####

df_w = df
df_l = df

names(df_w) = gsub("winner_", "player_", names(df_w))
names(df_w) = gsub("w_", "player_", names(df_w))
names(df_w) = gsub("loser_", "opp_", names(df_w))
names(df_w) = gsub("l_", "opp_", names(df_w))

names(df_l) = gsub("winner_", "opp_", names(df_l))
names(df_l) = gsub("w_", "opp_", names(df_l))
names(df_l) = gsub("loser_", "player_", names(df_l))
names(df_l) = gsub("l_", "player_", names(df_l))

df_w$won = 1
df_l$won = 0

df = rbind(df_w, df_l)

saveRDS(df, "/Users/chloelepert/Documents/masters_paper/data-processing/Data/tennisHistory.rds")

