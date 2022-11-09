### Created by David Ross Hall --- davidross.hall@mail.utoronto.ca
### File created on 2022-11-09

### Toxicity Data Plot

library(tidyverse)
library(plotly)

toxRaw <- read_csv("www/jiajun_EHP2020.csv")

# compounds with high BCF
bcf <- toxRaw %>%
  filter(measure == 'bcf, 5 uM') %>%
  filter(mean >= 10) 

# compounds with high mortality
mortality <- toxRaw %>%
  filter(measure == "mortality") %>%
  filter(mean >=10) # 10% mortality requires full study. 

# union of important compounds 

targetCmpds <- unique(bcf$pfas, mortality$pfas) %>%
  append(., 60)

# Col headers for plots

headers <- data.frame("measure" = unique(toxRaw$measure),
                      "header" = c("Pericadial Edema (n)",
                                   "Tail Dysplasia (n)",
                                   "Spinal Curvature (n)",
                                   "BCF, 0.5 µM (L/kg)",
                                   "BCF, 5 µM (L/kg)",
                                   "Mortality (%)"
                      ))

tox <- toxRaw %>%
  #filter(measure != 'bcf, 0.5 uM') %>%
  mutate(annotCmpds = case_when(pfas %in% targetCmpds ~ pfas, 
                                TRUE ~ 1),
         annotAlpha = case_when(pfas %in% targetCmpds ~ 1, 
                                TRUE ~0.8)) %>%
  left_join(., y = headers)

# basic plot 
p <- ggplot(data = tox, 
            aes(x = pfas,
                y = mean,
                ymin = mean-sd, 
                ymax = mean+sd,
                colour = as.factor(annotCmpds),
                alpha = annotAlpha)) +
  geom_point(size = 1) + 
  geom_errorbar() +
  facet_wrap(vars(header), scales = "free_x", nrow = 2) 

# adjusting aesthetics 
p2 <- p +
  scale_colour_viridis_d()+
  coord_flip() +
  theme_bw() +
  theme(legend.position = "none",
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        strip.text.x = element_text(size = 6),
        axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10),
        panel.spacing = unit(0.1, "cm"))  +
  scale_x_continuous(breaks = targetCmpds,
                     guide = guide_axis(n.dodge=3)) +
  scale_y_continuous(labels = scales::number_format(accuracy = 1),
                     guide = guide_axis(check.overlap = TRUE)) +
  expand_limits(x = 0, y = 0) +
  labs(x = "PFAS compound ID", 
       y = "mean ± SD")

