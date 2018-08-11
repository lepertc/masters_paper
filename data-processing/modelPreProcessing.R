##### Library #####
library(data.table)

##### Load Data #####
df = readRDS("~/Documents/masters_paper/data-processing/Data/teamHistory.rds")

# Number of rest days
df$h_rest = as.numeric(difftime(df$Date, df$h_date_prior, units = "days"))
df$v_rest = as.numeric(difftime(df$Date, df$v_date_prior, units = "days"))

# Restrict to games with a previous game within 8 days
df = df[h_rest <= 8 & v_rest <= 8]

# Rest as binary variable
df$h_rest_bin = df$h_rest > 6
df$v_rest_bin = df$v_rest > 6
saveRDS(df, "~/Documents/masters_paper/data-processing/Data/teamHistoryProcessed.rds")
