
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(ggplot2)
library(dplyr)




shinyServer(function(input, output) {
  
  HIST_PLOT_func <- function(dataset, MO_type, X_ray_ref, compoundName){
    min_hist=as.numeric(input$range[1])
    max_hist=as.numeric(input$range[2])
    dataset=dataset[complete.cases(dataset),]
    dataset[MO_type] = 1000.0 * dataset[MO_type]
    condition = ((dataset[MO_type] >= min_hist) & (dataset[MO_type] < max_hist))
    dataset=dataset[condition,]
    binz <- input$bins
    dataset = group_by(dataset,pair)  %>% do(data.frame(. ,index=1:nrow(.)))
    

    mean_plus = as.numeric(apply(dataset[MO_type],2,mean))

    sd_plus = as.numeric(apply(dataset[MO_type],2,sd))


    hist_title =
        paste("Transfer Integrals Distribution (mean=",as.integer(mean_plus),"meV, sd=",as.integer(sd_plus),"meV)", sep=" ")
    X_LAB = paste("Transfer Integrals (", MO_type,") in meV")
    
    ggplot_histplot <- ggplot(dataset, geom = "blank") + 
      
      geom_histogram(bins = binz, colour = "limegreen" , aes(x=get(MO_type), y = ..density..)) +
      
      stat_density(geom = "line", aes(colour = "red")) +
      
      stat_function(fun = dnorm, aes(x = get(MO_type), colour="red"),  args  = list(mean = mean_plus, sd = sd_plus))  +
      
      geom_vline(xintercept = mean_plus, colour="red")  +

      geom_vline(xintercept = 1.0*as.numeric(X_ray_ref), colour="darkblue") +
      
      theme(legend.position="none", text = element_text(size=16)) +
      
      ggtitle(hist_title) + 
      
      labs(x=X_LAB, y="Density")
    
    return(ggplot_histplot)
  }
  
  EVOLUTION_PLOT_func <- function(dataset, MO_type, compoundName){
    min_hist=as.numeric(input$range[1])
    max_hist=as.numeric(input$range[2])
    dataset=dataset[complete.cases(dataset),]
    dataset[MO_type] = 1000.0 * dataset[MO_type]
    condition = ((dataset[MO_type] >= min_hist) & (dataset[MO_type] < max_hist))
    dataset=dataset[condition,]
    
    dataset = group_by(dataset,pair)  %>% do(data.frame(. ,index=1:nrow(.)))
    
    evol_title = paste(compoundName, "Evolution along MD trajectory", sep=" ")
    Y_LAB = paste("Transfer Integrals (", MO_type,") in meV")

    mean_plus = as.numeric(apply(dataset[MO_type],2,mean))
    
    ggplot_evolplot <- ggplot(dataset, geom = "blank",  aes( x=index, y=get(MO_type), colour = pair) ) +

      geom_point(aes(colour = pair ),size = 2, alpha = 0.8) +
      
      geom_line(alpha=0.2) + ggtitle(evol_title) +
      
      geom_hline(yintercept = mean_plus, linetype="dashed", size=1 ) +
     
      labs(x="MD step", y=Y_LAB) +
      theme(legend.position="right", text = element_text(size=16))
    
    return(ggplot_evolplot)
  }
  
  
  output$histHOMO <- renderPlot({
    
    inFile <- input$file1
    PP_AA_ESP = read.csv(file=inFile$datapath, header = input$header,  fill=TRUE, sep = input$sep, col.names = c("pair","HOMO","LUMO","q4","q5"), na.strings = c("-inf","-nan"), quote=input$quote)
    
    MethodB <- "Dreiding-FF with ESP charges /"
    dd <- PP_AA_ESP
    Hd = HIST_PLOT_func(dd, "HOMO", as.numeric(input$XrayHOMO), MethodB)
    
    
    Hd
  })
  
  output$mdHOMO <- renderPlot({
    
    inFile <- input$file1
    
    PP_AA_ESP = read.csv(file=inFile$datapath, header = input$header,  fill=TRUE, sep = input$sep, col.names = c("pair","HOMO","LUMO","q4","q5"), na.strings = c("-inf","-nan"), quote=input$quote)
    
    MethodB <- "Dreiding-FF with ESP charges /"
    dd <- PP_AA_ESP
    Hd = EVOLUTION_PLOT_func(dd, "HOMO",  MethodB)
    
    
    Hd
  })
  
  output$histLUMO <- renderPlot({
    
    inFile <- input$file1
    PP_AA_ESP = read.csv(file=inFile$datapath, header = input$header,  fill=TRUE, sep = input$sep, col.names = c("pair","HOMO","LUMO","q4","q5"), na.strings = c("-inf","-nan"), quote=input$quote)
    
    MethodB <- "Dreiding-FF with ESP charges /"
    dd <- PP_AA_ESP
    Hd = HIST_PLOT_func(dd, "LUMO", as.numeric(input$XrayLUMO), MethodB)
    
    
    Hd
  })
  
  
  output$mdLUMO <- renderPlot({
    
    inFile <- input$file1
    PP_AA_ESP = read.csv(file=inFile$datapath, header = input$header,  fill=TRUE, sep = input$sep, col.names = c("pair","HOMO","LUMO","q4","q5"), na.strings = c("-inf","-nan"), quote=input$quote)
    
    MethodB <- "Dreiding-FF with ESP charges /"
    dd <- PP_AA_ESP
    Hd = EVOLUTION_PLOT_func(dd, "LUMO",  MethodB)
    
    
    Hd
  })
  
  
})
