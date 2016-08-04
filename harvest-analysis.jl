#############################
#harvest-analysis.jl
#Brandon Edwards
#Last Updated: August 2016
#############################

#############################
# Constants
#############################

#Should be current year - 1
analysisYear = 2015

#############################
# Packages needed
#############################

using DataFrames, Gadfly

#############################
# File IO
#############################
projPath = Base.source_path()
separateDirChar = "\\"
pathEndSearch = rsearch(projPath, separateDirChar)[1]
endOfDirPath = projPath[pathEndSearch:length(projPath)]
projPath = split(projPath, endOfDirPath)[1]
file = string(projPath, "\\", analysisYear, "_Harvest_Data_All.csv")

#############################
# Import Data
#############################

data = readtable(file)
#Drop data with NA for month
data = data[!isna(data[:MONTH]),:]

#############################
# Entire Lake Analysis
#############################
lakeResults = DataFrame(Month = Int[], HarvestWeight = Float64[], Events = Int64[])

for month = 1:12
  tempData = data[data[:MONTH] .== month, :]
  push!(lakeResults, (month, sum(tempData[:HVSWT_KG]), size(tempData)[1]))
end
