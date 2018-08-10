##### Library ######
library(engsoccerdata)
library(data.table)

##### Load Data #####
data("england")
data("englandplayoffs")
data("facup")
data("champs")

##### Executed Statements #####

# Combine game types
england_hist <- england[, c("Date", "home", "visitor", "Season")]
england_hist$type <- "england"
champs <- champs[, c("Date", "home", "visitor", "Season")]
champs$type <- "champs"
facup <- facup[, c("Date", "home", "visitor", "Season")]
facup$type <- "facup"
playoff <- englandplayoffs[, c("Date", "home", "visitor", "Season")]
playoff$type <- "playoff"
games <- as.data.table(rbind(england_hist, champs, facup, playoff))

# Filter to relevant years
games$Date = as.Date(games$Date)
games$year = year(games$Date)
games = games[Date < as.Date("2016-07-01") & Date > as.Date("1995-07-01"), ]

# Get season game load
games = melt(games, id.vars = c("Date", "type", "year", "Season"), 
             variable.name = "location", value.name =  "team")
team_season_load = games[, .(load = .N), by = list(team, Season)]

# Get previous game location and date
games[, date_order := rank(Date), by = "team"]
games = games[, year := NULL]
games_prior = games
games_prior$type = NULL
games_prior$Season = NULL
games_prior$date_order = games_prior$date_order + 1
setnames(games_prior, c("Date", "location"), c("Date_prior", "location_prior"))
games = merge(games, games_prior, by = c("team", "date_order"))

games = merge(games, team_season_load, by = c("team", "Season"))

# Get game information
league_games = as.data.table(england)
league_games$Date = as.Date(league_games$Date)
league_games = league_games[Date < as.Date("2016-07-01") & Date > as.Date("1995-07-01") & division == 1, 
                            c("Date", "Season", "home", "visitor", "hgoal", "vgoal", "division")]

# Get team strength
league_goal_avg = league_games[, .(home_goals = mean(hgoal), visitor_goals = mean(vgoal)), 
                           by = .(Season, division)]

home_goal_avgs = league_games[, .(scored_goals = mean(hgoal), taken_goals = mean(vgoal)), 
                              by = .(Season, home, division)]
home_goal_avgs = merge(home_goal_avgs, league_goal_avg, by = c("Season"))
home_goal_avgs$h_att_str = home_goal_avgs$scored_goals/home_goal_avgs$home_goals
home_goal_avgs$h_def_weak = home_goal_avgs$taken_goals/home_goal_avgs$visitor_goals

visitor_goal_avgs = league_games[, .(scored_goals = mean(vgoal), taken_goals = mean(hgoal)), 
                                 by = .(Season, visitor, division)]
visitor_goal_avgs = merge(visitor_goal_avgs, league_goal_avg, by = c("Season"))
visitor_goal_avgs$v_att_str = visitor_goal_avgs$scored_goals/visitor_goal_avgs$visitor_goals
visitor_goal_avgs$v_def_weak = visitor_goal_avgs$taken_goals/visitor_goal_avgs$home_goals

home_goal_avgs = home_goal_avgs[, c("Season", "home", "h_att_str", "h_def_weak")]
visitor_goal_avgs = visitor_goal_avgs[, c("Season",  "visitor", "v_att_str", "v_def_weak")]

home_goal_avgs$Season = 1 + home_goal_avgs$Season
visitor_goal_avgs$Season = 1 + visitor_goal_avgs$Season

league_games = merge(league_games, home_goal_avgs, by = c("Season", "home"))
league_games = merge(league_games, visitor_goal_avgs, by = c("Season", "visitor"))

league_games[, division := NULL]

# Merge in game history
games[, c("type", "date_order", "location") := NULL]
games_home = games
names(games_home)[c(1, 4:6)] = c("home", "h_date_prior", "h_location_prior", "h_load")
games_visitor = games
names(games_visitor)[c(1, 4:6)] = c("visitor", "v_date_prior", "v_location_prior", "v_load")

league_games = merge(league_games, games_home, by = c("Season", "Date", "home"))
league_games = merge(league_games, games_visitor, by = c("Season", "Date", "visitor"))

##### Save data tables #####
saveRDS(team_season_load, "~/Documents/masters_paper/data-processing/Data/loadByTeam.rds", compress = FALSE)
saveRDS(team_season_load, "~/Documents/masters_paper/data-processing/Data/teamHistory.rds", compress = FALSE)
