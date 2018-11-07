##### Library #####
library(stargazer)
library(data.table)

##### Functions #####
sample_n_percent_win = function(df, per) {
  n_id = nrow(df)
  samp = sample(unique(df$match_id), round(length(unique(df$match_id))*per), replace = FALSE)
  df_win = df[(df$match_id %in% samp) & df$won == 1, ]
  df_lose = df[!(df$match_id %in% samp) & df$won == 0, ]
  return(rbind(df_win, df_lose))
}

##### Load data #####
df = readRDS("/Users/chloelepert/Documents/masters_paper/data-processing/Data/tennisHistoryProcess.rds")
df$delta_hours_2 = df$delta_hours^2

df = sample_n_percent_win(df, 0.5)
##### Build models #####

# Table 1
m0 <- glm(won ~ delta_hours, data = df, family = binomial)

m02 <- glm(won ~ delta_hours + delta_hours_2, data = df, family = binomial)

m1 <- glm(won ~ delta_hours + delta_rank_pts + mean_rank_pts, data = df, 
          family = binomial)

m2 <- glm(won ~ delta_hours + delta_rank_pts + mean_rank_pts + player_seed + opp_seed, data = df, 
          family = binomial)

m2b <- glm(won ~ delta_hours + delta_rank_pts + mean_rank_pts + player_seed + opp_seed, data = df, 
          family = binomial)
# Table 2
m3 <- glm(won ~ delta_rank_pts + mean_rank_pts + delta_hours:surface + player_seed + opp_seed, data = df, 
          family = binomial)

m4 <- glm(won ~ delta_rank_pts + mean_rank_pts+ delta_hours:as.factor(best_of) + player_seed + opp_seed, data = df, 
           family = binomial)

m53 <- glm(won ~ delta_rank_pts + mean_rank_pts+ delta_hours:surface + player_seed + opp_seed, 
           data = df[best_of == 3], family = binomial)

m55 <- glm(won ~ delta_rank_pts + mean_rank_pts+delta_hours:surface + player_seed + opp_seed, 
           data = df[best_of == 5], family = binomial)

df_sim_rank = df#[df$player_seed == FALSE & df$opp_seed == FALSE, ]

df_sim_rank$delta_rank = rank(abs(df_sim_rank$delta_rank_pts))

out = list()
for(i in seq(500, 18800, 500)) {
  m2_sim_i <- glm(won ~ delta_hours + delta_rank_pts + player_seed + opp_seed + mean_rank_pts, data = df_sim_rank[df_sim_rank$delta_rank < i, ], 
                family = binomial)
  s = summary(m2_sim_i)
  out[[length(out) + 1]] = list(coef = m2_sim_i$coefficients["delta_hours"], se = s$coefficients["delta_hours", "Std. Error"], i = i)
}

df_out = rbindlist(out)

#  
  

