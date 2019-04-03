#
# Пример приложения Shiny, где можно рисовать прямо на графике
#
# Author: Andrey Makeev am@smallhall.org
#
#    http://smallbigdata.ru
#    http://smallhall.org
#

library(shiny)
library(ggplot2)

#ggplot(as.data.frame(ts), mapping = aes(x = x, y = x)) + geom_line()

ts <- as.ts(1:100)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Drawing on ggplot chart"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("size",
                     "Brush size:",
                     min = 1,
                     max = 50,
                     value = 30)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("plot", click = "plot_click")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  observeEvent(input$size, {
    
  })
  
  observeEvent(input$plot_click, {
    
  })
   
   output$plot <- renderPlot({
      ggplot()
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

