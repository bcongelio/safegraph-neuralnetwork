library(shiny)
library(tidyverse)
library(neuralnet)

###loading saved model
load('trained-neural-model.rda')

nn.data <- readr::read_csv("./neural-data/pittsburgh-shiny.csv") %>%
  select(visits_by_day, st.oppo, st.ml, st.div, st.weekday, pi.oppo, pi.ml, pi.div,
         pi.weekday, pe.oppo, pe.ml, pe.div, pe.weekday, tempmax,
         tempmin, humidity, precip, precipprob, snow, windspeed, cloudcover, icon)

nn.data$...1 <- NULL
nn.data$...2 <- NULL

ui <- fluidPage(
  titlePanel("Predicting Foot Traffic"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("st.ml", "Steelers Moneyline",
                  min = -300, max = 300, value = 0),
      sliderInput("pi.ml", "Pirates Moneyline",
                  min = -300, max = 300, value = 0),
      sliderInput("pe.ml", "Penguins Moneyline",
                  min = -300, max = 300, value = 0)
    ),
    mainPanel(
      plotOutput("coolplot")
    )
  )
)


server <- function(input, output) {
  output$coolplot <- renderPlot({
    filtered <- 
      nn.data %>%
      filter(st.ml == input$sliderInput)
    plot(neural.model)
  })
}
shinyApp(ui = ui, server = server)