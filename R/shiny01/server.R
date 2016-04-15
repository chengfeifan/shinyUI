library(shiny)

shinyServer(function(input,output){
  datasetInput<-reactive({
    switch(input$dataset,
           "idv1"=dataDiv$idv1,
           "idv2"=dataDiv$idv2,
           "idv3"=dataDiv$idv3,
           "idv4"=dataDiv$idv4,
           "idv5"=dataDiv$idv5,
           "idv6"=dataDiv$idv6,
           "idv7"=dataDiv$idv7,
           "idv8"=dataDiv$idv8,
           "idv9"=dataDiv$idv9,
           "idv10"=dataDiv$idv10,
           "idv11"=dataDiv$idv11,
           "idv12"=dataDiv$idv12,
           "idv13"=dataDiv$idv13,
           "idv14"=dataDiv$idv14,
           "idv15"=dataDiv$idv15)
  })
  datafileInput<-reactive({
    switch(input$datafile,
           "r"=datasetInput()$r,
           "y"=datasetInput()$y,
           "t"=datasetInput()$t,
           "u"=datasetInput()$u,)
  })
  
  output$Table<-renderTable(
    datafileInput()
  )
  
  # if(input$datafile=='y'){
    output$yPlotControl<-renderUI(
      if(input$datafile=='y'){
        selectInput("variable","choose a variable",choices = colnames(datafileInput()))
      }
    )
  # }

  
  output$Image<-renderImage(
    list(src="J:/myPackage/shinyUI/images/TEgraph.png",
         contentType="image/png",
         alt="TEgraph")
  )
})