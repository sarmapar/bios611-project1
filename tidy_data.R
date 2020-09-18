library(tidyverse)
library(stringr)

tidy_up_names <- function(dataset){
  names(dataset) <- names(dataset) %>%
    str_replace_all(" ", "")
  dataset
}

parks <- read_csv("source_data/parks.csv")
species <- read_csv("source_data/species.csv")
acres <- read_csv("source_data/stateAcres.csv")

parks <- tidy_up_names(parks)
species <- species[,1:13] %>%
  tidy_up_names()
names(acres) <- c("State","StateAcres")

acres["StateAcres"] <- acres["StateAcres"]*1000


write_csv(parks, "derived_data/parks.csv")
write_csv(species, "derived_data/species.csv")
write_csv(acres, "derived_data/acres.csv")
