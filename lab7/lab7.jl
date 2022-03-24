# Moorits Mihkel Muru, University of Tartu 2022
# Lab 7 of the Statistical Data Science (LTMS.00.025) course
# Solutions in Julia

using DataFrames      # Tables for data
using StatsBase       # Basic statistics tools
using FreqTables      # Frequency tables
using Distributions   # Normal distribution
using HypothesisTests # Hypothesis Testing
using GLM             # General linear models
using StatsPlots      # Plotting
using HTTP            # Stream data from web
using FileIO          # Reading in a file from a web stream
using CodecZlib       # Unpacking RData file
using RData           # Reading RData files
using CSV             # Reading CSV files
using Dates           # Standard library for working with datetime formats

# Reading the data from web
students_dataset_url = "http://www.ms.ut.ee/mart/andmeteadus/countries.RData"
request = HTTP.get(students_dataset_url)
buffer = CodecZlib.GzipDecompressorStream(IOBuffer(request.body))
countries = DataFrame(RData.load(Stream{format"RData"}(buffer))["countries"])

# Correlation matrix
cor(Matrix(countries[!, Not(1)]))
corrplot(Matrix(countries[!, Not(1)]))
@df countries cornerplot(cols(2:11))

# Linear model
m1 = lm(@formula(cars ~ gdp), countries)
scatter(residuals(m1))

countries.lgdp = log.(countries.gdp)
m2 = lm(@formula(cars ~ lgdp), countries)
scatter(residuals(m2))

m3 = lm(@formula(log(cars) ~ lgdp), countries)
scatter(residuals(m3))

m4 = lm(@formula(log(cars) ~ lgdp + lgdp^2), countries)
scatter(residuals(m4))

m5 = lm(@formula(log(cars) ~ lgdp + lgdp^2 + lgdp^3), countries)
scatter(residuals(m5))

bic.([m1,m2,m3,m4,m5])