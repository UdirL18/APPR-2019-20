#za poidvedbokatere funkcije imam v knjižnici uporabimo npr ?knitr
library(knitr)
library(shiny)

#-------------------------------------------------------------
library(readr)#read_csv - podatki so ločeni z ,

#-------------------------------------------------------------
library(dplyr)
#omogoča enostavnejše in preglednejše operacije na razpredelnicah.
#rename, select, mutate, recode, group_by, top_n, 
#desc (uredi od najvišje do najnižje ocene), summarise, filter

#-----------------------------------------------------------------
library(ggplot2)
#ggplot, geom_col, scale_fill_manual, facet_grind,facet_wrap
#geom_smooth, geom_segment - ravne črte med toččkami, map_data

#----------------------------------------------------------------
library(tidyr) 
#gather(), replace_na, gathe (ekvivalneten) pivot_longer

#----------------------------------------------------------------
library(naniar)
#replace_with_na_at

#---------------------------------------------------------------
library(rvest) 
#za spletne strani, omogoča premikanje po značkah. read_html, 
#html_nodes

#---------------------------------------------------------------
library(NbClust) 
#Za določanje skupin
#NbClust

#---------------------------------------------------------------
library(ggdendro)
#za dendrograme: 
#ggdendrogram, dendro_data (izvoz podatkov v obliko dalahko delamo z ggplot),
#segment - za povezave v dendrogramu,theme_dendro  

#---------------------------------------------------------------
library(ggrepel) 
#za overlapping

#---------------------------------------------------------------
library(scales) 
#izračun deleža: percent

#---------------------------------------------------------------
library(wesanderson) 
#barva grafa

#-------------------------------------------------------------
library(reshape2) #(za melt pri grafu 5)nisem uporabila
library(rgdal)
library(rgeos)
library(mosaic)
library(maptools)
library(munsell)
library(StatMeasures)
library(magrittr)
library(ggmap)
library(stringr)
library(tmap)
library(XML)
library(tidyverse)
library(grid)
library(rworldmap)
library(gsubfn)


# Uvozimo funkcije za pobiranje in uvoz zemljevida.
#source("lib/uvozi.zemljevid.r", encoding="UTF-8")
