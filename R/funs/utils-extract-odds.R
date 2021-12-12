extract_odds <- function(site_name){


dat_lines_brut <-
  read_html(site_name) %>%
  html_elements(".liveOddsCell") 


data_attributes <-
  bind_rows(lapply(xml_attrs(dat_lines_brut), function(x)
    data.frame(as.list(x), stringsAsFactors = FALSE)))




odds_list <- lapply(dat_lines_brut, function(x) list(Away_odds = html_elements(x, ".__awayOdds") %>%
                                                       html_elements(".Decimal") %>%
                                                       html_text() %>%
                                                       str_squish() %>% 
                                                       as.numeric(),
                                                     
                                                     Home_odds = html_elements(x, ".__homeOdds") %>%
                                                       html_elements(".Decimal") %>%
                                                       html_text() %>%
                                                       str_squish() %>% 
                                                       as.numeric())
) %>% suppressWarnings()

data_with_odds <- data_attributes %>% 
  bind_cols(bind_rows(odds_list)) %>% 
  na.omit()

data_with_odds
}