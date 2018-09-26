##### Library #####
library(ggplot2); theme_set(theme_bw())

##### Executed Statements #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/tennisHistoryProcess.rds")

##### Previous match length ######
df_p = df[df$won == 1, ]

p1 <- ggplot(df_p, aes(x = minutes)) + geom_histogram(binwidth = 5) + 
  xlim(c(0, 400)) + labs(title = "Distribution of tennis match length")

p2 <- ggplot(df_p[df_p$set != 1 & df_p$set != 6,], 
             aes(x = game, fill = as.factor(set))) + 
  geom_histogram(binwidth = 1, alpha = 0.5, position="identity") + 
  xlim(c(0, 75)) +
  labs(title = "Distribution of the number of games in tennis matches by number of set",
       x = "Number of games", fill = NULL)

p3 <- ggplot(df_p[df_p$set != 1 & df_p$set != 6,], aes(x = game/set, color = as.factor(set))) + 
  geom_density() + xlim(c(0, 20)) +
  labs(title = "Number of games per set by number of sets", color = NULL)

p4 <- ggplot(df_p[df_p$set != 1 & df_p$set != 6,], aes(x = minutes/set, color = as.factor(set))) + 
  geom_density() + xlim(c(0, 75))

p5 <- ggplot(df_p[df_p$set != 1 & df_p$set != 6,], 
       aes(x = minutes/set, y = game/set, color = as.factor(set))) + 
  geom_point() + xlim(c(0, 100))

##### Surface #####
s = as.data.frame(table(df_p$surface))
s$share = s$Freq/sum(s$Freq)
rownames(s) = s$Var1
s$Var1 = NULL
  
  