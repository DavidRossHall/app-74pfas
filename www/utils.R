### Created by David Ross Hall --- davidross.hall@mail.utoronto.ca
### File created on 2022-11-0

# removes HTML tags from string
cleanHTML <- function(htmlString) {
  htmlString <- str_replace(htmlString, "<br>", " ")
  return(gsub("<.*?>", "", htmlString))
}

# Get PFAS ID number from PFAS name in table. 
getID <- function(str){
  
  return(str_extract(str, "(?<=#)[0-9]*"))
}


## Rough volcano plot code for now. 
       
volcanoPlot <- function(data, pValueCutoff = 0.05){

  volc_cols <- c("up" = "red", 
                 "down" = "blue", 
                 "notSig" = "#D3D3D3")


  cutoff <- as.numeric(pValueCutoff)

  df <- data %>%
    mutate(sig = case_when(
      pvalue < cutoff & mean < 0 ~ "down",
      pvalue < cutoff & mean > 0 ~ "up",
      TRUE ~ "notSig"
    )
    )

  p <- ggplot(data = df,
              aes( x = mean,
                   y = -log10(pvalue),
                   colour = sig,
                   text = ""
                   # label = paste("Protein Group:",
                   #               protein_group,
                   #               "<br>Genes:",
                   #               genes)
                   )
              ) +
    geom_point(alpha = 0.4,
               aes(text = paste(
                 "Protein Group: ", protein_group,
                 "<br>Genes: ", genes,
                 "<br>Mean FC: ", round(mean, 2),
                 "<br>p-value: ", round(pvalue, 5)
                  )
                 )
               ) +
    geom_abline(intercept = -log10(cutoff),
                slope = 0,
                linetype = "dotted") +
    scale_color_manual(values = volc_cols) +
        theme_classic() +
    theme(legend.position = "none")

  plotly::ggplotly(p, tooltip = "text")

}

dat <- low_pg %>%
  filter(pfas == 1) %>%
  group_by(pfas, obs) %>%
  summarize(n = n()) %>%
  ungroup()

ggplot(dat, 
       aes(x = as.character(pfas),
           y = n,
           fill = as.character(obs))) +
  geom_bar(position = "stack", 
           stat = "identity") +
  scale_y_continuous(breaks = c(0, 1622, 1622+211, 1622+211+220),
                     labels = c(0, 1622, paste(1622+211), paste(1622+211+220)))


## bar chart summary num. of detected PG/exposure group.

### counts number of protein groups per selection
### cumulatively sums pg groups to output totals from N = 3 obs to N = 1 obs

pg_sum <- function(data){
  
  data %>% 
    group_by(pfas, obs) %>%
    summarize(n = n()) %>%
    ungroup() %>%
    arrange(desc(obs)) %>%
    mutate(cumsum = cumsum(n))
  
}

## Bar chart of PG groups per n Obs

pg_sum_barchart <- function(data){
  
  dat <- pg_sum(data)
  
  p <-  ggplot(dat, 
               aes(x = as.character(pfas),
                   y = n,
                   fill = as.character(obs))) +
    geom_bar(position = "stack", 
             stat = "identity") +
    scale_y_continuous(breaks = c(0, dat$cumsum),
                       labels = c(0, dat$cumsum)) +
    labs(x = "PFAS ID", 
         y = "Cummulative sum of Protein Groups", 
         fill = "No. Observations") +
  theme_classic() 
  
  plotly::ggplotly(p)
}