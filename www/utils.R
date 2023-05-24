### Created by David Ross Hall --- davidross.hall@mail.utoronto.ca
### File created on 2022-11-0

# removes HTML tags from string
cleanHTML <- function(htmlString) {
  return(gsub("<.*?>", "", htmlString))
}