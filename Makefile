.PHONY: clean
SHELL: /bin/bash

clean:
	rm -f derived_data/*csv
	rm -f figures/*.png

derived_data/parks.csv derived_data/species.csv derived_data/acres.csv:\
	source_data/parks.csv \
	source_data/species.csv \
	tidy_data.R
		Rscript tidy_data.R
		
figures/species_acreage.png:\
	derived_data/parks.csv\
	derived_data/species.csv\
	natParkSize.R
		Rscript natParkSize.R

figures/species_number_long_lat.png:\
	derived_data/parks.csv\
	derived_data/species.csv\
	natParkSpeciesLoc.R 
		Rscript natParkSpeciesLoc.R
		
figures/species_plant_animal_rank.png:\
	derived_data/parks.csv\
	derived_data/species.csv\
	natParkPlantsAnimals.R
		Rscript natParkPlantsAnimals.R
		
assets/species_acreage.png: figures/species_acreage.png
		cp figures/species_acreage.png assets/species_acreage.png

assets/species_number_long_lat.png: figures/species_number_long_lat.png
		cp figures/species_number_long_lat.png assets/species_number_long_lat.png

assets/species_plant_animal_rank.png: figures/species_plant_animal_rank.png
		cp figures/species_plant_animal_rank.png assets/species_plant_animal_rank.png