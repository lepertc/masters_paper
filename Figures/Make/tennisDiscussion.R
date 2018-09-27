##### Library #####
library(ggplot2); theme_set(theme_bw())
library(data.table)

##### Load data #####
df = readRDS("/Users/chloelepert/Documents/masters_paper/data-processing/Data/tennisHistoryProcess.rds")

# ggplot(df, aes(x = player_prior_minutes, color = player_seed)) + 
#  geom_density() + xlim(0, 400)

# ggplot(df, aes(x = player_prior_minutes, y = player_rank_points)) + geom_point(size = 0.05) +
#  xlim(0, 400)

cor.test(df[df$won == 1, ]$player_prior_minutes, df[df$won == 1, ]$player_rank_points)

df = as.data.table(df)

df$one = 1
df_seed = df[, list(count = sum(one), min_mean = mean(delta_minutes), min_sd = sd(player_prior_minutes)),
             by = c("player_seed", "opp_seed")]
df_seed$se = df_seed$min_sd/sqrt(df_seed$count)

m1 = glm(minutes ~ player_seed:opp_rank_points, df, family = poisson)

df = df[set > 1]
m43 <- glm(won ~ delta_hours:as.factor(set) + delta_rank_pts +  player_seed + 
             opp_seed, data = df[best_of == 3 & set < 4], family = binomial)

m45 <- glm(won ~ delta_hours:as.factor(set) + delta_rank_pts +  player_seed + 
             opp_seed, data = df[best_of == 5], family = binomial)
