library(tidyverse)

parks <- read_csv("source_data/parks.csv")
species <- read_csv("source_data/species.csv")

#Do something to clean up

write_csv(parks, "derived_data/parks.csv")
write_csv(species, "derived_data/species.csv")
