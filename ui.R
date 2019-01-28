#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
titainc_train <- read.csv("./Data/titanic_train.csv")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Titanic Dataset - Survival"),
  p("Documentation:"),  
  p("This Web application loads the required packages and the Titanic data set. 
    A decision tree is then trained which predicts whether a person will survive 
    the Titanic accident or not based on the attributes class, gender and age. 
    The decision tree and accuracy are displayed. 0 means the person has not survived, 
    1 means the person has survived."),
  p("The user then has the opportunity to make entries for the attributes class, 
    gender and age. After a click on the Submit button, the prediction for the 
    corresponding entries is displayed."),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("Class", "Class:", list(1,2,3)),
      selectInput("Sex", "Sex:", list("female", "male")),
      sliderInput("Age", "Age:", min=0, max=100, value=30, step=1),
      actionButton("Submit", "Calculate Prediction")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      p("Decision Tree of the trained Model"),
      plotOutput("DecisionTree"),
      textOutput("Accuracy"),
      textOutput("Prediction")
    )
  )
))
