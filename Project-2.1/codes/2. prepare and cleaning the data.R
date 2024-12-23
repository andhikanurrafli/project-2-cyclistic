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
