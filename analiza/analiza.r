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

# Prepare Data
#wcg3 =  wcg[,c('tekmovalka','DB', 'DA')]
#wcg3 <- na.omit(wcg) # listwise deletion of missing
#wcg3 <- scale(wcg3) # standardize variables




#=============================================================================================
#CLUSTER
#==============================================================================================
#PODATKI
#______________________________________________________________________________________________
wcg$skupna_ocena_tezin = rowSums(wcg[,c(3,4)])
wcg$skupni_odbitek_izvedbe = rowSums(wcg[,c(5,6)])
wcg$skupni_odbitek_odstet = wcg[,11] + 10
wcg$skupna_ocena = rowSums(wcg[,c(7,10,12)])

wcg3 <- data.frame(wcg$tekmovalka, wcg$DB, wcg$DA, wcg$rekvizit)
colnames(wcg3) <- c("tekmovalka","DB", "DA", "rekvizit")
print(wcg3)
str(wcg3)



wcg3 <- na.omit(wcg3) %>% mutate_if(is.numeric, scale)

#podatki ne vsebujejo NA vrednosti DB in DA sta načeloma obe med 0 in neskončno
#rada bi dala v skupine tekmovalke, ki imajo v povprečju višjo oceno za težine s telesom in tiste, ki imajo višjo oceno z rekvizitim

#________________________________________________________________________________________________
#KNJIŽNICE
#_____________________________________________________________________________________________
install.packages("factoextra")
install.packages("cluster")
install.packages("magrittr")

library("cluster")
library("factoextra")
library("magrittr")

#_______________________________________________________________________________________________

#razlika <- get_dist(wcg3$DB, stand = TRUE, method = "pearson")
#https://www.datanovia.com/en/blog/types-of-clustering-methods-overview-and-quick-start-r-code/

#_____________________________________________________________________________________________
#k-MEANS
#____________________________________________________________________________________________
#določimo stevilo clustersov
#apply(data,MARGIN=1`: the manipulation is performed on rows, MARGIN=2`: the manipulation is performed on columns
#MARGIN=c(1,2)` the manipulation is performed on rows and columns, katera funkcija )
#var je neka varijanca

#še ne vem kaj pomeni i in 2:15...
#whithinss= v razredredu vsot kvadratov
#kmeans(data, koliko centrov zgostitve, )
#kmeans(wcg3,centers=i)$withinss je nek objekt na katerem naredimo vsoto

wss <- (nrow(wcg3)-1)*sum(apply(wcg3,2,var))  
for (i in 2:3) wss[i] <- sum(kmeans(wcg3,centers=i)$withinss)
plot(2:3, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")
