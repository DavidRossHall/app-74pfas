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
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style_edits.css")
  ), 
  navbarPage(title = div(
    div(
      id = "img-id",
      img(src = "images/tempIcon.png", style = "width:50%")
    ),
    "PFAStlas"
  ),
  
  # Insert rest of ui code
                 tabPanel("Welcome",
                          includeHTML("www/welcome.html")),
                 tabPanel("Toxicity",
                          sidebarPanel(
                            p("You can interact with the time series plot above; i.e. narrowing displayed date range. Note however that the date range for both plots is dictated by your inputted dates. In other words, you’ll need to change your inputted dates to update the data displayed on the correlation plot. To save as an image, use the download button in the top-left (time-series) or right-click and save as (correlation)"),
                            DT::dataTableOutput('pfasTable')),
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

