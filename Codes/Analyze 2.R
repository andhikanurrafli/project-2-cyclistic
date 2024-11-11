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