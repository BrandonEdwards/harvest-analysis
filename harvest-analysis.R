####################################
#
#	harvest-analysis.R
#	Brandon Edwards
# Last Update: August 2016
#
####################################

####################################
#	Clear Memory
####################################

remove(list=ls())

####################################
#	Constants
####################################

#Should be currentYear - 1
AnalysisYear <- 2015

####################################
# File IO
####################################

mainDir <- paste(getwd(), "/", sep = "")
subDir <- paste("Plots/", sep = "")
dir.create(file.path(mainDir, subDir))

####################################
#	Load Data
####################################	

data <- read.csv(paste(mainDir, AnalysisYear, "_Harvest_Data_All.csv", sep=""))

####################################
#	Analyze Entire Lake
####################################

lake.results <- NULL

for (month in 1:12)
{
  data.temp <- data[data$MONTH %in% c(month), ]
  total.weight <- sum(data.temp$HVSWT_KG)
  lake.results <- rbind(lake.results, (month, total.weight))
}
