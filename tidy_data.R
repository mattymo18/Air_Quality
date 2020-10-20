library(tidyverse)

Raleigh_Air <- read.csv("Source_Data/Raleigh_Air.csv") %>% 
  select(city, utc, parameter, value, latitude, longitude)
Greenville_Air <- read.csv("Source_Data/Greenville_Air.csv") %>% 
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

Greenville <- spread(Greenville_Air, key = parameter, value = value)

Greenville$utc = as.Date(Greenville$utc) 
Greenville$Time <- format(Greenville$utc,"%H:%M:%S")
Greenville = Greenville %>% 
  select(-Time)
Greenville.Clean <- Greenville %>% 
  group_by(utc, .drop = T) %>% 
  summarise(PM25 = mean(pm25)) %>% 
  mutate(Location = "Greenville") %>% 
  arrange(utc) %>% 
  select(Location, utc, PM25)

write.csv(Raleigh.Clean, "derived_data/Raleigh.Clean.csv")
write.csv(Greenville.Clean, "derived_data/Greenville.Clean.csv")





library(lubridate)

Confirmed_Cases <- read_csv("Source_Data/covid_confirmed_usafacts.csv")
Raleigh_Clean <- read_csv("derived_data/Raleigh.Clean.csv")

#Begin_Date = gsub("^0", "", format(min(Raleigh_Clean$utc), format = "%m/%d/%Y"))
#End_Date = gsub("^0", "", format(max(Raleigh_Clean$utc), format = "%m/%d/%Y"))
Confirmed_Cases_Raleigh <- subset(Confirmed_Cases, State =="NC" & countyFIPS == 37183, select = `1/22/20`:`10/18/20`)

day <- seq(10,21)
for (i in day) {
  Confirmed_Cases_Raleigh[[paste("1/", i,"/20",sep = "")]] = 0
}

Pivoted_Cases <- Confirmed_Cases_Raleigh %>%
  pivot_longer(cols = `1/22/20`:`1/21/20`,names_to = "utc", values_to = "Cases")

Pivoted_Cases$utc <- as.Date(Pivoted_Cases$utc, "%m/%d/%Y")
year(Pivoted_Cases$utc) <- 2020

Raleigh_Clean_COVID <- merge(Raleigh_Clean, Pivoted_Cases,by="utc")

write.csv(Raleigh_Clean_COVID, "derived_data/Raleigh.Clean.Covid.csv")



Greenville_Clean <- read_csv("derived_data/Greenville.Clean.csv")

#Begin_Date = gsub("^0", "", format(min(Greenville_Clean$utc), format = "%m/%d/%Y"))
#End_Date = gsub("^0", "", format(max(Greenville_Clean$utc), format = "%m/%d/%Y"))
Confirmed_Cases_Greenville <- subset(Confirmed_Cases, State =="NC" & countyFIPS == 37147, select = `1/22/20`:`10/18/20`)

day <- seq(10,21)
for (i in day) {
  Confirmed_Cases_Greenville[[paste("1/", i,"/20",sep = "")]] = 0
}

Pivoted_Cases <- Confirmed_Cases_Greenville %>%
  pivot_longer(cols = `1/22/20`:`1/21/20`,names_to = "utc", values_to = "Cases")

Pivoted_Cases$utc <- as.Date(Pivoted_Cases$utc, "%m/%d/%Y")
year(Pivoted_Cases$utc) <- 2020

Greenville_Clean_COVID <- merge(Greenville_Clean, Pivoted_Cases,by="utc")

write.csv(Greenville_Clean_COVID, "derived_data/Greenville.Clean.Covid.csv")
