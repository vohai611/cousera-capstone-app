
get_full_trigram = function(text_raw, stop_word = NULL, bad_word = NULL){
  
  tri_gram = text_raw %>% 
    # token by sentences first 
    unnest_tokens("line", "line", token = "sentences") %>% 
    mutate(id = row_number()) %>% 
    # then token 3-grams by words
    unnest_tokens("trigram", "line", "ngrams", n = 3, to_lower =TRUE) %>% 
    filter(!is.na(trigram)) %>% 
    separate(trigram, into = c("w1", "w2", "w3")) %>% 
    filter(!if_any(.fns = is.na)) 
  
  if(!is.null(stop_word)){
    tri_gram =  tri_gram %>% 
      filter(! (w3 %in% stop_word))
    
  }
  if(!is.null(bad_word)){
    tri_gram = tri_gram %>% 
      filter(! w3 %in% bad_word)
  } 
  
  add_on = tri_gram %>% 
    slice_head.(n = 1, .by = id) 
  
  add_on_word = c(pull(add_on, w1), pull(add_on, w2))
  add_on_word = tibble(w3= add_on_word, w1 = NA_character_, w2 = NA_character_)
  
  tri_gram = tri_gram %>% 
    bind_rows.(add_on_word)
  return(tri_gram)
}