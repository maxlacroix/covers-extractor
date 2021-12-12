extract_good_bets <- function(data_odds){
  
  
  data_odds %>% 
    group_by(data.game) %>% 
    mutate(n =n(),
           mean_away = (sum(Away_odds) - min(Away_odds) - max(Away_odds)) / (n - 2),
           prob_away = 1 / mean_away,
           mean_home = (sum(Home_odds) - min(Home_odds) - max(Home_odds)) / (n - 2),
           prob_home = 1 / mean_home,
           sum_probs = prob_away + prob_home,
           prob_away_cor = prob_away / sum_probs,
           prob_home_cor = prob_home / sum_probs,
           mean_away_cor = 1/ prob_away_cor,
           mean_home_cor = 1 / prob_home_cor) %>% 
    select(-mean_away,
           -prob_away,
           -mean_home,
           -prob_home,
           -sum_probs) %>% 
    ungroup() %>% 
    dplyr::filter(Away_odds > mean_away_cor | 
                    Home_odds >  mean_home_cor) %>% 
    mutate(ratio = case_when(
      
      Away_odds > mean_away_cor ~ Away_odds / mean_away_cor,
      TRUE ~ Home_odds / mean_home_cor
      
      
    )) %>% 
    mutate(which_odd = 
             case_when(
               
               Away_odds > mean_away_cor ~ Away_odds,
               TRUE ~ Home_odds 
               
               
             )) %>% 
    
    mutate(overall_prob = 
             
             case_when(
               
               Away_odds > mean_away_cor ~ prob_away_cor,
               TRUE ~ prob_home_cor 
               
               
             )
           
    ) %>% 
    dplyr::filter(ratio > 1,
                  which_odd < 10,
                  n > 5) %>% 
    mutate(kelly = overall_prob - (1 - overall_prob) / (which_odd - 1)) %>% 
    select(-which_odd) %>% 
    arrange(desc(ratio)) %>% 
    select(-class,
           -data.type,
           -overall_prob) 
}