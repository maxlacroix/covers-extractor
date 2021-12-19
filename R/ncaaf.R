extract_odds("https://www.covers.com/sport/football/ncaaf/odds") %>% 
  add_names(.,
            "https://www.covers.com/sport/football/ncaaf/matchup/") %>% 
  extract_good_bets(.)


