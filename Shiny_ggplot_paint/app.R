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

# A function needed to simply convert the time series into a data frame
ts_to_df <- function(ts) {
  data.frame(period = time(ts), value = as.matrix(ts))
}

# Creating the initial time series
ts <- as.ts(1:100)


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

server <- function(input, output) {
  
  # Declaring a reactive variable for the time series
  vars <- reactiveValues(ts = ts)
  
  observeEvent(input$plot_click, {
    xpos <- floor(input$plot_click$x)
    ypos <- input$plot_click$y
    currts <- vars$ts
    
    # calculating the "width" of a spline
    spl_width <- input$size
    spl_from <- ifelse(xpos - spl_width <= 0, 1, xpos - spl_width)
    spl_to <- ifelse(xpos + spl_width >= length(currts), length(currts), xpos + spl_width)
    
    # clearing values close to the clicked point to free up space for a spline, and 'drawing' it
    currts[spl_from:spl_to] <- NA
    currts[xpos] <- ypos
    currts <- na.spline(currts)
    
    # putting it back into the reactive variable
    vars$ts <- currts
  })
   
   output$plot <- renderPlot({
     ggplot(ts_to_df(vars$ts), mapping = aes(x = period, y = value)) + geom_line()
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

