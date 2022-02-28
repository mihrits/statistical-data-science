# Moorits Mihkel Muru, University of Tartu 2022
# Lab 4 of the Statistical Data Science (LTMS.00.025) course
# Solutions in Julia

using DataFrames      # Tables for data
using StatsBase       # Basic statistics tools
using FreqTables      # Frequency tables
using Distributions   # Normal distribution
using HypothesisTests # Hypothesis Testing
using StatsPlots      # Plotting
using HTTP            # Stream data from web
using FileIO          # Reading in a file from a web stream
using CodecZlib       # Unpacking RData file
using RData           # Reading RData files
using CSV             # Reading CSV files
using Dates           # Standard library for working with datetime formats

# Reading the data from web
students_dataset_url = "http://www.ms.ut.ee/mart/andmeteadus/students.RData"
request = HTTP.get(students_dataset_url)
buffer = CodecZlib.GzipDecompressorStream(IOBuffer(request.body))
students = DataFrame(RData.load(Stream{format"RData"}(buffer))["students"])

# T-test to infer if the height of the students is the same as in 1933.
OneSampleTTest(students.height[students.gender.==2], 173.83)

# DataFrame with no missing values in weights
weight_students = dropmissing(students, :weight) 
# Can male students' mean weight be X kg?
OneSampleTTest(weight_students.weight[weight_students.gender.==2], 75) # p-value: 0.1217 => retain H₀
OneSampleTTest(weight_students.weight[weight_students.gender.==2], 76) # p-value: 0.6011 => retain H₀

# Is the die fair?
rolls = [1, 5, 6, 6, 3, 5, 6, 6, 4, 5, 3, 6]
OneSampleTTest(rolls, 3.5) # Does not seem likely to be a fair die
confint(OneSampleTTest(rolls, 3.5), level=0.99)
pvalue(OneSampleTTest(rolls, 3.5))
# However Chi² seems to be less apt to reject the null hypothesis
ChisqTest([count(==(x), rolls) for x in 1:6])

# Chi² test for immunity to pesticides in crossed rice
ChisqTest([585, 1191, 590], [0.25, 0.5, 0.25])

# Are earthquakes caused by sinful activities?
earthquake_data_url = "http://www.ms.ut.ee/mart/andmeteadus/quake.csv"
earthquakes = DataFrame(CSV.File(IOBuffer(HTTP.get(earthquake_data_url).body)))
