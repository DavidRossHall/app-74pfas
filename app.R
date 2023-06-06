# ### Created by David Ross Hall --- davidross.hall@mail.utoronto.ca
# ### File created on 2022-11-07


# 1. Setup -----

## 1.1. Libraries ----

library(shiny)

library(tidyverse)
library(DT)
library(plotly)
library(shinycssloaders) # for spinners
source("www/utils.R")
source("www/toxPlotly.r") # tox plot

# 1.2 74 PFAS data ----

# PFAS info
cmpd_table <- read_csv(file = "www/pfas_imgs.csv")
pfas_tox <- read_csv(file = "www/jiajun_EHP2020.csv")

# 1.3 Proteomics Data -----

low_pg <- data.table::fread(file = "www/data/low-exposure-pg.csv")
high_pg <- data.table::fread(file = "www/data/high-exposure-pg.csv")

# 2. UI  -----

ui <- fluidPage(
  fluidRow(
    column(
      4,
      textOutput("selected_var"),
      radioButtons("cmpd_conc",
        "Exposure Concentration (µM)",
        c("0.5 µM", "5 µM"),
        inline = TRUE
      ),
      selectInput(
        "pfas_id", "PFAS ID (refer to table below)",
        paste0(
          "ID #",
          cmpd_table$ID,
          ": ",
          cleanHTML(cmpd_table$`Name<br>(<i>CAS RN</i>)`)
        )
      ),
      actionButton("plot_cmpd", "Plot exposure results"),
      br(),
      hr(),
      DT::dataTableOutput("cmpdTable")
    ),
    column(
      8,
      textOutput("conc_select"),
      textOutput("pfas_select"),
      textOutput("id_select"),
      DT::dataTableOutput("headTable"),
      plotlyOutput("cmpd_volcano") %>%
        withSpinner(color = "#002A5C"),
      plotlyOutput("pg_sums") %>%
        withSpinner(color = "orange")
    )
  )
)


# 3. Server  -----

server <- function(input, output, session) {

  ## PFAS table w/ structures -----

  output$cmpdTable <- DT::renderDataTable(cmpd_table,
    server = FALSE,
    escape = FALSE,
    rownames = FALSE,
    options = list(
      dom = "ft",
      scrollY = "600px",
      paging = FALSE,
      sScrollX = "100%",
      scrollCollapse = TRUE
    )
  )
  
  ## cmpd centric dataset for plotting ----
  
  cmpdDat <- eventReactive(input$plot_cmpd,{
    
    if(input$cmpd_conc == "0.5 µM"){
      dat <- low_pg
    } else {
      dat <- high_pg
    }
    
    dat <- dat %>%
      filter(pfas == as.numeric(sel_pfas_id()))
    
    dat
  })

  output$headTable <- DT::renderDataTable({
    DT::datatable(head(cmpdDat()),
                  options = list(scrollX = TRUE))
  })

  ## concentration radio buttons output -----

  output$conc_select <- renderText({
    paste0("You chose ", input$cmpd_conc)
  })

  output$pfas_select <- renderText({
    paste0("You chose PFAS ", input$pfas_id)
  })
  
  
  ## Getting ID no. of selected PFAS cmpd
  sel_pfas_id <- eventReactive(input$plot_cmpd, {
    getID(input$pfas_id)
  })
  
  output$id_select <- renderText({
    paste0("You chose PFAS ", sel_pfas_id())
  })



  ## Modal warning of processing time to plot compounds ----
  observeEvent(input$plot_cmpd, {
    showModal(modalDialog(
      title = "Plotting...",
      "Plotting the proteomics results of your select PFAS and exposure... this might take a minute to process...",
      easyClose = TRUE
    ))
  })


  ## Code for volcano plots
  output$cmpd_volcano <- renderPlotly({
    volcanoPlot(
      data = cmpdDat()
    )
  })

## Data table output of subsetted data

output$headTable <- DT::renderDataTable({
  DT::datatable(cmpdDat(),
                options = list(scrollX = TRUE))
})

## Bar chart output for number of protein groups

output$pg_sums <- renderPlotly({
  pg_sum_barchart(
    data = cmpdDat()
  )
})


}

# 4. Run the application  -----

shinyApp(ui = ui, server = server)
