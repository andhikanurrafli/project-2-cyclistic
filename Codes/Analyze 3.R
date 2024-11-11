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