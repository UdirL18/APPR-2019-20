library(tidyverse)
library(dplyr)
library(readr)

getwd()
baku <- read.csv2("X2019_WCH_Baku_Results", TRUE, ",",skip = 5,)
View(baku)


getwd()
sofia <- read.csv2("2018_WCH_Sofia_Results", TRUE, ",")
View(sofia)