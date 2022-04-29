# Moorits Mihkel Muru, University of Tartu 2022
# Lab 11 of the Statistical Data Science (LTMS.00.025) course
# Solutions in Julia

using DataFrames      # Tables for data
using StatsBase       # Basic statistics tools
using FreqTables      # Frequency tables
using GLM             # General linear models
using MultivariateStats # For PCA
using Chain           # Piping functions
using StatsPlots      # Plotting
# Load data from web
using HTTP            # Stream data from web
using FileIO          # Reading in a file from a web stream
using CodecZlib       # Unpacking RData file
using RData           # Reading RData files

# Reading the data from web
function get_data(url)
    @chain url begin
        HTTP.get
        IOBuffer(_.body)
        CodecZlib.GzipDecompressorStream
        Stream{format"RData"}(_)
        RData.load
        values
        only
    end
end

dataset_url = "http://www.ms.ut.ee/mart/andmeteadus/world.RData"
world_full = get_data(dataset_url)
world_clean = dropmissing(world_full)
world_clean.lgdp = log.(world_clean.gdp)