##### Library #####
library(stargazer)

##### Load data #####
df = readRDS("/Users/chloelepert/Documents/masters_paper/data-processing/Data/tennisHistoryProcess.rds")

##### Build models #####

m0 <- glm(won ~ delta_minutes, data = df, 
          family = binomial)

summary(m0)

m1 <- glm(won ~ delta_minutes + delta_rank_pts, data = df, 
          family = binomial)

summary(m1)

m2 <- glm(won ~ delta_minutes:surface + delta_rank_pts, data = df, 
          family = binomial)

summary(m2)

m2b <- glm(won ~ poly(delta_minutes, 2):surface + delta_rank_pts, data = df, 
          family = binomial)

summary(m2b)

m3 <- glm(won ~ delta_minutes:as.factor(best_of) + delta_rank_pts, data = df, 
          family = binomial)

summary(m3)

m3b <- glm(won ~ poly(delta_minutes, 2):as.factor(best_of) + delta_rank_pts, data = df, 
          family = binomial)

summary(m3b)


m4 <- glm(won ~ delta_minutes:as.factor(best_of):surface + delta_rank_pts, data = df, 
          family = binomial)

summary(m4)

stargazer(m0, m1, m3, m2, m4)

m1 <- glm(won ~ delta_minutes + delta_set + delta_game + delta_rank_pts, data = df, 
          family = binomial)

summary(m1)

m2 <- glm(won ~ poly(delta_minutes, 2) + poly(delta_set, 2) + poly(delta_game, 2) + 
            delta_rank_pts, data = df, 
          family = binomial)

summary(m2)

m3 <- glm(won ~ delta_minutes + min_per_game + delta_set + delta_rank_pts, data = df, 
          family = binomial)

summary(m3)
