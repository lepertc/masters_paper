##### Library #####
library(data.table)
library(bivpois)
library(stargazer)

##### Load data #####
data_in <- readRDS("~/Documents/masters_paper/models/bivariates.rds")
cont = data_in$continuous
bin = data_in$binary

##### Executed statements #####
cond_df = data.frame()

for(i in 1:200) {
  cond_df = rbind(cond_df, cont[[i]])
}

names(cond_df) = names(cont[[1]])
cond_df$one = 1
cond_df = aggregate(. ~ one, cond_df, FUN = sd)

df = readRDS("~/Documents/masters_paper/data-processing/Data/teamHistoryProcessed.rds")
df_home = df$df_home

m_days = lm.bp(hgoal ~ Team_rest + Opp_rest + Team_att_str + Opp_def_weak + Team_load + Opp_load, 
               vgoal ~ Team_rest + Opp_rest + Opp_att_str + Team_def_weak + Team_load + Opp_load, 
               l3 = ~ Team_rest + Opp_rest + Team_att_str + Opp_def_weak + Opp_att_str + Team_def_weak + Team_load + Opp_load, data = df_home)

cond_df = t(cond_df)
cond_df = cond_df[2:length(cond_df)]
cond_df = cbind(cond_df, m_days$coefficients)
cond_df = as.data.frame(cond_df)
names(cond_df) = c("SD", "Model")
cond_df$SE = cond_df$SD/sqrt(200)
cond_df$t = cond_df$Model/cond_df$SE

cond_df$sig = ""
cond_df$sig[abs(cond_df$t) > 1.645] = "*"
cond_df$sig[abs(cond_df$t) > 1.960] = "**"
cond_df$sig[abs(cond_df$t) > 2.576] = "***"

cond_df$m2 = paste0(round(cond_df$Model, digits = 3), cond_df$sig, " (", round(cond_df$SE, digits = 3), ")")

m_bin = lm.bp(hgoal ~ Team_rest_bin + Opp_rest_bin + Team_att_str + Opp_def_weak + Team_load + Opp_load, 
              vgoal ~ Team_rest_bin + Opp_rest_bin + Opp_att_str + Team_def_weak + Team_load + Opp_load, 
              l3 = ~ Team_rest_bin + Opp_rest_bin + Team_att_str + Opp_def_weak + Opp_att_str + Team_def_weak + Team_load + Opp_load, 
              data = df_home)

bin_df = data.frame()

for(i in 1:200) {
  bin_df = rbind(bin_df, bin[[i]])
}

names(bin_df) = names(bin[[1]])
bin_df$one = 1
bin_df = aggregate(. ~ one, bin_df, FUN = sd)

bin_df = t(bin_df)
bin_df = bin_df[2:length(bin_df)]
bin_df = cbind(bin_df, m_bin$coefficients)
bin_df = as.data.frame(bin_df)
names(bin_df) = c("SD", "Model")
bin_df$SE = bin_df$SD/sqrt(200)
bin_df$t = bin_df$Model/bin_df$SE

bin_df$sig = ""
bin_df$sig[abs(bin_df$t) > 1.645] = "*"
bin_df$sig[abs(bin_df$t) > 1.960] = "**"
bin_df$sig[abs(bin_df$t) > 2.576] = "***"

bin_df$m1 = paste0(round(bin_df$Model, digits = 3), bin_df$sig, " (", round(bin_df$SE, digits = 3), ")")

bin_df$cova = row.names(bin_df)
cond_df$cova = row.names(cond_df)

df = merge(bin_df, cond_df, by  = "cova", all = TRUE)
df = df[, c("cova", "m1", "m2")]

df$resp = "Home"
df$resp[grepl("l2", df$cova) == TRUE] = "Visitor"
df$resp[grepl("l3", df$cova) == TRUE] = "Game"

df$cova = c("Intercept", "Visitor defensive weakness", "Visitor load", "Visitor rest (days)",
            "Visitor rest > 5 days", "Home attacking strength", "Home load", 
            "Home rest (days)", "Home rest > 5 days", "Intercept", "Visitor Attacking strength",
            "Visitor load", "Visitor rest (days)", "Visitor rest > 5 days", "Home defensive weakness",
            "Home load", "home rest (days)", "Home rest > 5 days", "Intercept", 
            "Visitor attacking strength", "Visitor defensive strength", "Visitor load",
            "Visitor rest", "Visitor rest > 5 days", "Home attacking strength", "Home defensive weakness",
            "Home load", "Home rest (days)", "Home rest > 5 days")

df = df[, c("resp", "cova", "m1", "m2")]

stargazer(df, summary = FALSE, no.space = TRUE, rownames = FALSE, table.placement = "H",
          title = "Bivariate model for number of goals scored by each team")
