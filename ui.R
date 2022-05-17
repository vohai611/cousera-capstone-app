#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidytable)
library(stringr)
library(dplyr)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Predict word"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          selectInput("version", 
                      "Accuracy vs speed?",choices = c("Accuracy", "Speed"), selected = "Speed"),
          numericInput("gamma", "Discount factor:", min = 0, max = 1, value = .7,step = 0.05 ),
          textInput("text_input", "Your text", placeholder = "Please fill more than one words"),
          htmlOutput("text_predicted")
        ),

        # Show a plot of the generated distribution
        mainPanel(
          tableOutput("word_prob")
        )
    )
))

