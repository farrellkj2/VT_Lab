# Script to streamline HOBO temperature checking ####
library(tidyverse)
library(lubridate)

# Read in HOBO-treatment ID combinations
trts <- read_csv('./Elizabeth_temps/HOBO_list.csv')

# Pull in all raw CSV files at once ####
# Set a function to pull in file name (serial number) during read_csv
read_plus <- function(flnm) {
  read_csv(flnm, skip=2) %>% 
    mutate(filename = flnm, 
           HOBO_Number = as.numeric(substring(filename, 6,13)))  
   # separate(filename, into = c('junk','HOBO_Number'), sep = ' ', remove=T) %>% 
   # mutate(HOBO_Number = as.numeric(HOBO_Number))
}

# Define the folder path where all the raw files are
path <- "./Elizabeth_temps/HOBO_20190330_Bottom8Tanks/Orginial Data_Do Not touch/"
setwd(path)

start_date <- '2019-03-15'

# Read in all .csv files within the folder 
data <- list.files(pattern="*.csv", full.names = T) %>% 
  map_df(~read_plus(.)) %>% 
  rename(Date_Time = "Date Time - GMT -05:00", Temperature_C = "Temp, (*C)") %>% 
  mutate(Date_Time = ymd_hms(Date_Time), Date = as.Date(Date_Time), 
         Time = paste(hour(Date_Time),minute(Date_Time), sep=":")) %>% 
  left_join(., trts) %>% 
  select(Date_Time, Date, Time, HOBO_Number, Tank_ID, Treatment, Location, 
         Temperature_C, "Host Connect", EOF) %>% 
  filter(Date >= start_date, 
         !is.na(Temperature_C)) # keep temperatures that are not NA

# Quick plot to check temperatures ####
ggplot(data, aes(x = Date_Time, y = Temperature_C, col = Treatment)) + 
  geom_line() +
  facet_wrap(Treatment ~ Tank_ID, ncol=2)


# Calculate daily summary temps ####
summary_tanks <- data %>% 
  group_by(Tank_ID, Treatment, Date) %>% 
  summarize(min = min(Temperature_C), 
            mean = round(mean(Temperature_C),2), 
            max = max(Temperature_C))

summary_trt <- data %>% 
  group_by(Treatment, Date) %>% 
  summarize(min = min(Temperature_C), 
            mean = round(mean(Temperature_C),2), 
            max = max(Temperature_C))

# Plot daily max. by treatment
ggplot(summary_trt, aes(x = Date, y = max, col=Treatment)) +
  geom_line() + geom_point()

ggplot(summary_tanks, aes(x = Date, y = max, col=Tank_ID)) +
  geom_line() + geom_point() +
  facet_wrap(. ~ Treatment) +
  scale_x_date(date_breaks = "2 days", date_labels="%m-%d")
