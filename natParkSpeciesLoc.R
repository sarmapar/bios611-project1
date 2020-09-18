library(tidyverse)
library(ggplot2)

parks <- read_csv("derived_data/parks.csv") 
species <- read_csv("derived_data/species.csv")

parks <- species %>% 
  group_by(ParkName) %>% 
  summarize(numSpecies=n()) %>% 
  inner_join(parks,by="ParkName")

p <- ggplot(parks, aes(Latitude, Longitude)) + geom_point(aes(colour = numSpecies)) + 
  labs(title="Number of Spieces in US National Parks by Latitude/Longitude")

ggsave("figures/species_number_long_lat.png",plot=p)