#############################
#harvest-grid-by-month.jl
#Brandon Edwards
#Last Updated: October 2016
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
# Analysis
#############################

for month = 1:12
  matrix = zeros(Float64, 50, 50)
  tempData = data[data[:MONTH] .== month, :]
  for i = 1:size(tempData)[1]
    y = tempData[:GRID][i]%100
    x = (tempData[:GRID][i] - y) / 100
    x = convert(Int64, x)

    if (x <= 50 && y <= 50)
      matrix[x,y] += data[:HVSWT_KG][i]
    end
  end #for i
  outputFile = string("C:/Users/Brandon/Documents/GitHub/harvest-analysis/Plots/Month-Grid/Month ", month, ".png")
  draw(PNG(outputFile, 6inch, 6inch), spy(matrix))
end #for month
