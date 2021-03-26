###########################################################################################
#3. FAZA: VIZUALIZACIJA PODATKOV - ZEMLJEVIDI #https://www.r-bloggers.com/2017/12/how-to-highlight-countries-on-a-map/
############################################################################################
#NAVODILA:
#-Na zemljevidu prikažite dva podatka - enega imenskega ali urejenostnega 
# (z majhnim številom vrednosti, npr. 3-6), in enega številskega. 
#-Vsaj en od prikazanih podatkov naj pride iz vira, ločenega od zemljevida (npr. datoteka CSV).
#-Na zemljevid lahko dodaste še oznake območij in narišete še nekaj točk s svojimi oznakami (npr. za mesta). 
#-Podatki o koordinatah točk naj bodo v priloženi datoteki CSV.


#===========================================================================================
#KNJIŽNICE
#===========================================================================================

#library(rgdal)
#library(rgeos)
#library(mosaic)
#library(maptools)
#library(munsell)
#library(StatMeasures)
#library(reshape2)
#library(ggplot2) #map_data
#library(tidyverse)
#library(rvest)
#library(magrittr)
#library(ggmap)
#library(stringr)
#library(dplyr) #left_join (če v drugonavedeni tabelini tehpodatkovbo ohranil podatke iz prvonavedene tabele)

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
#source('lib/uvozi.zemljevid.r')
#source('lib/libraries.r', encoding = 'UTF-8')



#============================================================================================
#ZEMLEVID SVETA
#============================================================================================
#iz ggplot2 uvozimo zemljevid
map.world <- map_data("world") #, xlim=c(-120,100),ylim=c(-20,100)) 
#potrebujem le ta del zemljevida saj v južnem delu ni nobene države s tekmovalko v finalih
#zanemarimo japonsko k je itak kiksala na veliko

#View(map.world)


#============================================================================================
# SPREMEMBA IMEN DRŽAV
# - imena v induvidualne_finali niso enaka kot v map.world
# - moramo jih preimenovati
#============================================================================================

# PREIMENOVANJE DRŽAV
induv_zemljevid <- induvidualne_finali #da ne bom pokvarila tabele
induv_zemljevid$drzava <- recode(induv_zemljevid$drzava  #dplyr
                     ,'BUL' = 'Bulgaria'
                     ,'GEO' = 'Georgia'
                     ,'ISR' = 'Israel'
                     ,'ITA' = 'Italy'
                     ,'JPN' = 'Japan'
                     ,'RUS' = 'Russia'
                     ,'UKR' = 'Ukraine'
                     ,'USA' = 'USA'
                     ,'BLR' = 'Belarus'
                     ,'AZE' = 'Azerbaijan'
                     #,'MDA' = 'Moldova'
                     #,'EST' = 'Estonia'
                     #,'ROU' = 'Romania'
                     ,'SLO' = 'Slovenia'
                     #,'TUR' = 'Turkey'
                     #,'MKD' = 'Macedonia'  
                     #,'CZE' = 'Czech Republic'
                     #,'LTU' = 'Lithuania'
                     #,'LUX' = 'Luxembourg'
                     #,'CRO' = 'Croatia'
                     ,'LAT' = 'Latvia'
                     ,'HUN' = 'Hungary'
                     #,'MNE' = 'Montenegro'
                     #,'BIH' = 'Bosnia and Herzegovina'
                     
)

# PREVERIM ALI SEM USPEŠNO ZAMENJALA IMENA =)
#View(induv_zemljevid) 


#===========================================================================================
# ZDRUŽITEV
# - združio induv_zemljevid in world map
#===========================================================================================
#head(map.world)

# LEFT JOIN iz dplyr- če v induv_zemljevid ni te države bo ohranil podatke iz map.world
map.world_joined <- left_join(map.world, induv_zemljevid, by = c('region' = 'drzava'))

#View(map.world_joined) #long lat group order region subregion tekmovalka tekma rekvizit E D Pen. koncna_ocena


#============================================================================================
# INDIKATOR
# -v zemljevidu, bomo poudarili države, ki so imeli temovalke v finalih 
#  evropskih in svetovnih prvenstev. NOTE 2020 ni blo finalov, zato sem jih kar sama naredila.
# -ustvarili bom indikator, ki bo povedal ali želim obarvati določeno državo 
#  če je v tabeli map.world_joined v stolpcu tekma NA potem države ne bomo obarvali.
#===========================================================================================

map.world_joined <- map.world_joined %>% mutate(fill_flg = ifelse(is.na(tekma),F,T)) 
#dodamo stolpec fill_flg če je v stolpcu tekma NA bo v fill_flg FALSE drugače TRUE
#head(map.world_joined)

#View(map.world_joined)


#==============================================================================================
# 1.1 ZEMLJEVID
#==============================================================================================

ggplot() +
  geom_polygon(data = map.world_joined, aes(x = long, y = lat, group = group, fill = fill_flg)) +
  scale_fill_manual(values = c("#CCCCCC","#e60000")) +
  labs(title = 'DRŽAVE S TEKMOVALKAMI V FINALIH SVETOVNIH PRVENSTEV') +
  theme(panel.background = element_rect(fill = "#444444")
        ,plot.background = element_rect(fill = "#444444")
        ,panel.grid = element_blank()
        ,plot.title = element_text(size = 15)
        ,axis.text = element_blank()
        ,axis.title = element_blank()
        ,axis.ticks = element_blank()
        ,legend.position = "none"
  )

#*opomba:
#dobila sem zemljevid, ki prikazuje katere države so bile zastopane v finalih svetovnega prvestva.
#doala bi še:
# 1.meje držav obarvanih z rdečo (sem)
# 2.imena tekmovalk



#=================================================================================================
#1.2 ZEMLJEVID, KI OBARVA DRŽAVE GLEDE NA KONČNE OCENE (nefer k rusije 2020 ni blo na evropcu :( ))
#============================================================================================
#države bi radi obarvali glede na končne ocene

ggplot(map.world_joined, aes( x = long, y = lat, group = group )) +
  geom_polygon(aes(fill = koncna_ocena))



#===================================================================================
#ZEMLJEVID NAJVIŠJE OCENE
#===================================================================================
#da bomo bolje videli katera država ima najvišjo oceno za posamezen rekvizit bom tiste države obkrožila, 
#rada bi dodala stolpec true fase, če je max ocena za rekvizit true drugače false
#*opomba: to ni glih kul ker bodo to vse ocene iz Kijeva tj. obkrožili bomo izrael in belorusijo


#grep{base} 
#-----------------------------------------------------------------------------------------------------
vrstice_hoop <- map.world_joined[grep("hoop",map.world_joined$rekvizit),] %>% 
  filter(region == "Israel") #long,lat, group, order, region, subregion, tekmovalka, tekma, rekvizit
vrstice_ball <- map.world_joined[grep("ball",map.world_joined$rekvizit),]%>% 
  filter(region == "Belarus")
vrstice_clubs <- map.world_joined[grep("clubs",map.world_joined$rekvizit),]%>% 
  filter(region == "Belarus")
vrstice_ribbon <- map.world_joined[grep("ribbon",map.world_joined$rekvizit),]%>% 
  filter(region == "Belarus")
#vrstice_hoop <- map.world_joined[grep("hoop",map.world_joined$rekvizit),] %>% 
#  filter(koncna_ocena == "26.5")
#vrstice_ball <- map.world_joined[grep("ball",map.world_joined$rekvizit),]%>% 
#  filter(koncna_ocena == "26")
#vrstice_clubs <- map.world_joined[grep("clubs",map.world_joined$rekvizit),]%>% 
#  filter(koncna_ocena == "26.55")
#vrstice_ribbon <- map.world_joined[grep("ribbon",map.world_joined$rekvizit),]%>% 
#  filter(koncna_ocena == "23.0")
#max(map.world_joined$koncna_ocena, na.rm = TRUE) #katera je max ocena 26.55
#max(vrstice_hoop$koncna_ocena, na.rm = TRUE) #max ocena pri obroču 26.5


#preverimo katera vrstica ima maximalno oceno za posamezni rekvizit
#------------------------------------------------------------------------------------------------------
#which.max(vrstice_hoop$koncna_ocena) #2444; 26.5 ISR
#which.max(vrstice_ball$koncna_ocena) #717; 26 Belorusija
#which.max(vrstice_clubs$koncna_ocena) #802; 26.55 belorusija
#which.max(vrstice_ribbon$koncna_ocena) #538; 23.0 Belorusija


#tabela 4 vrstic
#-------------------------------------------------------------------------------------------------------
max_ocena <- rbind(vrstice_hoop,vrstice_ball, vrstice_clubs, vrstice_ribbon) 
max_ocena$najvisja_ocena <- "TRUE" #dodamo stolpec najvišja_ocena in ga nastavimo na TRUE(v vseh 4 vrsticah)
#View(max_ocena)


#združimo data z left_join iz dplyr
#--------------------------------------------------------------------------------------------------------
map.world_joined_max <- left_join(map.world_joined, max_ocena, by = c('long' = 'long','lat' = 'lat', 'group' = 'group', 'order' = 'order', 'region'= 'region', 'subregion' = 'subregion', 'tekmovalka' = 'tekmovalka', 'tekma' = 'tekma', 'rekvizit' = 'rekvizit', 'E' = 'E', 'D' = 'D', 'Pen.' = 'Pen.', 'koncna_ocena' = 'koncna_ocena',  'fill_flg' = 'fill_flg'))

map.world_joined_max <- map.world_joined_max %>% 
  mutate(najvisja_ocena = ifelse(is.na(najvisja_ocena),F,T)) #dodamo stolpec
#is.na vrne TRUE, če je na danem mestu NA, sicer FALSE
#ifelse(test, yes, no) {base} test = data, če true vrne yes, če false no
#View(map.world_joined_max)


#zemljevid
#--------------------------------------------------------------------------------------------------------
ggplot(map.world_joined_max, aes( x = long, y = lat, group = group)) +
  geom_polygon(aes(color = as.factor(najvisja_ocena))) +
  scale_color_manual(values = c('TRUE' = 'red', 'FALSE' = NA))



#=====================================================================================
#1.2.2 IZPIS IMEN NAJBOLJŠIH TEKMOVALK ZA DRŽAVO (Izrael, Rusija, Belorusija, Bulgaria)
#=====================================================================================
vrstice_tekmovalka_Isr <- map.world_joined[grep("Israel",map.world_joined$region),] %>% 
  filter( koncna_ocena == max(koncna_ocena))
vrstice_tekmovalka_Blr <- map.world_joined[grep("Belarus",map.world_joined$region),] %>% 
  filter( koncna_ocena == max(koncna_ocena))
vrstice_tekmovalka_Rus <- map.world_joined[grep("Russia",map.world_joined$region),] %>% 
  filter( koncna_ocena == max(koncna_ocena))
vrstice_tekmovalka_Bul <- map.world_joined[grep("Bulgaria",map.world_joined$region),] %>% 
  filter( koncna_ocena == max(koncna_ocena))

vrstice_tekmovalka <- rbind(vrstice_tekmovalka_Rus[5000,], vrstice_tekmovalka_Blr[1,], vrstice_tekmovalka_Isr[1,], vrstice_tekmovalka_Bul[1,])
#View(vrstice_tekmovalka)


 




#============================================================================================
#1.3 ZEMLJEVID NAJVIŠJIH OCEN (končen)
#===========================================================================================
#!javi mi neke napake font family


#------------------------------------------------------------------------------------------
#IMENA DRŽAV
#------------------------------------------------------------------------------------------
#imena <-map.world_joined_max[match(unique(map.world_joined_max$region), map.world_joined_max$region),]
#View(imena)

#------------------------------------------------------------------------------------------
#zemljevid_najvisjih_ocen
#------------------------------------------------------------------------------------------
zemljevid_najvisjih_ocen <- ggplot(map.world_joined_max, aes( x = long, y = lat, group = group)) +
  geom_polygon(aes(color = as.factor(najvisja_ocena), fill = koncna_ocena)) +
  scale_color_manual(values = c('TRUE' = 'blue', 'FALSE' = 'black'))+
  scale_fill_gradientn(colours = c('green1','yellow','orange','red')
                       ,breaks = c(10, 16, 18, 20, 22, 24, 26))+
  #scale_fill_manual(values = c("red", "grey", "seagreen3")) +
  guides(fill = guide_legend(reverse = T)
         ,color = FALSE) +
  labs(fill = 'Končna ocena'
       ,color = 'najvišja ocena '
       ,title = 'DRŽAVE Z NAJVIŠJO OCENO V FINALIH'
       ,x = NULL
       ,y = NULL) +
  theme(plot.title = element_text(size = 20, hjust = 0.5, colour = 'azure3' )
        ,axis.ticks = element_blank()
        ,axis.text = element_blank()
        ,panel.grid = element_blank() #mreža v ozadju
        ,panel.background = element_rect(fill = '#333333')
        ,plot.background = element_rect(fill = '#333333')
        ,legend.position = c(.05,.500)
        ,legend.background = element_blank()
        ,legend.key = element_rect(fill = 'azure3')
        ,legend.text = element_text(color = 'azure3')
        ,legend.title = element_text(color = 'azure3', size = 10)
  ) +
  annotate(geom = 'text'
           ,label = 'Source: FIG https://www.gymnastics.sport/site/events/searchresults.php#filter'
           ,x=-Inf
           ,y=-Inf
           ,hjust=0
           ,vjust=0
           #,x = 18, y = 100
           ,size = 3
           ,family = 'Gill Sans'
           ,color = '#CCCCCC'
           #,hjust = 'left'
  )+
geom_text(data = vrstice_tekmovalka, aes(x = long, y = lat, label = tekmovalka), 
           size = 3, col = "#CCCCCC", fontface = "bold")


print(zemljevid_najvisjih_ocen)






