# Moorits Mihkel Muru, University of Tartu 2022
# Homework 1 of the Statistical Data Science (LTMS.00.025) course
# Data analysis in Julia

using DataFrames      # Tables for data
using StatsBase       # Basic statistics tools
using FreqTables      # Frequency tables
using Distributions   # Normal distribution
using HypothesisTests # Hypothesis Testing
using StatsPlots      # Plotting
using RData           # Reading RData files

# Reading the births data from a file
birthsfilename = "births.RData"
b = only(RData.load(joinpath("hw1", birthsfilename))).second

db = describe(b)

bclean = dropmissing(b)
bterm = bclean[bclean.preterm.==0, :]
bpreterm = bclean[bclean.preterm.==1, :]

# mean weight
mean(bterm.bweight)
mean(bpreterm.bweight)
UnequalVarianceTTest(bterm.bweight, bpreterm.bweight)
EqualVarianceTTest(bterm.bweight, bpreterm.bweight)

# mean maternal age
mean(bterm.matage)
mean(bpreterm.matage)
EqualVarianceTTest(bterm.matage, bpreterm.matage)

# percentage of male babies
maleterm = count(==(1), bterm.sex)
totterm = length(bterm.sex)
malepreterm = count(==(1), bpreterm.sex)
totpreterm = length(bpreterm.sex)
# R prop.test output:
# > prop.test(c(225,31), c(427, 63))
# 	2-sample test for equality of proportions with continuity correction
# data:  c(225, 31) out of c(427, 63)
# X-squared = 0.14603, df = 1, p-value = 0.7024
# alternative hypothesis: two.sided
# 95 percent confidence interval:
#  -0.1064607  0.1761979
# sample estimates:
#    prop 1    prop 2
# 0.5269321 0.4920635

# percentage of hypertension
hypterm = sum(Int, bterm.hyp)
hyppreterm = sum(Int, bpreterm.hyp)
# R prop.test output:
# > prop.test(c(52,19), c(427,63))

# 	2-sample test for equality of proportions with continuity correction

# data:  c(52, 19) out of c(427, 63)
# X-squared = 12.911, df = 1, p-value = 0.0003267
# alternative hypothesis: two.sided
# 95 percent confidence interval:
#  -0.30641207 -0.05320281
# sample estimates:
#    prop 1    prop 2
# 0.1217799 0.3015873


# Plotting male vs female, term vs preterm
maletermfrac = maleterm/totterm
femaletermfrac = 1-maletermfrac
malepretermfrac = malepreterm/totpreterm
femalepretermfrac = 1-malepretermfrac
femalefrac = count(==(2), bclean.sex) / length(bclean.sex)
boysdata = [
    maletermfrac femaletermfrac;
    malepretermfrac femalepretermfrac
]

let 
    xlabel = repeat(["term", "preterm"], outer=2)
    labels = repeat(["boys", "girls"], inner=2)

    groupedbar(xlabel, boysdata, group = labels,
        bar_position = :stack,
        bar_width = [totpreterm/totterm*1.45, 1.45],
        color = [:skyblue  :pink; :skyblue :pink],
        # yrange = (0.90, 1.10),
        ylabel = "Fraction of girls/boys",
        grid = false,
        framestyle = :box,
        legend = :outertopright,
        )
    
    scatter!([0.69], [femalefrac],
        yerr = [-0.1064607,  0.1761979],
        label = "full sample\nmean value",
        ms = 10,
        shape = :cross,
        color = :gray20)
    
    savefig("hw1/fraction_of_boys_girls.pdf")
end