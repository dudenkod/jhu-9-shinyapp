
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)


shinyUI(pageWithSidebar(
  headerPanel("Visualisation of electron mobility in photovoltaic materials"),
  sidebarPanel(
    fileInput('file1', 'Choose CSV File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain', '.dat')),
    tags$hr(),
    checkboxInput('header', 'Header available', FALSE),
    radioButtons('sep', 'Separator',
                 c(Comma=',',
                   Semicolon=';',
                   Tab='\t',
                   Space=' '),
                 'Space'),

    # Specification of range within an interval
    sliderInput("range", "Range:",
                min = -200, max = 200, value = c(-150,150)),
    sliderInput("bins",
                "Number of bins:",
                min = 1,
                max = 75,
                value = 25),
    numericInput("XrayHOMO", "Transfer Integral calculated for X-ray atomic coordinates (HOMO, in meV)", -110),
    numericInput("XrayLUMO", "Transfer Integrals calculated for X-ray atomic coordinates (LUMO, in meV)", 66),
    submitButton("Update View")
  ),

  mainPanel(
    tabsetPanel(type = "tabs", 
                tabPanel("HIST HOMO", plotOutput("histHOMO")),
                tabPanel("Trajectory HOMO", plotOutput("mdHOMO")),
                tabPanel("HIST LUMO", plotOutput("histLUMO")),
                tabPanel("Trajectory LUMO", plotOutput("mdLUMO"))
    )
    #plotOutput('contents')
  )
))
