# Moorits Mihkel Muru, University of Tartu 2022
# Homework 1 of the Statistical Data Science (LTMS.00.025) course
# Data analysis in Julia

using DataFrames      # Tables for data
using StatsBase       # Basic statistics tools
using FreqTables      # Frequency tables
using Distributions   # Normal distribution
using HypothesisTests # Hypothesis Testing
using StatsPlots      # Plotting
using Latexify        # Converts to latex
using RData           # Reading RData files

# Reading the births data from a file
birthsfilename = "births.RData"
b = only(RData.load(joinpath("hw1", birthsfilename))).second

db = describe(b)

latexify(Matrix(db)[:,2:end-1])
bclean = dropmissing(b)
bterm = bclean[bclean.preterm.==0, :]
bpreterm = bclean[bclean.preterm.==1, :]

# mean weight
mean(bterm.bweight)
mean(bpreterm.bweight)
UnequalVarianceTTest(bterm.bweight, bpreterm.bweight)

# mean maternal age
mean(bterm.matage)
mean(bpreterm.matage)
EqualVarianceTTest(bterm.matage, bpreterm.matage)

# percentage of male babies

# percentage of hypertension