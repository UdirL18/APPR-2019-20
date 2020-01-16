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

#graf ki prikazuje koliko ima kakšna tekmovalka točk pri težinah z rekvizitom, 
#problem je da ne vemo kater rekvizit je to-barvamo
graf.AD <- ggplot(data = wcg) + 
  geom_point(mapping = aes(x = tekmovalka, y = DA, color = rekvizit)) + ggtitle("vrednosti težin z rekvizitom")

#uvozimo zemljevid sveta
zemljevid <- uvozi.zemljevid("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             
                             "ne_50m_admin_0_countries",mapa="./zemljevidi") %>% fortify()






# Uvozimo zemljevid.
#zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip", "OB",
                           #  pot.zemljevida="OB", encoding="Windows-1250")
#levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
 # { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
#zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels=levels(obcine$obcina))
#zemljevid <- fortify(zemljevid)

# Izračunamo povprečno velikost družine
#povprecja <- druzine %>% group_by(obcina) %>%
  #summarise(povprecje=sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
