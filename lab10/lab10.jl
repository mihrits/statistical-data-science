# Moorits Mihkel Muru, University of Tartu 2022
# Lab 10 of the Statistical Data Science (LTMS.00.025) course
# Solutions in Julia

using DataFrames      # Tables for data
using StatsBase       # Basic statistics tools
using FreqTables      # Frequency tables
using GLM             # General linear models
using MultivariateStats # For PCA
using StatsPlots      # Plotting
using HTTP            # Stream data from web
using FileIO          # Reading in a file from a web stream
using CodecZlib       # Unpacking RData file
using RData           # Reading RData files

# Reading the data from web
dataset_url = "http://www.ms.ut.ee/mart/andmeteadus/WB.RData"
request = HTTP.get(dataset_url)
buffer = CodecZlib.GzipDecompressorStream(IOBuffer(request.body))
data = only(values(RData.load(Stream{format"RData"}(buffer))))

dataclean = dropmissing(data)
matdata = Matrix(dataclean[!, 2:end])
normdata = (matdata .- mean(matdata, dims=1)) ./ std(matdata, dims=1)
pca = fit(PCA, normdata')