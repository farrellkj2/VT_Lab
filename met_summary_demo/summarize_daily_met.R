#### Demo for summarizing met station data by day using tidyverse ####
# install.packages('tidyverse')
library(tidyverse)

raw <- read_csv('./met_summary_demo/FCR_GLM_met_NLDAS2_010113_010118_GMTadjusted.csv')
head(raw) # View data preview with auto-parsed structures 

# Calculate all statistics for all varaibles, then drop the ones you don't need
met <- raw %>%                                                 # start with the raw data
  mutate(Date = as.Date(time, format="%Y-%m-%d hh:mm:ss")) %>% # create a column of just the date
  select(-time) %>%                                            # drop the datetime column
  group_by(Date) %>%                                           # group by date (for daily statistics)
  summarise_all(c("min", "median", "max","sum")) %>%           # get min, median, max, and sum for all variables each day
  select(-(ShortWave_sum:WindSpeed_sum), -Rain_min, -Rain_median, -Rain_max) %>% # drop calcs you don't want
  select(Date, noquote(order(colnames(.))))                    # arrange columns alphabetically after Date

View(met) # Look at your output

# Reshape to "long" data for ease of plotting
met_long <- met %>% 
  gather(Metric, Value, AirTemp_max:WindSpeed_min) %>%
  separate(Metric, c('Variable','Statistic'), sep='_')

ggplot(met_long, aes(x = Date, y = Value, group = Variable, col = Statistic)) +
  geom_line() +
  facet_grid(Variable ~ ., scales = "free_y")

# Add extra stuff to file as example of reverting to previous commit
ggplot(subset(met_long, Variable == "AirTemp" & Statistic == "max"), aes(x = Date, y = Value, group = Variable, col = Statistic)) +
  geom_line()
