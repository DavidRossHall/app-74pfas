### Created by David Ross Hall --- davidross.hall@mail.utoronto.ca
### File created on 2022-11-07

require(shiny)
library(DT)

shinyUI <- DT::dataTableOutput('mytable')

dat <- data.frame(
  country = c('China'),
  flag = c('<img src="http://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Flag_of_the_People%27s_Republic_of_China.svg/200px-Flag_of_the_People%27s_Republic_of_China.svg.png" height="52"></img>'
  )
)

#now this is a function
shinyServer <- function(input, output){
  output$mytable <- DT::renderDataTable({
    
    DT::datatable(dat, escape = FALSE) # HERE
  })
}

#minor change to make it runnable
shinyApp(shinyUI, shinyServer)