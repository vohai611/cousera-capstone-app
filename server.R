#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("R/katz_predict.R")
tri_gram_small = readRDS("data/tri_gram_small.rds")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  tri_gram_sample = reactive({
    
    if (input$version  == "Speed")
      tri_gram_small
    else{
      readRDS("data/tri_gram_large.rds")
    }
  })
  
  word_predict = reactive({
    req(length(strsplit(input$text_input, " ")[[1]]) >= 2)
    katz_predict(
      input$text_input,
      tri_gram = tri_gram_sample(),
      gamma2 = input$gamma,
      gamma3 = input$gamma
    )
  })
  
  output$text_predicted = renderText({
    paste(
      str_squish(input$text_input),
      '<span style="color: red;">',
      word_predict()$w3[1],
      "</span>"
    )
  })
  
  output$word_prob = renderTable({
    word_predict() %>%
      rename(word = w3, probability  = q_bo) %>%
      mutate(probability = paste0(round(probability * 100, 2), "%")) %>%
      head(10)
  })
  
})
