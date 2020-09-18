library(tidyverse)
library(ggplot2)

parks <- read_csv("derived_data/parks.csv") 
species <- read_csv("derived_data/species.csv")

parks <- species %>% 
  group_by(ParkName) %>% 
  summarize(numSpecies=n()) %>% 
  inner_join(parks,by="ParkName")

p <- ggplot(parks, aes(Acres,numSpecies)) + geom_point() + 
  labs(title="Number of Species and Acreage of US National Parks")

ggsave("figures/species_acreage.png",plot=p)