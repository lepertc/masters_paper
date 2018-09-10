library(ggplot2); theme_set(theme_bw())

r1 = rnorm(10000, 10, 10)
r2 = rnorm(10000, 0, 10)

pred = c(r1, r2)
group = c(rep(1, 10000), rep(0, 10000))

df = as.data.frame(cbind(group, pred))
df$group = as.factor(df$group)
df$fill = "tie"
df$fill[df$pred > 2] = "win"
df$fill[df$pred < -10] = "loss"

p <- ggplot(df, aes(x = pred)) + geom_density() + 
  geom_vline(xintercept = 2) +
  geom_vline(xintercept = -10) + facet_grid(group ~ .) + 
  labs(title = "Distribution of ability to win a match depending on whether or not a feature is matched")
