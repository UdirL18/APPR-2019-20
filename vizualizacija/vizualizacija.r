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


# LEFT JOIN- že v wcg ni te države bo ohranil podatke iz map.world
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
