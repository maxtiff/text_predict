suppressPackageStartupMessages(c(
        library(shinythemes),
        library(shiny),
        library(tm),
        library(stringr),
        library(markdown),
        library(stylo)))

shinyUI(fluidPage("Coursera Data Science Capstone",theme = shinytheme("flatly"),titlePanel("Text Prediction")
         fluidRow(                 
                 column(3),
                 column(6,
                        tags$div(textInput("text", 
                                  label = h3("Enter your text here:"),
                                  value = ),
                        tags$span(style="color:grey",("Only English words are supported.")),
                        br(),
                        tags$hr(),
                        h4("Prediction:"),
                        tags$span(style="color:darkred",
                                  tags$strong(tags$h3(textOutput("predictedWord")))),
                        br(),
                        tags$hr(),
                        h4("Entered:"),
                        tags$em(tags$h4(textOutput("enteredWords"))),
                        align="center")
                        ),
                 column(3)
         )
),