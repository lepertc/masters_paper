##### Library #####
library(bivpois)
library(data.table)
library(tidyr)

##### Load data #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/teamHistoryProcessed.rds")

df_home = df$df_home

simp = lm.bp(hgoal ~ 1, vgoal ~ 1, zeroL3 = TRUE, data = df_home)

# Continuous rest time: 

n = nrow(df_home)
B = 200

out.1 = list()
out.2 = list()

for(i in 1:B) {
  samp = sample(n, replace = TRUE)
  samp.df = df_home[samp, ]
  cont.bp = lm.bp(hgoal ~ Team_rest + Opp_rest + Team_att_str + Opp_def_weak + Team_load + Opp_load, 
                  vgoal ~ Team_rest + Opp_rest + Opp_att_str + Team_def_weak + Team_load + Opp_load, 
                  l3 = ~ Team_rest + Opp_rest + Team_att_str + Opp_def_weak + Opp_att_str + Team_def_weak + Team_load + Opp_load, 
                  data = samp.df, verbose = FALSE)
  bin.bp = lm.bp(hgoal ~ Team_rest_bin + Opp_rest_bin + Team_att_str + Opp_def_weak + Team_load + Opp_load, 
                 vgoal ~ Team_rest_bin + Opp_rest_bin + Opp_att_str + Team_def_weak + Team_load + Opp_load, 
                 l3 = ~ Team_rest_bin + Opp_rest_bin + Team_att_str + Opp_def_weak + Opp_att_str + Team_def_weak + Team_load + Opp_load, 
                 data = samp.df, verbose = FALSE)
  out.1[[length(out.1) + 1]] = cont.bp$coefficients
  out.2[[length(out.2) + 1]] = bin.bp$coefficients
  print(i)
}

saveRDS(list(continuous = out.1, binary = out.2), 
        "~/Documents/masters_paper/models/bivariates.rds")

