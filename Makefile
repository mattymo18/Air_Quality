.PHONY: clean

clean:

	rm derived_data/*.csv
	rm derived_graphs/*.png
			
derived_graphs/cluster.TSNE.plot.png\
derived_graphs/cluster.kmeans.plot.png\
derived_graphs/cluster.PCA.plot.png\
derived_graphs/cluster.PAM.Frame.plot.png\
derived_graphs/cluster.PAM.Silhouette.plot.png\
derived_graphs/cluster.determination.png:\
 derived_data/DF.Final.csv\
 cluster_data.R
	Rscript cluster_data.R

derived_graphs/ACF.plot.png:\
 derived_data/Greenville.Clean.Covid.csv\
 derived_data/Raleigh.Clean.Covid.csv\
 ACF_plots.R
	Rscript ACF_plots.R


derived_graphs/Total.Cases.boxplot.png\
derived_graphs/Per.Day.Cases.boxplot.png\
derived_graphs/PM25.boxplot.png\
derived_graphs/Time.Vs.Cases.plot.png\
derived_graphs/Time.Vs.PM25.plot.png\
derived_graphs/PM25.Vs.Cases.plot.png:\
 derived_data/Greenville.Clean.Covid.csv\
 derived_data/Raleigh.Clean.Covid.csv\
 derived_data/DF.Final.csv\
 tidy_graphs.R
	Rscript tidy_graphs.R

derived_data/DF.Final.csv\
derived_data/DF.Final.No.Binary.csv\
derived_data/Greenville_Clean_COVID_PM25_O3.csv\
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
