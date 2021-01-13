# Analiza podatkov s programom R, 2019/20

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2019/20

* [![Shiny](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/UdirL18/APPR-2019-20/master?urlpath=shiny/APPR-2019-20/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/UdirL18/APPR-2019-20/master?urlpath=rstudio) RStudio

## Analiza rezultatov tekmovanj v ritmični gimnastiki.

Pri projektu bom analizirala rezultate svetovnih in evropskih prvenstev. Predvsem se bom osredotočila na spremembe ocene tekom olimpijskega cikla, 
ter poskušala predviditi rezultate za naslednje večje tekmovanje. Osredotočila se bom na tri večja tekmovanja:
* ZA INDUVIDUALNE SESTAVE
1. [36th FIG Rhythmic Gymnastics World Championships](https://gym.longinestiming.com/File/0000110101FFFFFFFFFFFFFFFFFFFF03): podatki v obliki CSV, 
2. [37th FIG Rhythmic Gymnastics World Championships](https://gym.longinestiming.com/File/000012000100FFFFFFFFFFFFFFFFFF04): podatki v obliki CSV,
3. [2020 European Championships in Rhythmic Gymnastics](https://backend.europeangymnastics.com/sites/default/files/paragraph/age-group-competition-info/competition-results/SENIORS%20-%20Individual%20-%20All-around%20Final%20AllAroundResultsRg_0.pdf): podatki v obliki CSV.
* ZA SKUPINSKE SESTATVE
1. [37th FIG Rhythmic Gymnastics World Championships](https://en.wikipedia.org/wiki/2019_Rhythmic_Gymnastics_World_Championships); podatki v obliki html,
2. [2020 European Championships in Rhythmic Gymnastics](https://backend.europeangymnastics.com/sites/default/files/paragraph/age-group-competition-info/competition-results/SENIORS%20-%20Group%20-%20Qualification%20AllAroundResultsRg_0.pdf): podatki v obliki CSV.

### Tabele:
* Tabela wcg
  1. stolpec "Tekmovalka"
    -stolpec z imenom in priimkom tekmovalke, tipa character.

  2. stolpec "drzava"
    -stolpec z kratico države, ki jo tekomovalka zastopa, tipa character.

  3.  stolpec "rekvizit"
    -stolpec, ki pove s katerim rekvizitom je tekmovalka dobila te ocene, tipa character. Ta stolpec sem dodala ko sem tabele združila ve eno.

  4. stolpec  "tekma"
    -stolpec, ki pove na kateri tekmi je tekmovalka dobila te ocene, tipa character. Ta stolpec sem dodala ko sem tabele združila ve eno.  

  5. stolpec "DA"
    -stolpec z seštevkom tehničnih vrednostih z rekvizitom, tipa numeric.

  6. stolpec "BA"
    -stolpec z seštevkom tehničnih vrednostih z telesom, tipa numeric. 

  7. stolpec "EA"
    -stolpec z odbitkom kompozicijskih izvedbenih napak, tipa numeric.

  8. stolpec "ET"
    -stolpec z odbitkom tehničnih izvedbenih napak, tipa numeric. 

  9. stolpec "Pen"
    -stolpec z odbitkom sodnice koordinatorke, časomerilk in linijskih sodnic , tipa numeric.  

  
  **OPOMBA**: končna ocena je sestavlejena iz ocene težavnosti, odbitka izvedbenih napak in odbitkov s strani sodnice koordinatorke, časomerilke in linijskih sodnic. Ocena       težavnosti je sestavljena iz dveh komponent (težine s telesom in težine z rekvizitom). Odbitek izvedbenih napak se odšteje od 10.00 točk in nato prišteje končni oceni.   
  
* Tabela ecg
  1. stolpec "Tekmovalka"
    -stolpec z imenom in priimkom tekmovalke, tipa character.

  2. stolpec "drzava"
    -stolpec z kratico države, ki jo tekomovalka zastopa, tipa character.

  3.  stolpec "rekvizit"
    -stolpec, ki pove s katerim rekvizitom je tekmovalka dobila te ocene, tipa character. 

  4. stolpec  "tekma"
    -stolpec, ki pove na kateri tekmi je tekmovalka dobila te ocene, tipa character. 

  5. stolpec "E"
    -stolpec z odbitkom izvedbenih napak, tipa numeric.  

  6. stolpec "D"
    -stolpec z seštevkom tehničnih vrednostih, tipa numeric. 

  7. stolpec "Pen"
    -stolpec z odbitkom sodnice koordinatorke, časomerilk in linijskih sodnic , tipa numeric.  

  8.  stolpec "koncna_ocena"
    -stolpec s koncno oceno, tipa numeric. 
  
* Tabela skupinske
  1. stolpec "drzava"
    -stolpec z imenom države, ki jo tekomovalke zastopajo, tipa character.

  2. stolpec "E"
    -stolpec z odbitkom izvedbenih napak, tipa numeric.  

  3. stolpec "D"
    -stolpec z seštevkom tehničnih vrednostih, tipa numeric. 

  4. stolpec "Pen"
    -stolpec z odbitkom sodnice koordinatorke, časomerilk in linijskih sodnic , tipa numeric.  

  5.  stolpec "koncna_ocena"
    -stolpec s koncno oceno, tipa numeric.

  6.  stolpec "rekvizit"
    -stolpec, ki pove s katerim rekvizitom so tekmovalke dobile te ocene, tipa character. 

  7. stolpec  "tekma"
    -stolpec, ki pove na kateri tekmi so tekmovalke dobile te ocene, tipa character. 
  

   


## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `rgeos` - za podporo zemljevidom
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `tidyr` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-201819)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).
