################################################################################################################
#3. FAZA: VIZUALIZACIJA PODATKOV - GRAFI
################################################################################################################
require(ggplot2)
require(dplyr)
library(tidyverse) #mutate
library(reshape2)
library(scales) #izračun deleža
library(wesanderson) #barva grafa


#=============================================================================================================
#1. KAKO SE JE SKOZI OLIMPISKI CIKEL SPREMINJALA VREDNOST OCEN (SKUPNE IN D). 
#______________________________________________________________________________________________________________
#iz vsake tekme bom izbrala 10 najvišjih ocen (neglede na rekvizit), 
#primerjala D s končno oceno (za 5. najvišjo oceno-prikaz na grafu), 
#izračunala medijano in povprečno vrednost za vsako tekmo.
#----------------------------------------------------------------------------


#---------------------------------------------------------------------------
#PRIPRAVA PODATKOV
#----------------------------------------------------------------------------
induvidualne_viz <- induvidualne #da ne bi kaj pokvarili v prvotni tabeli


induvidualne_viz %>% 
  #----------------------------------------------------------------------------
  #izracunamo koliko % ocene predstavlja D
  #----------------------------------------------------------------------------
   add_column(delez =percent(induvidualne_viz$D/induvidualne_viz$koncna_ocena, accuracy = 0.01))%>%
  #----------------------------------------------------------------------------
  #izberemo 10 najboljših za vsako tekmo 
  #---------------------------------------------------------------------------
   group_by(tekma) %>%
   top_n(10, koncna_ocena) %>%
   arrange(desc(koncna_ocena)) %>% #desc uredi od najvišje do najnižje ocene
   select(-c(tekmovalka, drzava, E, Pen.)) %>% #te stolpci nas ne bodo zanimali
   mutate(ranking = 1:10)-> induvidualne_viz 
#View(induvidualne_viz)


#---------------------------------------------------------------------------
#PRIPRAVA PODATKOV ZA graf1
#---------------------------------------------------------------------------

# V dat SHRANIMO STOLPCE KI JIH BOMO POTREBOVALI PRI TEJ ANALIZI
#--------------------------------------------------------------------------
dat <- data.frame(
  D = induvidualne_viz$D,
  koncna_ocena = induvidualne_viz$koncna_ocena,
  ranking = as.factor(induvidualne_viz$ranking),
  tekma = as.factor(induvidualne_viz$tekma)
)


#POVPREČJE
#----------------------------------------------------------------------------
dat %>%
  group_by(tekma)%>% 
  summarise(D=mean(D), koncna_ocena =mean(koncna_ocena))%>%
  gather("Stat", "Value",-tekma) %>%
  add_column(ranking = "povprečje")-> dat_mean
#View(dat_mean)


#MEDIANA
#----------------------------------------------------------------------------
dat %>%
  group_by(tekma)%>% 
  summarise(D=median(D), koncna_ocena=median(koncna_ocena))%>%
  gather("Stat", "Value", -tekma) %>%
  add_column(ranking = "mediana")-> dat_mediana
#View(dat_mediana)


#V dat_D SHRANIMO SPREMENJENO dat NUMERIČNE STOLPCE DAMO V ENEGA, 
#DODAMO NOV STOLPEC stat Z VREDNOSTJO D IN koncna_ocena
#-----------------------------------------------------------------------------
dat_D <- dat %>%
  gather("Stat", "Value", -ranking, -tekma)
#View(dat_D)


#ZDRUŽIMO TABELE
#-----------------------------------------------------------------------------
dat_graf1 <- rbind(dat_D, dat_mean, dat_mediana)
View(dat_graf1)

value <- dat_graf1$Value
#------------------------------------------------------------------------------
#GRAF  !!!!!mal še polepšaj-kul bi blo če bi se pojavila vrednost ko dašz miško na en bar
#------------------------------------------------------------------------------
graf1 <- ggplot(dat_graf1, aes(x = ranking, y = Value, fill = Stat)) +
  geom_col(position = "dodge") +
  #------------------------------------------------------------
  #DEKORACIJA LEGENDE
  #------------------------------------------------------------
  scale_fill_manual(values=c("slateblue2","lightpink"),  #!!!!!!!!!!niso mi ok barve
                    labels = c("D", "KONČNA OCENA")
                    )+
  #legend("topright", legend = c("D", "KONCNA OCENA"), cex = 0.75)+
  #--------------------------------------------------------
  #SKALA NA Y OSI
  #--------------------------------------------------------
  #scale_y_continuous(breaks=dat_D$Value)+ #preveč natlačen
  #scale_y_continuous(breaks=c(10:26))+
  #---------------------------------------------------------
  #NASLOV, TEXT NA OSEH
  #---------------------------------------------------------
  ggtitle("DVIG OCEN SKOZI OLIMPIJSKI CIKEL 2017 - 2021")+
  #xlab("Najvišje ocenjene sestave") +
  ylab("ocena")+
  #theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  geom_text(aes(label = value, #navpična vrednost na grafu
                angle = 90, 
                vjust = 0.25, 
                hjust=1, 
                #color = "white",
                ))+
  #--------------------------------------------------------
  #TRIJE GRAFKI
  #--------------------------------------------------------
  facet_grid(.~tekma)+
  #--------------------------------------------------------
  #OZADJE-da se znebimo sivega ozadja
  #--------------------------------------------------------
  theme_bw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), #mislim da je bolje da sedaj ni vodoravnih črt
        strip.background = element_blank(),
        panel.border = element_blank(),
        #----------------------------------------------------------------------
        #NAPISI PRI X OSI, IZBRIS Y OSI 
        #----------------------------------------------------------------------
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        axis.title.x = element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(), #izbris črtic na oseh
        #----------------------------------------------------------------------
        #NASLOV GRAFA NA SREDINI
        #----------------------------------------------------------------------
        plot.title = element_text(hjust=0.5),
        #----------------------------------------------------------------------
        #DEKORACIJA LEGENDE
        #----------------------------------------------------------------------
        legend.justification = c("left", "top"),
        legend.position = "top",
        legend.key.size = unit(0.25, 'cm'),
        legend.title = element_blank(),
        legend.text = element_text(size = 6, colour = "black"))

print(graf1)





#------------------------------------------------------------------------------
#GRAF2-delž D v končni oceni za 5. najvišjo oceno
#------------------------------------------------------------------------------
#!!!!!! ne vem še kako bi to pogazala če sploh
#=================================================================================
#IDK WHAT THIS IS
#===============================================================================
induvidualne_5 <- induvidualne_viz#[c(5,15,25),]
induvidualne_5 %>%
  select(-c(rekvizit, D, koncna_ocena, ranking)) ->induvidualne_graf2#%>%
  #table() 
View(induvidualne_graf2)

#kr neki
ggplot(induvidualne_graf2[c(5,15,25),], aes(x=tekma, y=delez)) +
  geom_bar()

#kr neki na kvadrat
plot(induvidualne_graf2$tekma, induvidualne_graf2$delez, type = "b", pch = 19, 
     col = "red", xlab = "x", ylab = "y")


#okej sam se nič ne vidi
#----------------------------------------------------------------------------
bp<- ggplot(induvidualne_graf2, aes(x="", y="", fill=delez))+
  geom_bar(width = 1, stat = "identity")
bp

pie <- bp +
  coord_polar("y", start=0)+
  facet_grid(.~tekma)
pie

#----------------------------------------------------------------------------
#lbls <- induvidualne_graf2$delez
#pie(induvidualne_graf2, labels = lbls,
#    main="Delež ocene D")










#=============================================================================================================
#2. KAKO SE JE SKOZI OLIMPISKI CIKEL SPREMINJALA VREDNOST DA (APPARATUS DIFFICULTY) IN KOLIKO JE ZARADI TEGA MANJ
#POMEMBNA VREDNOST DB (BODY DIFFICULTY).
#______________________________________________________________________________________________________________
#primerjam DA in DE za tekmovalko Linoy Ashram za vsako vajo in
#(predikcija kakšen bo DA na olimpijskih.)





#==================================================================================================================
#3. GRAF VREDNOSTI TEŽIN Z REKVIZITOM (2018,2019)
#__________________________________________________________________________________________________________________
#graf ki prikazuje koliko ima kakšna tekmovalka točk pri težinah z rekvizitom, 
#problem je da ne vemo kater rekvizit je to-barvamo, tekmo-shape

graf3 <- ggplot(data = wcg, mapping = aes(x = DA, y = tekmovalka, color = rekvizit, shape  = tekma)) +
  geom_point()+
  ggtitle("vrednosti težin z rekvizitom")+ 
  labs(x="vrednosti AD", y="tekmovalke") + 
  facet_wrap( ~ rekvizit, ncol=8)

print(graf3)



#======================================================================================================
#4. PRI KATEREM REKVIZITU TEKMOVALKE DOBIJO NAJVEČJI ODBITEK ZA IZVEDBO?
#______________________________________________________________________________________________________
#------------------------------------------------------------------------------------------------------
#PRIPRAVA PODATKOV
#------------------------------------------------------------------------------------------------------
#iz tabele induvidualne_finali iberemo max, min (GLEDE NA E), mediano in povprečje
#neglede na tekmo, za vsak rekvizit posebaj
induvidualne_E <- induv_zemljevid_finali # da ne povarimo tabele

#najboljši E
#--------------------------
max_E <- induvidualne_E %>%
  group_by(rekvizit) %>%
  summarise(Value = max(E)) %>%
  add_column(nacin = "max")

#najslabši E
#--------------------------
min_E <- induvidualne_E %>%
  group_by(rekvizit) %>%
  summarise(Value = min(E))%>%
  add_column(nacin = "min")

#mediana E
#-------------------------
me_E <- induvidualne_E %>%
  group_by(rekvizit)%>% 
  summarise(Value = median(E))%>%
  add_column(nacin = "mediana")

#povprečje E
#-------------------------
av_E <- induvidualne_E %>%
  group_by(rekvizit)%>% 
  summarise(Value = mean(E))%>%
  add_column(nacin = "povprečje")

#združimo
#--------------------------
induv_graf4 <- rbind(max_E, min_E, me_E, av_E)
#View(induv_graf4) #!!!preveč decimalk

#------------------------------------------------------------------------------------------------------
#GRAF
#------------------------------------------------------------------------------------------------------
graf4 <- ggplot(induv_graf4, aes(x=nacin, y=Value)) +
  #------------------------------------------------------------------------
  #LOLIPOP
  #------------------------------------------------------------------------
  geom_segment( aes(x=nacin, xend=nacin, y=0, yend=Value), color="grey") +
  geom_point( size=7.5, color=alpha("orange", 0.3), fill=alpha("orange", 0.3), alpha=0.7, shape=21, stroke=2)+
  #-----------------------------------------------------------------------
  #IZPIS VREDNOSTI
  #--------------------------------------------------------------------------
  geom_text(aes(label = round(Value,2), #navpična vrednost na grafu
                angle = 90, 
                vjust = 0.25, 
                hjust=0.5, 
  ),size = 2.5)+
  #--------------------------------------------------------------------------
  #DEKORACIJA
  #--------------------------------------------------------------------------
  theme_light() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=0.5, size = 8),
    axis.ticks.y = element_blank(),
    axis.text.y = element_blank(),
  ) +
  xlab("") +
  ylab("vrednost izvedbenega odbitka E")+
  #---------------------------------------------------------------------------
  #GRAFKI ZA VSAK REKVIZIT
  #---------------------------------------------------------------------------
  facet_grid(.~rekvizit)


print(graf4)
#!!!!!!!!!!!ni mi ok napisi max, min, povprečje, mediana





#===================================================================================================
#5. SKUPINSKE VAJE

