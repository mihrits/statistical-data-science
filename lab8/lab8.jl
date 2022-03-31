# Moorits Mihkel Muru, University of Tartu 2022
# Lab 8 of the Statistical Data Science (LTMS.00.025) course
# Solutions in Julia

using DataFrames      # Tables for data
using StatsBase       # Basic statistics tools
using FreqTables      # Frequency tables
using Distributions   # Normal distribution
using HypothesisTests # Hypothesis Testing
using GLM             # General linear models
using StatsPlots      # Plotting
using CategoricalArrays # Transform continuous array into categorical
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
const c = countries # Shorter name for the data frame

# Summary
describe(c.alco)
# Country with lowest and highest alcohol consumption
c.country[findfirst(==(minimum(c.alco)), c.alco)]
c.country[findfirst(==(maximum(c.alco)), c.alco)]
# Countries that consume less than 1 or more than 15 litre of alcohol per adult per year
c.country[findall(<(1), c.alco)]
c.country[findall(>(15), c.alco)]

# Corralation matrix
vcat(reshape(names(c), 1, 11), hcat(names(c)[2:11], cor(Matrix(c[!,2:11]))))
# Highest correlation with educW and educM
lm(@formula(alco ~ educW), c) # adding educM does not improve model

@df c scatter(:latitude, :alco)
m_lat_alco = lm(@formula(alco ~ latitude), c)
scatter(predict(m_lat_alco), residuals(m_lat_alco))
m_lat2_alco = lm(@formula(alco ~ latitude + latitude^2), c)
scatter(predict(m_lat2_alco), residuals(m_lat2_alco))

c.latcut = cut(c.latitude, [-40, -20, 20, 40, 65])
m_latcut_alco = lm(@formula(alco ~ latcut), c)
levels!(c.latcut, ["[-20, 20)", "[-40, -20)", "[20, 40)", "[40, 65)"]) # relevel
m_latcut_alco_releveled = lm(@formula(alco ~ latcut), c)

aic(m_latcut_alco)
aic(m_latcut_alco_releveled)
bic(m_latcut_alco)
bic(m_latcut_alco_releveled)

m_alco = lm(@formula(alco ~ latcut + log(gdp) + educW + educM), c)

c.life = (c.lifeM .+ c.lifeW)./2
@df c scatter(:alco, :life , ylabel = "Life expectancy", xlabel = "Alcohol consumption")