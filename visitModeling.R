library(tidyverse)
library(ggplot2)

parks <- read_csv("derived_data/parks.csv") 
species <- read_csv("derived_data/species.csv")
visits <- read_csv("derived_data/visits.csv")

parks <- species %>% 
  group_by(ParkName) %>% 
  summarize(numSpecies=n()) %>% 
  inner_join(parks,by="ParkName") %>%
  inner_join(visits,by="ParkName")

animal <- c("Mammal","Bird","Reptile","Amphibian","Fish","Spider/Scorpion","Insect","Invertebrate","Crab/Lobster/Shrimp","Slug/Snail")
plant <- c("Vascular Plant", "Nonvascular Plant", "Algae")

parks <- species %>% 
  group_by(ParkName) %>% 
  summarize(numAnimalSpecies=sum(Category %in% animal)) %>% inner_join(parks,by="ParkName")

parks <- species %>%
  group_by(ParkName) %>%
  summarize(numPlantSpecies=sum(Category %in% plant)) %>% inner_join(parks,by="ParkName")

parks$highVisits <- (parks$Average10Yrs > 1000000)
fit <- glm(highVisits~numSpecies+numAnimalSpecies+numPlantSpecies+Acres+Latitude+Longitude,data=parks)
summary(fit)

p <- ggplot(parks, aes(Latitude, Longitude)) + geom_point(aes(colour = numSpecies)) + 
  labs(title="Number of Spieces in US National Parks by Latitude/Longitude")

#split data
parks$label <- c(rep("Train",30),rep("Validate",9),rep("Test",9)) %>%
  sample(48,replace=FALSE)

train <- parks %>% filter(label=="Train");
validate <- parks %>% filter(label=="Validate");
test <- parks %>% filter(label=="Test");

model <- glm(highVisits ~ numSpecies + 
               numAnimalSpecies +
               numPlantSpecies +
               Acres +
               Latitude +
               Longitude, data=train)
pred <- predict(model, newdata=validate, type="response");
sum((pred>0.5) == validate$highVisits)/nrow(validate);

#library(MLmetrics)
#f1 <- MLmetrics::F1_Score;
f1(validate$highVisits, pred > 0.5);

###########^^^ this is promising, maybe do ROC curve from here? That might be good. 


library(gbm)
model <- gbm(highVisits ~ numSpecies +
               numAnimalSpecies +
               numPlantSpecies +
               Acres +
               Latitude +
               Longitude, distribution="bernoulli",
             data=train,
             n.trees = 5,
             interaction.depth = 2,
             shrinkage = 0.5)

pred <- predict(model, validate, type="response")
sum((pred>0.5)==validate$neutral)/nrow(validate)