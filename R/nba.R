extract_odds("https://www.covers.com/sport/basketball/nba/odds") %>% 
  add_names(.,
            "https://www.covers.com/sport/basketball/nba/matchup/") %>% 
  extract_good_bets(.)


