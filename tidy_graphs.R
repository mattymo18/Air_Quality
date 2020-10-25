library(tidyverse)
library(gridExtra)


#load in data

Gdat<-read.csv("derived_data/Greenville.Clean.Covid.csv")
Rdat<-read.csv("derived_data/Raleigh.Clean.Covid.csv")

g1 <- Gdat %>% 
  ggplot(aes(x = Cases, y = PM25)) +
  geom_point(alpha = .5, color = "Red") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  ggtitle("Raleigh") +
  theme(plot.title = element_text(hjust = 0.5))
g2 <- Rdat %>% 
  ggplot(aes(x = Cases, y = PM25)) +
  geom_point(alpha = .5, color = "Purple") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))  +
  ggtitle("Greenville") +
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
  ylab("Particulate Matter 2.5") +
  xlab("Date")

g6 <- Rdat %>% 
  ggplot(aes(x = as.Date(utc, "%Y-%m-%d"), y = Cases)) +
  geom_point(alpha = .5, color = "Red") +
  geom_line(color = "Red")  +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  ggtitle("Raleigh") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Particulate Matter 2.5") +
  xlab("Date")

Graph3 <- grid.arrange(g6, g5, nrow = 1)
ggsave("derived_graphs/Time.Vs.Cases.plot.png", plot = Graph3)  


