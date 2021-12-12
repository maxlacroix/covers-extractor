library(lubridate)
library(jsonlite)
library(tidyr)
library(purrr)
library(fuzzyjoin)
library(ggplot2)

ajd <- today()
demain <- today() + 10
max_events <- 100
max_makerts <- 100
sport <- 1597 #NCAAB - si jamais on voulait checker la NBA -> 584


url <- paste0("https://content.mojp-sgdigital-jel.com/content-service/api/v1/q/event-list?startTimeFrom=",
              ajd,"T05%3A00%3A00Z&startTimeTo=",
              demain,
              "T04%3A59%3A59Z&started=false&maxEvents=",
              max_events,
              "&orderEventsBy=startTime&maxMarkets=",
              max_makerts,
              "&orderMarketsBy=displayOrder&marketSortsIncluded=HH%2CHL%2CMR%2CWH&eventSortsIncluded=MTCH&includeChildMarkets=true&prioritisePrimaryMarkets=true&includeMedia=true&drilldownTagIds=",
              sport)

table_ncaab <- fromJSON(url)

table_ncaab%>%
  pluck("data") %>% 
  pluck("events") %>% 
  as.data.frame() %>%
  select(c(name, startTime, markets)) %>% 
  rename("GameName" = "name") %>% 
  unnest(cols = c(markets)) %>% 
  rename("EventName" = "name") %>% 
  filter(EventName == "Winner 2 Way")%>% 
  select(eventId, GameName, EventName, outcomes) %>% 
  unnest(cols = c(outcomes)) %>% 
  select(-displayOrder) %>% 
  unnest(cols = c(prices)) %>% 
  select(eventId,
         GameName,
         LongName = name,
         decimal) -> prices_per_market


prices_per_market %>% 
  separate(col = GameName, into = c("Away", "Home"), sep = " at ") %>% 
  mutate(line = case_when(
    Away == LongName ~ "Away",
    TRUE ~ "Home"
    
    
  )) %>% 
  pivot_wider(id_cols = c(eventId),
              values_from = c(decimal, Home, Away),
              names_from = line) %>% 
  select(eventId,
         moj_Away = decimal_Away,
         moj_Home = decimal_Home,
         
         Away = Away_Away,
         Home = Home_Home) %>% 
  
  
  stringdist_left_join(data_with_names, by = c("Away" = "Away_team",
                                    "Home" = "Home_team"),
                       max_dist = 4) %>% 
  select(-class) %>% 
  na.omit() %>% 
  group_by(eventId,
           moj_Away,
           moj_Home,
           Away,
           Home) %>% 
  
  summarise(mean_away = mean(Away_odds, na.rm = TRUE),
            max_away = max(Away_odds, na.rm = TRUE),
            mean_home = mean(Home_odds, na.rm = TRUE),
            max_home = max(Home_odds, na.rm = TRUE),
            n = n()) -> data_graph
  

data_graph %>% 
filter(moj_Away > mean_away) %>% 
  arrange(moj_Away) %>% 
  ggplot(aes(y = moj_Away,
             x = mean_away)) +
  geom_point() +
  geom_abline(slope = 1) +
  theme_bw()
 
data_graph %>% 
  filter(moj_Home > mean_home) %>% 
  arrange(moj_Home) %>% 
  ggplot(aes(y = moj_Home,
             x = mean_home)) +
  geom_point() +
  geom_abline(slope = 1) +
  theme_bw()


            