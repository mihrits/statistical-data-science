using RData
using StatsBase
using StatsPlots
using FreqTables
using DataFrames

tudengid = load("lab1/tudengid.RData")["tudengid"]

plot(tudengid.pikkus, tudengid.kaal)
mean(tudengid.pikkus)
median(tudengid.pikkus)
# R-i table käsu replikeerimine:
freqtable(tudengid.tervis) # See tuleb FreqTables teegist
countmap(tudengid.tervis) # See tuleb StatsBase teegist
combine(groupby(tudengid, :tervis), nrow => :count) # See tuleb DataFrames teegist ehk põhimõtteliselt ilma lisadeta

prop(freqtable(tudengid.tervis))
round.(prop(freqtable(tudengid.tervis))*100, digits=2)
@df tudengid boxplot(:sugu, :pikkus)
freqtable(tudengid, :olu, :tervis, :sugu)

mean(tudengid.pikkus)
median(tudengid.pikkus)
var(tudengid.pikkus)
std(tudengid.pikkus)
quantile(tudengid.pikkus, 0.3)
quantile(tudengid.pikkus, 0.1:0.1:0.9)

mean(tudengid.kaal) # NA asemel on Julias `missing` tüüpi väärtused
mean(skipmissing(tudengid.kaal))
freqtable(tudengid.kiirabi) # Julias on vaikesätteks, et missing väärtused jäetakse tabelisse
freqtable(tudengid.kiirabi, skipmissing=true)

histogram(tudengid.pikkus, xlabel="Pikkus (cm)", ylabel="Sagedus",
    title="Tudengite pikkuste jaotus", color=:gold, legend=false)

mehed = filter(:sugu => ==(2), tudengid)
naised = filter(:sugu => ==(1), tudengid)
boxplot(naised.sugu, naised.pikkus, xticks = ([1,2], ["naine", "mees"]),
    xlabel="Sugu", ylabel="Pikkus", color=:pink, legend=false, xtickfont=11)
boxplot!(mehed.sugu, mehed.pikkus, color=:skyblue)

boxplot(tudengid.olu, tudengid.pikkus, label="Kõik andmed")
boxplot!(naised.olu, naised.pikkus, label="Naised", alpha=0.5)

suguolu = prop(freqtable(tudengid, :sugu, :olu), margins=2)
sugu = repeat(["naised", "mehed"], outer=5)
kogused = repeat(sort!(unique(tudengid.olu)), inner=2)
groupedbar(kogused, suguolu, bar_position=:stack, group=sugu, xlimit=(0,6.5), framestyle=:box,
    ylabel="Naistudengite osakaal", xlabel="Mitu pudelit õlut tudeng nädalas joob?", color = [:gray90 :red])

tudengid.kaal[[1,4,24], :]
freqtable(mehed.olu)

tudengid[1:7, :]
mehed[mehed.pikkus.<170, :]