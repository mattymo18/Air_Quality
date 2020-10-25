.PHONY: clean

clean:

	rm derived_data/*.csv
			

derived_graphs/Time.Vs.Cases.plot.png\
derived_graphs/Time.Vs.PM25.plot.png\
derived_graphs/PM25.Vs.Cases.plot.png:\
 derived_data/Greenville.Clean.Covid.csv\
 derived_data/Raleigh.Clean.Covid.csv\
 tidy_graphs.R
	Rscript tidy_graphs.R

derived_data/Greenville.Clean.csv\
derived_data/Raleigh.Clean.csv:\
 Source_Data/Raleigh_Air.csv\
 Source_Data/Greenville_Air.csv\
 tidy_data.R
	Rscript tidy_data.R
	
derived_data/Greenville.Clean.Covid.csv\
Raleigh.Clean.Covid.csv:\
 derived_data/Raleigh.Clean.csv\
 derived_data/Greenville.Clean.csv\
 Source_Data/covid_confirmed_usafacts.csv\
 tidy_data.R
	Rscript tidy_data.R
