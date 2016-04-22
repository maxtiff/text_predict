shinyServer(function(input, output) {
        
  wordPrediction = reactive({
    text = input$text
    textInput = cleanInput(text)
    wordCount = length(textInput)
    wordPrediction = nextWordPrediction(wordCount,textInput)})

  output$predictedWord = renderPrint(wordPrediction())
  output$enteredWords = renderText({ input$text }, quoted = FALSE)
}) 