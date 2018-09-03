##### Library #####
library(data.table)
library(stargazer)

##### Executed Statements #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/teamHistory.rds")
df$outcome = "Tie"
df$outcome[df$hgoal > df$vgoal] = "Home win"
df$outcome[df$vgoal > df$hgoal] = "Visitor win"

sum_out = as.data.table(table(df$outcome))
sum_out$share = sum_out$N/nrow(df)
names(sum_out) = c("Outcome", "Number of games", "Share of games")

stargazer(sum_out, summary = FALSE)
