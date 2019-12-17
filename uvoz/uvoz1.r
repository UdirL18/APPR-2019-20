library(tidyverse)

getwd()
baku <- read.csv("2019_WCH_Baku_Results.csv", TRUE, ",",skip = 5,)
View(baku)

getwd()
sofia <- read.csv("2018_WCH_Sofia_Results.csv", TRUE, ",")
View(sofia)