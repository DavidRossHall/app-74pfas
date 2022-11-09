library(reshape2)
library(plotly)

# Plotly stuff ----

  p <- ggplot(tips, aes(x=total_bill, y=tip/total_bill)) + geom_point(shape=1)
  
  # Divide by day, going horizontally and wrapping with 2 columns
  p <- p + facet_wrap( ~ day, ncol=2)
  
  fig <- ggplotly(p)
  
  fig

# Data table w/ images ----

  # UI 
  
  DT::dataTableOutput('pfasTab')
  
  # Server 
  output$pfasTab = DT::renderDataTable(pfas_info,
                                       server = FALSE,
                                       escape = FALSE,
                                       rownames= FALSE,
                                       options = list(
                                         scrollY = '300px',
                                         paging = FALSE
                                       ))
