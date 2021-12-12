extract_odds("https://www.covers.com/sport/hockey/nhl/odds") %>% 
  add_names(.,
            "https://www.covers.com/sport/hockey/nhl/matchup/") %>% 
extract_good_bets(.)
