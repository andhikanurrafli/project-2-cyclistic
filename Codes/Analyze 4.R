# membuat datasetnya

membership_daily_dist <- tripdata_mutate %>% 
  group_by(Day, membership_type) %>% 
  summarise(avg_dist = mean(ride_duration_hours), .groups = "drop")

# mengurutkan jenis harinya

membership_daily_dist <- tripdata_mutate %>% 
  group_by(Day, membership_type) %>% 
  summarise(avg_dist = mean(ride_duration_hours), .groups = "drop") %>% 
  mutate(Day = factor(Day, levels = day_levels)) %>% 
  arrange(Day, membership_type)

# membuat visualnya

ggplot(membership_daily_dist, aes(x = Day, y = avg_dist, fill = membership_type))+
  geom_bar(stat = "identity", position = "dodge", show.legend = TRUE)+
  labs(title = "Average Daily Ride by Each Membership Type",
       x = "Day",
       y = "Average Distance (KM)" ) +
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 35, hjust = 1))+
  scale_fill_manual(values = c("member" = "skyblue", "casual" = "orange"))
  