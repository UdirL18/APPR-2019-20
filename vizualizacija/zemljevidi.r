###########################################################################################
#3. FAZA: VIZUALIZACIJA PODATKOV - ZEMLJEVIDI
############################################################################################

#===========================================================================================
#KNJIŽNICE
#===========================================================================================
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#Preveri katere knjižnice si zares potrebovala
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

library(rgdal)
library(rgeos)
library(mosaic)
library(maptools)
library(munsell)
library(StatMeasures)
library(reshape2)
library(ggplot2)
library(tidyverse)

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
#source('lib/uvozi.zemljevid.r')
#source('lib/libraries.r', encoding = 'UTF-8')

library(tidyverse)
library(rvest)
library(magrittr)
library(ggmap)
library(stringr)
library(dplyr)


#============================================================================================
#ZEMLEVID SVETA
#============================================================================================

map.world <- map_data("world", xlim=c(-100,100),ylim=c(20,100)) 
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
induv_zemljevid$drzava <- recode(induv_zemljevid$drzava 
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

# LEFT JOIN- če v induv_zemljevid ni te države bo ohranil podatke iz map.world
map.world_joined <- left_join(map.world, induv_zemljevid, by = c('region' = 'drzava'))

#View(map.world_joined)


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
# 2.imena držav obarvanih z rdečo (!!!)



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


#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!tukaj ne vem glih točno kaj grep dela
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#-----------------------------------------------------------------------------------------------------
vrstice_hoop <- map.world_joined[grep("hoop",map.world_joined$rekvizit),]
vrstice_ball <- map.world_joined[grep("ball",map.world_joined$rekvizit),]
vrstice_clubs <- map.world_joined[grep("clubs",map.world_joined$rekvizit),]
vrstice_ribbon <- map.world_joined[grep("ribbon",map.world_joined$rekvizit),]
#max(map.world_joined$koncna_ocena, na.rm = TRUE) #katera je max ocena 26.55
#max(vrstice_hoop$koncna_ocena, na.rm = TRUE) #max ocena pri obroču 26.5


#preverimo katera vrstica ima maximalno oceno za posamezni rekvizit
#------------------------------------------------------------------------------------------------------
#which.max(vrstice_hoop$koncna_ocena) #2444
#which.max(vrstice_ball$koncna_ocena) #717
#which.max(vrstice_clubs$koncna_ocena) #802
#which.max(vrstice_ribbon$koncna_ocena) #538


#tabela 4 vrstic
#-------------------------------------------------------------------------------------------------------
max_ocena <- rbind(vrstice_hoop[2444, ],vrstice_ball[717, ],vrstice_clubs[802, ],vrstice_ribbon[538, ]) 
max_ocena$najvisja_ocena <- "TRUE" #dodamo stolpec najvišja_ocena in ga nastavimo na TRUE(v vseh 4 vrsticah)



#združimo data
#--------------------------------------------------------------------------------------------------------
map.world_joined_max <- left_join(map.world_joined, max_ocena, by = c('region' = 'region'))

map.world_joined_max <- map.world_joined_max %>% mutate(fill_flg = ifelse(is.na(najvisja_ocena),F,T))



#zemljevid
#--------------------------------------------------------------------------------------------------------
ggplot(map.world_joined_max, aes( x = long.x, y = lat.x, group = group.x )) +
  geom_polygon(aes(color = as.factor(fill_flg))) +
  scale_color_manual(values = c('TRUE' = 'red', 'FALSE' = NA))

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!meje se nekaj črtkano zrišejo
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



#============================================================================================
#1.3 ZEMLJEVID NAJVIŠJIH OCEN (končen)
#===========================================================================================
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!neobkroži mi pravilno belorusije in izraela 
#!nočem met te legende FALSE TRUE
#!javi mi neke napake font family
#!ne znam dodati imen držav
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#------------------------------------------------------------------------------------------
#IMENA DRŽAV
#------------------------------------------------------------------------------------------
#imena <-map.world_joined_max[match(unique(map.world_joined_max$region), map.world_joined_max$region),]
#View(imena)

#------------------------------------------------------------------------------------------
#zemljevid_najvisjih_ocen
#------------------------------------------------------------------------------------------
zemljevid_najvisjih_ocen <- ggplot(map.world_joined_max, aes( x = long.x, y = lat.x, group = group.x )) +
  geom_polygon(aes(color = as.factor(fill_flg), fill = koncna_ocena.x)) +
  scale_color_manual(values = c('TRUE' = 'red', 'FALSE' = 'black'))+
  guides(fill = guide_legend(reverse = T)) +
  labs(fill = 'končna ocena'
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
           ,x = 18, y = 100
           ,size = 3
           ,family = 'Gill Sans'
           ,color = '#CCCCCC'
           ,hjust = 'left'
  )#+
  #geom_text(aes(long.x, lat.x, label =imena , group = NULL), size = 0.5)


print(zemljevid_najvisjih_ocen)




#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#===================================================================================================
#ZEMLJEVIDU ŽELIM DODATI IMENA DRŽAV OBARVANIH Z MODRO #https://rpubs.com/EmilOWK/209498
#===================================================================================================
#install.packages("choroplethrAdmin1")
#install.packages("choroplethr")
#install.packages("psych")
#install.packages("grid")
#install.packages("stringr")
#install.packages("magrittr")
#install.packages("psych")
#install.packages("kirkegaard")

#library(choroplethrAdmin1)
#library(choroplethr)
#library(ggplot2)
#library(grid)
#library(stringr)
#library(magrittr)
#library(psych)
#library(kirkegaard)

#katere države imamo
#as.factor(map.world_joined_max$region) %>% levels()

#preiimenovanje držav
#map.world_joined_max$region <- recode(map.world_joined_max$region
 #                    ,'Bulgaria' = 'BUL'
  #                   ,'Georgia' = 'GEO'
   #                  ,'Israel' = 'ISR'
    #                 ,'Italy' = 'ITA'
     #                ,'Japan' = 'JPN'
      #               ,'Russia' = 'RUS'
       #              ,'Ukraine' = 'UKR'
      #               ,'Belarus' ='BLR')
#map.world_joined_max$region

#admin1_choropleth(country.name = "bulgaria", 
 #                 df           = map.world_joined_max$region, 
  #                legend       = "Random uniform data", 
   #               num_colors   = 1) +
  #geom_text(data = d_geo, aes(long, lat, label = clean_names, group = NULL), size = 2.5)
