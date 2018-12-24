library(shiny)
library(HistData)
data(GaltonFamilies)
library(dplyr)
library(ggplot2)

# 1st step: pass inches to cm
fam_data <- GaltonFamilies
fam_data <- fam_data %>% mutate(mother=mother*2.54,
                    father=father*2.54,
                    childHeight=childHeight*2.54)

# linear model
fam_model <- lm(childHeight ~ mother + father + childNum+gender, data=fam_data)

shinyServer(function(input, output) {
  output$pText1 <- renderText({
    paste("Father's height: ",
          strong(round(input$inf, 1)))
  })
  output$pText2 <- renderText({
    paste("Mother height: ",
          strong(round(input$inm, 1)))
  })
  output$pText3 <- renderText({
    paste("Rank of the child: ",
          strong(input$inseq))
  })
  output$pred <- renderText({
    final_ds <- data.frame(father=input$inf,
                     mother=input$inm,
                     childNum=input$inseq,
                     gender=factor(input$ing, levels=levels(fam_data$gender)))
    ch <- predict(fam_model, newdata=final_ds)
    childsex <- ifelse(
      input$ing=="female",
      "Daugther",
      "Son"
    )
    paste0(em(strong(childsex)),
           "'s predicted height: ",
           em(strong(round(ch))),
           " cm"
    )
  })
  output$Plot <- renderPlot({
    childsex <- ifelse(
      input$ing=="female",
      "Daugther",
      "Son"
    )
    final_ds <- data.frame(mother=input$inf,
                     father=input$inm,
                     childNum=input$inseq,
                     gender=factor(input$ing, levels=levels(fam_data$gender)))
    ch <- predict(fam_model, newdata=final_ds)
    oc <- c("Mother", childsex, "Father")
    final_ds <- data.frame(
      x = factor(oc, levels = oc, ordered = TRUE),
      y = c(input$inf, ch, input$inm))
    ggplot(final_ds, aes(x=x, y=y, color=c("pink", "blue", "red"), fill=c("pink", "blue", "red"))) +
      geom_bar(stat="identity", width=0.5) +
      xlab("") +
      ylab("Height (cm)") +
      theme_minimal() +
      theme(legend.position="none")
  })
})