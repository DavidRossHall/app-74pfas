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

  source("www/utils.R")

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
          tabPanel("Phenotypic", plotOutput("plot")), 
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

  ## 3.2 Verbatim table selection ----

  # pfas_sel <- reactive(pfas_info[input$pfasTab_rows_selected, 'pfas_id'])
  # 
  # 
  # output$pfasSelection = renderPrint({
  #   cat('PFAS ID:\n\n')
  #   cat(as.vector(input$pfasTab_rows_selected), sep =', ')
  #   cat('\n\nPreferred Names\n\n')
  #   pfas_info[input$pfasTab_rows_selected, 'preferred_name']
  # 
  #   #cat('\n\n PFAS ID\n\n')
  #   #cat(as.vector(pfas_info[input$pfasTab_rows_selected, 'pfas_id']))
  # })

  ## 3.3 plot of tox data  ----

  # output$toxPlot <- renderPlot({
  # 
  #   pfas_sel <- pfas_info[input$pfasTab_rows_selected, 'pfas_id']
  #   print(pfas_sel)
  # 
  #   p
  # 
  # })

})

# 4. Run the application  -----

shinyApp(ui = ui, server = server)

