rm(list=ls())

#html_nodes(table)iz spletne strani želim dobiti le tabelo
# length(stran) pove da imamo na spletni strani 2 tabeli
library(rvest)

#url <- "https://www.gymnastics.sport/site/events/results.php?idEvent=14977"
#stran <- read_html(url)
#stran %>% html_nodes(xpath='//*[@id="app"]/div[2]/div/div[2]/table') %>% html_table(header=TRUE, fill = TRUE) 


uvoz.por.hoop <- function(por.hoop){
  url <- "https://www.gymnastics.sport/site/events/results.php?idEvent=15889#filter"
  stran <- html_session(url) %>% read_html()
  stran %>% html_nodes(xpath='//*[@id="app"]/div[2]/div/div[2]/table') %>% html_table(header=TRUE, fill = TRUE)
}  
por.hoop <- uvoz.por.hoop()
View(por.hoop)




