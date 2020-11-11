library(tidyverse)
library(gridExtra)


#load in data

Gdat<-read.csv("derived_data/Greenville.Clean.Covid.csv")
Rdat<-read.csv("derived_data/Raleigh.Clean.Covid.csv")

g1 <- Gdat %>% 
  ggplot(aes(x = Cases, y = PM25)) +
  geom_point(alpha = .5, color = "Purple") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  ggtitle("Greenville") +
  ylab("Particulate Matter 2.5") +
  theme(plot.title = element_text(hjust = 0.5))
g2 <- Rdat %>% 
  ggplot(aes(x = Cases, y = PM25)) +
  geom_point(alpha = .5, color = "Red") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))  +
  ggtitle("Raleigh") +
  ylab("Particulate Matter 2.5") +
  theme(plot.title = element_text(hjust = 0.5))

Graph1 <- grid.arrange(g1, g2, nrow = 1)
ggsave("derived_graphs/PM25.Vs.Cases.plot.png", plot = Graph1)

g3 <-  Gdat %>% 
  ggplot(aes(x = as.Date(utc, "%Y-%m-%d"), y = PM25)) +
  geom_point(alpha = .5, color = "Purple") +
  geom_line(color = "Purple")  +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  ggtitle("Greenville") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Particulate Matter 2.5") +
  xlab("Date")

g4 <-  Rdat %>% 
  ggplot(aes(x = as.Date(utc, "%Y-%m-%d"), y = PM25)) +
  geom_point(alpha = .5, color = "Red") +
  geom_line(color = "Red")  +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  ggtitle("Raleigh") +
  ylab("Particulate Matter 2.5") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Particulate Matter 2.5") +
  xlab("Date")

Graph2 <- grid.arrange(g3, g4, nrow = 1)
ggsave("derived_graphs/Time.Vs.PM25.plot.png", plot = Graph2)

g5 <- Gdat %>% 
  ggplot(aes(x = as.Date(utc, "%Y-%m-%d"), y = Cases)) +
  geom_point(alpha = .5, color = "Purple") +
  geom_line(color = "Purple")  +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  ggtitle("Greenville") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Covid-19 Cases") +
  xlab("Date")

g6 <- Rdat %>% 
  ggplot(aes(x = as.Date(utc, "%Y-%m-%d"), y = Cases)) +
  geom_point(alpha = .5, color = "Red") +
  geom_line(color = "Red")  +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  ggtitle("Raleigh") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Covid-19 Cases") +
  xlab("Date")

Graph3 <- grid.arrange(g5, g6, nrow = 1)
ggsave("derived_graphs/Time.Vs.Cases.plot.png", plot = Graph3)  

PM25.data <- rbind(Gdat[, c(4, 5)] , Rdat[, c(4, 9)])

g7 <- PM25.data %>% 
  ggplot(aes(y = PM25, x = Location)) +
  geom_boxplot(aes(color = Location)) + 
  geom_jitter(aes(color = Location), alpha = .5) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  ggtitle("Particulate Matter 2.5") +
  ylab("Particulate Matter 2.5") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_color_manual(breaks = c("Greenville", "Raleigh"), values=c("Purple", "Red")) 
ggsave("derived_graphs/PM25.boxplot.png", plot = g7)

Full.data <- read.csv("derived_data/DF.Final.csv")


g8 <- Full.data %>% 
  ggplot(aes(y = Cases, x = Location)) +
  geom_boxplot(aes(color = Location)) +
  geom_jitter(aes(color = Location), alpha = .5) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  ggtitle("Number of Total Cases") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Cases") +
  scale_color_manual(breaks = c("Greenville", "Raleigh"), values=c("Purple", "Red"))

ggsave("derived_graphs/Total.Cases.boxplot.png", plot = g8)

Full.data = Full.data %>% 
  mutate(New_Cases = Cases - lag(Cases)) 
Full.data$New_Cases[205] = 0
Full.data$New_Cases[1] = 0
Full.data = Full.data %>% 
  filter(New_Cases > 0)

g9 <- Full.data %>% 
  ggplot(aes(y = New_Cases, x = Location)) +
  geom_boxplot(aes(color = Location)) +
  geom_jitter(aes(color = Location), alpha = .5) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  ggtitle("Number of Cases per Day") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Cases per Day") +
  scale_color_manual(breaks = c("Greenville", "Raleigh"), values=c("Purple", "Red"))

ggsave("derived_graphs/Per.Day.Cases.boxplot.png", plot = g9)