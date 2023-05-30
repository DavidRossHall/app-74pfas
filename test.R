# library(DT)
# readfile <- mtcars
# server <- shinyServer(function(input, output, session) {
# 
#   output$x1 = DT::renderDataTable(readfile, server = FALSE)
# 
# 
#   # output$x2 = DT::renderDataTable({
#   #   sel <- input$x1_rows_selected
#   #   if(length(readfile)){
#   #     readfile[sel, ]
#   #   }
#   #
#   # }, server = FALSE)
#   #
# 
#   output$x3 <- renderPlot({
#     #s = input$x3_rows_selected
#     ggplot(readfile[input$x1_rows_selected, ], aes(x=factor(cyl, levels=c(4,6,8)))) +
#       geom_bar()
#   })
# })
# 
# 
# ui <- fluidPage(
# 
#   fluidRow(
#     column(6, DT::dataTableOutput('x1')),
#     # column(6, DT::dataTableOutput('x2')),
#     column(6, plotOutput('x3', height = 500))
#   )
# 
# )
# 
# shinyApp(ui, server)
# 
# # library(shiny)
# # 
# # ui <- fluidPage(
# #   numericInput("number", "Input", 1),
# #   actionButton("button", "Reset"),
# #   textOutput("check")
# # )
# # server <- function(input, output) {
# #   num <- reactiveVal()
# # 
# #   observeEvent(input$number, {
# #     num(input$number)
# #   })
# # 
# #   observeEvent(input$button, {
# #     num(1)
# #   })
# # 
# #   observeEvent(c(input$button, input$number), {
# #     output$check <- renderText({
# #       num()
# #     })
# #   })
# # }
# # shinyApp(ui, server)
# # 

