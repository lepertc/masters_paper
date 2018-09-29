library(ggplot2); theme_set(theme_bw())

r1 = rnorm(10000, 10, 10)
r2 = rnorm(10000, 0, 10)

pred = c(r1, r2)
group = c(rep(1, 10000), rep(0, 10000))

df = as.data.frame(cbind(group, pred))
df$group[df$group == 1] = "Feature matched"
df$group[df$group == 0] = "Feature NOT matched"

df$group = as.factor(df$group)

df$fill = "Tie"
df$fill[df$pred > 2] = "Win"
df$fill[df$pred < -10] = "Loss"

p <- ggplot(df, aes(x = pred)) + geom_density() + 
  geom_vline(xintercept = 2) +
  geom_vline(xintercept = -10) + facet_wrap(~ group, nrow = 2) + 
  labs(title = "Distribution of ability to win a match depending on whether or not a feature\nis matched",
       x = "Ability to win a match", y = NULL) +
  theme(plot.title = element_text(size = 10), axis.text.x = element_text(size = 8),
        axis.text.y = element_text(size = 8), axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10)) +
  geom_text(aes(x = -30, y = 0.02, label = "Lose")) +
  geom_text(aes(x = -4, y = 0.02, label = "Tie")) +
  geom_text(aes(x = 30, y = 0.02, label = "Win"))
