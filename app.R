library(shiny)
library(shinydashboard)
library(shinythemes)
library(shinyBS)
library(shinyjs)
library(shinyalert)
library(tidyverse)


# ui ----------------------------------------------------------------------
ui <- navbarPage(
  title = "My Simple Web App",
  # header = "A Simple App",
  # footer = "Copyrighted",
  # theme = "bootstrap.min.css",
  theme = shinytheme("flatly"),
  position = "static-top",
  navbarMenu(title = "Home",
    tabPanel(title = "Home",
             h3("This is the title"),
             p("Lorem ipsum..."),
             fileInput(inputId = "file1", label = "Input csv File", 
                       accept = c(".csv", ".txt"))
             
    ),
    tabPanel(title = "Services",
             selectInput("selectData", "Select Data to Preview",
                         choices = c("mtcars", "economics", "cars")),
             hr(),
             fluidRow(
               dataTableOutput("table")
             ),
             hr(),
             fluidRow(
               downloadButton("tableDownload", "Download")
             )
             
             )
  ),
  navbarMenu(title = 'Services',
             tabPanel(title = "Data"),
             tabPanel(title = "Graph")
  ),
  navbarMenu(title = "Contact Us",
             tabPanel(title = "About us"),
             tabPanel(title = "Contact Us")
    
  )
  
)






# server ------------------------------------------------------------------

server <- function(input, output) {
  
  data <- reactive({
    file <- input$file1
    ext <- tools::file_ext(file$datapath)
    
    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))
    
    data <- read.csv(file$datapath)
    data
  })
  
  data2 <- reactive({
    data <- switch(input$selectData,
      "mtcars" = mtcars,
      "economics" = economics,
      "cars" = cars
    )
    data
    })
  
  output$table <- renderDataTable({
    data2()
  })
  
  
  
  output$tableDownload <- downloadHandler(
    filename <- function() {
      paste0("data-", format(Sys.Date(), format = "%d-%m-%y"), ".csv")
    },
    content <- function(file) {
     write.csv(data2(), file) 
    }
  )
  
}

shinyApp(ui = ui, server = server)

