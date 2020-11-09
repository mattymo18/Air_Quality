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


Greenville_raw <- read_csv("Source_Data/Greenville.csv")

Greenville <- spread(Greenville_raw, key = parameter, value = value)

Greenville$utc = as.Date(Greenville$utc) 
Greenville$Time <- format(Greenville$utc,"%H:%M:%S")

Greenville <- Greenville %>% dplyr::select(-Time)

Greenville.Clean <- Greenville %>% 
  group_by(utc, .drop = T) %>% 
  dplyr::summarise(O3 = mean(o3, na.rm=T), 
                   PM25 = mean(pm25, na.rm=T)) %>% 
  mutate(Location = "Greenville") %>%
  dplyr::arrange(utc) %>% 
  dplyr::select(Location, utc, PM25, O3)

Confirmed_Cases_Greenville <- subset(Confirmed_Cases, State =="SC" & countyFIPS == 45045, select = `1/22/20`:`10/18/20`)

day <- seq(10,21)
for (i in day) {
  Confirmed_Cases_Greenville[[paste("1/", i,"/20",sep = "")]] = 0
}

Pivoted_Cases <- Confirmed_Cases_Greenville %>%
  pivot_longer(cols = `1/22/20`:`1/21/20`,names_to = "utc", values_to = "Cases")

Pivoted_Cases$utc <- as.Date(Pivoted_Cases$utc, "%m/%d/%Y")
year(Pivoted_Cases$utc) <- 2020

Greenville_Clean_COVID_PM25_O3 <- merge(Greenville.Clean, Pivoted_Cases,by="utc")

write.csv(Greenville_Clean_COVID_PM25_O3,"derived_data/Greenville_Clean_COVID_PM25_O3.csv")


df.greenville <- read_csv("derived_data/Greenville_Clean_COVID_PM25_O3.csv")
df.raleigh <- read_csv("derived_data/Raleigh.Clean.Covid.csv")
DF <- plyr::rbind.fill(df.raleigh, df.greenville)

DF$newcases <- NA
DF$newcases[DF$Location == 'Raleigh'][-1] <- diff(DF$Cases[DF$Location == 'Raleigh'])
DF$newcases[DF$Location == 'Greenville'][-1] <- diff(DF$Cases[DF$Location == 'Greenville'])

DF$Population <- NA
DF[DF$Location == "Raleigh",'Population'] <- 474069
DF[DF$Location == "Greenville",'Population'] <-  523542

DF$newcasesper <- NA
DF$newcasesper <- DF$newcases/DF$Population

DF[DF$Location == "Raleigh",'newcasesper'] <- lead(DF[DF$Location == "Raleigh",'newcasesper'], 6)
DF[DF$Location == "Greenville",'newcasesper'] <- lead(DF[DF$Location == "Greenville",'newcasesper'], 6)

DFreg <- DF[!is.na(DF$O3) & !is.na(DF$newcasesper),] %>%
  dplyr::select(X1, utc, Location, O3, PM25, newcasesper, Cases)

write.csv(DFreg, "derived_data/DF.Final.No.Binary.csv")

DF <- DFreg

#lets add binaries for stay at home and bars closing
DF = DF %>% 
  mutate(numerical_day = as.numeric(utc))
DF.full = DF %>% 
  mutate(Stay_At_Home = ifelse(DF$Location == "Greenville" & 
                                 DF$numerical_day >= 85 & 
                                 DF$numerical_day <= 111, 1, ifelse(DF$Location == "Raleigh" &
                                                                      DF$numerical_day >= 77 &
                                                                      DF$numerical_day <= 139, 1, 0))) %>% 
  mutate(Bar_Close = ifelse(DF$Location == "Greenville" &
                              DF$numerical_day >= 78 &
                              DF$numerical_day <= 111, 1, ifelse(DF$Location == "Raleigh" &
                                                                   DF$numerical_day >= 66 &
                                                                   DF$numerical_day <= 257, 1, 0))) %>% 
  select(-numerical_day)
DF.full$Stay_At_Home <- factor(DF.full$Stay_At_Home)
DF.full$Bar_Close <- factor(DF.full$Bar_Close)

write.csv(DF.full, "derived_data/DF.Final.csv")