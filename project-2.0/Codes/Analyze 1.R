

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



