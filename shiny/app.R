### Shiny app to explore reader preferences

# call packages
library(shiny)
library(ggplot2)


### UI ###
ui <- fluidPage(
  titlePanel(
    # text title of visualization
  ),
  # Genre prefs plot
  fluidRow(
    column(4,
           # inputs for manipulating the graph
           # genre
           # name
    ),
    column(8,
           #plotOutput("prefplot"). # see server for prefplot def
    )
  ),
  # Triggers plot
  fluidRow(
    column(4,
           # inputs for manipulating the graph
           # type of trigger
           # name
    ),
    column(8,
           #plotOutput("trigplot"). # see server for trigplot def
    )
  ),
)

### SERVER ###
server <- function(input, output) {
  # create pref output
  output$prefplot <- renderPlot({
    # define plot parameters
  })
  
  # create trig output
  output$trigplot <- renderPlot({
    # define plot parameters
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
