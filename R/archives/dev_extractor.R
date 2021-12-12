library(rvest)
library(dplyr)
library(stringr)
library(xml2)
library(tictoc)
library(tidyr)

tic()
dat_lines_brut <-
  read_html("https://www.covers.com/sport/football/nfl/odds") %>%
  html_nodes(".liveOddsCell") 


data_attributes <-
  bind_rows(lapply(xml_attrs(dat_lines_brut), function(x)
    data.frame(as.list(x), stringsAsFactors = FALSE)))


odds_list <- lapply(dat_lines_brut, function(x) list(Away_odds = html_nodes(x, ".__awayOdds") %>%
                                                html_nodes(".Decimal") %>%
                                                html_text() %>%
                                                str_squish() %>% 
                                                as.numeric(),
                                              
                                              Home_odds = html_nodes(x, ".__homeOdds") %>%
                                                html_nodes(".Decimal") %>%
                                                html_text() %>%
                                                str_squish() %>% 
                                                as.numeric())
)

data_with_odds <- data_attributes %>% 
  bind_cols(bind_rows(odds_list)) %>% 
  na.omit()




team_list <- lapply(data_with_odds$data.game, function(x) list(Away_team = 
                                                    paste0("https://www.covers.com/sport/football/nfl/matchup/",x) %>% 
                                                    read_html() %>% 
                                                    html_nodes(".covers-CoversMatchupDetails-awayName") %>% 
                                                    xml_contents() %>% 
                                                    html_text() %>% 
                                                    str_squish(),
                                                  
                                                  Home_team = paste0("https://www.covers.com/sport/football/nfl/matchup/",x) %>% 
                                                    read_html() %>% 
                                                    html_nodes(".covers-CoversMatchupDetails-homeName") %>% 
                                                    xml_contents() %>% 
                                                    html_text() %>% 
                                                    str_squish(),
                                                  
                                                  data.game = x
                                                  
)
)


data_with_names <- data_with_odds %>% 
  left_join(bind_rows(team_list))

toc()


data_with_odds %>% 
  select(data.game,
         data.book,
         Away_odds,
         Home_odds) %>% 
  na.omit() %>% glimpse()
