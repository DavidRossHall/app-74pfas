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

# 2. UI  -----

ui <- fluidPage(
  
  titlePanel("Tabsets"),
  
  sidebarLayout(
    
    sidebarPanel(
      DT::dataTableOutput('pfasTab')
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Phenotypic", plotlyOutput("toxPlot")), 
        tabPanel("Protein", verbatimTextOutput("summary")), 
        tabPanel("Table", tableOutput("table"))
      )
    )
  )
)

# 3. Server  -----

server <- shinyServer(function(input, output, session) {
  
  ## 3.1 PFAS table w/ structures ----
  
  output$pfasTab = DT::renderDataTable(pfas_table,
                                       server = FALSE,
                                       escape = FALSE,
                                       rownames= FALSE,
                                       options = list(
                                         scrollY = '600px',
                                         paging = FALSE,
                                         sScrollX = "100%",
                                         scrollCollapse = TRUE
                                       )) 
  
  
  # 3.2 Toxicity Data Plots
  
  output$toxPlot = renderPlotly({
    
    # base tox plot loaded from utils.r
    toxPlotly <- plotly::ggplotly(p2)
    
    config(toxPlotly,
           displayModeBar = TRUE,
           displaylogo = FALSE
    )
    
  })
  
})

# 4. Run the application  -----

shinyApp(ui = ui, server = server)

