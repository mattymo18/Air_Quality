library(tidyverse)

Raleigh_Air <- read.csv("Source_Data/Raleigh_Air.csv") %>% 
  select(city, utc, parameter, value, latitude, longitude)
Raleigh <- na.omit(spread(Raleigh_Air, key = parameter, value = value))

Raleigh$utc = as.Date(Raleigh$utc) 
Raleigh$Time <- format(Raleigh$utc,"%H:%M:%S")
Raleigh = Raleigh %>% 
  select(-Time)
Raleigh.Clean <- Raleigh %>% 
  group_by(utc, .drop = T) %>% 
  summarise(CO = mean(co), 
            NO2 = mean(no2), 
            O3 = mean(o3), 
            PM10 = mean(pm10), 
            PM25 = mean(pm25), 
            SO2 = mean(so2)) %>% 
  mutate(Location = "Raleigh") %>% 
  arrange(utc) %>% 
  select(Location, utc, CO, NO2, O3, PM10, PM25, SO2)

write.csv(Raleigh.Clean, "derived_data/Raleigh.Clean.csv")


