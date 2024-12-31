---
title: "Cyclistic 1.1"
author: "Andhika Nurrafli Putra"
date: "2024-11-30"
output: html_document
---

## Dataset
```{r}
library(tidyverse)
library(knitr)
library(geosphere)
```
Dataset yang saya dapatkan sepenuhnya dari tugas proyek akhir dari Coursera yang terdapat di Link [ini](https://divvy-tripdata.s3.amazonaws.com/index.html), dan saya menggunakan data yang paling terkini yaitu data yang dirilis pada 5 November 2024. Dataset ini saya simpan di directory pribadi saya, dan kemudian saya menggunakan perintah-perintah yang sesuai.

### Preparing and cleaning the data
```{r}
# input the data

trip_data <- read.csv("tripdata.csv")

# cleaning the data

# turning data string in
trip_data$started_at <- ymd_hms(trip_data$started_at)
trip_data$ended_at <- ymd_hms(trip_data$ended_at)

# deleting rows that has na value

trip_data_cleaned <- trip_data %>%
  filter(start_station_name != "" & end_station_name != "")

# merging geo lat and lng
trip_data_cleaned_geo <- trip_data_cleaned %>% 
  unite("startCoordinate", start_lat, start_lng, sep = ", ")

trip_data_cleaned_geo <- trip_data_cleaned_geo %>% 
  unite("endCoordinate", end_lat, end_lng, sep = ", ")
```

Data-data tersebut sudah saya bersihkan dengan menghilangkan kolom n/a atau yang kosong, sehingga didapatkan data yang bersih. Saya juga telah menggabungkan beberapa kolom menjadi satu sehingga dapat memudahkan analisis nantinya.

## Tujuan analisis
Tujuan analisis ini adalah untuk membantu cyclistic dalam meningkatkan pengguna 
keanggotaan agar dapat memperoleh ROI yang lebih besar.


## Analyzing the data

Disini saya akan mencoba menganilisis data dengan menggunakan tujuan analisis data ini.

