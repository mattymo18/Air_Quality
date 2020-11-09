library(tidyverse)
library(gridExtra)
Gdat<-read.csv("derived_data/Greenville.Clean.Covid.csv")
Rdat<-read.csv("derived_data/Raleigh.Clean.Covid.csv")
#initialize variables
t<-Gdat[,2]
gtime<-as.Date(t, "%Y-%m-%d")
Gpm<-Gdat[,5]
Gcase<-Gdat[,6]

d<-Rdat[,2]
rtime<-as.Date(d, "%Y-%m-%d")
Rpm<-Rdat[,9]
Rcase<-Rdat[,11]

#caeses acf for greenville
GC.acf <- acf(Gcase)
GC.acf.df <- with(GC.acf, data.frame(lag, acf))
#pm acf for greenville
GPM.acf <- acf(Gpm)
GPM.acf.df <- with(GPM.acf, data.frame(lag, acf))

#cases acf for Raleigh
RC.acf <- acf(Rcase)
RC.acf.df <- with(RC.acf, data.frame(lag, acf))
#pm acf for raleigh
RPM.acf <- acf(Rpm)
RPM.acf.df <- with(RPM.acf, data.frame(lag, acf))

#greenville Cases acf
g1 <- GC.acf.df %>% 
  ggplot(aes(x = lag, y = acf)) +
  geom_hline(aes(yintercept = 0), color = "black") +
  geom_hline(aes(yintercept = .1), color = "purple", linetype = "dashed") +
  geom_hline(aes(yintercept = -.1), color = "purple", linetype = "dashed") +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  geom_segment(aes(xend = lag, yend = 0)) +
  xlim(0, 24) +
  xlab("Lag") +
  ylab("ACF") +
  ggtitle("Greenville Cases")

#greenville pm acf
g2 <- GPM.acf.df %>% 
  ggplot(aes(x = lag, y = acf)) +
  geom_hline(aes(yintercept = 0), color = "black") +
  geom_hline(aes(yintercept = .1), color = "purple", linetype = "dashed") +
  geom_hline(aes(yintercept = -.1), color = "purple", linetype = "dashed") +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  geom_segment(aes(xend = lag, yend = 0)) +
  xlim(0, 24) +
  xlab("Lag") +
  ylab("ACF") +
  ggtitle("Greenville PM 2.5")

#Raleigh cases acf
g3 <- RC.acf.df %>% 
  ggplot(aes(x = lag, y = acf)) +
  geom_hline(aes(yintercept = 0), color = "black") +
  geom_hline(aes(yintercept = .1), color = "red", linetype = "dashed") +
  geom_hline(aes(yintercept = -.1), color = "red", linetype = "dashed") +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  geom_segment(aes(xend = lag, yend = 0)) +
  xlim(0, 24) +
  xlab("Lag") +
  ylab("ACF") +
  ggtitle("Raleigh Cases")

#Raleigh pm acf
g4 <- RPM.acf.df %>% 
  ggplot(aes(x = lag, y = acf)) +
  geom_hline(aes(yintercept = 0), color = "black") +
  geom_hline(aes(yintercept = .1), color = "red", linetype = "dashed") +
  geom_hline(aes(yintercept = -.1), color = "red", linetype = "dashed") +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  geom_segment(aes(xend = lag, yend = 0)) +
  xlim(0, 24) +
  xlab("Lag") +
  ylab("ACF") +
  ggtitle("Raleigh PM 2.5")

Graph1 <- grid.arrange(grobs = list(g1, g3, g2, g4), nrow = 2)
ggsave("derived_graphs/ACF.plot.png", plot = Graph1)

