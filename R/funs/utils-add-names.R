add_names <- function(data, 
                      matchup_site){
  
  
  team_list <- lapply(unique(data$data.game), function(x) list(Away_team = 
                                                                           paste0(matchup_site,x) %>% 
                                                                           read_html() %>% 
                                                                           html_elements(".covers-CoversMatchupDetails-awayName") %>% 
                                                                           xml_contents() %>% 
                                                                           html_text() %>% 
                                                                           str_squish(),
                                                                         
                                                                         Home_team = paste0(matchup_site,x) %>% 
                                                                           read_html() %>% 
                                                                           html_elements(".covers-CoversMatchupDetails-homeName") %>% 
                                                                           xml_contents() %>% 
                                                                           html_text() %>% 
                                                                           str_squish(),
                                                                         
                                                                         data.game = x
                                                                         
  )
  )
  
  
  data_with_names <- data %>% 
    left_join(bind_rows(team_list))
  
  data_with_names
  
}