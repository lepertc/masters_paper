##### Library #####
library(glmnet)

##### Load data #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/tennisHistoryProcess.rds")

##### EDA #####

# Round
table(df$round)/2

# Surface
table(df$surface)/2

# Seed
table(df$player_seed)
table(is.na(df$player_seed))
table(is.na(df$player_seed), is.na(df$opp_seed))

# Rank
hist(df$player_rank)

# Points
hist(df$player_rank_points)

# Best of
table(df$best_of)

# Minutes
hist(df$minutes)

# Prior outcome
table(df$won, df$player_prior_outcome)

# Rest 
table(df$opp_rest) # weird no games 1-5 day apart
table(df[df$same_tourn == TRUE, ]$player_rest, df[df$same_tourn == TRUE, ]$opp_rest)
# Turns out we only get the tournament date, not the match date

##### GLM ##### weird symmetries

m1 <- glm(won ~ player_rank + opp_rank, data = df, family = binomial)

m2 <- glm(won ~ player_rank_points + opp_rank_points, data = df, family = binomial)

m3 <- glm(won ~ player_rank_points + opp_rank_points + opp_prior_minutes +
            player_prior_minutes, data = df, family = binomial)

m4 <- glm(won ~ player_rank_points + opp_rank_points + opp_prior_minutes +
            player_prior_minutes, data = df[same_tourn == TRUE], family = binomial)

m5 <- glm(won ~ player_rank_points + opp_rank_points + opp_prior_minutes +
            player_prior_minutes + opp_prior_surface + player_prior_surface +
            is.na(df$player_seed) + is.na(df$opp_seed), data = df, family = binomial)

# GLM, GLMNet, XGboost

