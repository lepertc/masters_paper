##### Library #####
library(stargazer)

##### Load data #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/teamHistoryProcessed.rds")

df_home = df$df_home
df_vis = df$df_vis

##### Home goals #####
m_home_days = glm(hgoal ~ Team_rest + Opp_rest + Team_att_str + Opp_def_weak +  
                    Team_load + Opp_load, data = df_home, family = poisson)

summary(m_home_days)

m_home_bin = glm(hgoal ~ Team_rest_bin + Opp_rest_bin + Team_att_str + Opp_def_weak + 
                   Team_load + Opp_load, data = df_home, family = poisson)

summary(m_home_bin)

##### Away goals #####
m_vis_days = glm(vgoal ~ Team_rest + Opp_rest + Team_att_str + Opp_def_weak + 
                   Team_load + Opp_load, data = df_vis, family = poisson)

summary(m_vis_days)

m_vis_bin = glm(vgoal ~ Team_rest_bin + Opp_rest_bin + Team_att_str + Opp_def_weak + 
                  Team_load + Opp_load, data = df_vis, family = poisson)

summary(m_vis_bin)



