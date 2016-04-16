library(shiny)
library(plotly)
shinyServer(function(input,output){
  #choose a dataset
  datasetInput<-reactive(
    dataDiv[[input$dataset]]
  )
  
  #choose a datafile
  datafileInput<-reactive(
    datasetInput()[[input$datafile]]
  )
  
  #output the datafile
  output$Table<-renderTable(
    datafileInput()
  )
  
  # if the data file is y, then choose the colunm to plot
    output$yPlotControl<-renderUI(
      if(input$datafile=='y'){
        selectInput("variable","choose a variable",choices = colnames(datafileInput()),
                    selected = colnames(datafileInput())[1])
      }
    )
    
    #output the column chosen
    output$Text<-renderPrint(
      which(colnames(datafileInput())==input$variable)
    )
    
    # to subset the colunm of data file, use i to get the column
    i<-reactive(
      input$variable
    )
    
    # plot the column variable
    output$contents<-renderPlotly(
      dataPlot<-data.frame(c(1:length(datafileInput()[,i()])),datafileInput()[,i()]),
      names(dataPlot)<-c("Time","Value"),
      p<-plot_ly(dataPlot,x=Time,y=Value,colors = "green"),
      layout(p)
    )
    
    # output the local image
  output$Image<-renderImage(
    list(src="J:/myPackage/shinyUI/images/TEgraph.png",
         contentType="image/png",
         alt="TEgraph")
  )
  
})