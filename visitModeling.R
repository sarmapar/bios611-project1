library(tidyverse)
library(ggplot2)
library(MLmetrics)
library(reshape2)

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

parks$highVisits <- (parks$Avg10YrVisits > 1000000)

cor(parks$Avg10YrVisits,parks$numSpecies/parks$Acres)
cor(parks$Avg10YrVisits,parks$Acres)
cor(parks$Avg10YrVisits,parks$numSpecies)
cor(parks$Avg10YrVisits,parks$numAnimalSpecies)
cor(parks$Avg10YrVisits,parks$numPlantSpecies)

parks.m <- melt(parks, id.vars="Avg10YrVisits",
                measure.vars = c("numAnimalSpecies","numPlantSpecies"))
p <- ggplot(parks.m, aes(x=Avg10YrVisits,y=value, color=variable)) + 
  geom_point() +
  labs(title="Correlation of the number of plant and animal species to annual visitation",
       y="Number of Species",
       x="Annual Visitors (10 year average)",
       fill="Category") +
  geom_smooth(method=lm, se=FALSE)

ggsave("figures/species_visit_correlation.png",plot=p)


#split data
parks$label <- c(rep("Train",30),rep("Validate",9),rep("Test",9)) %>%
    sample(48,replace=FALSE)

train <- parks %>% filter(label=="Train");
validate <- parks %>% filter(label=="Validate");
test <- parks %>% filter(label=="Test");

model <- glm(highVisits ~ numSpecies +
               numAnimalSpecies +
               numPlantSpecies,
             data=train)
pred <- predict(model, newdata=validate, type="response");
sum((pred>0.5) == validate$highVisits)/nrow(validate);
  
f1 <- MLmetrics::F1_Score;
f1(validate$highVisits, pred > 0.5)


roc <- do.call(rbind, Map(function(threshold){
  p <- pred > threshold;
  tp <- sum(p[validate$highVisits])/sum(validate$highVisits);
  fp <- sum(p[!validate$highVisits])/sum(!validate$highVisits);
  tibble(threshold=threshold,
         tp=tp,
         fp=fp)
},seq(100)/100))

p2 <- ggplot(roc, aes(fp,tp)) + geom_line() + xlim(0,1) + ylim(0,1) +
  labs(title="ROC Curve",x="False Positive Rate",y="True Positive Rate");

ggsave("figures/roc.png",plot=p2)


