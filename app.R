### Created by David Ross Hall --- davidross.hall@mail.utoronto.ca
### File created on 2022-11-07

### --- based on table here: https://yihui.shinyapps.io/DT-info/

# 1. Setup -----

  ## 1.1. Libraries ----
  
  library(shiny)
  library(shiny)
  library(DT)
  
  source("www/utils.R")
  
  ## 1.2 74 PFAS data ----
  
  pfas_info <- read_csv(file = "www/pfas_imgs.csv")

# 2. UI  ----- 

ui <- fluidPage(
  title = 'PFAS Data Tables',
  fluidRow(
    column(6, DT::dataTableOutput('pfasTab')),
    column(6, verbatimTextOutput('pfasSelection'))
  )
)

# 3. Server  ----- 

server <- shinyServer(function(input, output, session) {
  
  ## 3.1 PFAS table w/ structures ----
  
  output$pfasTab = DT::renderDataTable(pfas_info, 
                                       server = FALSE, 
                                       escape = FALSE,
                                       rownames= FALSE)

  ## 3.2 Verbatim table selection ---- 
  
  output$pfasSelection = renderPrint({
    cat('PFAS ID:\n\n')
    cat(as.vector(input$pfasTab_rows_selected)[3], sep =', ')
    cat('\n\nPreferred Names\n\n')
    pfas_info[input$pfasTab_rows_selected, 'preferred_name']
  })
  
      
})

# 4. Run the application  ----- 

shinyApp(ui = ui, server = server)