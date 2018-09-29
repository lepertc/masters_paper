##### Library #####
library(ggplot2); theme_set(theme_bw())
library(gridExtra)
library(data.table)

##### Executed Statements #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/teamHistory.rds")

# Home
df_h = as.data.table(cbind(rpois(100*nrow(df), mean(df$hgoal)), rep(1, 100*nrow(df))))
names(df_h) = c("n_goal", "one")
df_h = df_h[, list(count = sum(one)/100), by = n_goal]

h_lab = paste("Mean: ", round(mean(df$hgoal), 2),
              "Variance: ", round(var(df$hgoal), 2))

p1 <- ggplot(df, aes(x = hgoal)) + geom_histogram(binwidth = 1, color = "darkgrey", fill = "grey") + 
  labs(title = "Distribution of goals overlayed with expected number of goals assuming\na poisson distribution\nHome goals",
       y = NULL, x = NULL) +
  geom_text(aes(x = 6, y = 1500, label = h_lab)) +
  scale_x_continuous(breaks = c(0, 2, 4, 6, 8), labels = c(0, 2, 4, 6, 8)) +
  geom_point(data = df_h, aes(x = n_goal, y = count), color = "darkred") +
  theme(plot.title = element_text(size = 10), axis.text.x = element_text(size = 8),
        axis.text.y = element_text(size = 8), axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10))

# Visitor 

df_v = as.data.table(cbind(rpois(100*nrow(df), mean(df$vgoal)), rep(1, 100*nrow(df))))
names(df_v) = c("n_goal", "one")
df_v = df_v[, list(count = sum(one)/100), by = n_goal]

v_lab = paste("Mean: ", round(mean(df$vgoal), 2),
              "Variance: ", round(var(df$vgoal), 2))

p2 <- ggplot(df, aes(x = vgoal)) + geom_histogram(binwidth = 1, color = "darkgrey", fill = "grey") + 
  labs(title = "Visitor goals",
       y = NULL, x = "Number of goals") +
  geom_text(aes(x = 6, y = 1500, label = v_lab)) +
  scale_x_continuous(breaks = c(0, 2, 4, 6, 8), labels = c(0, 2, 4, 6, 8)) +
  geom_point(data = df_v, aes(x = n_goal, y = count), color = "darkred") +
  theme(plot.title = element_text(size = 10), axis.text.x = element_text(size = 8),
        axis.text.y = element_text(size = 8), axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10))

p <- grid.arrange(p1, p2)
