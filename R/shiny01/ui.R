library(shiny)
data("dataDiv-TE")
shinyUI(fluidPage(
  titlePanel("Show the data of TE Model"),
  
  sidebarPanel(
    selectInput("dataset","choose a div",choices=names(dataDiv)),
    selectInput("datafile","choose a data file",choices=c("y","r","u","t")),
    br(),
    submitButton("Update View")
  ),
  
  
  mainPanel(
    tabsetPanel(
      tabPanel("Table",tableOutput("Table")),
      tabPanel("Graph",imageOutput("Image"))
    )
  )
  
  
))