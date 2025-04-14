Cyclistic 1.1
================
Andhika Nurrafli Putra
2025-04-09

So I have been work in this project before here I want to perfecting it,
after learning data analysis course now I want to showcase my Analysis
skill through this project.

## Determining the Business Questions

Base on the stakeholders, financial analysts from Cyclistic, users who
become members are more profitable than users who only use it for a day
or are casual. Then moreno believes that by increasing the number of
users who use members it will be more profitable than casual users.

So in this Case I will use these business questions to determine the
purpose of the analysis:  
1. How do annual members and casual riders use bikes differently?  
2. Why do casual riders purchase an annual membership to Cyclistic?  
3. How does Cyclistic use digital media to influence casual riders to
become members?  

This Analysis will produce:  
1. Clear statement of business task  
2. Description of all data sources used  
3. Documentation of data cleaning or manipulation steps  
4. Summary of analysis  
5. Supporting visualizations and key findings  
6. Top three recommendations based on analysis

### Loading the Environment

First thing first to do an RStudio, I will usually load the packages
that I needed to. So here is one the first packages I need to load.

``` r
library("arrow") # to load Parquet data that I have converted from CSV(s) before
```

    ## Warning: package 'arrow' was built under R version 4.4.3

    ## 
    ## Attaching package: 'arrow'

    ## The following object is masked from 'package:utils':
    ## 
    ##     timestamp

``` r
library("tidyverse")
```

    ## Warning: package 'tidyverse' was built under R version 4.4.2

    ## Warning: package 'lubridate' was built under R version 4.4.2

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.4     ✔ tidyr     1.3.1
    ## ✔ purrr     1.0.2

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ lubridate::duration() masks arrow::duration()
    ## ✖ dplyr::filter()       masks stats::filter()
    ## ✖ dplyr::lag()          masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
library("knitr")
```

    ## Warning: package 'knitr' was built under R version 4.4.2

## Preparing the Data

### Dataset

I got this dataset from Coursera’s [“Google data analitik
Course”](https://divvy-tripdata.s3.amazonaws.com/index.html), I took two
years of data from the website to produce a good analysis. At first I
need to convert the data from .csv to .parquet so I can load the in
RStudio more easily and it saves some spaces in my local database. I
convert the data using python here is the code:

``` python
import pandas as pd
import os

folder_path = r"D:\Studying\Data Analyst Projects\Project 2.1\Data"

csv_files = [f for f in os.listdir(folder_path) if f.endswith('.csv')]

for file in csv_files:
    csv_path = os.path.join(folder_path, file)
    parquet_path = os.path.join(folder_path, file.replace('.csv', '.parquet'))
    
    print(f"Converting {file} to Parquet format...")
    df = pd.read_csv(csv_path)
    df.to_parquet(parquet_path,engine='pyarrow', index=False)
    
print ("Conversion completed.")
```

After I convert the datasets that I got, then I combined them into one
.parquet data using python also here is the code:

``` python
import os
import duckdb
import pandas as pd

folder_path = r"D:\Studying\Data Analyst Projects\Project 2.1\Data"

parquet_files = [f for f in os.listdir(folder_path) if f.endswith('.parquet')]

all_data = []

for file in parquet_files:
    full_path = os.path.join(folder_path, file).replace("\\", "/")
    print(f"Reading {full_path}...")
    df = duckdb.query(f"SELECT * FROM '{full_path}'").to_df()
    
    df["source_file"] = file
    all_data.append(df)
    
combined_df = pd.concat(all_data, ignore_index=True)
print("All data combined.")
output_path = os.path.join(folder_path, "combined_data.parquet").replace("\\", "/")

# Convert ID columns to string
# because parquet files are not compatible with int64
# and duckdb will convert them to int64
combined_df['start_station_id'] = combined_df['start_station_id'].astype(str)
combined_df['end_station_id'] = combined_df['end_station_id'].astype(str)

# Save to parquet
combined_df.to_parquet(output_path, engine="pyarrow", index=False)

output_path = os.path.join(folder_path, "combined_data.parquet").replace("\\", "/")
combined_df.to_parquet(output_path, engine="pyarrow", index=False)
print(f"Combined data saved to {output_path}.")
```

That’s all the data that I will use in this analysis. Next up we will
prepare the data, in this process we will load and cleaning the data.

### Loading the Data

I have convert the original data which is in .csv format into .parquet
format, so I can load it easily and save some space on my computer.

``` r
data <- read_parquet("combined_data.parquet")
```

Next step is cleaning the data.

### Cleaning the Data

Now we’re cleaning the data so we can verified the data is usable and
hope to not make a bias that can affect the data.

``` r
data_cleaned <- drop_na(data)
```

## Processing the Data

### Checking data for error

Checking for error in data, this include converting the data into
another string or filtering out outliers to make sure analysis running
smoothly.

``` r
str(data_cleaned)
```

    ## tibble [7,978,555 × 14] (S3: tbl_df/tbl/data.frame)
    ##  $ ride_id           : chr [1:7978555] "A847FADBBC638E45" "5405B80E996FF60D" "5DD24A79A4E006F4" "2A59BBDF5CDBA725" ...
    ##  $ rideable_type     : chr [1:7978555] "docked_bike" "docked_bike" "docked_bike" "docked_bike" ...
    ##  $ started_at        : chr [1:7978555] "2020-04-26 17:45:14" "2020-04-17 17:08:54" "2020-04-01 17:54:13" "2020-04-07 12:50:19" ...
    ##  $ ended_at          : chr [1:7978555] "2020-04-26 18:12:03" "2020-04-17 17:17:03" "2020-04-01 18:08:36" "2020-04-07 13:02:31" ...
    ##  $ start_station_name: chr [1:7978555] "Eckhart Park" "Drake Ave & Fullerton Ave" "McClurg Ct & Erie St" "California Ave & Division St" ...
    ##  $ start_station_id  : chr [1:7978555] "86" "503" "142" "216" ...
    ##  $ end_station_name  : chr [1:7978555] "Lincoln Ave & Diversey Pkwy" "Kosciuszko Park" "Indiana Ave & Roosevelt Rd" "Wood St & Augusta Blvd" ...
    ##  $ end_station_id    : chr [1:7978555] "152.0" "499.0" "255.0" "657.0" ...
    ##  $ start_lat         : num [1:7978555] 41.9 41.9 41.9 41.9 41.9 ...
    ##  $ start_lng         : num [1:7978555] -87.7 -87.7 -87.6 -87.7 -87.6 ...
    ##  $ end_lat           : num [1:7978555] 41.9 41.9 41.9 41.9 42 ...
    ##  $ end_lng           : num [1:7978555] -87.7 -87.7 -87.6 -87.7 -87.7 ...
    ##  $ member_casual     : chr [1:7978555] "member" "member" "member" "member" ...
    ##  $ source_file       : chr [1:7978555] "202004-divvy-tripdata.parquet" "202004-divvy-tripdata.parquet" "202004-divvy-tripdata.parquet" "202004-divvy-tripdata.parquet" ...

``` r
# so there is data that has date in it but the string say it is a chr, here i'm gonna make it into date format

library(lubridate)

data_cleaned$started_at <- ymd_hms(data_cleaned$started_at)
data_cleaned$ended_at <- ymd_hms(data_cleaned$ended_at)

# creating new column ride duration
data_cleaned$ride_duration <- as.numeric(difftime(data_cleaned$ended_at, data_cleaned$started_at, units = "mins"))
data_cleaned$ride_duration <- round(data_cleaned$ride_duration)
summary(data_cleaned$ride_duration)
```

    ##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
    ## -29050.00      7.00     13.00     23.29     24.00 156450.00

``` r
# there is a minus value in Minimum of ride_duration I need to fix this by deleting it because it is not valid

data_cleaned <- subset(data_cleaned, ride_duration >= 0)
summary(data_cleaned)
```

    ##    ride_id          rideable_type        started_at                    
    ##  Length:7976631     Length:7976631     Min.   :2020-01-01 00:04:44.00  
    ##  Class :character   Class :character   1st Qu.:2020-08-21 12:57:05.50  
    ##  Mode  :character   Mode  :character   Median :2021-04-27 17:50:39.00  
    ##                                        Mean   :2021-02-20 05:26:28.46  
    ##                                        3rd Qu.:2021-08-10 18:08:55.50  
    ##                                        Max.   :2021-12-31 23:59:48.00  
    ##     ended_at                      start_station_name start_station_id  
    ##  Min.   :2020-01-01 00:10:54.00   Length:7976631     Length:7976631    
    ##  1st Qu.:2020-08-21 13:26:12.50   Class :character   Class :character  
    ##  Median :2021-04-27 18:15:11.00   Mode  :character   Mode  :character  
    ##  Mean   :2021-02-20 05:50:53.98                                        
    ##  3rd Qu.:2021-08-10 18:27:28.00                                        
    ##  Max.   :2022-01-03 17:32:18.00                                        
    ##  end_station_name   end_station_id       start_lat       start_lng     
    ##  Length:7976631     Length:7976631     Min.   :41.65   Min.   :-87.83  
    ##  Class :character   Class :character   1st Qu.:41.88   1st Qu.:-87.66  
    ##  Mode  :character   Mode  :character   Median :41.90   Median :-87.64  
    ##                                        Mean   :41.90   Mean   :-87.64  
    ##                                        3rd Qu.:41.93   3rd Qu.:-87.63  
    ##                                        Max.   :42.06   Max.   :-87.53  
    ##     end_lat         end_lng       member_casual      source_file       
    ##  Min.   :41.65   Min.   :-87.83   Length:7976631     Length:7976631    
    ##  1st Qu.:41.88   1st Qu.:-87.66   Class :character   Class :character  
    ##  Median :41.90   Median :-87.64   Mode  :character   Mode  :character  
    ##  Mean   :41.90   Mean   :-87.64                                        
    ##  3rd Qu.:41.93   3rd Qu.:-87.63                                        
    ##  Max.   :42.17   Max.   :-87.52                                        
    ##  ride_duration      
    ##  Min.   :     0.00  
    ##  1st Qu.:     7.00  
    ##  Median :    13.00  
    ##  Mean   :    24.42  
    ##  3rd Qu.:    24.00  
    ##  Max.   :156450.00

``` r
# so there is still outliers I can determining it by using IQR
Q1 <- as.numeric(quantile(data_cleaned$ride_duration, 0.25))
Q3 <- as.numeric(quantile(data_cleaned$ride_duration, 0.75))
IQR_val <- IQR(data_cleaned$ride_duration)
# so we will continue to determine lower and upper bound so we can filter out the outliers
lower_bound <- Q1 - 1.5 * 17
upper_bound <- Q3 + 1.5 * 17  

data_no_outliers <- data_cleaned %>%
  filter(ride_duration >= 0 ,ride_duration<= upper_bound)
```

So we are already filtering out the outliers, transforming data into
string that we needed and onto the next step is I want to add
day_of_week column

``` r
data_no_outliers <- data_no_outliers %>%
  mutate(
    started_at = as.POSIXct(started_at),
    day_of_week = wday(started_at, week_start = 7,),
    day_of_week_label = wday(started_at, week_start = 7, label = TRUE)
  )
```

Finally we finish transforming some column, add columns and let’s we
move to the next step which we’re gonna explore the data.  
\### Exploring the data

After we’re cleaning the data and finally we can comfortably to explore
the data looking for the business task and finds out what we can do with
the data.  
So first we need to state what we’re gonna find in this data and what to
expect:  
1. We need to visualize how the casual and member use the bike
differently.  
2. Find out why casual riders wants to buy membership 3. Promoting using
media digital to influence casual riders want to buy membership.  

First we need to find patters how do casual and membership riders use
the bike.

``` r
summary_usage <- data_no_outliers %>% 
  group_by(member_casual, day_of_week_label) %>% 
  summarise(total_rides = n()) %>% 
  ungroup() # the grouping stop right here eheh
```

    ## `summarise()` has grouped output by 'member_casual'. You can override using the
    ## `.groups` argument.

``` r
summary_usage$day_of_week_label <- factor(
  summary_usage$day_of_week_label,
  levels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
)

# Visualize it

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

usage_base_on_dow
```

![](Project-Markdown_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

Base on the visualization we can see that:  
**1. Member users tend to commute by bike**  
Member users mostly use bikes on weekdays, which suggests they are more
likely using them to commute to work.  

**2. Casual users are tourists**  
We can observe that bike usage is higher on weekends than on weekdays.
This pattern suggests that tourists often visit the city on weekends and
use bikes for leisure or sightseeing.  

Next step is we’re gonna find **how casual users wants to buy
membership**. So we are gonna find the patterns on why is casual user
*converting* into membership.  
First thing we thought is casual user become a membership is because
they need to commute everyday, with divvy is one of the reliable bike
sharing service, it can be one of the reasons why casual users are
buying the membership.  
We try to check the usage frequency of the casual users who will become
the potential to buy the membership.

``` r
# base on usage per date
frequent_casual <- data_no_outliers %>%
  filter(member_casual == "casual") %>%
  mutate(week = lubridate::week(started_at)) %>%
  group_by(week, started_at_date = as.Date(started_at)) %>%  # per date
  summarise(trips = n(), .groups = "drop") %>%
  filter(trips >= 3)
nrow(frequent_casual)
```

    ## [1] 729

``` r
# base on usage per week
casual_weekly <- data_no_outliers %>%
  filter(member_casual == "casual") %>%
  mutate(week = lubridate::week(started_at)) %>%
  group_by(week) %>%
  summarise(total_trips = n())
nrow(casual_weekly)
```

    ## [1] 53

Now that we have a picture of potential membership users we now need to
promoting the divvy bike service. We need to find when is the time to
promote our membership to potential casual users who already we see.  
We can first now to find when to start the promotion.

``` r
casual_monthly_usage <- data_no_outliers %>%
  filter(member_casual == "casual") %>%
  mutate(month = floor_date(started_at, unit = "month")) %>%
  group_by(month) %>%
  summarise(total_trips = n(), .groups = "drop")

casual_monthly_usage_viz <- ggplot(casual_monthly_usage, aes(x = month, y = total_trips)) +
  geom_line(color = "tomato", size = 1) +
  geom_point(color = "tomato", size = 2) +
  labs(title = "Monthly Bike Usage by Casual Users",
       x = "Month",
       y = "Number of Trips") +
  theme_minimal()
```

    ## Warning: Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0.
    ## ℹ Please use `linewidth` instead.
    ## This warning is displayed once every 8 hours.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
    ## generated.

``` r
casual_monthly_usage_viz
```

![](Project-Markdown_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

We now can check that how the numbers of casual user usage patterns
based on the visualization.

### Analyzing the Data

Based on the visualization of the data and data that we have explored
before.  
**1. Patterns on how Casual users and Membership using the bike**
*Member users tend to commute by bike*  
Member users mostly use bikes on weekdays, which suggests they are more
likely using them to commute to work.  

*Casual users are tourists*  
We can observe that bike usage is higher on weekends than on weekdays.
This pattern suggests that tourists often visit the city on weekends and
use bikes for leisure or sightseeing.

``` r
usage_base_on_dow
```

![](Project-Markdown_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

**2. Why Casual users want to buy membership** First thing we thought is
casual user become a membership is because they need to commute
everyday, with divvy is one of the reliable bike sharing service, it can
be one of the reasons why casual users are buying the membership.  
We try to check the usage frequency of the casual users who will become
the potential to buy the membership.

``` r
frequent_casual
```

    ## # A tibble: 729 × 3
    ##     week started_at_date trips
    ##    <dbl> <date>          <int>
    ##  1     1 2020-01-01        390
    ##  2     1 2020-01-02        550
    ##  3     1 2020-01-03        405
    ##  4     1 2020-01-04        343
    ##  5     1 2020-01-05        361
    ##  6     1 2020-01-06        259
    ##  7     1 2020-01-07        331
    ##  8     1 2021-01-01        202
    ##  9     1 2021-01-02        413
    ## 10     1 2021-01-03        442
    ## # ℹ 719 more rows

``` r
casual_monthly_usage
```

    ## # A tibble: 24 × 2
    ##    month               total_trips
    ##    <dttm>                    <int>
    ##  1 2020-01-01 00:00:00        6744
    ##  2 2020-02-01 00:00:00       10764
    ##  3 2020-03-01 00:00:00       22377
    ##  4 2020-04-01 00:00:00       18659
    ##  5 2020-05-01 00:00:00       65092
    ##  6 2020-06-01 00:00:00      118206
    ##  7 2020-07-01 00:00:00      198705
    ##  8 2020-08-01 00:00:00      225067
    ##  9 2020-09-01 00:00:00      179346
    ## 10 2020-10-01 00:00:00      107016
    ## # ℹ 14 more rows

Now that we know how is the numbers now let’s try to take a look at the
visualization.

``` r
casual_monthly_usage_viz
```

![](Project-Markdown_files/figure-gfm/unnamed-chunk-11-1.png)<!-- --> We
can see the ups and downs of the number of casual users, we can see why.
The visualization is clearly a seasonal pattern over the course of 2020
and 2021. Usage are tends to peak in warmer seasons which is in spring
and summer (May to August) and drop in colder season especially in
Winter(December to February)  This trends suggest that casual users are
likely influenced by the weather conditions, with more people are more
likely to ride on warmer season. Conversely, the cold and snowy winter
months discourage casual riders, leading to steep decline in trips.  
These seasonal patterns imply that casual users are primarily
recreational riders or tourists who are more active during
vacation-friendly seasons and less consistent during periods of
inclement weather.  

## Sharing Findings

### Recommendations on Promotion Strategy

To improve the numbers of membership we can convert casual riders or
users by setting a pattern of promotions, which I suggest:  
Promotional Strategies to Convert Casual Users into Members  

**1. Seasonal Membership Discounts**  
*Offer time-limited membership discounts during late summer and early
fall (e.g., August–September)*, when casual usage is still high but may
begin to decline. This is an ideal opportunity to encourage frequent
casual riders to switch to membership for continued savings.  

**2. Membership Trial Programs**  
*Provide a 7-day or 14-day free trial membership for casual users who
ride multiple times in a short period*. Target users who have used the
service at least 3 times in a week to increase the likelihood of
conversion.  

**3. Weather-Based Campaigns**  
*Launch special promotions in the spring (around March–April) to
coincide with rising casual usage after winter*. This can include
early-bird membership deals or bundled offers with local attractions to
encourage new members ahead of peak season.  

**4. Targeted In-App Notifications**  
Use ride history data to identify casual users with frequent usage and
send personalized offers or reminders about membership benefits via
email or mobile app notifications.  

**5. Weekend-to-Weekday Perks**  
Encourage casual users who ride mostly on weekends to use the service
during weekdays by offering weekday ride bonuses for members, promoting
the flexibility and value of being a full-time member.  

Now we will try to put the suggestions base on the last data where we
should put it.

``` r
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
# convert it to posixct
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

promo_data_viz
```

![](Project-Markdown_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->
