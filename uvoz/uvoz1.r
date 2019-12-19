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

sofia_hoop <- read_csv("sofia_hoop.csv",skip = 8, col_names = c("","","Tekmovalka", "","","Država","","", "DA", "DB","", "EA", "ET", "Pen.", ""),
                       locale=locale(encoding="Windows-1250")) %>% select(c(3,6,9,10,12:14))

sofia_ball <- read_csv("sofia_ball.csv",skip = 8, col_names = c("","","Tekmovalka", "","","Država","","", "DA", "DB","", "EA", "ET", "Pen.", ""),
                       locale=locale(encoding="Windows-1250")) %>% select(c(3,6,9,10,12:14))

sofia_clubs <- read_csv("sofia_clubs.csv",skip = 8, col_names = c("","","Tekmovalka", "","","Država","","", "DA", "DB","", "EA", "ET", "Pen.", ""),
                       locale=locale(encoding="Windows-1250")) %>% select(c(3,6,9,10,12:14))

sofia_ribbon <- read_csv("sofia_ribbon.csv",skip = 8, col_names = c("","","Tekmovalka", "","","Država","","", "DA", "DB","", "EA", "ET", "Pen.", ""),
                       locale=locale(encoding="Windows-1250")) %>% select(c(3,6,9,10,12:14))

baku_hoop <- read_csv("baku_hoop.csv",skip = 8, col_names = c("","","Tekmovalka", "","","Država","","", "DA", "DB","", "EA", "ET", "Pen.", ""),
                       locale=locale(encoding="Windows-1250")) %>% select(c(3,6,9,10,12:14))

baku_ball <- read_csv("baku_ball.csv",skip = 8, col_names = c("","","Tekmovalka", "","","Država","","", "DA", "DB","", "EA", "ET", "Pen.", ""),
                       locale=locale(encoding="Windows-1250")) %>% select(c(3,6,9,10,12:14))

baku_clubs <- read_csv("baku_clubs.csv",skip = 8, col_names = c("","","Tekmovalka", "","","Država","","", "DA", "DB","", "EA", "ET", "Pen.", ""),
                       locale=locale(encoding="Windows-1250")) %>% select(c(3,6,9,10,12:14))

baku_ribbon <- read_csv("baku_ribbon.csv",skip = 8, col_names = c("","","Tekmovalka", "","","Država","","", "DA", "DB","", "EA", "ET", "Pen.", ""),
                       locale=locale(encoding="Windows-1250")) %>% select(c(3,6,9,10,12:14))


#problem je le zadnji stolpec, v csvjih ni ,, če tekmovalka ni imela pen. 
#in zato končna ocena tistih skoči v stolpec za pen.

#vidimo da bi vse to lahko združili v eno tabelo, zraven imena bi morali napisati še tekmo in rekvizit.

wcg <- rbind(baku_hoop, baku_ball, baku_clubs, baku_ribbon, sofia_hoop, sofia_ball, sofia_clubs, sofia_ribbon)



