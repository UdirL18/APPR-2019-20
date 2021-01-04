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

map.world <- map_data("world", xlim=c(-100,100),ylim=c(20,100)) #potrebujem le ta del zemljevida saj v južnem delu ni nobene države s tekmovalko v finlih

#===========================================
# SPREMEMBA IMEN DRŽAV
# - imena v wcg data niso enaka kot v map.world
# - moramo jih preimenovati
#===========================================


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
zemljevid_najvisjih_ocen <- ggplot(map.world_joined_max, aes( x = long.x, y = lat.x, group = group.x )) +
  geom_polygon(aes(color = as.factor(fill_flg), fill = skupna_ocena.x)) +
  scale_color_manual(values = c('TRUE' = 'red', 'FALSE' = 'black')
   )+
  guides(fill = guide_legend(reverse = T)) +
  labs(fill = 'skupna ocena'
       ,color = 'najvišja ocena '
       ,title = 'DRŽAVE Z NAJVIŠJO OCENO V FINALIH'
       ,x = NULL
       ,y = NULL) +
  theme(plot.title = element_text(size = 20, hjust = 0.5, colour = 'azure3' )
        ,axis.ticks = element_blank()
        ,axis.text = element_blank()
        ,panel.grid = element_blank()
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
  ) 
print(zemljevid_najvisjih_ocen)

#==================================================================================================================
#GRAFI
#==========================================================================================================================
#graf ki prikazuje koliko ima kakšna tekmovalka točk pri težinah z rekvizitom, 
#problem je da ne vemo kater rekvizit je to-barvamo, tekmo-shape

graf_AD <- ggplot(data = wcg, mapping = aes(x = DA, y = tekmovalka, color = rekvizit, shape  = tekma)) + geom_point()+
  ggtitle("vrednosti težin z rekvizitom")+ labs(x="vrednosti AD", y="tekmovalke") + facet_wrap( ~ rekvizit, ncol=8)
print(graf_AD)
#graf, ki prikazuje pri katerem rekvizitu tekmovalke dobijo največji odbitek za izvedbo
wcg$skupna_ocena_tezin = rowSums(wcg[,c(3,4)])
wcg$skupni_odbitek_izvedbe = rowSums(wcg[,c(5,6)])
wcg$skupni_odbitek_odstet = wcg[,11] + 10
wcg$skupna_ocena = rowSums(wcg[,c(7,10,12)])

E <- barplot(data=wcg, mapping=aes(X=rekvizit, Y=skupni_odbitek_odstet, color= tekmovalka), main = 'Izvedba',xlab = 'rekvizit', horiz = FALSE)
print(E)
histogram_AD <- hist(wcg$DA)
plot(wcg$DA, xlab = 'AD vrednosti', ylab = 'vrednosti', main = 'AD', col = 'green')

#===================================================================================================
#ZEMLJEVIDU ŽELIM DODATI IMENA DRŽAV OBARVANIH Z MODRO #https://rpubs.com/EmilOWK/209498
#===================================================================================================
#install.packages("choroplethrAdmin1")
#install.packages("choroplethr")
#install.packages("psych")

#library(choroplethrAdmin1)
#library(choroplethr)
#library(ggplot2)
#library(grid)
#library(stringr)
#library(magrittr)
#library(psych)

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
