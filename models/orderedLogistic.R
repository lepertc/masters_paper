##### Library #####
library(stargazer)
library(MASS)
library(glm.predict)

##### Load data #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/teamHistoryProcessed.rds")

df_home = df$df_home

##### Executed Statements #####

m_days = polr(outcome ~ Team_rest + Opp_rest + Team_att_str + Opp_def_weak +
                Opp_att_str + Team_def_weak + Team_load + Opp_load, data = df_home)

summary(m_days)

m_bin = polr(outcome ~ Team_rest_bin + Opp_rest_bin + Team_att_str + Opp_def_weak + 
               Opp_att_str + Team_def_weak + Team_load + Opp_load, data = df_home)

summary(m_bin)

##### Printing model #####
stargazer(m_days, m_bin, no.space = TRUE, title = "Ordered logistic model")
