library(ggfortify)
library(cluster)
library(Rtsne)
library(factoextra)
library(tidyverse)
library(gridExtra)

set.seed = 18

DF.Full <- read.csv("derived_data/DF.Final.csv") %>% 
  mutate(New_Cases = Cases - lag(Cases))
DF.Full$New_Cases[205] = 0
DF.Full$New_Cases[1] = 0
DF.Green <- DF.Full %>% 
  filter(Location == "Greenville") 
DF.Ral <- DF.Full %>% 
  filter(Location == "Raleigh")

g1 <- fviz_nbclust(DF.Full %>% select(O3, PM25), kmeans,
             method = "silhouette") + theme(panel.grid.major = element_blank(), 
                                           panel.grid.minor = element_blank(),
                                           panel.background = element_blank(), 
                                           axis.line = element_line(colour = "black")) + ggtitle("Silhouette Method")
#this suggests there might be two clusters
g2 <- fviz_nbclust(DF.Full %>% select(O3, PM25), kmeans,
             method = "gap_stat") + theme(panel.grid.major = element_blank(), 
                                          panel.grid.minor = element_blank(),
                                          panel.background = element_blank(), 
                                          axis.line = element_line(colour = "black")) + ggtitle("Gap Stat Method")
#this sorta means that there is only 1 cluster...
g3 <- fviz_nbclust(DF.Full %>% select(O3, PM25), kmeans,
             method = "wss") + theme(panel.grid.major = element_blank(), 
                                     panel.grid.minor = element_blank(),
                                     panel.background = element_blank(), 
                                     axis.line = element_line(colour = "black")) + ggtitle("WSS Method")

graph1 <- grid.arrange(grobs = list(g1, g2, g3), nrow = 1)
ggsave("derived_graphs/cluster.determination.png", plot = graph1)


fit1 <- Rtsne(DF.Full %>% select(O3, PM25, Bar_Close), dims = 2)
g4 <- ggplot(fit1$Y %>% as.data.frame() %>% as_tibble(), aes(V1,V2)) +
  geom_point(aes(color=DF.Full$Location))

cc <- kmeans(DF.Full %>% select(O3, PM25), 2)
g5 <- ggplot(fit1$Y %>% as.data.frame() %>% as_tibble() %>% mutate(label=cc$cluster),aes(V1,V2)) +
  geom_point(aes(color=factor(label)))

pcs <- prcomp(DF.Full %>% select(O3, PM25), scale. = T)
pcs
summary(pcs)
g6 <- autoplot(pcs, loadings=T, loadings.colour = 'blue', loadings.label.size = 6)
g7 <- autoplot(pam(DF.Full %>% select(O3, PM25), 2), 
               frame = T, fram.type = 'norm')
pam1 <- pam(DF.Full %>% select(O3, PM25), 2)
pam1$clusinfo
pam1$medoids
g8 <- autoplot(silhouette(pam(DF.Full %>% select(O3, PM25), 2)))

ggsave("derived_graphs/cluster.TSNE.plot.png", plot = g4)
ggsave("derived_graphs/cluster.kmeans.plot.png", plot = g5)
ggsave("derived_graphs/cluster.PCA.plot.png", plot = g6)
ggsave("derived_graphs/cluster.PAM.Frame.plot.png", plot = g7)
ggsave("derived_graphs/cluster.PAM.Silhouette.plot.png", plot = g8)