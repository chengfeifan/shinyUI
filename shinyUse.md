#shiny包的使用
`shiny`作为Rstudio中一个非常重要的包，对于构建交互式的网页非常方便。一般由`shiny`构筑的网页，由两个文件构成:`ui.R`和`server.R`，下面分别对两者的组件进行介绍。
**在运行程序的时候，需要将`ui.R`和`server.R`放入同一个文件夹之中**

## ui里面的一些组件

### ui输入
####`ui.R`一般的框架

	library(shiny)
	shinyUI(fluidPage(
		# 标题
		titlePanel("title name"),
		# 边栏
		sidebarPanel(
		#选择块
			selectInput("dataset","choose a dataset",choices=c("A","B"))
		)
		
		#主栏
		mainPanel()
	))
	
#### `selectInput`
selectInput提供下拉菜单的选择，输入格式：

`selectInput("data","choose",choices=c("A","B"))`

`data`是用于储存变量的名称（可以在`server.R`中以`input$data`调用），`choose`是输入说明，`choices`给出下拉变量的选择

#### `numericInput`
顾名思义，numericInput是用来输入数值类型数据，其输入格式：
`numericInput("num","type a number",10)`

其中`num`是用于储存变量的名称（可以再`server.R`中以`input$num`调用），`type a number`是说明信息，`10`是输入的数据

#### `checkboxInput`勾选组件
有时候，我们可以选择某些图形是否出现，可以通过勾选是否要这个内容来实现，所以这个输入的变量只会出现`TRUE`或者`FALSE`，也就是说这个变量是bool型变量

	checkboxInput("out","Output",FALSE)
	
其中`out`是用来储存bool型变量，`Output`是对变量进行的说明，`FALSE`是取值

#### `checkboxGroupInput`多勾选组件
有时候我们需要对内容进行多选，这样就需要多项选择

	checkboxGroupInput("cities","choose Cities",cities)

这样子就可以实现多项选择了
#### `sliderInput`定制化滑动条
通过滑动滑动条来选择数据，是一件非常酷炫的事情，下面给出一个例子

	sliderInput("integer","Integer:",
				min=0,max=1000,value=500,step=1)
				
其中`integer`用来储存变量，`Interger:`是说明，`min`代表着滑动条的最小值，`max`代表着滑动条的最大值，`value`代表着滑动条初始值，`step`代表着滑动条的间隔

若需要输入区间范围，可以增加两个变量，例如

	sliderInput("range","Range:",
			min=0,max=1000,value=c(200,500))

其中`range`用来储存变量，只不过此时的变量变成了一个vector

#### `radioButtons`选项卡

我们常常会给出一些选项来，还是直接举例子：

	radioButtons("dist","Distribution type:",
		list("Norm"="norm",
				"Uniform"="unif",
				"Log-normal"="lnorm",
				"Exponential"="exp"
			)
	),
	br(),

其中`dist`依旧是用于储存变量，`Distribution`依旧是对变量的说明，而`list`中，左端代表着展现出来选项，等号右边是选项对应的值，当然在`server.R`中调用也需要用`reactive`来动态调用

#### `helpText`插件说明
对于某些插件的功能，我们可能需要对其进行说明，最简单的方式就是在插件下方使用`helpText`

#### `submitButton`提交按钮
对于结果展现，我们并不希望其实时进行更新，而是通过我们的提交来实现结果的刷新，直接在底下增加`submitButton`，使用如下面的：

`submitButton("Update View")`

### 界面的选择`tabsetPanel`
有时候，将所有的内容放入一个界面之中，会显得非常杂乱无章，所以为了将内容分开，需要在使用`tabsetPanel`

	tabsetPanel(
		tabPanel("plot",plotOutput("plot")),
		tabPanel("summary",verbatimTextOutput("summary")),
		tabPanel("Table",tableOutput("table"))
	)

### ui中的输出
由于`ui`中的输出需要与`server`中的程序对应，所以这里需要将两个程序中的组件一起写出来

#### summary格式的输出
`server.R`中需要调用`renderPrint`：

	output$summary<-renderPrint({
		#内容
		summary()
	})
	
`ui.R`中需要调用`verbatimTextOutput`:

`verbatimTextOutput("summary")`

#### Table格式的输出
`server.R`中需要调用`renderTable`：

	output$view<-renderTable({
		#内容 data.frame
		
	})
	
`ui.R`中需要调用`tableOutput`:

`tableOutput("view")`

#### 字符串的输出

`server.R`则调用`renderText`来输出

`ui.R`对于字符串的输出，可以用`h1`、`h2`和`h3`等来调节字体的大小，例如：

`h3(textOutput("caption"))`

#### 图片输出
`server.R`则调用`renderPlot`来输出

`ui.R`对于图片输出，使用`plotOutput`即可

`plotOutput("graph")`


## server里面的一些组件
#### `server.R`一般框架

	library(shiny)
	shinyServer(function(input,output){
		#内容
	})
	
#### 动态输入`reactive`

在`ui.R`中传递过来的参数，只是一个字符串，如何获取将这个字符串所代表的数据集，我们需要用到`reactive`函数：

	datasetInput<-reactive({
		switch(input$dataset,
				"rock" = rock,
				"pressure" = pressure,
				"cars" = cars
		)
	})
	
其中`input$dataset`代表着从`ui.R`中传递过来的参数，但是它仅仅只是一个字符串，所以需要用`switch`函数将数据转化对应的数据集，之后调用的时候，使用`datasetInput()`即可

## 程序调试

代码在某个地方无条件地停止执行：

	browser()
	
在特定的条件下停止执行代码：

	# Stop execution when the user selects "am"
	browser(expr = identical(input$variable, "am"))
	
设置R的`error`选项，使得当错误发生的时候，自动进入调试浏览器：

	# Immediately enter the browser when an error occurs
	options(error = browser)
	
使用`recover`函数为错误处理器

	# Call the recover function when an error occurs
	options(error = recover)
	
	
## 文件相关

#### 上传文件
一般情况下，shiny上传的每个文件最大不超过5MB，可以通过修改`shiny.maxRequestSize`，在`server.R`中增加以下命令： `options(shiny.maxRequestSize=30*1024^2)`即可将文件大小限制提高到30MB

在`ui.R`中需要用`fileInput`来调用文件

	fileInput('file1','choose CSV File',
			accept=c('text/csv','.csv'))
	tags$hr()
			
其中`file1`用来储存文件，`choose CSV File`是对输入的说明，`accept`是对于文件类型的选择

在`server.R`中需要通过以下代码进行调用：

	inFile<-input$file1
	if(is.null(inFile))
		return(NULL)
		
	read.csv(inFile$datapath)

可以看出其调用使用的文件的路径，并不是真的把文件储存在变量之中

#### 下载文件
有时候会有上传文件的需求，我们查看的数据需要下载

在`ui.R`中需要用到`downloadButton`函数来下载需要的数据

	downloadButton('downloadData','Download')
	
对上述的表达式进行说明，其中`downloadData`代表着储存数据的变量，`Download`是下载按钮上的说明

在`server.R`中需要将数据写入，需要用到`downloadHandler`

	output$downloadData <- downloadHandler(
		filename=function(){
			paste(input$dataset,'.csv',sep='')
		}
		content = function(file){
			write.csv(datasetInput(),file)
		}
	)
	
主要需要定义，文件的的名字`filename`，文件的内容`content`

### 动态网页的实现

#### `conditionalPanel`条件刷新
当动态输入的变量来自于`input`变量

	checkboxInput("smooth","Smooth"),
	conditionalPanel(
		condition = "input.smooth == true"
		selectInput("smoothMethod","Method",
			list("lm","glm","gam","loess","rlm"))
	)
	
根据你是否选择`smooth`来判断是否出现下面的内容，一旦勾选了smooth，下面就会出现让你选择smooth的方法

如果动态输入的变量来自于`output`变量

在`ui.R`中，如下面的内容：

	# Partial example
	selectInput("dataset", "Dataset", 	c("diamonds", "rock", "pressure", "cars")),
	conditionalPanel(
	condition = "output.nrows",	
	checkboxInput("headonly", "Only use first 1000 rows"))
	
在`server.R`，如下内容：

	# Partial example
	datasetInput <- reactive({
	switch(input$dataset,
          "rock" = rock,
          "pressure" = pressure,
          "cars" = cars)
    })

	output$nrows <- reactive({
		nrow(datasetInput())
	})
	
在`server.R`中需要将输出的变量设置为动态的，也就是说用`reactive`函数对其进行封装

#### 动态刷新`renderUI`

`renderUI`使用与`renderTable`,`renderPrint`的使用方法差不多，在`server.R`中使用`renderUI`，而在`ui.R`中使用`uiOutput`，对`server.R`计算结果进行展示，下面编写代码，进行说明：

在`ui.R`中编辑如下代码：

	library(shiny)

	shinyUI(fluidPage(
	headerPanel("Test"),
	
	sidebarPanel(
    # Partial example
    numericInput("lat", "Latitude",10),
    numericInput("long", "Longitude",10),
    uiOutput("cityControls"))
    ))
    
在`server.R`中编辑如下代码：

	library(shiny)
	shinyServer(function(input,output){
	# Partial example
	output$cityControls <- renderUI({
    cities <- c(input$lat:input$long)
    checkboxGroupInput("cities", "Choose Cities", cities)
    })
    })
    
上面代码对于结果呈现已经说得很清楚了，调试一下代码就可以了

#### javascript增加动态
需要使用组件`Shiny.unbindAll()`和`Shiny.bindAll()`

## shiny高级使用技巧

#### 对于`global.R`和局部的理解
如果没有设置全局变量的话，当用户每一次对`ui.R`和`server.R`访问时，都会重新加载变量，重新生成网页，对于全局变量，最好的方式是在`global.R`中设置，这样子并不需要用户每一访问，都重新加载，既占用内存，又消耗了时间

#### 对于非全局代码的调用

	source('yourcode.R',local=TRUE)
	




## shiny server设置
使用`shiny server`的好处

* 能够运行多个`shiny APP`，每一个都有其自己的`URL`
* 支持浏览器（浏览器不支持`WebSocket`）
* 系统使用着能够开发和管理自己的shiny application
* 自动结束进程，当下一个访问者需要访问地址时

详细的`shiny-server`教程参见[shiny-server](http://docs.rstudio.com/shiny-server/)

### 安装配置([shiny server](http://docs.rstudio.com/shiny-server/#configuration-settings))
系统: `centos 7.0`

安装`R`命令： `sudo yum install R`

安装`shiny package`：``

安装`shiny server`：通过`wget`来下载安装文件：

	wget https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.4.2.786-rh5-x86_64.rpm
	
然后用一下命令直接安装：

	sudo yum install --nogpgcheck shiny-server-1.4.2.786-rh5-x86_64.rpm
	
### 启动`shiny server`
启动`shiny server`：`sudo systemctl start shiny-server`

结束`shiny server`：`sudo systemctl stop shiny-server`

观察`shiny server`的状态：`sudo systemtcl status shiny-server`

设置`shiny server`自动运行\不自动运行：`sudo systemctl enable\disable shiny-server`


### server配置
命令打开`vi /etc/shiny-server/shiny-server.conf`

`server`默认为`HTTP server`，监听的接口（`port/IP`）通过下面的定义：

	server{
		listen 80;
	}
	
通过定义虚拟接口，可以隐藏监听接口

	server{
		listen 80;
		server_name server1.com;
	}

### 需要赋予shiny用户root权限
* 为`shiny`用户创建密码:`passwd shiny`
* 修改`/etc/sudoers`文件，向其中添加下面的指令`shiny ALL=(ALL) ALL`，即可修改用户权限，从`root`用户进入`shiny`用户，可以用下面的指令`su shiny`

### 运行自己的服务

在运行了其中默认的配置

`sudo /opt/shiny-server/bin/deploy-example user-dirs`

运行下面的命令

`mkdir ~/ShinyApps`

拷贝文件夹指令：`scp/cp -r`

只需要将文件复制到目录下`~/ShinyApps`，然后通过下面的地址来访问`shiny`形成的网页

`http://<server-address>:3838/<your_username>/yourfile`




### server小提示

* `shiny`包可能会无法安装上去，所以在命令窗口输入`R`，然后输入下面指令：`install.packages('shiny', repos='http://cran.rstudio.com/')
library(shiny)`

* `shiny`访问的的时候，需要将服务器的端口打开，不然无法进行访问，如果你在配置文件`/etc/shiny-server/shiny-server.conf`文件中写的监听端口为`3838`,服务器端口开放命令：

		iptables -I INPUT -p tcp --dport 3838 -j ACCEPT
		iptables -I INPUT -p gre -j ACCEPT
		
* `plotly`包安装问题，可能会碰到系统的`curl`包无法安装，而`curl`无法安装的原因在于系统的`libcurl`没有安装，需要输入一下命令：

		yum -y install libcurl
		yum install curl curl-level
		

		




