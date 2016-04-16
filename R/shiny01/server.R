library(shiny)

shinyServer(function(input,output){
  datasetInput<-reactive(
    dataDiv[[input$dataset]]
  )
  datafileInput<-reactive(
    datasetInput()[[input$datafile]]
  )
  
  output$Table<-renderTable(
    datafileInput()
  )
  
    output$yPlotControl<-renderUI(
      if(input$datafile=='y'){
        selectInput("variable","choose a variable",choices = colnames(datafileInput()),
                    selected = colnames(datafileInput())[1])
      }
    )
    
    output$Text<-renderPrint(
      which(colnames(datafileInput())==input$variable)
    )
    
    i<-reactive(
      input$variable
    )
    
    output$contents<-renderPlot(
      plot(datafileInput()[,i()],type='l',main=i(),ylab = "Value",xlab = "Time")
    )
    
  output$Image<-renderImage(
    list(src="J:/myPackage/shinyUI/images/TEgraph.png",
         contentType="image/png",
         alt="TEgraph")
  )
  
})