#UVOZ PODATKOV IZ SPLETA

#KNJIŽNICE------------------------------------------------------------------------------------------------------
require(tidyr)
require(readr)
require(dplyr)
require(rvest) #za spletne strani, omogoča premikanje po značkah
require(XML)
#---------------------------------------------------------------------------------------------------------------

#BAKU
#---------------------------------------------------------------------------------------------------------------
#v spremenljivko url si shranimo spletno povezavo
url_baku_skupinske <- "https://en.wikipedia.org/wiki/2019_Rhythmic_Gymnastics_World_Championships" 

tabela_baku_skupinske <- read_html(url_baku_skupinske) #iz knjižnice rvest
#če želimo shraniti
#write_html(stran_mlad_dp,"stran_mlad_dp.html")



#ZOGE
#---------------------------------------------------------------------------------------------------------------
#html_nodes iz rvest-izbiranje delov htmlja, xpath-poseben jezik za zapisovanje poti do značke
tabela_baku_skupinske %>%
  html_nodes(xpath = "//table[@class='wikitable sortable']") %>% 
  .[[9]] %>% 
  html_table() %>% 
  rename(drzava = 2, E = 3, D = 4, koncna_ocena = 6) %>% 
  replace_na(list(Pen. = 0)) %>% #NA v stolpcu Pen. spremenim v 0
  select(-1) %>% #izbrišem prvi stolpec(uvrstitev) ker to lahko izračunamo sami
  mutate(rekvizit = "5 žog") %>%
  mutate(tekma = "2019 Baku") -> tabela_baku_skupinske_zoge
  #View() %>%
  #sapply(class) # rank:integer, drzava: caracter, E: num, D num, pen.:num, total:num 



#KIJI + OBROCI 
#-----------------------------------------------------------------------------------------------------------------
 tabela_baku_skupinske %>%
  html_nodes(xpath = "//table[@class='wikitable sortable']") %>% 
  .[[10]] %>% 
  html_table() %>% 
  rename(drzava = 2, E = 3, D = 4, koncna_ocena = 6) %>% 
  replace_na(list(Pen. = 0)) %>% #NA v stolpcu Pen. spremenim v 0
  select(-1) %>% #izbrišem prvi stolpec(uvrstitev) ker to lahko izračunamo sami
  mutate(rekvizit = "3 obroči + 4 kiji") %>%
  mutate(tekma = "2019 Baku") -> tabela_baku_skupinske_kiji_obroci 
  #View() %>%
  #sapply(class) # rank:integer, drzava: caracter, E: num, D num, pen.:num, total:num 




#SKUPNA TABELA
#------------------------------------------------------------------------------------------------------------------
wcg_baku_skupinske <- rbind(tabela_baku_skupinske_kiji_obroci, tabela_baku_skupinske_zoge)
#View(wcg_baku_skupinske)




#==================================================================================================================
#KIJEV
sl <- locale("sl", decimal_mark=".", grouping_mark=";") 

kijev_zoge <-
  read_csv("podatki/kyiv_RG_rezultati.csv", skip = 153, n_max = 6, locale=locale(encoding="Windows-1250"))[,c(3:7)]

kijev_zoge %>% 
  rename(drzava = 1, E = 2, D = 3, Pen.= 4, koncna_ocena = 5) %>% #preimenujemo stolpce
  mutate(rekvizit = "5 žog") %>% #dodamo dva stolpca
  mutate(tekma = "2020 Kijev") -> kijev_zoge



#------------------------------------------------------------------------------------------------------------------
kijev_kiji_obroci <-
  read_csv("podatki/kyiv_RG_rezultati.csv", skip = 170, n_max = 6, locale=locale(encoding="Windows-1250"))[,c(3:7)]

kijev_kiji_obroci %>% 
  rename(drzava = 1, E = 2, D = 3, Pen.= 4, koncna_ocena = 5) %>% #preimenujemo stolpce
  mutate(rekvizit = "3 obroči + 4 kiji") %>% #dodamo dva stolpca
  mutate(tekma = "2020 Kijev") -> kijev_kiji_obroci 



#SKUPNA TABELA
#------------------------------------------------------------------------------------------------------------------
ecg_kijev_skupinske <- rbind(kijev_kiji_obroci, kijev_zoge)
#View(ecg_kijev_skupinske)



#================================================================================================================
#SKUPNA TABELA SKUPINSKIH VAJ
skupinske <- rbind(wcg_baku_skupinske, ecg_kijev_skupinske)


#ni mi všeč ker mam nekje države poimenovane z kraticam nekje pa s celim imenom
skupinske$drzava <- recode(skupinske$drzava 
                     ,'BUL' = 'Bulgaria'
                     ,'ISR' = 'Israel'
                     ,'ITA' = 'Italy'
                     ,'JPN' = 'Japan'
                     ,'RUS' = 'Russia'
                     ,'UKR' = 'Ukraine'
                     ,'AZE' = 'Azerbaijan'
                     ,'CHN' = 'China'
                     ,'BLR' = 'Belarus'
                     ,'TUR' = 'Turkey'
                     ,'FRA' = 'France'
                     ,'EST' = 'Estonia')
#View(skupinske)




