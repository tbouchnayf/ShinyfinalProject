library(shiny)

shinyUI(fluidPage(
  titlePanel("Children's hight prediction"),
  sidebarLayout(
    
    sidebarPanel(
      helpText("children prediction based on his rank in the family, father's hight and mother's"),
      helpText("Parameters:"),
      sliderInput(inputId = "inf",
                  label = "Father's height in CM:",
                  value = 175,
                  min = 150,
                  max = 200,
                  step = 1),
      
      
      sliderInput(inputId = "inm",
                  label = "Mother's height in CM:",
                  value = 160,
                  min = 140,
                  max = 190,
                  step = 1),
      numericInput(inputId="inseq", label = h4("the Rank of the child"), step = 1, value = 1),
      radioButtons(inputId = "ing",
                   label = "Child's gender: ",
                   choices = c("Female"="female", "Male"="male"),
                   inline = TRUE)
    ),

    
    mainPanel(
      htmlOutput("pText1"),
      htmlOutput("pText2"),
      htmlOutput("pText3"),
      htmlOutput("pred"),
      plotOutput("Plot", width = "50%")
    )
  )
))
