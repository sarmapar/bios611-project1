library(tidyverse)
library(ggplot2)
library(reshape2)

parks <- read_csv("derived_data/parks.csv") 
species <- read_csv("derived_data/species.csv")

parks <- species %>% 
  group_by(ParkName) %>% 
  summarize(numSpecies=n()) %>% 
  inner_join(parks,by="ParkName")

animal <- c("Mammal","Bird","Reptile","Amphibian","Fish","Spider/Scorpion","Insect","Invertebrate","Crab/Lobster/Shrimp","Slug/Snail")
plant <- c("Vascular Plant", "Nonvascular Plant", "Algae")

parks <- species %>% 
  group_by(ParkName) %>% 
  summarize(Animal=sum(Category %in% animal)) %>% inner_join(parks,by="ParkName")

parks <- species %>%
  group_by(ParkName) %>%
  summarize(Plant=sum(Category %in% plant)) %>% inner_join(parks,by="ParkName")

data <- melt(parks[,c("ParkName","Plant","Animal")], id.vars='ParkName')
data <- arrange(data, desc(value))

p <- ggplot(data,aes(x=reorder(ParkName, value),y=value,fill=variable)) + 
  geom_bar(stat='identity', position = 'dodge') +
  coord_flip() +
  labs(title="Species Distribution in US National Parks", x="US National Park", y="Number of Species", fill="Category")

ggsave("figures/species_plant_animal_rank.png",plot=p)