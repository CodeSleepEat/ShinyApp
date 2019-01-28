#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
library(caret)
library(rattle)
library(e1071)
titanic_train <- read.csv("./Data/titanic_train.csv")

shinyServer(function(input, output) {
  
  titanic <- reactive({
    titanic_train <- read.csv("./Data/titanic_train.csv")
    titanic_train <- titanic_train[, c("Survived", "Pclass", "Sex", "Age")]
    names(titanic_train) <- c("Survived", "Class", "Sex", "Age")
    titanic_train$Survived <- as.factor(titanic_train$Survived)
    titanic_train$Class <- as.factor(titanic_train$Class)
    titanic_train$Sex <- as.factor(titanic_train$Sex)
    titanic_train <- na.omit(titanic_train)
    titanic_train
  })
  
  trainindex <- reactive({
    set.seed(5555555)
    createDataPartition(titanic()$Survived, p=0.7, list=F)
  })
  trainset <- reactive({
    titanic()[trainindex(), ]
  })
  test <- reactive({
    titanic()[-trainindex(), ]
  })
  model1 <- reactive({
    train(Survived ~ ., trainset(), method="rpart")
  })
   
  output$DecisionTree <- renderPlot({
    fancyRpartPlot(model1()$finalModel)
  })
  output$Accuracy <- renderText({
    pred1 <- predict(model1(), test())
    CM1 <- confusionMatrix(pred1, test()$Survived)
    paste("The Accuracy is: ", CM1$overall[1])
  })
  Pred <- eventReactive(input$Submit, {
    df <- data.frame(Class = as.factor(as.character(input$Class)), Sex = input$Sex, Age = input$Age)
    prediction <- predict(model1(), df)
    p <- ifelse(prediction==1, "Survived", "Not Survived")
    paste("The Prediction is: ", p)
  })
  output$Prediction <- renderText({
      Pred()
    })
  
})
