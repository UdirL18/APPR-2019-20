####################################################################################################
# 4. faza: Napredna analiza podatkov
####################################################################################################
#NAVODILA:
#-sestavite predikcijski model za napovedovanje:
#   za prihodnost, kako je neka vrednost odvisna od drugih, morda uporabite kako metodo iz strojnega učenja, ...
#-na podlagi modela naključno modelirate nove podatke (npr. napovedovanje gibanja delnic),
#-s pomočjo razvrščanja določite skupine s podobnimi lastnostmi,
#-s pomočjo gručenja izločite osamelce (in morda tako izboljšate model), ali pa za različne 
# skupine podatkov naredite različne modele.

#-Kot rezultat te faze lahko sestavite tudi aplikacijo v ogrodju Shiny (za boljšo oceno).
#-Vaš program bo narisal enega ali več grafov (lahko tudi zemljevidov), 
#ki jih boste nato vključili v poročilo skupaj z opisom vaše analize in njenimi zaključki.

#---------------------------------------------------------------------------------------------------
#PLAN/KAJ ME ZANIMA:
#-predikcijski model za napovedovanje kdo bo zmagal na olimpijskih igrah 2021 skupinske
#-(predikcijski model za napovedovanje verjetne izbire tekmovalk, ki bodo zastopale Rusijo)
#-novi podatki: kakšne bodo ocene na OI za dino, arino in linoy
#-grupiranje E/D (induvidualne) in skupinske
#-s pomočjo razvrščanja določimo skupine tekmovalk ki so bolj spretne z rekvizitom in tiste ki imajo boljšo tehniko s telesom
#-Grupiranje po rekvizitih - kateter jim je boljši induv (in skupinsko)
#-s pomočjo gručenja izločite osamelce - soldatova, kaylen, (lala) zaradi BD (in morda tako izboljšate model), ali pa za različne 
# skupine podatkov naredite različne modele.
#-----------------------------------------------------------------------------------------------------


require(ggplot2)
require(dplyr)
library(NbClust) #Za določanje skupin
require(ggdendro) #za dendrograme
require(ggrepel) #za overlapping


#============================================================================================
#1. KATERA DRŽAVA BO ZMAGALA NA OLIMPIJSKIH IGRAH V SKUPINSKIH SESTAVAH
#============================================================================================
#View(skupinske)


#----------------------------------------------------------------
#graf-za lažje predstavljanje podatkov
#----------------------------------------------------------------
ggplot(skupinske, aes(x = D, y = E, col = tekma)) + 
  geom_point()

#---------------------------------------------------------------
# MODEL
#--------------------------------------------------------------
model_skupinske <- lm(E ~ D, data=skupinske)


#------------------------------------------------------------------
# IZRIS LINEARNEGA MODELA
#------------------------------------------------------------------
ggplot(skupinske, aes(x = D, y = E)) + 
  geom_point() + 
  facet_grid(.~rekvizit)+
  geom_smooth(method=lm, formula=y~x) 


#-----------------------------------------------------------------
# PREDIKCIJA. Kakšna bo E ko bodo D dvignile na 32, 35
#-----------------------------------------------------------------
novDskupinske <- data.frame(D=c(32, 35))
predict(model_skupinske, novDskupinske) #7.518193 7.536600 
napovedEskupinske <- novDskupinske %>% mutate(E=predict(model_skupinske, .)) 

napovedE_tabela_skupinske <- napovedEskupinske %>% 
  mutate(drzava = "napoved", tekma = 2021, rekvizit = c("3 obroči + 4 kiji", "5 žog"), Pen.= 0.00, koncna_ocena = c(7.518193+32, 7.536600+35) )  

#napovedEskupinske %>% View
#napovedE_tabela_skupinske %>% view

skupinske_predikcija_napoved <- rbind(napovedE_tabela_skupinske, skupinske)
skupinske_predikcija_napoved %>% view


########################################################################
#----------------
# izris napovedi
#----------------
predikcija_skupinske <- ggplot(skupinske_predikcija_napoved, aes(x = D, y = E)) + 
  geom_point(shape=1) + 
  geom_smooth(method=lm, formula=y~x) +
  geom_point(data=napovedEskupinske, aes(x=D, y=E), color='red', size=3)+
  labs( title = "PREDIKCIJA OCENE E NA OLIMPIJSKIH IGRAH 2021 ZA SKUPINSKE SESTAVE" )+
  facet_grid(.~rekvizit)+
  theme_bw()+ #brez sivega ozadja
  theme(legend.position = "none" #brez legende
        ,plot.title = element_text(hjust=0.5)#naslovna na sredini
        
  )

print(predikcija_skupinske)









#==============================================================================
#2. GRUPIRANJE GLEDE NA E IN GLEDE NA D ZA SKUPINSKE SESTAVE
#==============================================================================

risba_skupinske <- skupinske %>% 
  ggplot(aes(x=D, y=E, col=drzava, shape=rekvizit))+
  geom_point()+
  theme_minimal()+
  facet_grid(.~tekma)+
  #---------------------------------------------------------
  #oštevilčimo pikice
  #---------------------------------------------------------
  geom_text(
    data=skupinske %>% mutate(n = row_number()),
    aes(label=drzava),
    size=2,
    color='black',
    nudge_x = 0.03,
    nudge_y = 0.03
  )+
  theme_minimal()
print(risba_skupinske)

#KOMENTAR:izgleda kot da bi lahko pogrupirali skupaj v Bakuju: 
#Rus, Bul, Jap, Blr


#---------------------------------------------------------------
#STANDARDIZACIJA MATRIKE
#---------------------------------------------------------------
data_skupinske <- skupinske %>%
  select(E,D) %>%
  as.matrix() %>%
  scale() #naredi standardizacijo

#View(data_skupinske)


#----------------------------------------------------------------
#HIERARHIČNO RAZVRŠČANJE 
#----------------------------------------------------------------
razdalje_skupinske <- dist(as.matrix(data_skupinske)) #na i,j tem mestu je razdalja med i-to in j-to vrstico
model_skupinske <- hclust(razdalje_skupinske) #model


#malo pregledamo
#----------------------------------------------------------------
## Dobimo opis postopka razvrščanja
#names(model_skupinske) 

# Algoritem za razvrščanje: ward.D, ward.D2, single, 
# complete, average, mcquitty, median, centroid
# Lahko podamo kot parameter
#model_skupinske$method

# Tip metrike: pridobljen iz matrike različnosti
# Npr. za D <- dist(X, method="manhattan") bi dobili "manhattan"
#model_skupinske$dist.method

# Opis zaporedja združevanja skupin
#model_skupinske$merge %>% View

# Višine, ko je prišlo do združevanja
#model_skupinske$height

# Preureditev elementov, da bomo lahko lepo izrisali dendrogram
#model_skupinske$order

# Poimenovanja podatkovnih enot. 
#model_skupinske$labels

# Opisni klic funkcije, ki je sprožila izračun
#model_skupinske$call

#---------------------------------------------------------
#DENDROGRAM - le vmesen graf
#----------------------------------------------------------
#1. način izrisa dendrograma
#plot(model_skupinske, hang=-1,  cex=0.3, main="skupinske") 

#2. način: S pomočjo paketa `ggdendro`
require(ggdendro)

dendrogram_skupinske <- ggdendrogram(model_skupinske, labels=TRUE) + 
  theme(axis.text.y = element_blank())
  
print(dendrogram_skupinske)


#----------------------------------------------------------------------
# Pridobitev podatkov za izris z ggplot
#----------------------------------------------------------------------
ddata_skupinske <- dendro_data(model_skupinske, type = "rectangle") #izvozi podatke v objekt na katerem lahko uporabljamo ggplot
#View(ddata_skupinske)
#names(ddata_skupinske) #"segments"    "labels"      "leaf_labels" "class"

#segment(ddata_skupinske) %>% View #povezave v dendrografu

#-----------------------------------------------------------
#dendrogram brez napisov držav - nepotrebno
#-----------------------------------------------------------
ggplot(segment(ddata_skupinske)) + 
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend)) + 
  #coord_flip() + 
  #scale_y_reverse(expand = c(0.2, 0)) + 
  theme_dendro()


#################################################
#------------------------------------------------
#dodamo še napise
#-------------------------------------------------
#v tabelo labels dodamo še dva stolpca label in drzava
ddata_skupinske$labels$label <- paste(skupinske$drzava[model_skupinske$order], ddata_skupinske$labels$label %>% as.character)
ddata_skupinske$labels$drzava <- skupinske$drzava[model_skupinske$order]

dendrogg_skupinske <- ggplot(segment(ddata_skupinske)) + 
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend), size=0.01) +  #size debelina črt
  labs( title = "DENDROGRAM DRŽAV GLEDE NA OCENO E IN D")+
  theme(plot.title = element_text(hjust=0.5))+
  coord_flip()  + 
  scale_y_reverse(expand = c(0.5, 0)) + 
  geom_text(
    data=ddata_skupinske$labels, 
    aes(x=x, y=y, label=label, colour=drzava), hjust=0, size=2, nudge_y = 0.03, show.legend = FALSE) + #size pisava držav
  theme(axis.line.y=element_blank(),
        axis.ticks.y=element_blank(),
        axis.text.y=element_blank(),
        axis.title.y=element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.x=element_blank(),
        panel.background=element_rect(fill="white"),
        panel.grid=element_blank())
print(dendrogg_skupinske)
#dendrogg + ggsave("dendrogg.pdf", device="pdf")
#iz grafa se zdi da je najbolje razvrstiti v 3 skupine Elbow method


#-------------------------------------------------------
# šTEVILO SKUPIN- RAZVRSTITEV GLEDE NA REZ DENDROGRAMA
#-------------------------------------------------------
# 3 skupine
#-------------------------------
# določanje skupin
#--------------------------------
p3 <- cutree(model_skupinske, k=3)
#p3   #1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 3 3 3 3 3 2 3 3 3 3 2 2
    #po vrstnem redu iz tabele skupinske nam pove v katero skupino gre posamezna država

##################################################################
#----------------------------------
#pikice pobarvane v barvah skupine
#-----------------------------------
grupiranje_skupinske3 <- skupinske %>% 
  ggplot(aes(x=D, y=E, col=p3, shape = tekma)) +
  guides(color = FALSE)+ #legende za barvo ne potrebujem
  geom_point() +
  geom_text_repel( # da se ne prekrivajo imena
    aes(label=drzava),
    size=2,
    color='black',
    nudge_x = 0.05,
    nudge_y = 0.05
  )+
  labs( title = "GRUPIRANJE DRŽAV GLEDE NA OCENO E IN D")+
  scale_y_continuous(breaks=c(6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5))+
  theme_minimal()+
  theme(plot.title = element_text(hjust=0.5))
  
print(grupiranje_skupinske3)  
  #+ ggsave("risba2.pdf", device="pdf")

#KOMENTAR: 
#1. SKUPINA: D med 18.2 in 21.1, E med 7.35 in 8.75
#Bul baku oba rek, Jap baku oba rek, Ita baku kiji+obroč, Blr baku kiji+obroč, Rus baku oba rek,
# china baku oba rek, Azerb baku kiji+obroči samo eni finali, Isr oba rek
#2. SKUPINA: D med 18.5 in 21.6 E 5.7 in 6.8
#ita baku kiksane žoge, Bel baku kiksane žoge, UKr baku kiksane žoge samo to v finalih, Est kijev, Fra kijev, Tur kijev
#3. SKUPINA: D med 23.00 in 27.1 in E 6.25 in 8.25
#Ukr kijev oba, Israel kijev obe, Est kijev žoge , Azer kijev oba, Fra kiji+obroč, tur kiji+obroč



#============================================================================================================
#3. GRUPIRANJE GLEDE NA BD/AD INDUVIDUALNE SESTAVE
#============================================================================================================
#s pomočjo razvrščanja določimo skupine tekmovalk, ki so bolj spretne z rekvizitom 
#in tiste ki imajo boljšo tehniko s telesom.

risba_ind <- wcg %>% 
  ggplot(aes(x=DA, y=DB, col=tekmovalka, shape=rekvizit))+
  geom_point()+
  theme_minimal()+
  facet_grid(.~tekma)+
  #---------------------------------------------------------
#oštevilčimo pikice
#---------------------------------------------------------
#geom_text(
#  data=wcg %>% mutate(n = row_number()),
#  aes(label=tekmovalka),
#  size=2,
#  color='black',
#  nudge_x = 0.03,
#  nudge_y = 0.03
#)+
  theme_minimal()
print(risba_ind)

#opazimo da Vlada izstopa z višjim DB in da pri DA ni takega izstopanja

#---------------------------------------------------------------
#STANDARDIZACIJA MATRIKE
#---------------------------------------------------------------
data_ind <- wcg %>%
  select(DB,DA) %>%
  as.matrix() %>%
  scale() #naredi standardizacijo

#View(data_ind)


#----------------------------------------------------------------
#RAZVRŠČANJE 
#----------------------------------------------------------------
razdalje_ind <- dist(as.matrix(data_ind)) #na i,j tem mestu je razdalja med i-to in j-to vrstico
model_ind <- hclust(razdalje_ind) #model


#----------------------------------------------------------------------
# Pridobitev podatkov za izris z ggplot
#----------------------------------------------------------------------
ddata_ind <- dendro_data(model_ind, type = "rectangle") 


#------------------------------------------------
#dodamo še napise
#-------------------------------------------------
#v tabelo labels dodamo še dva stolpca label in drzava
ddata_ind$labels$label <- paste(wcg$tekmovalka[model_ind$order], ddata_ind$labels$label %>% as.character)
ddata_ind$labels$tekmovalka <- wcg$tekmovalka[model_ind$order]

###########################################################
dendrogg_ind <- ggplot(segment(ddata_ind)) + 
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend), size=0.01) +  #size debelina črt
  coord_flip()  + 
  scale_y_reverse(expand = c(0.5, 0)) + 
  labs(title = "DENDROGRAF GRUPIRANJA INDUVIDUALNIH 
  TEKMOVALK GLEDE NA BD IN AD")+
  geom_text(data=ddata_ind$labels, 
    aes(x=x, y=y, label=label, colour=tekmovalka), hjust=0, size=1.5, nudge_y = 0.03, show.legend = FALSE) + #size pisava tekmovalk
  theme(axis.line.y=element_blank(),
        axis.ticks.y=element_blank(),
        axis.text.y=element_blank(),
        axis.title.y=element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.x=element_blank(),
        #legend.key = element_blank(),
        panel.background=element_rect(fill="white"),
        panel.grid=element_blank(),
        plot.title = element_text(hjust=0.5))
print(dendrogg_ind)



#--------------------------------------------
#DOLOČANJE ŠTEVILA SKUPIN
#--------------------------------------------
library(NbClust)
#-----------------------------------------------------------------
# euclidean
#-----------------------------------------------------------------
NbClust(data = data_ind, distance = "euclidean",
        min.nc = 2, max.nc = 15, method = "complete") #priporoča 2
#-----------------------------------------------------------------
NbClust(data = data_ind, distance = "euclidean",
        min.nc = 2, max.nc = 15, method = "ward.D") #priporoča 5
#-----------------------------------------------------------------
NbClust(data = data_ind, distance = "euclidean",
        min.nc = 2, max.nc = 15, method = "ward.D2") #priporoča 3
#-----------------------------------------------------------------
NbClust(data = data_ind, distance = "euclidean",
        min.nc = 2, max.nc = 15, method = "single") #priporoča 2
#-----------------------------------------------------------------
NbClust(data = data_ind, distance = "euclidean",
        min.nc = 2, max.nc = 15, method = "average") #priporoča 2
#-----------------------------------------------------------------
NbClust(data = data_ind, distance = "euclidean",
        min.nc = 2, max.nc = 15, method = "kmeans") #priporoča 5
#-----------------------------------------------------------------
#manhattan
#----------------------------------------------------------------
NbClust(data = data_ind, distance = "manhattan",
        min.nc = 2, max.nc = 15, method = "complete") #priporoča 2
#-----------------------------------------------------------------
NbClust(data = data_ind, distance = "manhattan",
        min.nc = 2, max.nc = 15, method = "ward.D") #priporoča 5
#-----------------------------------------------------------------
NbClust(data = data_ind, distance = "manhattan",
        min.nc = 2, max.nc = 15, method = "ward.D2") #priporoča 4
#-----------------------------------------------------------------
NbClust(data = data_ind, distance = "manhattan",
        min.nc = 2, max.nc = 15, method = "single") #priporoča 2
#-----------------------------------------------------------------
NbClust(data = data_ind, distance = "manhattan",
        min.nc = 2, max.nc = 15, method = "average") #priporoča 2
#-----------------------------------------------------------------
NbClust(data = data_ind, distance = "manhattan",
        min.nc = 2, max.nc = 15, method = "kmeans") #priporoča 5


#-----------------------------------------------------------------
#poskusimo 2, 3, 4, 5 skupin
#-----------------------------------------------------------------
p2ind <- cutree(model_ind, k=2)
p3ind <- cutree(model_ind, k=3)
p4ind <- cutree(model_ind, k=4)
p5ind <- cutree(model_ind, k=5)



#----------------------------------------------------------------
#1) graf če delimo na dve skupini - izloči MINAGAWA Kaho (rip njen trak :|)
#--------------------------------------------------------------
grupiranje_ind2 <- wcg %>% 
  ggplot(aes(x=DA, y=DB, col=p2ind)) + 
  geom_point() +
  geom_text(
    aes(label=drzava),
    size=2,
    color='black',
    nudge_x = 0.05,
    nudge_y = 0.05
  )#+
#theme_minimal()

#print(grupiranje_ind2)

#################################################################
#----------------------------------------------------------------
#2) graf če delimo na tri skupine 
#--------------------------------------------------------------
grupiranje_ind3 <- wcg %>% 
  ggplot(aes(x=DA, y=DB, col=p3ind, shape = tekma)) + 
  geom_point() +
  geom_text_repel( #da se napisi ne prekrivajo
    aes(label=drzava),
    size=2,
    color='black',
    nudge_x = 0.05,
    nudge_y = 0.05
  )+
theme_minimal()

print(grupiranje_ind3)

#KOMENTAR: 
#1. SKUPINA: minagawa z kiksano vajo
#2. SKUPINA: 
#3. SKUPINA:


#----------------------------------------------------------------
#3) graf če delimo na štiri skupine 
#--------------------------------------------------------------
grupiranje_ind4 <- wcg %>% 
  ggplot(aes(x=DA, y=DB, col=p4ind, shape = tekma)) + 
  geom_point() +
  geom_text(
    aes(label=drzava),
    size=2,
    color='black',
    nudge_x = 0.05,
    nudge_y = 0.05
  )#+
#theme_minimal()

print(grupiranje_ind4)

#################################################################
#----------------------------------------------------------------
#4) graf če delimo na pet skupin 
#--------------------------------------------------------------
grupiranje_ind5 <- wcg %>% 
  ggplot(aes(x=DA, y=DB, col=p5ind, shape = tekma)) + 
  geom_point() +
  guides(color = FALSE)+ #legende za barvo ne potrebujem
  geom_text_repel(
    aes(label=drzava),
    size=2,
    color='black',
    nudge_x = 0.05,
    nudge_y = 0.05
  )+
  theme_minimal()+
  labs(title = "GRUPIRANJE DRŽAV PO VREDNOSTI 
       DB IN DA INDUVIDUALNIH SESTAV")+
  theme(plot.title = element_text(hjust=0.5))

print(grupiranje_ind5)



#==========================================================================
#4. GRUPIRANJE PO REKVIZITIH - KATER JIM JE BOLJŠI
#==========================================================================
#View(induvidualne_finali)
#-------------------------------------------------------------------------
#PRIPRAVA PODATKOV
#-------------------------------------------------------------------------
#View(ecg)

#za vsak rekvizit bomo zapisali katero mestoje zasedla tekmovalka, potem bomo za vsako tekmovalko izbrali najvišjo uvrstitev
induvidualne_rekviziti <- ecg %>% #da ne pokvarimo podatkov
  group_by(rekvizit) %>% #morda ne bo potrebno
  mutate(mesto=as.numeric(c(1:25))) #%>% #ker imamo podatke že urejene
 

  
view(induvidualne_rekviziti)
  

#-----------------------------
#mediane za posamezen rekvizit
#-----------------------------
#skupna mediana
#induvidualne_rekviziti %>%group_by(rekvizit) %>% median(.,induvidualne_rekviziti$koncna_ocena) #21.5

#mediana po rekvizitih
medians <- induvidualne_rekviziti %>%
  group_by(rekvizit) %>%
  summarize(median = median(koncna_ocena, na.rm = T)) 
#View(medians) #ball 21.65, clubs	21.75, hoop 21.00, ribbon	19.30


#------
#graf
#------
ggplot(induvidualne_rekviziti, aes(tekmovalka, koncna_ocena) ) + 
  facet_grid(.~rekvizit)+
  geom_point() +  
  geom_hline(yintercept = 21.5, color = "blue") + #nastavljena na medijani
  labs( x = "tekmovalke", y = "končna ocena", 
        title = "GRAF KONČNIH OCEN GLEDE NA REKVIZIT" )+
  geom_text(
    aes(label=tekmovalka),
    size=2,
    color='black',
    nudge_x = 0.05,
    nudge_y = 0.05
  )

#KOMENTAR: zdi se da bi pri vsakem rekvizitu lahko tekmovalke razdelili na tri skupine
# 1.sk: nad mediano za posamezen rekvizit, 2.sk: pod mediano, 3.sk: jovana markovic, bih hana 

#---------------------------------------------------------------------------------
#METODA VODITELJEV
#---------------------------------------------------------------------------------

# Izbrati moramo število voditeljev
# k = 3

data_rekviziti <- ecg %>% 
  select(koncna_ocena) %>%
  as.matrix() %>%
  scale()

#----------------------------------------------------------------------------------
modelK_rekviziti <- kmeans(data_rekviziti, 3)

# Razporeditev v skupine
modelK_rekviziti$cluster
#[1] 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 1 1 1 1 1 1 1 1 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3
#[42] 3 1 1 1 1 1 1 1 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 1 1 1 1 1 1 1 1 2 2 3 3 3 3 3 3 3
#[83] 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 2 2

# Končni centri 
#modelK_rekviziti$centers

# Vsota kvadratov vseh razdalj
#modelK_rekviziti$totss #99

# Vsote kvadratov razdaj do centrov za posamezne skupine
#modelK_rekviziti$withinss #5.975027 2.111021 7.690559

# sum(modelK$withinss)
#modelK_rekviziti$tot.withinss

# totss - tot.withinss
#modelK_rekvizit$betweenss

# Število točk v vsaki skupini
#modelK_rekviziti$size #34  6 60

# Število iteracij algoritma
#modelK_rekviziti$iter
#-----------------------------------------------------------------------------------


###############################################################
#--------------------------------------------------------------
# KONČNI GRAF SKUPIN PO REKVIZITIH
#--------------------------------------------------------------
require('ggrepel') #za overlapping

grupiranje_rekviziti <- ecg %>% 
  mutate(skupina=modelK_rekviziti$cluster) %>%
  ggplot(aes(x=tekmovalka, y=koncna_ocena, col=skupina)) +
  facet_grid(.~rekvizit)+
  geom_point()+
 labs( y = "končna ocena", 
      title = "GRAF SKUPIN INDUVIDUALNIH TEKMOVALK PO REKVIZITIH")+
  geom_text_repel(  #dodamo imena tekmovalk, ki se ne prekrivajo
    aes(label=tekmovalka),
    size=1.5,
    color='black',
    min.segment.length = 0, #črtica do vsake pikice
    #box.padding = 0.05,
    #nudge_x = 0.05,
    #nudge_y = 0.5
  )+
  scale_y_continuous(breaks=c(2.5, 5, 7.5, 10, 12.5, 15, 17.5, 20, 22.5, 25))+
  theme_bw()+ #brez sivega ozadja
  theme(legend.position = "none" #brez legende
        ,axis.ticks.x = element_blank() #brez črtic na x osi
        ,axis.text.x = element_blank() #brez value na x osi
        ,axis.title.x = element_blank()
        ,axis.text.y = element_text(size = 5)
        ,panel.grid.major = element_blank() #navpične črte
        ,panel.grid.minor = element_blank() #vodoravne črte
        #,strip.background = element_blank() #ozadje pri ball clubs...
        #,panel.border = element_blank()
        ,plot.title = element_text(hjust=0.5)#naslovna sredini
    
  )

print(grupiranje_rekviziti)

#KOMENTAR: skupine po rekvizitih
#ŽOGA: 
#     1.SK: Harnasko, Kaleyn, Ashram, Salos,
#     2.SK:
#     3.SK:
#KIJI:
#OBROČ:
#TRAK:




#==========================================================================================
#5. KAKŠNE BODO OCENE NA OI 
#==========================================================================================
#gledamo dvig ocen skozi čas
#---------------------------
#izbrane tekmovalke-na vseh treh tekmah 
izbrane <- c("ASHRAM Linoy" ,"ZELIKMAN Nicol","NIKOLCHENKO Vlada","KALEYN Boryana"
             ,"SALOS Anastasiia")
induvidualne_predikcija <- induvidualne_finali %>% 
  mutate(tekma = recode(induvidualne_finali$tekma
                                   ,"2018 Sofia" = "2018" #KAJ JE = V KAJ ŽELIMO SPREMENITI
                                   ,"2019 Baku" = "2019"
                                   ,"2020 Kijev" = "2020")) %>% 
  subset(tekmovalka %in% izbrane)
  
#View(induvidualne_predikcija)


#----------------------------------------------------------------
#graf 
#----------------------------------------------------------------
ggplot(induvidualne_predikcija, aes(x = D, y = E, col = tekma)) + 
  geom_point()

#---------------------------------------------------------------
# MODEL
#--------------------------------------------------------------
model_ind <- lm(E ~ D, data=induvidualne_predikcija)

# Koeficienti premic
#model_ind$coefficients #(Intercept)6.7351068           D 0.1283348

# Residuali (razlike do premice)
#model_ind$residuals

# Dodatne statistike modela
#s <- summary(model_ind) #iz residualov in koeficientov poračuna vrednosti

# Npr. R^2 https://en.wikipedia.org/wiki/Coefficient_of_determination
#s$r.squared

# Pregled nekaterih statistik modela
#require(ggfortify)
#autoplot(model)

#------------------------------------------------------------------
# IZRIS LINEARNEGA MODELA
#------------------------------------------------------------------
ggplot(induvidualne_predikcija, aes(x = D, y = E)) + 
  geom_point() + 
  facet_grid(.~rekvizit)+
  geom_smooth(method=lm, formula=y~x) 

 
#-----------------------------------------------------------------
# PREDIKCIJA. Kakšna bo E ko bodo D dvignile na 17, 17.5
#-----------------------------------------------------------------
novD <- data.frame(D=c(17.5, 18))
predict(model_ind, novD) #8.980967 9.045134 
napovedE <- novD %>% mutate(E=predict(model_ind, .)) 

napovedE_tabela <- napovedE %>% 
  mutate(tekmovalka="napoved", drzava = "napoved", tekma = 2021, rekvizit = "napoved", Pen.= 0.00, koncna_ocena = c(8.980967+17.5, 9.045134+18) )  

#napovedE %>% View
#napovedE_tabela %>% view

induvidualne_predikcija_napoved <- rbind(napovedE_tabela, induvidualne_predikcija)


#----------------
# izris napovedi
#----------------
predikcija_graf_ind <- ggplot(induvidualne_predikcija_napoved, aes(x = D, y = E)) + 
  geom_point(shape=1) + 
  geom_smooth(method=lm, formula=y~x) +
  geom_point(data=napovedE, aes(x=D, y=E), color='red', size=3)+
  labs( title = "PREDIKCIJA POVPREČNE OCENE E ZA INDUVIDUALNE SESTAVE 
        NA OLIMPIJSKIH IGRAH 2021" )+
  theme_bw()+ #brez sivega ozadja
  theme(legend.position = "none" #brez legende
        ,plot.title = element_text(hjust=0.5)#naslovna na sredini
        
  )

print(predikcija_graf_ind)


