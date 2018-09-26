##### Library #####
library(ggplot2); theme_set(theme_bw())
library(data.table)

##### Executed Statements #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/loadByTeam.rds")

df = df[df$load > 35, ]
p <- ggplot(df, aes(x = load)) + geom_histogram(binwidth = 1) + 
  labs(title = "Distribution of the number of games played by a Premier League teams \nover the course of a season",
       x = "Number of games", y = NULL,
       caption = "39-47: teams making it to various stages in the FA cup; \n
       50- teams making it to various stages in european competition and FA cup")
