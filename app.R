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
  navbarPage("My Application",
                 tabPanel("Welcome",
                          includeHTML("www/welcome.html")),
                 tabPanel("Toxicity",
                          sidebarPanel(DT::dataTableOutput('pfasTable')),
                          mainPanel(textOutput("selected_var"))),
                 navbarMenu("Proteomics",
                            tabPanel("Global Changes"),
                            tabPanel("Chemical-Centric",
                                     sidebarPanel(DT::dataTableOutput('pfasTable2')),
                                     mainPanel()),
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
                                       rownames= FALSE,
                                       options = list(
                                         scrollY = '600px',
                                         paging = FALSE,
                                         sScrollX = "100%",
                                         scrollCollapse = TRUE
                                       )
)

output$pfasTable2 <- DT::renderDataTable(pfas_table,
                                        server = FALSE,
                                        escape = FALSE,
                                        rownames= FALSE,
                                        options = list(
                                          scrollY = '600px',
                                          paging = FALSE,
                                          sScrollX = "100%",
                                          scrollCollapse = TRUE
                                        )
)


output$selected_var <- renderPrint({
  input$pfasTable_rows_selected
})



})

# 4. Run the application  -----

shinyApp(ui = ui, server = server)

