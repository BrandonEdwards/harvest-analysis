#############################
#harvest-analysis-outliers-removed.jl
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

#Remove outliers
iqr = quantile(data[:EFFDUR], 0.75) - quantile(data[:EFFDUR], 0.25)

median = median(data[:EFFDUR])

data = data[data[:EFFDUR] .<= (iqr + median), :]
data = data[data[:EFFDUR] .>= (iqr - median), :]

#############################
# Lake Analysis
#############################
lakeResults = DataFrame(Month = Int[], HarvestWeight = Float64[], Events = Int64[], Effort = Float64[])

for month = 1:12
  tempData = data[data[:MONTH] .== month, :]
  push!(lakeResults, (month, sum(tempData[:HVSWT_KG]), size(tempData)[1], sum(tempData[:EFFDUR])))
end

plotOutputPath = string(projPath, "\\Plots\\Lake\\")

harvestWeight = plot(lakeResults, x="Month", y="HarvestWeight", Geom.line, Guide.title("Harvest Weight by Month for Entire Lake"), Guide.xticks(ticks=lakeResults[:Month]))
events = plot(lakeResults, x="Month", y="Events", Geom.line, Guide.title("Number Events by Month for Entire Lake"), Guide.xticks(ticks=lakeResults[:Month]))
effort = plot(lakeResults, x="Month", y="Effort", Geom.line, Guide.title("Effort by Month for Entire Lake"), Guide.xticks(ticks=lakeResults[:Month]))

draw(PNG(string(plotOutputPath, "harvest_outliers_removed.png"), 8inch, 6inch), harvestWeight)
draw(PNG(string(plotOutputPath, "events_outliers_removed.png"), 8inch, 6inch), events)
draw(PNG(string(plotOutputPath, "effort_outliers_removed.png"), 8inch, 6inch), effort)

#############################
# Basin Analysis
#############################

for basin = 1:length(unique(data[:BASIN])) #number of unique basins
  basinResults = DataFrame(Month = Int[], HarvestWeight = Float64[], Events = Int64[], Effort = Float64[])

  basinName = unique(data[:BASIN])[basin]

  basinData = data[data[:BASIN] .== basinName, :]

  for month = 1:12
    tempData = basinData[basinData[:MONTH] .== month, :]
    push!(basinResults, (month, sum(tempData[:HVSWT_KG]), size(tempData)[1], sum(tempData[:EFFDUR])))
  end #for month

  plotOutputPath = string(projPath, "\\Plots\\Basin\\", basinName, "\\")

  harvestWeight = plot(basinResults, x="Month", y="HarvestWeight", Geom.line, Guide.title(string("Harvest Weight by Month for ", basinName, " Basin")), Guide.xticks(ticks=lakeResults[:Month]))
  events = plot(basinResults, x="Month", y="Events", Geom.line, Guide.title(string("Number Events by Month for ", basinName, " Basin")), Guide.xticks(ticks=lakeResults[:Month]))
  effort = plot(basinResults, x="Month", y="Effort", Geom.line, Guide.title(string("Effort by Month for ", basinName, " Basin")), Guide.xticks(ticks=lakeResults[:Month]))

  draw(PNG(string(plotOutputPath, "harvest_outliers_removed.png"), 8inch, 6inch), harvestWeight)
  draw(PNG(string(plotOutputPath, "events_outliers_removed.png"), 8inch, 6inch), events)
  draw(PNG(string(plotOutputPath, "effort_outliers_removed.png"), 8inch, 6inch), effort)

end #for basin

#############################
# Zone Analysis
#############################

for zone = 1:length(unique(data[:ZONE]))
  zoneResults = DataFrame(Month = Int[], HarvestWeight = Float64[], Events = Int64[], Effort = Float64[])

  zoneName = unique(data[:ZONE])[zone]

  zoneData = data[data[:ZONE] .== zoneName, :]

  for month = 1:12
    tempData = zoneData[zoneData[:MONTH] .== month, :]
    push!(zoneResults, (month, sum(tempData[:HVSWT_KG]), size(tempData)[1], sum(tempData[:EFFDUR])))
  end

  plotOutputPath = string(projPath, "\\Plots\\Zone\\", zoneName, "\\")

  harvestWeight = plot(zoneResults, x="Month", y="HarvestWeight", Geom.line, Guide.title(string("Harvest Weight by Month for Zone ", zoneName)), Guide.xticks(ticks=lakeResults[:Month]))
  events = plot(zoneResults, x="Month", y="Events", Geom.line, Guide.title(string("Number Events by Month for Zone ", zoneName)), Guide.xticks(ticks=lakeResults[:Month]))
  effort = plot(zoneResults, x="Month", y="Effort", Geom.line, Guide.title(string("Effort by Month for Zone ", zoneName)), Guide.xticks(ticks=lakeResults[:Month]))

  draw(PNG(string(plotOutputPath, "harvest_outliers_removed.png"), 8inch, 6inch), harvestWeight)
  draw(PNG(string(plotOutputPath, "events_outliers_removed.png"), 8inch, 6inch), events)
  draw(PNG(string(plotOutputPath, "effort_outliers_removed.png"), 8inch, 6inch), effort)

end
