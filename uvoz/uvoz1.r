#UvOZ PODATKOV
#=============================================================================================================
#UVOZ CSV DATOTEK - INDUVIDUVALNE SESTAVE
#=============================================================================================================

#naložili smo data, z >class(sofia_hoop) smo preverili da je res data.frame 
#(dvodimenzionalna tabela iz vrstic in stolpcev, vsak stolpec je enega tipa),
#z dim(sofia_ ) preverimo število vrstic 14 in št stolpcev 17,

#preverimo imena stolpcev names(sofia_hoop), to bo potreba še urediti. x je nepotreben
#x1=uvrstitev, x2=ime tekmovalke, x3,x4 sta nepotrebna, noc=kratica države, x5 nepotreben,
#D je nepotreben saj je to le seštevek x6=DA E=DB, deduction je nepotreben je seštevek Qualification=EA 
#in Start=ET, X7 je čisto pomešan saj imajo odbitke le nekatere tekmovalke,
#x8 bi moral predstavljati skupno oceno, x9, x10 sta nepotrebna

#str() tu vidimo kakšnega tipa so naši stolpci (vsiporebni stolpci so factor ampak to ni ok), potrebujemo:
#x1=intiger, x2 in noc=character, ostali numeric.

#===========================================================================================================
#KNJIŽNICE
#===========================================================================================================
library(dplyr)
library(tidyr) #za funkciji gather() in spread()
library(readr)
library(naniar)


#==============================================================================================================
#BRANJE IZ EXCELA
#==============================================================================================================
sl <- locale("sl", decimal_mark=".", grouping_mark=";") 

#SOFIA
#---------------------------------------------------------------------------------------------------------------
sofia_hoop<- read_csv("podatki/sofia_hoop.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(sofia_hoop) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")

sofia_ball<- read_csv("podatki/sofia_ball.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(sofia_ball) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")

sofia_clubs<- read_csv("podatki/sofia_clubs.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(sofia_clubs) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")

sofia_ribbon<- read_csv("podatki/sofia_ribbon.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(sofia_ribbon) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")



#BAKU
#------------------------------------------------------------------------------------------------------------------
baku_hoop<- read_csv("podatki/baku_hoop.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(baku_hoop) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")

baku_ball<- read_csv("podatki/baku_ball.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(baku_ball) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")

baku_clubs<- read_csv("podatki/baku_clubs.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(baku_clubs) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")

baku_ribbon<- read_csv("podatki/baku_ribbon.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(baku_ribbon) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")



#KIJEV
#-----------------------------------------------------------------------------------------------------------------
kijev_hoop<- 
  read_csv("podatki/kyiv RG rezultati.csv", skip = 6, n_max= 25, locale=locale(encoding="Windows-1250"))[,c(2:7)]
colnames(kijev_hoop) <- c("tekmovalka","drzava","E", "D", "Pen.", "koncna_ocena")

kijev_ball<- 
  read_csv("podatki/kyiv RG rezultati.csv", skip = 43, n_max= 25, locale=locale(encoding="Windows-1250"))[,c(2:7)]
colnames(kijev_ball) <- c("tekmovalka","drzava","E", "D", "Pen.", "koncna_ocena")

kijev_clubs<- 
  read_csv("podatki/kyiv RG rezultati.csv", skip = 80, n_max= 25, locale=locale(encoding="Windows-1250"))[,c(2:7)]
colnames(kijev_clubs) <- c("tekmovalka","drzava","E", "D", "Pen.", "koncna_ocena")

kijev_ribbon<- 
  read_csv("podatki/kyiv RG rezultati.csv", skip = 116, n_max= 25, locale=locale(encoding="Windows-1250"))[,c(2:7)]
colnames(kijev_ribbon) <- c("tekmovalka","drzava","E", "D", "Pen.", "koncna_ocena")



#==============================================================================================================
#DODAJANJE STOLPCEV
#==============================================================================================================
#vidimo da bi vse to lahko združili v eno tabelo, zraven imena bi morali napisati še tekmo in rekvizit.

#SOFIA
#-------------------------------------------------------------------------------------------------------------
sofia_hoop$rekvizit<-"hoop" 
sofia_hoop$tekma<-"2018 Sofia"

sofia_ball$rekvizit<-"ball" 
sofia_ball$tekma<-"2018 Sofia"

sofia_clubs$rekvizit<-"clubs" 
sofia_clubs$tekma<-"2018 Sofia"

sofia_ribbon$rekvizit<-"ribbon" 
sofia_ribbon$tekma<-"2018 Sofia"



#BAKU
#------------------------------------------------------------------------------------------------------------
baku_hoop$rekvizit<-"hoop" 
baku_hoop$tekma<-"2019 Baku"

baku_ball$rekvizit<-"ball" 
baku_ball$tekma<-"2019 Baku"

baku_clubs$rekvizit<-"clubs" 
baku_clubs$tekma<-"2019 Baku"

baku_ribbon$rekvizit<-"ribbon" 
baku_ribbon$tekma<-"2019 Baku"



#KIJEV
#-------------------------------------------------------------------------------------------------------------
kijev_hoop$rekvizit<-"hoop" 
kijev_hoop$tekma<-"2020 Kijev"

kijev_ball$rekvizit<-"ball" 
kijev_ball$tekma<-"2020 Kijev"

kijev_clubs$rekvizit<-"clubs" 
kijev_clubs$tekma<-"2020 Kijev"

kijev_ribbon$rekvizit<-"ribbon" 
kijev_ribbon$tekma<-"2020 Kijev"


#=============================================================================================================
#ZDRUŽITEV SVETOVNIH POKALOV V SKUPNO TABELO wcg
#=============================================================================================================
# uporabimo knjižnico library(naniar), replace_with_na_at nadomesti spremenljivke z NA če je dosežen pogoj
# .vars = na katerem stolpcu uporabimo zamenjavo, 
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!kaj je ~.x
wcg <- rbind(baku_hoop, baku_ball, baku_clubs, baku_ribbon, sofia_hoop, sofia_ball, sofia_clubs, sofia_ribbon) %>% 
  replace_with_na_at(.vars = c("Pen."), condition = ~.x >= 0) 

#preuredimo še vrstni red stolpcev
wcg <- wcg[c('tekmovalka', 'drzava', 'tekma', 'rekvizit', 'DB', 'DA', 'EA', 'ET', 'Pen.')]
  

#v stolpcu pen. nekatere tekmovalke "nimajo podatka" v resnici le niso dobile odbitka zato te na nastavimo na 0
wcg[is.na(wcg)] = 0
#View(wcg)



#=============================================================================================================
#ZDRUŽITEV EVROPSKEGA PRVENSTVA KIJEV V SKUPNO TABELO ecg
#=============================================================================================================
ecg <- rbind(kijev_hoop, kijev_ball, kijev_clubs, kijev_ribbon)

#preuredimo še vrstni red stolpcev
ecg <- ecg[c('tekmovalka', 'drzava', 'tekma', 'rekvizit', 'E', 'D', 'Pen.', 'koncna_ocena')]

#View(ecg)



#=============================================================================================================
#ZDRUŽITEV TABEL wcg IN ecg V SKUPNO TABELO induvidualne
#=============================================================================================================
#če bi želeli združit tabeli bi morali v wcg seštet EA 7 in  ET 8 da dobimo E nato DB in DA da dobimo D
wcg_D_E <- wcg
wcg_D_E$E <- wcg_D_E$EA + wcg_D_E$ET
wcg_D_E$D <- wcg_D_E$DB + wcg_D_E$DA
wcg_D_E$koncna_ocena <- wcg_D_E$D + 10 + wcg_D_E$E + wcg_D_E$Pen.
wcg_D_E <- wcg_D_E[c('tekmovalka', 'drzava', 'tekma', 'rekvizit', 'E', 'D', 'Pen.', 'koncna_ocena')]
#View(wcg_D_E)

induvidualne <- rbind(ecg, wcg_D_E)
View(induvidualne)

#===============================================================================================
#SAMO "FINALISTKE"
#===============================================================================================
finali_kijev <- ecg %>%
  group_by(tekma) %>%
  group_by(rekvizit) %>% 
  slice(c(1,2,3,4,5,6,7,8)) %>% #vemo da so podatki urejeni, tako da samo vzamemo prvih 8 ocen
  ungroup() 

induvidualne_finali <- rbind(finali_kijev, wcg_D_E)
View(induvidualne_finali)
