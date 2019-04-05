# Script to streamline HOBO temperature checking ####
library(tidyverse)
library(lubridate)

# Manually read in 1 file (target format)
goal <- read_csv("./Elizabeth_temps/20190330_FormatedHOBOFloats.csv") 

# Pull in all raw CSV files at once ####

# Define the path where all the raw files are
path <- "Elizabeth_temps/HOBO_20190330_Bottom8Tanks/Orginial Data_Do Not touch"

# Pull in the names of all raw files
files <- dir(path, pattern = "*.csv")

# Read in all files from the path
raw <- tibble(filename = files) %>%
  mutate(file_contents= map(filename, 
                            ~ read_csv(file.path(path, .)))) %>%
  separate(filename, c('SN','SerialNum', 'Date'), sep = " ") %>%
  select(SerialNum, Date, file_contents)


tbl <- list.files(path = path, pattern = "*.csv", full.names=TRUE) %>% 
  map_df(~read_csv(., skip=2))



####################
raw_dir <- paste("FieldData/",Site,sep="")
out_dir <- "Ch2Model"


## LOAD RAW DATA ------------
# get file names: 
pattern = "*.csv" # for identifying files to read
files <- list.files(path, pattern=pattern, full.names=TRUE)

# load data into lists
read_and_label <- function(x,...){
  z <- fread(x,...)
  
  # add file name without the extension as id column
  pattern <- "(.*\\/)([^.]+)(\\.csv$)"
  z$ids <- sub(pattern, "\\2", x)
  z
}