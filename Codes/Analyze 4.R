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


# mengubah perintah visualisasi menjadi lebih simpel

ggplot(membership_daily_time, aes(x = Day, y = avg_time, fill = membership_type))+
  geom_bar(stat = "identity", position = "dodge", show.legend = TRUE)+
  labs(title = "Average Daily Ride by Each Membership Type",
       x = "Day",
       y = "Average Time (Hours)" ) +
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
  