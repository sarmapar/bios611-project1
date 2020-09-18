.PHONY: clean
SHELL: /bin/bash

clean:
	rm derived_data/*
  
derived_data/parks.csv derived_data/species.csv derived_data/acres.csv:\
	source_data/parks.csv \
	source_data/species.csv \
	source_data/stateAcres.csv \
	tidy_data.R
		Rscript tidy_data.R
		

