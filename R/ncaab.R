extract_odds("https://www.covers.com/sport/basketball/ncaab/odds") %>% 
  add_names(.,
            "https://www.covers.com/sport/basketball/ncaab/matchup/") %>% 
  extract_good_bets(.) %>% View()




