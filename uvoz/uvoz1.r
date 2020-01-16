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

library(dplyr)
library(tidyr) #za funkciji gather() in spread()
library(readr)

sl <- locale("sl", decimal_mark=".", grouping_mark=";")


sofia_hoop<- read_csv("podatki/sofia_hoop.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(sofia_hoop) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")

  sofia_ball<- read_csv("podatki/sofia_ball.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(sofia_ball) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")

sofia_clubs<- read_csv("podatki/sofia_clubs.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(sofia_clubs) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")

sofia_ribbon<- read_csv("podatki/sofia_ribbon.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(sofia_ribbon) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")

baku_hoop<- read_csv("podatki/baku_hoop.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(baku_hoop) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")

baku_ball<- read_csv("podatki/baku_ball.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(baku_ball) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")

baku_clubs<- read_csv("podatki/baku_clubs.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(baku_clubs) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")

baku_ribbon<- read_csv("podatki/baku_ribbon.csv", skip = 7, locale=locale(encoding="Windows-1250"))[,c(3,6,9,10,12:14)]
colnames(baku_ribbon) <- c("tekmovalka","drzava","DB", "DA", "EA", "ET", "Pen.")

#vidimo da bi vse to lahko združili v eno tabelo, zraven imena bi morali napisati še tekmo in rekvizit.
sofia_hoop$rekvizit<-"hoop" 
sofia_hoop$tekma<-"Sofia"

sofia_ball$rekvizit<-"ball" 
sofia_ball$tekma<-"Sofia"

sofia_clubs$rekvizit<-"clubs" 
sofia_clubs$tekma<-"Sofia"

sofia_ribbon$rekvizit<-"ribbon" 
sofia_ribbon$tekma<-"Sofia"

baku_hoop$rekvizit<-"hoop" 
baku_hoop$tekma<-"Baku"

baku_ball$rekvizit<-"ball" 
baku_ball$tekma<-"Baku"

baku_clubs$rekvizit<-"clubs" 
baku_clubs$tekma<-"Baku"

baku_ribbon$rekvizit<-"ribbon" 
baku_ribbon$tekma<-"Baku"


#problem je le zadnji stolpec, v csvjih ni ,, če tekmovalka ni imela pen. 
#in zato končna ocena tistih skoči v stolpec za pen.


library(naniar)
wcg <- rbind(baku_hoop, baku_ball, baku_clubs, baku_ribbon, sofia_hoop, sofia_ball, sofia_clubs, sofia_ribbon) %>% replace_with_na_at(.vars = c("Pen."), condition = ~.x >= 0) 

wcg[is.na(wcg)] = 0





