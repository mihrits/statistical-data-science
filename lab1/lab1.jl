using RData
using StatsBase
using GLMakie
using StatsPlots

tudengid = load("lab1/tudengid.RData")["tudengid"]

plot(tudengid.pikkus, tudengid.kaal)
mean(tudengid.pikkus)
median(tudengid.pikkus)
countmap(tudengid.tervis) # või combine(groupby(tudengid, :tervis), nrow => :count)
