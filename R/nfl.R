extract_odds("https://www.covers.com/sport/football/nfl/odds") %>% 
  add_names(.,
            "https://www.covers.com/sport/football/nfl/matchup/") %>% 
  extract_good_bets(.)

