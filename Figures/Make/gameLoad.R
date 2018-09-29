##### Library #####
library(ggplot2); theme_set(theme_bw())
library(data.table)

##### Executed Statements #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/loadByTeam.rds")

df = df[df$load > 35, ]
p <- ggplot(df, aes(x = load)) + geom_histogram(binwidth = 1, color = "darkgrey", fill = "grey") + 
  labs(title = "Distribution of the number of games played by a Premier League teams\nover the course of a season",
       x = "Number of games", y = NULL,
       caption = "39-47: teams making it to various stages in the FA cup\n50-: teams making it to various stages in European competition and FA cup") +
  theme(plot.title = element_text(size = 10), axis.text.x = element_text(size = 8),
        axis.text.y = element_text(size = 8), axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10), plot.caption = element_text(size = 8))
