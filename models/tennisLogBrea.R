##### Library #####
library(ggplot2)

##### Functions #####

sample_n_percent_win = function(df, per) {
  n_id = nrow(df)
  samp = sample(n_id, round(n_id*per), replace = FALSE)
  df_win = df[(df$match_id %in% samp) & df$won == 1, ]
  df_lose = df[!(df$match_id %in% samp) & df$won == 0, ]
  return(rbind(df_win, df_lose))
}

model_n_percent = function(df, per) {
  d = sample_n_percent_win(df, per)
  m1 <- glm(won ~ delta_rank_pts + player_seed + opp_seed + delta_hours, data = d, 
            family = binomial)
  d1 <- as.data.frame(summary(m1)$coefficients)
  d1$mod = "m1"
  m2 <- glm(won ~ delta_rank_pts +  player_seed + opp_seed + delta_hours:as.factor(best_of), data = d, 
            family = binomial)
  d2 <- as.data.frame(summary(m2)$coefficients)
  d2$mod = "m2"
  df = rbind(d1, d2)
  df$per = per
  return(df)
}

model_all_percents = function(df) {
  df_out = data.frame()
  for(i in seq(0.01, 0.99, 0.01)){
    print(i)
    df_out = rbind(df_out, model_n_percent(df, i))
  }
  df_out$cov = rownames(df_out)
  return(df_out)
}

##### Load data #####
df = readRDS("/Users/chloelepert/Documents/masters_paper/data-processing/Data/tennisHistoryProcess.rds")

df_all = model_all_percents(df)
df_simp = df_all[grepl("delta_hours", df_all$cov) == TRUE, ]
df_simp$simp = grepl("delta_hours[0-9]", df_simp$cov)
ggplot(df_simp[df_simp$sim == TRUE, ], aes(x = per, y = Estimate)) + geom_point()

ggplot(df_simp[df_simp$sim == FALSE, ], aes(x = per, y = Estimate, color = grepl("[(]best_of[)]5", cov))) + geom_point()

m1 <- glm(won ~ delta_rank_pts + player_seed + opp_seed + delta_hours, data = df, 
          family = binomial)

m2 <- glm(won ~ delta_rank_pts +  player_seed + opp_seed + delta_hours:as.factor(best_of), data = df, 
          family = binomial)
