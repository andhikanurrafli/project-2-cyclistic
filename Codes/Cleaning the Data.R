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
str(tripdata_cleaned)
head(tripdata_cleaned)