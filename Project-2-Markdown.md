Cyclistic
================
Andhika Nurrafli Putra
2024-11-09

## Dataset

``` r
library(tidyverse)
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
    ## ✔ purrr     1.0.2     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
library(knitr)
```

Dataset yang saya dapatkan sepenuhnya dari tugas proyek akhir dari
Coursera yang terdapat di Link
[ini](https://divvy-tripdata.s3.amazonaws.com/index.html), dan saya
menggunakan data yang paling terkini yaitu data yang dirilis pada 5
November 2024. Dataset ini saya simpan di directory pribadi saya, dan
kemudian saya menggunakan perintah-perintah yang sesuai.

## Menentukan tujuan bisnis

Dari studi kasus ini *stakeholders* ingin memaksimalkan pengguna
keanggotaan tahunan dengan tujuan untuk memastikan kesuksesan
perusahaan. Hal ini akan saya cek terlebih dahulu dengan keanggotaan
biasa. Lalu kemudian saya analisis lebih lanjut bagaimana efek dari
keanggotaan itu.  
Di akhir nanti saya juga akan memberikan rekomendasi terhadap data yang
sudah dianalisis, dan juga nantinya saya akan memberikan slide tentang
data ini.

## Mengunggah Data

Kode dibawah saya gunakan untuk mengunggah data yang sudah saya unduh
kemudian saya masukkan ke Rstudio.

``` r
# Memuat data

tripdata <- read.csv("202410-divvy-tripdata.csv")


glimpse(tripdata)
```

    ## Rows: 616,281
    ## Columns: 13
    ## $ ride_id            <chr> "4422E707103AA4FF", "19DB722B44CBE82F", "20AE2509FD…
    ## $ rideable_type      <chr> "electric_bike", "electric_bike", "electric_bike", …
    ## $ started_at         <chr> "2024-10-14 03:26:04.083", "2024-10-13 19:33:38.926…
    ## $ ended_at           <chr> "2024-10-14 03:32:56.535", "2024-10-13 19:39:04.490…
    ## $ start_station_name <chr> "", "", "", "", "", "", "", "", "", "", "", "", "",…
    ## $ start_station_id   <chr> "", "", "", "", "", "", "", "", "", "", "", "", "",…
    ## $ end_station_name   <chr> "", "", "", "", "", "", "", "", "", "", "", "", "",…
    ## $ end_station_id     <chr> "", "", "", "", "", "", "", "", "", "", "", "", "",…
    ## $ start_lat          <dbl> 41.96, 41.98, 41.97, 41.95, 41.98, 41.88, 41.89, 41…
    ## $ start_lng          <dbl> -87.65, -87.67, -87.66, -87.65, -87.67, -87.65, -87…
    ## $ end_lat            <dbl> 41.98, 41.97, 41.95, 41.96, 41.98, 41.89, 41.88, 41…
    ## $ end_lng            <dbl> -87.67, -87.66, -87.65, -87.65, -87.67, -87.64, -87…
    ## $ member_casual      <chr> "member", "member", "member", "member", "member", "…

``` r
head(tripdata)
```

    ##            ride_id rideable_type              started_at
    ## 1 4422E707103AA4FF electric_bike 2024-10-14 03:26:04.083
    ## 2 19DB722B44CBE82F electric_bike 2024-10-13 19:33:38.926
    ## 3 20AE2509FD68C939 electric_bike 2024-10-13 23:40:48.522
    ## 4 D0F17580AB9515A9 electric_bike 2024-10-14 02:13:41.602
    ## 5 A114A483941288D1 electric_bike 2024-10-13 19:26:41.383
    ## 6 97833F00E6A67DC6 electric_bike 2024-10-14 06:35:06.130
    ##                  ended_at start_station_name start_station_id end_station_name
    ## 1 2024-10-14 03:32:56.535                                                     
    ## 2 2024-10-13 19:39:04.490                                                     
    ## 3 2024-10-13 23:48:02.339                                                     
    ## 4 2024-10-14 02:25:40.057                                                     
    ## 5 2024-10-13 19:28:18.560                                                     
    ## 6 2024-10-14 06:42:10.776                                                     
    ##   end_station_id start_lat start_lng end_lat end_lng member_casual
    ## 1                    41.96    -87.65   41.98  -87.67        member
    ## 2                    41.98    -87.67   41.97  -87.66        member
    ## 3                    41.97    -87.66   41.95  -87.65        member
    ## 4                    41.95    -87.65   41.96  -87.65        member
    ## 5                    41.98    -87.67   41.98  -87.67        member
    ## 6                    41.88    -87.65   41.89  -87.64        member

``` r
str(tripdata)
```

    ## 'data.frame':    616281 obs. of  13 variables:
    ##  $ ride_id           : chr  "4422E707103AA4FF" "19DB722B44CBE82F" "20AE2509FD68C939" "D0F17580AB9515A9" ...
    ##  $ rideable_type     : chr  "electric_bike" "electric_bike" "electric_bike" "electric_bike" ...
    ##  $ started_at        : chr  "2024-10-14 03:26:04.083" "2024-10-13 19:33:38.926" "2024-10-13 23:40:48.522" "2024-10-14 02:13:41.602" ...
    ##  $ ended_at          : chr  "2024-10-14 03:32:56.535" "2024-10-13 19:39:04.490" "2024-10-13 23:48:02.339" "2024-10-14 02:25:40.057" ...
    ##  $ start_station_name: chr  "" "" "" "" ...
    ##  $ start_station_id  : chr  "" "" "" "" ...
    ##  $ end_station_name  : chr  "" "" "" "" ...
    ##  $ end_station_id    : chr  "" "" "" "" ...
    ##  $ start_lat         : num  42 42 42 42 42 ...
    ##  $ start_lng         : num  -87.7 -87.7 -87.7 -87.7 -87.7 ...
    ##  $ end_lat           : num  42 42 42 42 42 ...
    ##  $ end_lng           : num  -87.7 -87.7 -87.7 -87.7 -87.7 ...
    ##  $ member_casual     : chr  "member" "member" "member" "member" ...

## Membersihkan data

Selanjutnya adalah melakukan pembersihan data yang mana akan membuat
saya lebih mudah untuk melakukan analisis nantinya. Berikut perintah
yang saya gunakan.

``` r
# saya akan melakukan pembersihan dengan memfilter data yang bernilai NA di setiap kolom stasiun dengan menggunakan kode

tripdata_cleaned <- tripdata %>% filter(start_station_name != "", 
                                        start_station_id != "", 
                                        end_station_name != "", 
                                        end_station_id != "")

# lalu mengganti nama jenis keanggotaan dari member_casual menjadi tipe keanggotaan

tripdata_cleaned <- tripdata_cleaned %>% rename(membership_type = member_casual)


# dan juga ride_id saya akan menggantinya dengan user

tripdata_cleaned <- tripdata_cleaned %>% rename(user = ride_id)

# saya akan menghapus kolom yang tidak relevan untuk analisis nanti

tripdata_cleaned <- tripdata_cleaned %>% select(-start_station_id, -end_station_id, -start_lat,
                                                -end_lat, -start_lng,
                                                -end_lng)
# mengubah jenis string dari chr ke waktu

tripdata_cleaned$started_at <- ymd_hms(tripdata_cleaned$started_at)
tripdata_cleaned$ended_at <- ymd_hms(tripdata_cleaned$ended_at)

# menambahkan kolom hari 

tripdata_cleaned <- tripdata_cleaned %>% 
  mutate(Day = weekdays(started_at))

# Menambahkan kolom untuk menentukan jumlah waktu pemakaian setiap user

tripdata_mutate <- tripdata_cleaned %>%
  mutate(
    ride_duration_hours = as.numeric(difftime(ended_at, started_at, units = "hours"))
  )

glimpse(tripdata_cleaned)
```

    ## Rows: 449,114
    ## Columns: 8
    ## $ user               <chr> "528F356117BC3840", "F3F376840416C601", "777AB735E4…
    ## $ rideable_type      <chr> "classic_bike", "electric_bike", "classic_bike", "c…
    ## $ started_at         <dttm> 2024-10-01 19:20:39, 2024-10-03 12:40:26, 2024-10-…
    ## $ ended_at           <dttm> 2024-10-01 19:35:06, 2024-10-03 12:40:29, 2024-10-…
    ## $ start_station_name <chr> "California Ave & Milwaukee Ave", "California Ave &…
    ## $ end_station_name   <chr> "California Ave & Milwaukee Ave", "California Ave &…
    ## $ membership_type    <chr> "member", "member", "casual", "casual", "member", "…
    ## $ Day                <chr> "Tuesday", "Thursday", "Wednesday", "Wednesday", "S…

``` r
str(tripdata_cleaned)
```

    ## 'data.frame':    449114 obs. of  8 variables:
    ##  $ user              : chr  "528F356117BC3840" "F3F376840416C601" "777AB735E4C2ACA6" "98C68BF9E5BFCD85" ...
    ##  $ rideable_type     : chr  "classic_bike" "electric_bike" "classic_bike" "classic_bike" ...
    ##  $ started_at        : POSIXct, format: "2024-10-01 19:20:39" "2024-10-03 12:40:26" ...
    ##  $ ended_at          : POSIXct, format: "2024-10-01 19:35:06" "2024-10-03 12:40:29" ...
    ##  $ start_station_name: chr  "California Ave & Milwaukee Ave" "California Ave & Milwaukee Ave" "Chicago State University" "Chicago State University" ...
    ##  $ end_station_name  : chr  "California Ave & Milwaukee Ave" "California Ave & Milwaukee Ave" "Chicago State University" "Chicago State University" ...
    ##  $ membership_type   : chr  "member" "member" "casual" "casual" ...
    ##  $ Day               : chr  "Tuesday" "Thursday" "Wednesday" "Wednesday" ...

``` r
head(tripdata_cleaned)
```

    ##               user rideable_type          started_at            ended_at
    ## 1 528F356117BC3840  classic_bike 2024-10-01 19:20:39 2024-10-01 19:35:06
    ## 2 F3F376840416C601 electric_bike 2024-10-03 12:40:26 2024-10-03 12:40:29
    ## 3 777AB735E4C2ACA6  classic_bike 2024-10-02 18:59:27 2024-10-02 19:06:55
    ## 4 98C68BF9E5BFCD85  classic_bike 2024-10-02 18:59:27 2024-10-02 19:07:11
    ## 5 FE234AD3EFBAD12C electric_bike 2024-10-05 16:01:35 2024-10-05 16:13:25
    ## 6 EB0472207B948EFB electric_bike 2024-10-26 22:37:12 2024-10-26 22:38:45
    ##               start_station_name               end_station_name membership_type
    ## 1 California Ave & Milwaukee Ave California Ave & Milwaukee Ave          member
    ## 2 California Ave & Milwaukee Ave California Ave & Milwaukee Ave          member
    ## 3       Chicago State University       Chicago State University          casual
    ## 4       Chicago State University       Chicago State University          casual
    ## 5        Western Ave & Roscoe St        Western Ave & Roscoe St          member
    ## 6 California Ave & Milwaukee Ave California Ave & Milwaukee Ave          member
    ##         Day
    ## 1   Tuesday
    ## 2  Thursday
    ## 3 Wednesday
    ## 4 Wednesday
    ## 5  Saturday
    ## 6  Saturday

## Analisis data

### Menentukan Rata-rata waktu penggunaan setiap tipe keanggotaan

Langkah berikutnya adalah analisis data yang bertujuan untuk menjawab
dari pentanyaan dan tujuan bisnis yang sudah ditentukan.  
Pertama saya akan mencari berapa jumlah rata-rata dari setiap tipe
membership, Berikut kodenya.

``` r
# melihat bagaimana rata-rata setiap tipe membership

membership_ride_hours_mean <- tripdata_mutate %>% group_by(membership_type) %>% 
  summarise(mean_ride_duration = mean(ride_duration_hours, na.rm=TRUE))

# kita lihat visualnya

ggplot(membership_ride_hours_mean, aes(x = membership_type, y = mean_ride_duration, fill = membership_type)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  labs(title = "Mean Ride Duration by Membership Type",
       x = "Membership Type",
       y = "Mean Ride Duration (hours)") +
  theme_minimal() +
  scale_fill_manual(values = c("member" = "skyblue", "casual" = "orange"))
```

![](Project-2-Markdown_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

Dari grafik diatas dapat dilihat bahwa keanggotaan kasual lebih banyak
menggunakan sepeda dari segi rata-rata penggunaannya.

### Menentukan preferensi dari setiap pengguna menggunakan tipe sepeda

Pada bagian ini saya akan mencoba mencari tau untuk setiap pengguna
mereka lebih memilih untuk menggunakan sepeda tipe apa berdasarkan dari
tipe keanggotaan mereka.

``` r
# mengetahui setiap tipe keanggotan lebih memilih sepeda jenis apa

membership_preference <- tripdata_cleaned %>%
  group_by(membership_type, rideable_type) %>%
  summarise(count = n(), .groups = "drop")

# melihat visualisasinya

ggplot(membership_preference, aes(x = rideable_type, y = count, fill = membership_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Rideable Type Preferences by Membership Type",
       x = "Rideable Type",
       y = "Number of Rides") +
  theme_minimal() +
  scale_fill_manual(values = c("member" = "skyblue", "casual" = "orange"))
```

![](Project-2-Markdown_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

Dari grafik tersebuk kita bisa melihat bahwa dari pengguna kasual dan
juga keanggotaan tahunan memiliki preferensi yang lebih banyak ke
classic_bike. Hal ini terjadi mungkin karena para pengguna yang juga
ingin berolahraga sembari menuju ke tujuan.

### Menentukan penggunaan sepeda oleh tiap jenis keanggotaan berdasarkan hari

Saat ini kita akan mencoba menghitung jumlah penggunaan sepeda oleh tiap
tipe keanggotaan berdasarkan hari. Hal ini penting karena kita akan
memantau setiap harinya tipe keanggotaan mana yang memiliki lebih banyak
aktivitas menggunakan sepeda.

``` r
# membuat datasetnya

membership_daily_ride <- tripdata_mutate %>% 
  group_by(Day, membership_type) %>% 
  summarise(ride_count = n(), .groups = "drop")

# mengurutkan jenis hari

day_levels <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
                "Saturday", "Sunday")

membership_daily_ride <- tripdata_mutate %>% 
  group_by(Day, membership_type) %>% 
  summarise(ride_count = n(), .groups = "drop") %>% 
  mutate(Day = factor(Day, levels = day_levels)) %>% 
  arrange(Day, membership_type)

# membuat visual

ggplot(membership_daily_ride, aes(x = Day, y = ride_count, fill = membership_type))+
  geom_bar(stat = "identity", position = "dodge", show.legend = TRUE) +
  labs(title = "Daily Ride by Membership Type",
       x = "Day",
       y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 35, hjust = 1))+
  scale_fill_manual(values = c("member" = "skyblue", "casual" = "orange"))
```

![](Project-2-Markdown_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

Berdasarkan data yang sudah dianalisis seperti diatas, kita dapat
melihat bahwa user yang memiliki keanggotaan tahunan lebih banyak
menggunakan sepeda di hari kerja, sedangkan user casual lebih banyak
menggunakan di akhir pekan. Hal ini dapat disebabkan oleh karena user
keanggotaan tahunan memilih untuk memiliki keanggotaan karena mereka
akan lebih sering menggunakannya untuk kepentingan mobilitas bekerja.
Sedangkan untuk user tahunan lebih sering menggunakan pada akhir pekan,
dimana kemungkinan mereka menggunakannya untuk melakukan kegiatan akhir
pekan seperti liburan dan bersenang-senang.

### Menentukan penggunaan sepeda oleh tiap jenis keanggotaan berdasarkan rata-rata Waktu

Selanjutnya akan saya coba untuk membuat sebuah tabel untuk menentukan
jenis keanggotaan mana yang paling banyak menggunakan sepeda di setiap
harinya.

``` r
# membuat datasetnya

membership_daily_time <- tripdata_mutate %>% 
  group_by(Day, membership_type) %>% 
  summarise(avg_time = mean(ride_duration_hours), .groups = "drop")

# mengurutkan jenis harinya

membership_daily_time <- tripdata_mutate %>% 
  group_by(Day, membership_type) %>% 
  summarise(avg_time = mean(ride_duration_hours), .groups = "drop") %>% 
  mutate(Day = factor(Day, levels = day_levels)) %>% 
  arrange(Day, membership_type)

# membuat visualnya

ggplot(membership_daily_time, aes(x = Day, y = avg_time, fill = membership_type))+
  geom_bar(stat = "identity", position = "dodge", show.legend = TRUE)+
  labs(title = "Average Daily Ride by Each Membership Type",
       x = "Day",
       y = "Average Time (Hours)" ) +
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 35, hjust = 1))+
  scale_fill_manual(values = c("member" = "skyblue", "casual" = "orange"))
```

![](Project-2-Markdown_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

Hal yang sebelumnya saya tulis terbukti di garis ini, dimana user dengan
keanggotaan tahunan cenderung sama rata-rata waktu yang ditempul
dibandingkan dengan jenis keanggotaan kasual yang mana dalam hal ini
user yang memilih untuk menggunakan keanggotan kasual menggunakannya
untuk mobilitas sebagai turis, dan user yang sudah membeli keanggotaan
tahunan merupakan orang-orang yang bekerja di kota itu, karena waktu
tempuhnya cenderung sama.  

Selanjutnya saya akan mengubah perintah variasi untuk menjadi lebih
mudah, berikut kodenya.

``` r
# mengubah perintah visualisasi menjadi lebih simpel

average_daily_ride_viz <- ggplot(membership_daily_time, aes(x = Day, y = avg_dist, fill = membership_type))+
  geom_bar(stat = "identity", position = "dodge", show.legend = TRUE)+
  labs(title = "Average Daily Ride by Each Membership Type",
       x = "Day",
       y = "Average Time (KM)") +
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 35, hjust = 1))+
  scale_fill_manual(values = c("member" = "skyblue", "casual" = "orange"))


ride_count_viz <- ggplot(membership_daily_ride, aes(x = Day, y = ride_count, fill = membership_type))+
  geom_bar(stat = "identity", position = "dodge", show.legend = TRUE) +
  labs(title = "Daily Ride by Membership Type",
       x = "Day",
       y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 35, hjust = 1))+
  scale_fill_manual(values = c("member" = "skyblue", "casual" = "orange"))
```

Dalam hal ini untuk rekomendasi saya akan menjadi lebih mudah untuk
melakukan perintahnya.

## Sebuah rekomendasi

Berdasarkan dari kedua grafik dari hasil analisis terakhir diatas kita
dapat mengetahui bahwa:  
- Pelanggan keanggotaan tahunan cenderung lebih sering memakai sepeda
pada hari kerja, walaupun di akhir pekan juga lebih banyak daripada
member kasual akan tetapi itu tidak signifikan.  
- Pelanggan kasual lebih banyak menggunakan sepeda di akhir pekan, dan
waktu tempuh rata-rata yang mereka capai lebih jauh daripada pelanggan
keanggotaan tahunan.  

Disini kita bisa saja untuk meningkatkan keanggotaan tahunan dengan
memberikan promosi dan percobaan-percobaan yang mungkin akan dapat
mempengaruhi pengguna kasual berpindah ke keanggotaan tahunan. Dengan
meningkatkan fitur-fitur yang bisa diperoleh oleh hanya pengguna tahunan
saja atau dengan mengekslusifkannya. Pengguna kasual bisa mencoba fitur
itu dan kemudian menciptakan unsur *flexing* di setiap pengguna.
