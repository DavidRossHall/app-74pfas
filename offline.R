### Created by David Ross Hall --- davidross.hall@mail.utoronto.ca
### File created on 2022-11-07

### Collection of offline r code for data preparation and calculations. 

# Libraries 

library(tidyverse)

# organizing PFAS table for display/radio icones

# relative location of PFAS molecule images. 
imgs <- data.frame(
  imgs = list.files(path = "www/molecules/")
)

# table with relative molecule images & PFAS ID. 
imgs <- imgs %>%
  mutate(pfas_id = str_replace(imgs, "\\.png", ""),
         pfas_id = as.numeric(pfas_id),
         imgs = paste0("www/molecules/", imgs)) %>%
  relocate(pfas_id) %>%
  arrange(pfas_id)
  
pfas_info <- read_csv("raw-data/74pfas_info.csv") %>%
  mutate(pfas_id = as.numeric(pfas_id))

pfas <- left_join(pfas_info, imgs) %>%
  select(pfas_id, preferred_name, casrn, imgs)

write_csv(pfas, file = "www/pfas_imgs.csv")