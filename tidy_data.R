library(tidyverse)
library(stringr)

tidy_up_names <- function(dataset){
  names(dataset) <- names(dataset) %>%
    str_replace_all(" ", "")
  dataset
}

parks <- read_csv("source_data/parks.csv")
species <- read_csv("source_data/species.csv")
visits <- read_csv("source_data/natParkVisits.csv")

parks <- tidy_up_names(parks)
species <- species[,1:13] %>%
  tidy_up_names()
names(acres) <- c("State","StateAcres")
visits <- visits[,c(1,14)]
names(visits) <- c("ParkName","Avg10YrVisits")
visits["ParkName"] <- sapply(visits["ParkName"],gsub,pattern=" NP",replacement=" National Park")
  

acres["StateAcres"] <- acres["StateAcres"]*1000


write_csv(parks, "derived_data/parks.csv")
write_csv(species, "derived_data/species.csv")
write_csv(visits, "derived_data/visits.csv")

