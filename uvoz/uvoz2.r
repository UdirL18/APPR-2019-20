rm(list=ls())

#html_nodes(table)iz spletne strani želim dobiti le tabelo
# length(stran) pove da imamo na spletni strani 2 tabeli
library(rvest)

#url <- "https://www.gymnastics.sport/site/events/results.php?idEvent=14977"
#stran <- read_html(url)
#stran %>% html_nodes(xpath='//*[@id="app"]/div[2]/div/div[2]/table') %>% html_table(header=TRUE, fill = TRUE) 


uvoz.por.hoop <- function(){
  url <- "https://www.gymnastics.sport/site/events/results.php?idEvent=15889#filter"
  stran <- html_session(url) %>% read_html()
  stran %>% html_nodes(xpath='//*[@id="app"]/div[2]/div/div[2]/table') %>% .[[1]] %>% html_table(header=TRUE, fill = TRUE)
}  
por.hoop <- uvoz.por.hoop()
View(por.hoop)


link <- "https://www.gymnastics.sport/site/events/results.php?idEvent=15889#filter"
stran <- html_session(link) %>% read_html()
vrstice <- stran %>% html_nodes(xpath='//*[@id="app"]/div[2]/div/div[2]/table') %>% html_text()
csv <- gsub(" {2,}", ",", vrstice) %>% paste(collapse="") #zamenja, kjer sta vsaj 2 presledka z vejicami (v CSV)
stolpci <- c("IZBRISI2","Sezon_v_ligi", "Ekipa", "Zmage_redni_del", "Porazi_redni_del", "Uspesnost_redni_del","Stevilo_playoffov", "Playoff_zmage", "Playoff_porazi","Playoff_uspesnost", "Zmage_serij","Porazi_serij","Uspesnost_serij","Nastopi_finale", "Zmage_finale","IZBRISI")

podatki_ekipe <- read_csv(csv, locale=locale(encoding="UTF-8"), col_names=stolpci)
podatki_ekipe <- podatki_ekipe[,-c(1,2,16)]


