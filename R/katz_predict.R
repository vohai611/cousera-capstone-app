katz_predict = function(word, tri_gram, gamma2 = 0.5, gamma3 = 0.5 ){
  
  word = str_to_lower(word)
  word = strsplit(word, " ")[[1]]
  
 if(length(word) > 1) word1 = word[[length(word)-1]]
  word2 = word[[length(word)]]
  
  observed_q2 = tri_gram %>% 
    filter.(w2 == .env$word2) %>% 
    count.(w3,name = "n") %>% 
    transmute.(w3, q2_bo = ( n - .env$gamma2)/ sum(n))
  
  alpha2 = 1- sum(observed_q2$q2_bo)
  # unobserved
  
  un_observed_q2 = tri_gram %>% 
    anti_join.(observed_q2) %>% 
    count.(w3, name = "n") %>% 
    transmute.(w3, q2_bo = alpha2 * n / sum(n))
  
  q2 = bind_rows.(observed_q2, un_observed_q2)
  
  if (length(word) == 1)
    return(q2 %>% arrange.(desc.(q2_bo)) %>% rename.(q_bo = q2_bo))
  
  # trigram calculation
  ## observed
  
  observed_q3 = tri_gram %>% 
    filter.(w1 == .env$word1 , w2== .env$word2) %>% 
    count.(w3, name = "n") %>% 
    transmute.(w3, q_bo = (n - .env$gamma3) / sum(n))
  
  alpha3 = 1 - sum(observed_q3$q_bo)
  
  ## unobserved
  un_observed_q3 = tri_gram %>% 
    anti_join.(observed_q3) %>% 
    count.(w3, name = "n") %>% 
    left_join.(q2, by =  "w3") %>% 
    transmute.(w3, q_bo = alpha3 * q2_bo / sum(q2_bo)) 
  
  q3 = bind_rows.(observed_q3, un_observed_q3) 
  
  q3  %>% 
    arrange.(desc.(q_bo)) 
}