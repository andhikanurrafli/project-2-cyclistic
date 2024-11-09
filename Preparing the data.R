# memuat environmnt

library(tidyverse)
library(knitr)

# Memuat data

tripdata <- read.csv("202410-divvy-tripdata.csv")


glimpse(tripdata)
head(tripdata)
str(tripdata)