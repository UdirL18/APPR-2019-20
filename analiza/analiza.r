# 4. faza: Analiza podatkov

#predikcijski model za napovedovanje kdo bo zmagal na olimpijskih igrah 2020
#predikcijski model za napovedovanje verjetne izbire tekmovalk, ki bodo zastopale Rusijo
#s pomočjo razvrščanja določimo skupine tekmovalk ki so bolj spretne z rekvizitom in tiste ki imajo boljšo tehniko s telesom

#=============================================================================================
#KATERA DRŽAVA BO ZMAGALA NA OLIMPIJSKIH IGRAH
#=============================================================================================
#PODATKI
#wcg$skupna_ocena_tezin = rowSums(wcg[,c(3,4)])
#wcg$skupni_odbitek_izvedbe = rowSums(wcg[,c(5,6)])
#wcg$skupni_odbitek_odstet = wcg[,11] + 10
#wcg$skupna_ocena = rowSums(wcg[,c(7,10,12)])

#================================================================================================
#
#install.packages("caret")
#library(tidyverse)
#library(caret)
#theme_set(theme_bw())

#pogledam kakšen je moj data
#sample_n(wcg,3)
#nova tabela ki ima le tri stolpce: drzava, tekmovalka, skupna ocena
#wcg2 = wcg[,c('tekmovalka','drzava','skupna_ocena')]

#model <- lm(skupna_ocena ~., data = wcg2)
#model




