# ### Created by David Ross Hall --- davidross.hall@mail.utoronto.ca
# ### File created on 2022-11-07
# 
# ### --- based on table here: https://yihui.shinyapps.io/DT-info/ &
# ### --- https://community.rstudio.com/t/getting-the-user-selected-entry-of-a-data-table-in-shiny-to-actually-make-a-scatterplot/52419/2
# 
# # 1. Setup -----
# 
#   ## 1.1. Libraries ----
#   
#   library(shiny)
#   library(tidyverse)
#   library(DT)
#   
#   source("www/utils.R")
#   
  ## 1.2 74 PFAS data ----

  pfas_info <- read_csv(file = "www/pfas_imgs.csv") # %>%
    #mutate(preferred_name = str_replace_all(preferred_name, paste0("(.{25})"), "\\1-\n"))
#   
#   
  pfas_tox <- read_csv(file = "www/jiajun_EHP2020.csv")
# 
# # 2. UI  ----- 
# 
# ui <- fluidPage(
#   title = 'PFAS Data Tables',
#   fluidRow(
#     column(6, DT::dataTableOutput('pfasTab')),
#     #column(6, verbatimTextOutput('pfasSelection')),
#     column(4, plotOutput("toxPlot"))
#   )
# )
# 
# # 3. Server  ----- 
# 
# server <- shinyServer(function(input, output, session) {
#   
#   ## 3.1 PFAS table w/ structures ----
#   
#   output$pfasTab = DT::renderDataTable(pfas_info, 
#                                        server = FALSE, 
#                                        escape = FALSE,
#                                        rownames= FALSE,
#                                        options = list(
#                                          scrollY = '300px', 
#                                          paging = FALSE
#                                        ))
# 
#   ## 3.2 Verbatim table selection ---- 
#   
#   pfas_sel <- reactive(pfas_info[input$pfasTab_rows_selected, 'pfas_id'])
#   
#   
#   output$pfasSelection = renderPrint({
#     cat('PFAS ID:\n\n')
#     cat(as.vector(input$pfasTab_rows_selected), sep =', ')
#     cat('\n\nPreferred Names\n\n')
#     pfas_info[input$pfasTab_rows_selected, 'preferred_name']
#    
#     #cat('\n\n PFAS ID\n\n')
#     #cat(as.vector(pfas_info[input$pfasTab_rows_selected, 'pfas_id']))
#   })
#   
#   ## 3.3 plot of tox data  ----
# 
#   output$toxPlot <- renderPlot({
# 
#     pfas_sel <- pfas_info[input$pfasTab_rows_selected, 'pfas_id']
#     print(pfas_sel)
# 
#     p
# 
#   })
#       
# })
# 
# # 4. Run the application  ----- 
# 
# shinyApp(ui = ui, server = server)

library(shiny)
library(tidyverse)
library(DT)

df <- pfas_info <- read_csv(file = "www/pfas_imgs.csv") 

# Define UI for application that creates a datatables
ui <- fluidPage(fluidRow(selectInput("TheFile", "Select Cohort", 
                                     choices = c("Test_Dataset1.csv", "Test_Dataset2.csv", "Test_Dataset3.csv.csv"))),
                fluidRow(column(12, div(dataTableOutput("dataTable")))),
                
                # Application title
                titlePanel("Download Datatable")
                
                # Show a plot of the generated distribution
                , mainPanel(
                  DT::dataTableOutput("fancyTable"),
                  plotOutput("plot")
                  
                ) # end of main panel
                
) # end of fluid page

# Define server logic required to create datatable
server <- function(input, output, session) {
  
  myCSV <- reactive({
    # read.csv(input$TheFile)
    df
  })
  
  
  
  output$fancyTable <- DT::renderDataTable(
    datatable( data = myCSV()
               , extensions = 'Buttons',
               selection = 'single'
               , escape = FALSE,
               options = list( 
                 dom = "Blfrtip"
                 , buttons = 
                   list("copy", list(
                     extend = "collection"
                     , buttons = c("csv", "excel", "pdf")
                     , text = "Download"
                   ) ) # end of buttons customization
                 
                 # customize the length menu
                 , lengthMenu = list( c(10, 20, -1) # declare values
                                      , c(10, 20, "All") # declare titles
                 ) # end of lengthMenu customization
                 , pageLength = 10
               ) # end of options
               
    ) # end of datatables
  )
  
  observe({
    req(input$fancyTable_rows_selected)
    selRow <- myCSV()[input$fancyTable_rows_selected,]
    print(selRow[[1]])
    
    pfas_tox2 <- pfas_tox %>%
      mutate(alpha = if_else(as.numeric(selRow) == as.numeric(pfas), 0.5, 1))
    
    output$plot <- renderPlot({
      ggplot(pfas_tox2 , 
             aes(x=pfas, 
                 y=mean,
                 alpha = alpha)) + 
        geom_point(size=2) + 
        facet_wrap(~measure, ncol = 2) +
        coord_flip()
        }) 
  })
} # end of server

# Run the application 
shinyApp(ui = ui, server = server)