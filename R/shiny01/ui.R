library(shiny)
library(plotly)
shinyUI(fluidPage(
  titlePanel("Show the data of TE Model"),
  
  sidebarPanel(
    selectInput("dataset","choose a div",choices=names(dataDiv)),
    selectInput("datafile","choose a data file",choices=c("y","r","u","t")),
    br(),
    # conditionalPanel(
    #   condition ="input.datafile == 'y'",
    #   uiOutput("yPlotControl")
    # ),
    uiOutput("yPlotControl"),
    submitButton("Update View")
  ),
  
  
  mainPanel(
    tabsetPanel(
      tabPanel("Table",tableOutput("Table")),
      tabPanel("Graph",plotlyOutput("contents"),verbatimTextOutput("Text"),imageOutput("Image"))
    )
  )
  
  
))