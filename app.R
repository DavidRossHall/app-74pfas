# ### Created by David Ross Hall --- davidross.hall@mail.utoronto.ca
# ### File created on 2022-11-07
#
# ### --- based on table here: https://yihui.shinyapps.io/DT-info/ &
# ### --- https://community.rstudio.com/t/getting-the-user-selected-entry-of-a-data-table-in-shiny-to-actually-make-a-scatterplot/52419/2

# 1. Setup -----

## 1.1. Libraries ----

library(shiny)
library(tidyverse)
library(DT)
library(plotly)

source("www/utils.R")
source("www/toxPlotly.r") # tox plot

# 1.2 74 PFAS data ----

# PFAS info
pfas_table <- read_csv(file = "www/pfas_imgs.csv")
pfas_tox <- read_csv(file = "www/jiajun_EHP2020.csv")

# 1.3 Proteomics Data -----

low_pg <- data.table::fread(file = "www/data/low-exposure-pg.csv")
high_pg <- data.table::fread(file = "www/data/high-exposure-pg.csv")

# 2. UI  -----

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style_edits.css")
  ),
  navbarPage(
    title = div(
      div(
        id = "img-id",
        img(src = "images/tempIcon.png", style = "width:40%")
      ),
      "PFAStlas"
    ),

    # Insert rest of ui code
    tabPanel(
      "Welcome",
      includeHTML("www/welcome.html")
    ),
    # tabPanel(
    #   "Toxicity",
    #   sidebarPanel(
    #     p("You can interact with the time series plot above; i.e. narrowing displayed date range. Note however that the date range for both plots is dictated by your inputted dates. In other words, you’ll need to change your inputted dates to update the data displayed on the correlation plot. To save as an image, use the download button in the top-left (time-series) or right-click and save as (correlation)"),
    #     DT::dataTableOutput("pfasTable")
    #   ),
    #   mainPanel(textOutput("selected_var"))
    # ),
    navbarMenu(
      "Proteomics",
      tabPanel("Global Changes"),
      tabPanel(
        "Chemical-Centric",
        sidebarPanel(DT::dataTableOutput("pfasTable2")),
        mainPanel(textOutput("selected_var2"),
                  actionButton("plot_cmpd","Plot compound results"),
                  textOutput("buttonCheck"))
      ),
      tabPanel("Protein-centric")
    ),
    tabPanel("Notes")
  )
)

# 3. Server  -----

server <- shinyServer(function(input, output, session) {

  ## 3.1 PFAS table w/ structures ----

  output$pfasTable <- DT::renderDataTable(pfas_table,
    server = FALSE,
    escape = FALSE,
    rownames = FALSE,
    options = list(
      scrollY = "600px",
      paging = FALSE,
      sScrollX = "100%",
      scrollCollapse = TRUE
    )
  )

  output$pfasTable2 <- DT::renderDataTable(pfas_table,
    server = FALSE,
    escape = FALSE,
    rownames = FALSE,
    options = list(
      scrollY = "600px",
      paging = FALSE,
      sScrollX = "100%",
      scrollCollapse = TRUE
    )
  )


  output$selected_var <- renderPrint({
    input$pfasTable_rows_selected
  })


  output$selected_var2 <- renderPrint({
    if(length(input$pfasTable2_rows_selected) == 0){
      print("Please select a compound from the table")
      } else if(length(input$pfasTable2_rows_selected) == 1){
        name <- pfas_table[input$pfasTable2_rows_selected,3]
        name <- cleanHTML(name)
      return(name)
      } else {
        print("Only one compound can be analyzed at a time")
      }
  })
  
  observeEvent(input$plot_cmpd,{
    output$buttonCheck <- renderText({
      input$pfasTable2_rows_selected
    })
  })
  
  
  
})

# 4. Run the application  -----

shinyApp(ui = ui, server = server)
