# Analiza podatkov s programom R, 2019/20

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2019/20

* [![Shiny](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/jaanos/APPR-2019-20/master?urlpath=shiny/APPR-2019-20/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/jaanos/APPR-2019-20/master?urlpath=rstudio) RStudio

## Analiza rezultatov RGI

V projektni nalogi bom analizirala rezultate svetovnih pokalov v ritmični gimnastiki za induvidualne sestave. Osredotočila se bom na tekmovanja v letu 2019 in na najboljših 15 tekmovalk iz trenutnega olimpijskega cikla. Analizirala bom rezultate tako za posamične rekvizite (obroč, žoga, kiji, trak), kot tudi za skupni seštevek (all-rownd). Uporabila bom podatke iz spletne strani FIG (https://www.gymnastics.sport/site/events/searchresults.php), kjer so podatki v obliki HTML in CSV. 

TABELE:
1. TABELA bo vsebovala rezultate iz svetovnih  pokalov (World Cup in World Challenge Cup).
  *SPREMENLJIVKE: 
  *ime in priimek tekmovalke
  *država
  *rezultat sestave z obročem
  *rezultat sestave z žogo
  *rezultat sestave z kiji
  *rezultat sestave  z trakom
  
2. tabela bo vsebovala podrobno analizo ocen (difficulty and execution score) iz svetovnih prvenstev iz 2018 in 2019.
 * SPREMENLJIVKE: 
  *ime in priimek tekmovalke
  *država
  *DB (body difficulties) težine s telesom in plesni koraki, ter odbitek za odsotnos fundamentalnih gibanj z rekvizitom.
  *DA (tehnical value) težine z rekvizitom in dinamični elementi z rotacijam.
  *EA (artistic component) izvedba vaje na glasbo, uporaba tekmovalnega prostora, raznovrstnost elementov, izraznost.
  *ET (tehnical faults) tehnične napake z rekvizitom in telesom.
  *penalty odbitki-prestop ter glasba, dres in rekviziti niso v skaladu s pravilikom.

Cilj projektne naloge je predstaviti pripravljenost posameznih tekmovalk na olimpijske igre 2020 in napovedati katera država bo verjetno osvojila odličja.





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
