library(tidyverse)
library(knitr)
library(arrow)

data <- read_parquet("combined_data.parquet")
data <- data %>% select(-source_file)

# data cleaning

data_cleaned <- drop_na(data)

# data processiong

str(data_cleaned)

# so there is data that has date in it but the string say it is a chr, here i'm gonna make it into date format

library(lubridate)

data_cleaned$started_at <- ymd_hms(data_cleaned$started_at)
data_cleaned$ended_at <- ymd_hms(data_cleaned$ended_at)

# creating new column ride duration
data_cleaned$ride_duration <- as.numeric(difftime(data_cleaned$ended_at, data_cleaned$started_at, units = "mins"))
data_cleaned$ride_duration <- round(data_cleaned$ride_duration)
summary(data_cleaned$ride_duration)
# there is a minus value in Minimum of ride_duration I need to fix this by deleting it because it is not valid

data_cleaned <- subset(data_cleaned, ride_duration >= 0)
summary(data_cleaned)

# so there is still outliers I can determining it by using IQR
Q1 <- as.numeric(quantile(data_cleaned$ride_duration, 0.25))
Q3 <- as.numeric(quantile(data_cleaned$ride_duration, 0.75))
IQR_val <- IQR(data_cleaned$ride_duration)
# so we will continue to determine lower and upper bound so we can filter out the outliers
lower_bound <- Q1 - 1.5 * 17
upper_bound <- Q3 + 1.5 * 17  

data_no_outliers <- data_cleaned %>%
  filter(ride_duration >= 0 ,ride_duration<= upper_bound)

# Creating day_of_week column
data_no_outliers <- data_no_outliers %>%
  mutate(
    started_at = as.POSIXct(started_at),
    day_of_week = wday(started_at, week_start = 7,),
    day_of_week_label = wday(started_at, week_start = 7, label = TRUE)
    
  )

# exploring data

summary_usage <- data_no_outliers %>% 
  group_by(member_casual, day_of_week_label) %>% 
  summarise(total_rides = n()) %>% 
  ungroup() # the grouping stop right here eheh


summary_usage$day_of_week_label <- factor(
  summary_usage$day_of_week_label,
  levels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
)

# Viz

usage_base_on_dow <- ggplot(summary_usage, aes(x = day_of_week_label, y = total_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs( 
    title = "Total Trips base on Days and Users",
    x = "Day of week",
    y = "Total Trips",
    fill = "User Types") +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.text = element_text(size = 11)
  )

# frequent of casual user trips

frequent_casual <- data_no_outliers %>%
  filter(member_casual == "casual") %>%
  mutate(week = lubridate::week(started_at)) %>%
  group_by(week, started_at_date = as.Date(started_at)) %>%  # per tanggal
  summarise(trips = n(), .groups = "drop") %>%
  filter(trips >= 3)

casual_weekly <- data_no_outliers %>%
  filter(member_casual == "casual") %>%
  mutate(week = lubridate::week(started_at)) %>%
  group_by(week) %>%
  summarise(total_trips = n())
nrow(frequent_casual)

casual_freq <- data_no_outliers %>%
  filter(member_casual == "casual") %>%
  mutate(week = week(started_at)) %>%
  group_by(start_station_name, week) %>%  # atau gunakan proxy pengelompokan lainnya
  summarise(trips = n(), .groups = "drop") %>%
  filter(trips > 0)

ggplot(casual_freq, aes(x = trips)) +
  geom_histogram(binwidth = 1, fill = "skyblue", color = "black") +
  labs(title = "Distribution of Casual User Trip Frequency (Per Station per Week)",
       x = "Number of Trips per Week",
       y = "Count of Station-Weeks") +
  theme_minimal()

# line chart to see the potential membership and paterns

casual_weekly_usage <- data_no_outliers %>%
  filter(member_casual == "casual") %>%
  mutate(week = floor_date(started_at, unit = "week")) %>%
  group_by(week) %>%
  summarise(total_trips = n(), .groups = "drop")

casual_monthly_usage <- data_no_outliers %>%
  filter(member_casual == "casual") %>%
  mutate(month = floor_date(started_at, unit = "month")) %>%
  group_by(month) %>%
  summarise(total_trips = n(), .groups = "drop")

ggplot(casual_weekly_usage, aes(x = week, y = total_trips)) +
  geom_line(color = "tomato", size = 1) +
  labs(title = "Weekly Bike Usage by Casual Users",
       x = "Week",
       y = "Number of Trips") +
  theme_minimal()


casual_monthly_usage_viz <- ggplot(casual_monthly_usage, aes(x = month, y = total_trips)) +
  geom_line(color = "tomato", size = 1) +
  geom_point(color = "tomato", size = 2) +
  labs(title = "Monthly Bike Usage by Casual Users",
       x = "Month",
       y = "Number of Trips") +
  theme_minimal()
# promo strat

promo_data <- data.frame(
  strategy = c(
    "Early Bird Membership",
    "Frequent Casual Targeting",
    "Winter Membership Lock-In",
    "Spring Boost Campaign",
    "Summer-to-Member",
    "End-Year Loyalty Offer"
  ),
  start_month = as.Date(c(
    "2020-03-01", "2020-06-01", "2020-10-01",
    "2021-03-01", "2021-06-01", "2021-10-01"
  ))
)

promo_data$start_month <- as.POSIXct(promo_data$start_month)


promo_data_viz <- ggplot(casual_monthly_usage, aes(x = month, y = total_trips)) +
  geom_line(color = "tomato", size = 1) +
  geom_point(color = "tomato", size = 2) +
  geom_vline(data = promo_data, aes(xintercept = as.numeric(start_month)), 
             linetype = "dashed", color = "steelblue") +
  geom_text(data = promo_data, 
            aes(x = start_month, y = max(casual_monthly_usage$total_trips) * 0.95,
                label = strategy),
            angle = 90, vjust = -0.4, hjust = 0, size = 3.5, color = "steelblue") +
  labs(title = "Monthly Bike Usage by Casual Users (2020–2021)",
       x = "Month",
       y = "Number of Trips") +
  theme_minimal()

