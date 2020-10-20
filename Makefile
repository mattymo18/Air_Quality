.PHONY: clean

clean:

	rm derived_data/*.csv
			
		
derived_data/Raleigh.Clean.csv:\
 Source_Data/Raleigh_Air.csv\
 tidy_data.R
	Rscript tidy_data.R
	
Raleigh.Clean.Covid.csv:\
 derived_data/Raleigh.Clean.csv\
 Source_Data/covid_confirmed_usafacts.csv\
 tidy_data.R
	Rscript tidy_data.R
