# Script to streamline HOBO temperature checking ####
library(tidyverse)
library(lubridate)

# Read in HOBO-treatment ID combinations
trts <- read_csv('./Elizabeth_temps/HOBO_list.csv')

# Pull in all raw CSV files at once ####
# Set a function to pull in file name (serial number) during read_csv
read_plus <- function(flnm) {
  read_csv(flnm, skip=2) %>% 
    mutate(filename = flnm) %>% 
    separate(filename, into = c('junk','HOBO_Number'), sep = ' ', remove=T) %>% 
    mutate(HOBO_Number = as.numeric(HOBO_Number))
}

# Define the folder path where all the raw files are
path <- "./Elizabeth_temps/HOBO_20190330_Bottom8Tanks/Orginial Data_Do Not touch/"
setwd(path)

# Read in all .csv files within the folder 
data <- list.files(pattern="*.csv", full.names = T) %>% 
  map_df(~read_plus(.)) %>% 
  rename(Date_Time = "Date Time - GMT -05:00", Temperature_C = "Temp, (*C)") %>% 
  mutate(Date_Time = ymd_hms(Date_Time), Date = as.Date(Date_Time), 
         Time = paste(hour(Date_Time),minute(Date_Time), sep=":")) %>% 
  left_join(., trts) %>% 
  select(Date_Time, Date, Time, HOBO_Number, Tank_ID, Treatment, Location, 
         Temperature_C, "Host Connect", EOF)

# Quick plot to check temperatures ####
ggplot(data, aes(x = Date_Time, y = Temperature_C, col = Treatment)) + 
  geom_line() +
  facet_wrap(Treatment ~ Tank_ID, ncol=2)
