# 3. faza: Vizualizacija podatkov

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

#==========================================================================================================================
#graf ki prikazuje koliko ima kakšna tekmovalka točk pri težinah z rekvizitom, 
#problem je da ne vemo kater rekvizit je to-barvamo
#graf.AD <- ggplot(data = wcg) + 
 # geom_point(mapping = aes(x = tekmovalka, y = DA, color = rekvizit)) + ggtitle("vrednosti težin z rekvizitom")
#View(graf.AD)
#======================================================================================================
library(tidyverse)
library(rvest)
library(magrittr)
library(ggmap)
library(stringr)
library(dplyr)

#==============
#ZEMLEVID SVETA
#==============

map.world <- map_data("world")

#===========================================
# SPREMEMBA IMEN DRŽAV
# - imena v wcg data niso enaka kot v map.world
# - moramo jih preimenovati
#===========================================

# KATRE DRŽAVE IMAMO V WCG
as.factor(wcg$drzava) %>% levels()

# PREIMENOVANJE DRŽAV
wcg$drzava <- recode(wcg$drzava 
                     ,'BUL' = 'Bulgaria'
                     ,'GEO' = 'Georgia'
                     ,'ISR' = 'Israel'
                     ,'ITA' = 'Italy'
                     ,'JPN' = 'Japan'
                     ,'RUS' = 'Russia'
                     ,'UKR' = 'Ukraine'
                     ,'USA' = 'USA'
                     ,'BLR' = 'Belarus'
                     
)

# PREVERIM ALI SEM USPEŠNO ZAMENJALA IMENA =)
print(wcg)

#================================
# ZDRUŽITEV
# - združio wcg data 
#   in world map
#================================
#head(map.world)


# LEFT JOIN- če v wcg ni te države bo ohranil podatke iz map.world
map.world_joined <- left_join(map.world, wcg, by = c('region' = 'drzava'))

#===================================================
# INDIKATOR
# - v zemljevidu, bomo poudarili
#   države, ki so imeli tekmovalke v finalih 
# svetovnih prvenstev.
# - ustvarili bom indikator, ki bo povedal 
#ali želim obarvati določeno državo 
#če je v tabeli map.world_joined v stolpcu tekma NA 
#potem države ne bomo obarvali
#===================================================

map.world_joined <- map.world_joined %>% mutate(fill_flg = ifelse(is.na(tekma),F,T))
head(map.world_joined)


#==========
# ZEMLJEVID
#==========

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

#=================================================================================================
#dobila sem zemljevid, ki prikazuje katere države so bile zastopane v finalih svetovnega prvestva.
#=================================================================================================

#=================================================================================================
#zemljevid ki obarva države glede na končno oceno
#===================================================================================
#države bi radi obarvali glede na končne ocene
map.world_joined$skupna_ocena_tezin = rowSums(map.world_joined[,c(8,9)])
map.world_joined$skupni_odbitek_izvedbe = rowSums(map.world_joined[,c(10,11)])
map.world_joined$skupni_odbitek_odstet = map.world_joined[,17] + 10
map.world_joined$skupna_ocena = rowSums(map.world_joined[,c(12,16,18)])


ggplot(map.world_joined, aes( x = long, y = lat, group = group )) +
  geom_polygon(aes(fill = skupna_ocena))

#===================================================================================
#zemljevid najvišje ocene
#===================================================================================
#da bomo bolje videli katera država ima najvišjo oceno za posamezen rekvizit bom tiste države obkrožila, 
#to bo verjetno vse Rusija
#rada bi dodala stolpec true fase, če je max ocena za rekvizit true drugače false
max(map.world_joined$skupna_ocena, na.rm = TRUE) 
vrstice_hoop <- map.world_joined[grep("hoop",map.world_joined$rekvizit),]
vrstice_ball <- map.world_joined[grep("ball",map.world_joined$rekvizit),]
vrstice_clubs <- map.world_joined[grep("clubs",map.world_joined$rekvizit),]
vrstice_ribbon <- map.world_joined[grep("ribbon",map.world_joined$rekvizit),]
max(vrstice_hoop$skupna_ocena, na.rm = TRUE)

which.max(vrstice_hoop$skupna_ocena)
which.max(vrstice_ball$skupna_ocena)
which.max(vrstice_clubs$skupna_ocena)
which.max(vrstice_ribbon$skupna_ocena)

max_ocena <- rbind(vrstice_hoop[2802, ],vrstice_ball[2977, ],vrstice_clubs[2898, ],vrstice_ribbon[4253, ])
max_ocena$najvisja_ocena <- "TRUE"

#združimo data
map.world_joined_max <- left_join(map.world_joined, max_ocena, by = c('region' = 'region'))

map.world_joined_max <- map.world_joined_max %>% mutate(fill_flg = ifelse(is.na(najvisja_ocena),F,T))


ggplot(map.world_joined_max, aes( x = long.x, y = lat.x, group = group.x )) +
  geom_polygon(aes(color = as.factor(fill_flg))) +
  scale_color_manual(values = c('TRUE' = 'red', 'FALSE' = NA))

#============================================================================================
#oba zemljevida skupaj
#===========================================================================================
ggplot(map.world_joined_max, aes( x = long.x, y = lat.x, group = group.x )) +
  geom_polygon(aes(color = as.factor(fill_flg), fill = skupna_ocena.x)) +
  scale_color_manual(values = c('TRUE' = 'red', 'FALSE' = NA))

#=====================
# KONČNI ZEMLJEVID
#=====================

ggplot(map.oil, aes( x = long, y = lat, group = group )) +
  geom_polygon(aes(fill = oil_bbl_per_day, color = as.factor(opec_ind))) +
  scale_fill_gradientn(colours = c('#461863','#404E88','#2A8A8C','#7FD157','#F9E53F')
                       ,values = scales::rescale(c(100,96581,822675,3190373,10000000))
                       ,labels = comma
                       ,breaks = c(100,96581,822675,3190373,10000000)
  ) +
  guides(fill = guide_legend(reverse = T)) +
  labs(fill = 'Barrels per day\n2016'
       ,color = 'OPEC Countries'
       ,title = 'OPEC countries produce roughly 44% of world oil'
       ,x = NULL
       ,y = NULL) +
  theme(text = element_text(family = 'Gill Sans', color = '#EEEEEE')
        ,plot.title = element_text(size = 28)
        ,plot.subtitle = element_text(size = 14)
        ,axis.ticks = element_blank()
        ,axis.text = element_blank()
        ,panel.grid = element_blank()
        ,panel.background = element_rect(fill = '#333333')
        ,plot.background = element_rect(fill = '#333333')
        ,legend.position = c(.18,.36)
        ,legend.background = element_blank()
        ,legend.key = element_blank()
  ) +
  annotate(geom = 'text'
           ,label = 'Source: U.S. Energy Information Administration\nhttps://en.wikipedia.org/wiki/List_of_countries_by_oil_production\nhttps://en.wikipedia.org/wiki/OPEC'
           ,x = 18, y = -55
           ,size = 3
           ,family = 'Gill Sans'
           ,color = '#CCCCCC'
           ,hjust = 'left'
  ) +
  scale_color_manual(values = c('1' = 'orange', '0' = NA), labels = c('1' = 'OPEC'), breaks = c('1'))
